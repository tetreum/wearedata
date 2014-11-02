package wd.hud {
    import wd.data.*;
    import wd.http.*;
    import wd.hud.items.*;
    import wd.hud.items.datatype.*;
    import wd.d3.geom.metro.*;
    import wd.d3.geom.metro.trains.*;
    import flash.events.*;
    import wd.hud.items.pictos.*;
    import wd.utils.*;
    import wd.events.*;
    import wd.d3.*;
    import wd.footer.*;
    import wd.wq.textures.*;
    import wd.wq.core.*;
    import flash.geom.*;
    import wd.wq.display.*;
    import wd.hud.panels.layers.*;
    import wd.hud.panels.*;
    import wd.hud.popins.*;
    import wd.hud.panels.search.*;
    import wd.hud.panels.district.*;
    import wd.hud.panels.live.*;
    import wd.hud.tutorial.*;
    import wd.sound.*;
    import wd.hud.objects.*;
    import wd.core.*;
    import flash.display.*;
    import aze.motion.*;
    import flash.utils.*;
    import wd.hud.preloaders.*;

    public class Hud extends Sprite {

        private static var instance:Hud;

        private const BLACK_SCREEN_OPACITY:Number = 0.7;
        private const TUTORIAL_TIME_FOR_EACH_PANEL:Number = 7;

        private var trackers:Trackers;
        private var started:Boolean = false;
        private var sim:Simulation;
        private var districtPanel:DistrictPanel;
        private var footer:Footer;
        private var tutoTimer:Timer;
        private var tutoSequence:Array;
        private var building_preloader:BuildingPreloader;
        private var engine2D:WatchQuads;
        private var pictoQuad:WQuad;
        private var layerPanel:LayerPanel;
        private var livePanel:LivePanel;
        private var compass:Compass;
        private var tutoMananger:TutorialManager;
        private var trackerLabel:TrackerLabel;
        private var veloStations:VeloStations;
        public var mouseIsOver:Boolean = false;
        public var mouseIsClicked:Boolean = false;
        private var searchBar:Search;
        private var _popinManager:PopinsManager;
        private var spriteSheetFactory2Scren:Bitmap;
        private var blackScreen:Sprite;
        private var light:Sprite;
        private var lightQuad:WQuad;
        private var b:Bitmap;
        public var hook:TrainHook;

        public function Hud(sim:Simulation, footer:Footer){
            super();
            this.footer = footer;
            this.sim = sim;
            this.addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
            this.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
            instance = this;
            UVPicto.init(SpriteSheetFactory2.texture.width, SpriteSheetFactory2.texture.height);
            Metro.getInstance().addEventListener(ServiceEvent.METRO_TEXT_READY, this.updatePicto);
            this.trackers = new Trackers();
            Tracker.init();
            addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
        }
        public static function removeItem(type:int, node:ListNodeTracker):void{
            instance.trackers.remove(type, node);
        }
        public static function open(id:int):void{
            instance.trackers.open(id);
        }
        public static function close(id:int):void{
            instance.trackers.close(id);
        }
        public static function addItem(data:TrackerData):Tracker{
            if (data.type == DataType.PLACES){
                return (instance.trackers.addPlace(data));
            };
            if (instance == null){
                return (null);
            };
            instance.trackers.addDynamicTracker(data);
            return (null);
        }
        public static function addStation(line:MetroLine, station:MetroStation, multipleConnexion:Boolean):void{
            var data:StationTrackerData = new StationTrackerData(DataType.METRO_STATIONS, station.id, station.lon, station.lat, station);
            instance.trackers.addStation(data, line, station, multipleConnexion);
        }
        public static function addTrain(train:Train):void{
            instance.trackers.addTrain(DataType.TRAINS, train.id, train);
        }
        public static function removeTrain(train:Train):void{
            if (instance.hook.tracker != null){
                if (instance.hook.tracker.data != null){
                    if (instance.hook.tracker.data.object == train){
                        instance.hook.release();
                    };
                };
            };
            instance.trackers.removeTrain(train);
        }
        public static function getInstance():Hud{
            return (instance);
        }

        public function majTexture():void{
            var texture:WQConcreteTexture = WQTexture.fromBitmapData(SpriteSheetFactory2.texture);
            this.pictoQuad.texture = texture;
        }
        protected function updatePicto(e:ServiceEvent):void{
            Metro.getInstance().removeEventListener(ServiceEvent.METRO_TEXT_READY, this.updatePicto);
            SpriteSheetFactory2.addStations(e.data);
            this.majTexture();
        }
        protected function onRollOut(event:MouseEvent):void{
            this.mouseIsOver = false;
        }
        protected function onRollOver(event:MouseEvent):void{
            this.mouseIsOver = true;
        }
        protected function onAdded(event:Event):void{
            this.engine2D = new WatchQuads(stage, new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), this.sim.stage3DProxy.stage3D);
            var texture:WQConcreteTexture = WQTexture.fromBitmapData(SpriteSheetFactory2.texture);
            this.pictoQuad = new WQuad(texture, true);
            this.engine2D.addQuad(this.pictoQuad);
            var textureLight:WQConcreteTexture = WQTexture.fromBitmapData(this.getLight());
            this.lightQuad = new WQuad(textureLight);
            this.engine2D.addQuad(this.lightQuad);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onClick);
            this.tutoSequence = new Array();
            this.layerPanel = new LayerPanel(this);
            this.layerPanel.y = 20;
            this.layerPanel.x = 20;
            addChild(this.layerPanel);
            this.tutoSequence.push("layerPanel");
            this.compass = new Compass(this.sim);
            addChild(this.compass);
            this.popinManager = new PopinsManager(this.sim);
            this.searchBar = new Search();
            this.addChild(this.searchBar);
            this.tutoSequence.push("searchBar");
            this.districtPanel = new DistrictPanel();
            this.districtPanel.y = 20;
            this.districtPanel.x = 20;
            addChild(this.districtPanel);
            this.tutoSequence.push("districtPanel");
            this.livePanel = new LivePanel();
            this.livePanel.addEventListener(HudEvents.OPEN_DISCLAIMER_POPIN, this.popinManager.openPopin);
            addChild(this.livePanel);
            this.tutoSequence.push("livePanel");
            this.trackerLabel = new TrackerLabel();
            this.addChild(this.trackerLabel);
            this.tutoMananger = new TutorialManager();
            this.tutoMananger.addEventListener(TutorialManager.TUTORIAL_NEXT, this.showNextTuto);
            this.tutoMananger.addEventListener(TutorialManager.TUTORIAL_END, this.tutoEnd);
            this.addChild(this.tutoMananger);
            this.footer.popin = this.popinManager;
            this.footer.main.addChild(this.popinManager);
            this.footer.addEventListener(HudEvents.OPEN_HELP_POPIN, this.startTuto);
            this.footer.addEventListener(HudEvents.OPEN_LEGALS_POPIN, this.popinManager.openPopin);
            this.footer.addEventListener(HudEvents.OPEN_ABOUT_POPIN, this.popinManager.openPopin);
            this.footer.addEventListener(HudEvents.OPEN_LANG_POPIN, this.popinManager.openPopin);
            this.footer.addEventListener(HudEvents.OPEN_LANG_POPIN, this.popinManager.openPopin);
            this.footer.addEventListener(HudEvents.OPEN_SOUND_POPIN, SoundManager.swapMute);
            this.footer.addEventListener(HudEvents.OPEN_SHARE_LINK_POPIN, this.popinManager.openPopin);
            this.footer.addEventListener(HudEvents.QUALITY_CHANGE, this.qualityChange);
            this.tutoSequence.push("footer");
            this.hook = new TrainHook();
            addChild(this.hook);
            this.veloStations = new VeloStations();
        }
        private function qualityChange(e:Event):void{
            if (AppState.isHQ){
                this.sim.setHQ();
            } else {
                this.sim.setLQ();
            };
        }
        private function onClick(e:MouseEvent):void{
            if (this.popinManager.currentPopin == null){
                this.mouseIsClicked = true;
            };
            this.hook.release();
        }
        public function update():void{
            Tracker.update(this.sim, this.pictoQuad);
            this.compass.update();
        }
        public function checkState():void{
            this.sim.checkState();
            this.trackers.checkState();
            this.layerPanel.checkState();
            if (!(AppState.isActive(DataType.METRO_STATIONS))){
                Trackers.hideByType(DataType.TRAINS);
            } else {
                Trackers.showByType(DataType.TRAINS);
            };
            if (!(AppState.isActive(DataType.TRAFFIC_LIGHTS))){
                Trackers.hideByType(DataType.RADARS);
            } else {
                Trackers.showByType(DataType.RADARS);
            };
        }
        public function start():void{
            if (!(this.started)){
                this.checkState();
                if (SharedData.firstTime){
                    this.startTuto();
                };
                this.layerPanel.tweenIn();
                this.districtPanel.tweenIn();
                this.started = true;
            };
        }
        public function pause():void{
        }
        public function resize():void{
            this.districtPanel.x = ((stage.stageWidth - Panel.RIGHT_PANEL_WIDTH) - 20);
            this.livePanel.x = ((stage.stageWidth - Panel.RIGHT_PANEL_WIDTH) - 20);
            this.livePanel.replace();
            this.compass.x = 20;
            this.compass.y = (stage.stageHeight - 220);
            this.searchBar.y = (this.compass.y + 130);
            this.engine2D.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            if (this.blackScreen){
                this.blackScreen.width = stage.stageWidth;
                this.blackScreen.height = stage.height;
            };
            this.lightQuad.clear();
            this.lightQuad.add(0, 0, stage.stageWidth, stage.stageHeight, 0, 0, 1, 1);
            this.tutoMananger.resize();
        }
        public function render():void{
            this.engine2D.render();
        }
        public function trackerRollOut(tracker:Tracker):void{
            if (this.popinManager.currentPopin != null){
                return;
            };
            this.trackerLabel.rolloutHandler(tracker);
            this.sim.itemObjects.itemRollOutHandler(tracker, Tracker.staticTrackersOnView);
        }
        public function trackerRollOver(tracker:Tracker):void{
            if (this.popinManager.currentPopin != null){
                return;
            };
            URLFormater.place = tracker.data.labelData;
            if (!((tracker.data is TrainTrackerData))){
                this.trackerLabel.rolloverHandler(tracker);
            };
            this.sim.itemObjects.itemRollOverHandler(tracker, Tracker.staticTrackersOnView);
            var s:Array = ["RollOverLieuxVille", "ClickV4", "ClickV7"];
            SoundManager.playFX(s[int((Math.random() * s.length))], (0.5 + (Math.random() * 0.5)));
        }
        public function trackerClick(tracker:Tracker):void{
            var p:Point;
            this.trackerLabel.rolloutHandler(tracker);
            if (this.popinManager.currentPopin != null){
                return;
            };
            if (tracker.data.object != null){
                p = Locator.LOCATE(tracker.x, tracker.z);
                tracker.data.lon = p.x;
                tracker.data.lat = p.y;
            };
            var s:Array = ["ClickV4", "ClickV7"];
            SoundManager.playFX(s[int((Math.random() * s.length))], (0.5 + (Math.random() * 0.5)));
            this.sim.itemObjects.popinManager = ((this.sim.itemObjects.popinManager) || (this.popinManager));
            this.hook.release();
            if ((tracker.data is TrainTrackerData)){
                this.hook.hook(tracker);
            };
            this.sim.itemObjects.itemClickHandler(tracker);
            SocketInterface.sendData(tracker.data.lat, tracker.data.lon, tracker.data.labelData);
            GoogleAnalytics.mapItemClick(tracker.data.type);
        }
        private function startTuto(e:Event=null):void{
            this.popinManager.clear();
            this.tutoSequence = new Array();
            this.tutoSequence.push(this.footer);
            this.tutoSequence.push(this.compass);
            this.tutoSequence.push(this.searchBar);
            this.tutoSequence.push(this.layerPanel);
            this.tutoSequence.push(this.districtPanel);
            this.tutoSequence.push(this.livePanel);
            this.tutoSequence.push(this.footer);
            this.tutoSequence.push(this.footer);
            var i:int;
            while (i < this.tutoSequence.length) {
                this.tutoSequence[i].tutoMode = true;
                i++;
            };
            this.tutoMananger.launch();
            this.blackScreen = new Sprite();
            this.blackScreen.graphics.beginFill(0, this.BLACK_SCREEN_OPACITY);
            this.blackScreen.graphics.drawRect(0, 0, stage.stageWidth, stage.stageWidth);
        }
        private function showNextTuto(e:Event=null):void{
            if (this.tutoMananger.index > 0){
                trace(("desativate : " + this.tutoSequence[this.tutoMananger.index]));
                this.tutoSequence[(this.tutoMananger.index - 1)].tutoFocusOut();
            };
            if (this.tutoMananger.index == this.tutoSequence.length){
            } else {
                trace(("activate : " + this.tutoSequence[this.tutoMananger.index]));
                this.tutoSequence[this.tutoMananger.index].tutoFocusIn();
            };
        }
        private function tutoEnd(e:Event):void{
            var i:int;
            while (i < this.tutoSequence.length) {
                this.tutoSequence[i].tutoMode = false;
                i++;
            };
            eaze(this.blackScreen).to(0.5, {alpha:0});
        }
        private function getLight():BitmapData{
            if (!(this.light)){
                this.light = new Sprite();
            };
            var m:Matrix = new Matrix();
            m.createGradientBox(0x0200, 0x0200);
            this.light.graphics.clear();
            this.light.graphics.beginGradientFill(GradientType.RADIAL, [0, 0], [0, 0.8], [124, 254], m, "pad", InterpolationMethod.LINEAR_RGB, 0);
            this.light.graphics.drawRect(0, 0, 0x0200, 0x0200);
            this.light.mouseEnabled = false;
            this.mouseEnabled = false;
            this.light.buttonMode = false;
            var bd:BitmapData = new BitmapData(0x0200, 0x0200, true, 0);
            bd.draw(this.light);
            this.light.graphics.clear();
            this.light = null;
            return (bd);
        }
        public function dispose():void{
            Tracker.dispose();
            this.trackers.dispose();
        }
        public function reset():void{
            Tracker.init();
        }
        public function get popinManager():PopinsManager{
            return (this._popinManager);
        }
        public function set popinManager(value:PopinsManager):void{
            this._popinManager = value;
        }

    }
}//package wd.hud 
