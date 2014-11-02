package {
    import wd.sound.*;
    import wd.providers.*;
    import wd.core.*;
    import wd.d3.geom.monuments.*;
    import flash.events.*;
    import flash.display.*;
    import wd.utils.*;
    import wd.d3.*;
    import wd.footer.*;
    import wd.hud.*;
    import wd.intro.*;
    import wd.events.*;
    import wd.d3.control.*;
    import aze.motion.*;
    import wd.hud.items.*;

    public class Main extends MovieClip {

        public static var RENDER:String = "RENDER";

        private var initialized:Boolean;
        public var footer:Footer;
        public var simulation:Simulation;
        public var hud:Hud;
        public var intro:Intro;

        public function Main(){
            super();
            SoundManager.init();
            new MetroLineColors(Config.city_xml.metroLineColors.line);
            MonumentsProvider.setMeshData(Config.city_xml.monuments, Config.CITY);
            if (stage == null){
                addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            } else {
                this.initialize();
            };
        }
        private function onAdded(e:Event):void{
            stage.stageFocusRect = false;
            removeEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            this.initialize();
        }
        private function initialize():void{
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            if (Config.STARTING_PLACE != null){
                Locator.STARTING_PLACE = Config.STARTING_PLACE;
            };
            new Locator(Config.CITY, Config.WORLD_RECT, Config.WORLD_SCALE);
            AppState.isHQ = SharedData.isHq;
            this.simulation = new Simulation();
            this.simulation.addEventListener(Simulation.CONTEXT_READY, this.mapContextReady, false, 0, true);
            addChild(this.simulation);
        }
        protected function mapContextReady(event:Event):void{
            this.footer = new Footer(this);
            this.hud = new Hud(this.simulation, this.footer);
            this.intro = new Intro(this);
            this.intro.addEventListener(NavigatorEvent.INTRO_SHOW, this.showIntro);
            this.intro.addEventListener(NavigatorEvent.INTRO_HIDE, this.hideIntro);
            this.intro.addEventListener(NavigatorEvent.INTRO_HIDDEN, this.onIntroHidden);
            this.intro.addEventListener(NavigatorEvent.INTRO_VISIBLE, this.onIntroVisible);
            addChild(this.intro);
            addChild(this.hud);
            addChild(this.footer);
            this.simulation.alpha = (this.hud.alpha = 0);
            this.simulation.visible = (this.hud.visible = false);
            this.simulation.controller.addEventListener(NavigatorEvent.INTRO_SHOW, this.showIntro);
            this.simulation.controller.addEventListener(NavigatorEvent.INTRO_HIDE, this.hideIntro);
            new Keys(this, this.hud, this.simulation, stage);
            stage.addEventListener(Event.RESIZE, this.onResize);
            this.onResize(null);
        }
        private function hideIntro(e:NavigatorEvent):void{
            CameraController.forceLocation();
            CameraController.locked = true;
            this.intro.hide();
            this.start();
        }
        private function onIntroHidden(e:NavigatorEvent):void{
            trace("Main.onHidden");
            this.intro.visible = false;
            this.initialized = true;
            eaze(this.hud).to(1, {alpha:1}).onComplete(this.hud.start);
            this.hud.visible = true;
            CameraController.instance.zoomLevel = 0;
            CameraController.locked = false;
        }
        private function showIntro(e:NavigatorEvent):void{
            Tracker.hide();
            this.intro.show();
            this.intro.storeLocation();
            CameraController.locked = true;
            eaze(this.hud).to(1, {alpha:0});
        }
        private function onIntroVisible(e:NavigatorEvent):void{
            this.pause();
            this.footer.showIntroItems();
            CameraController.locked = false;
        }
        public function start():void{
            trace("START");
            if (!(hasEventListener(Event.ENTER_FRAME))){
                this.initialized = true;
                this.simulation.visible = true;
                this.onResize(null);
                this.simulation.navigation.reset();
                this.simulation.location.reset();
                this.simulation.start();
                this.footer.showAllItems();
                addEventListener(Event.ENTER_FRAME, this.oef);
            };
            Tracker.show();
        }
        public function pause():void{
            removeEventListener(Event.ENTER_FRAME, this.oef);
            this.hud.pause();
            this.simulation.pause();
        }
        public function oef(e:Event):void{
            this.update();
            this.render();
        }
        private function update():void{
            this.simulation.update();
            this.hud.update();
        }
        public function render():void{
            this.simulation.stage3DProxy.clear();
            this.simulation.render();
            this.hud.render();
            this.simulation.stage3DProxy.present();
        }
        public function onResize(e:Event=null):void{
            this.footer.resize(stage.stageWidth, stage.stageHeight);
            if (this.initialized){
                this.simulation.resize();
                this.hud.resize();
            };
            this.intro.resize();
        }
        public function onCityChange(e:Event):void{
            this.disposeView();
            this.resetView();
        }
        private function resetView():void{
            this.simulation.reset();
            this.hud.reset();
        }
        private function disposeView():void{
            this.simulation.dispose();
            this.hud.dispose();
        }

    }
}//package 
