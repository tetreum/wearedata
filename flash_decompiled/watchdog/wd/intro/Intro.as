package wd.intro {
    import flash.display.*;
    import wd.hud.items.*;
    import wd.http.*;
    import wd.hud.panels.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import flash.events.*;
    import wd.sound.*;
    import flash.geom.*;
    import wd.core.*;
    import wd.utils.*;
    import flash.ui.*;
    import flash.net.*;
    import aze.motion.*;
    import wd.events.*;
    import aze.motion.easing.*;
    import __AS3__.vec.*;
    import wd.hud.*;
    import biga.utils.*;
    import wd.d3.control.*;
    import flash.text.*;

    public class Intro extends Sprite {

        private static var instance:Intro;

        private var title_src:Class;
        private var title:Bitmap;
        private var label:TrackerLabel;
        private var main:Main;
        private var container:Sprite;
        private var picture:Bitmap;
        private var rect:Rectangle;
        private var service:PlacesService;
        private var holder:Sprite;
        private var debug:Sprite;
        private var tracker:Tracker;
        private var points:Vector.<Point>;
        private var indices:Vector.<int>;
        private var containerZoom:Sprite;
        private var _zoomValue:Number = 0;
        private var lastLocation:Point;
        private var lastSpot:IntroSpot;
        private var instructions:TextField;
        private var bg:Shape;
        private var loader:Loader;
        private var districts:IntroDistricts;
        public var spots:Vector.<IntroSpot>;

        public function Intro(main:Main){
            this.title_src = Intro_title_src;
            this.title = new this.title_src();
            super();
            instance = this;
            this.main = main;
            alpha = 0;
            this.bg = new Shape();
            addChild(this.bg);
            this.holder = new Sprite();
            addChild(this.holder);
            this.containerZoom = new Sprite();
            this.holder.addChild(this.containerZoom);
            this.container = new Sprite();
            this.containerZoom.addChild(this.container);
            this.tracker = new Tracker(new TrackerData(DataType.PLACES, 0, 0, 0, ""), null);
            this.label = new TrackerLabel();
            this.debug = new Sprite();
            this.container.addChild(this.debug);
            this.holder.addChild(this.title);
            this.instructions = new CustomTextField(CommonsText.mapInstructions.toUpperCase(), "introInstructions");
            this.instructions.wordWrap = false;
            this.instructions.background = true;
            this.instructions.backgroundColor = 0;
            this.addChild(this.instructions);
            addEventListener(Event.ADDED_TO_STAGE, this.onAdded);
        }
        public static function get visible():Boolean{
            return ((instance.alpha < 0.5));
        }

        private function traceDown(e:MouseEvent):void{
            if (e.type == MouseEvent.MOUSE_DOWN){
                this.districts.startDrag();
            } else {
                this.districts.stopDrag();
            };
        }
        private function onAdded(e:Event):void{
            removeEventListener(Event.ADDED_TO_STAGE, this.onAdded);
            this.init();
        }
        private function init():void{
            var s:Number;
            SoundManager.playVibe("AmbianceCarteVille", 1);
            var offset:Point = new Point();
            switch (Config.CITY){
                case Locator.BERLIN:
                    s = 0.68;
                    this.rect = new Rectangle(((-1551 * s) + 189), ((-1477 * s) + 272), (4627 * s), (3814 * s));
                    break;
                case Locator.LONDON:
                    s = 1.42;
                    this.rect = new Rectangle(((-985 * s) - 356), ((-665 * s) - 298), (3278 * s), (2643 * s));
                    break;
                case Locator.PARIS:
                    this.rect = new Rectangle(289, 80, 705, 595);
                    break;
            };
            this.districts = new IntroDistricts(this.rect);
            this.container.addChild(this.districts);
            this.pictureLoad();
        }
        private function onKeyDown(e:KeyboardEvent):void{
            if (e.keyCode == Keyboard.UP){
                this.districts.scaleX = (this.districts.scaleY = (this.districts.scaleY + 0.01));
            };
            if (e.keyCode == Keyboard.DOWN){
                this.districts.scaleX = (this.districts.scaleY = (this.districts.scaleY - 0.01));
            };
            this.resize();
            trace(this.districts.scaleX, this.districts.x, this.districts.y);
        }
        private function pictureLoad():void{
            this.loader = new Loader();
            this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onPictureLoaded);
            var req:URLRequest = new URLRequest((("assets/img/intro_" + Config.CITY.toLowerCase()) + ".jpg"));
            this.loader.load(req);
        }
        private function onPictureLoaded(e:Event):void{
            this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.onPictureLoaded);
            this.picture = (this.loader.content as Bitmap);
            this.picture.smoothing = true;
            this.container.addChildAt(this.picture, 0);
            this.container.x = (-(this.picture.width) / 2);
            this.container.y = (-(this.picture.height) / 2);
            this.picture.alpha = 0;
            eaze(this.picture).to(2, {alpha:1});
            this.service = new PlacesService();
            this.service.addEventListener(ServiceEvent.PLACES_COMPLETE, this.onPlacesComplete);
            this.service.addEventListener(ServiceEvent.PLACES_CANCEL, this.onPlacesCancel);
            this.resize();
            eaze(this).to(2, {alpha:1}).easing(Expo.easeOut);
        }
        private function onPlacesComplete(e:ServiceEvent):void{
            var p:Place;
            this.service.removeEventListener(ServiceEvent.PLACES_COMPLETE, this.onPlacesComplete);
            this.service.removeEventListener(ServiceEvent.PLACES_CANCEL, this.onPlacesCancel);
            var labels:Vector.<String> = new Vector.<String>();
            if (Locator.STARTING_PLACE != null){
                labels.push(Locator.STARTING_PLACE.name);
            };
            for each (p in Places[Locator.CITY.toUpperCase()]) {
                if (p.name.toUpperCase().lastIndexOf("BETC") == -1){
                    labels.push(p.name.toUpperCase());
                };
            };
            SpriteSheetFactory2.addTexts(labels);
            Hud.getInstance().majTexture();
            this.initLocations();
        }
        private function onPlacesCancel(e:ServiceEvent):void{
            this.service.removeEventListener(ServiceEvent.PLACES_COMPLETE, this.onPlacesComplete);
            this.service.removeEventListener(ServiceEvent.PLACES_CANCEL, this.onPlacesCancel);
        }
        private function initLocations():void{
            var p:Place;
            var spot:IntroSpot;
            this.points = new Vector.<Point>();
            this.spots = new Vector.<IntroSpot>();
            var d:Number = 0;
            for each (p in Places[Locator.CITY.toUpperCase()]) {
                if (p.name.lastIndexOf("BETC") != -1){
                } else {
                    spot = new IntroSpot(p, this.rect);
                    this.container.addChild(spot);
                    this.spots.push(spot);
                    this.points.push(new Point(spot.x, spot.y));
                    spot.addEventListener(MouseEvent.ROLL_OVER, this.onRoll);
                    spot.addEventListener(MouseEvent.ROLL_OUT, this.onRoll);
                    spot.addEventListener(MouseEvent.MOUSE_OUT, this.onRoll);
                    spot.addEventListener(NavigatorEvent.SET_START_LOCATION, this.onDown);
                };
            };
            this.districts.spots = this.spots;
            this.indices = new Delaunay().compute(this.points);
            this.container.addChild(this.label);
            for each (p in Places[Locator.CITY.toUpperCase()]) {
                if (p.name.lastIndexOf("BETC") != -1){
                };
            };
            GoogleAnalytics.callPageView(GoogleAnalytics.APP_TOPVIEW);
            AppState.activate(DataType.PLACES);
            addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            this.showLocations();
        }
        private function showLocations():void{
            var d:Number;
            var spot:IntroSpot;
            if (Locator.STARTING_PLACE != null){
                Hud.addItem(new TrackerData(DataType.PLACES, 0, Locator.STARTING_PLACE.lon, Locator.STARTING_PLACE.lat, Locator.STARTING_PLACE.name));
                this.start(new Point(Locator.STARTING_PLACE.lon, Locator.STARTING_PLACE.lat));
                Locator.STARTING_PLACE = null;
            } else {
                if (this.lastSpot != null){
                    this.lastSpot.alpha = 1;
                };
                d = 0;
                for each (spot in this.spots) {
                    spot.alpha = 0;
                    d = (d + 0.05);
                    eaze(spot).delay(d).to(0.35, {alpha:1}).onStart(this.spotApear);
                };
            };
        }
        private function spotApear():void{
            SoundManager.playFX("ApparitionLieuxVille", (0.8 + (Math.random() * 0.2)));
        }
        private function hideLocations():void{
            var spot:IntroSpot;
            var d:Number = 0.1;
            for each (spot in this.spots) {
                d = (d + 0.02);
                eaze(spot).delay(d).to(0.1, {alpha:0});
            };
            d = (d + 0.01);
            eaze(spot).delay(d).to(0.1, {alpha:0}, false);
        }
        private function onRoll(e:MouseEvent):void{
            var mc:IntroSpot = (e.target as IntroSpot);
            this.tracker.screenPosition = ((this.tracker.screenPosition) || (new Point()));
            this.tracker.screenPosition.x = mc.x;
            this.tracker.screenPosition.y = mc.y;
            switch (e.type){
                case MouseEvent.ROLL_OVER:
                    this.label.rolloverHandler(this.tracker, mc.place.name);
                    break;
                case MouseEvent.ROLL_OUT:
                    this.label.rolloutHandler(this.tracker);
                    break;
            };
        }
        private function onDown(e:Event):void{
            var p:Point;
            if (e.type == NavigatorEvent.SET_START_LOCATION){
                this.start(((e as NavigatorEvent).data as Point));
            } else {
                p = new Point(this.debug.mouseX, this.debug.mouseY);
                p.x = GeomUtils.clamp(p.x, this.rect.left, this.rect.right);
                p.y = GeomUtils.clamp(p.y, this.rect.top, this.rect.bottom);
                p = Locator.INTRO_LOCATE(p.x, (this.rect.bottom - (p.y - this.rect.top)), this.rect);
                this.start(p);
            };
            SoundManager.playFX("ChargementCarte", 1);
        }
        private function start(point:Point):void{
            Locator.LONGITUDE = point.x;
            Locator.LATITUDE = point.y;
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onWheel);
            dispatchEvent(new NavigatorEvent(NavigatorEvent.INTRO_HIDE));
        }
        public function hide():void{
            mouseEnabled = false;
            mouseChildren = false;
            CameraController.VIEW = CameraController.TOP_VIEW;
            CameraController.applyView();
            CameraController.VIEW = CameraController.STREET_VIEW;
            this.hideLocations();
            this.zoomValue = 0;
            this.districts.stop();
            eaze(this).to(3, {zoomValue:1}).onUpdate(this.updateZoomIn).onComplete(this.onHidden);
        }
        private function updateZoomIn():void{
            var n:Number = this._zoomValue;
            var inv:Number = (1 - n);
            var min:Number = (CameraController.MAX_HEIGHT * 0.5);
            var max:Number = CameraController.MAX_HEIGHT;
            CameraController.instance.camera.y = (min + (Cubic.easeOut(inv) * (max - min)));
            this.main.simulation.alpha = n;
            this.bg.alpha = (this.picture.alpha = (this.districts.alpha = (1 - (n * 2))));
            this.title.alpha = (this.instructions.alpha = (1 - n));
        }
        private function onHidden():void{
            visible = false;
            Mouse.cursor = MouseCursor.ARROW;
            dispatchEvent(new NavigatorEvent(NavigatorEvent.INTRO_HIDDEN));
            this.debug.graphics.clear();
            GoogleAnalytics.callPageView(GoogleAnalytics.APP_MAP);
            SoundManager.playVibe(("BoucleAmbiance_" + Locator.CITY), 1);
        }
        public function show():void{
            SoundManager.playVibe("AmbianceCarteVille", 1);
            visible = true;
            this._zoomValue = 1;
            this.districts.start();
            eaze(this).to(2, {zoomValue:0}).easing(Expo.easeInOut).onUpdate(this.updateZoomOut).onComplete(this.onVisible);
            this.showLocations();
        }
        private function updateZoomOut():void{
            var n:Number = this._zoomValue;
            var inv:Number = (1 - n);
            var min:Number = (CameraController.MAX_HEIGHT * 0.5);
            var max:Number = CameraController.MAX_HEIGHT;
            CameraController.instance.camera.y = (min + (inv * (max - min)));
            var p:Point = Locator.INTRO_REMAP(Locator.LONGITUDE, Locator.LATITUDE, this.rect);
            this.main.simulation.alpha = n;
            this.bg.alpha = (this.picture.alpha = (this.districts.alpha = inv));
            this.title.alpha = (this.instructions.alpha = inv);
        }
        private function onVisible():void{
            mouseEnabled = true;
            mouseChildren = true;
            Mouse.cursor = MouseCursor.BUTTON;
            GoogleAnalytics.callPageView(GoogleAnalytics.APP_TOPVIEW);
            dispatchEvent(new NavigatorEvent(NavigatorEvent.INTRO_VISIBLE));
        }
        public function get zoomValue():Number{
            return (this._zoomValue);
        }
        public function set zoomValue(n:Number):void{
            this._zoomValue = n;
        }
        public function resize():void{
            if (stage == null){
                return;
            };
            var w:Number = stage.stageWidth;
            var h:Number = stage.stageHeight;
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(0, 0x606060);
            this.bg.graphics.drawRect(0, 0, w, h);
            this.containerZoom.x = (w * 0.5);
            this.containerZoom.y = (h * 0.5);
            this.title.x = ((w * 0.5) - (this.title.width * 0.5));
            this.title.y = 50;
            this.instructions.x = ((w * 0.5) - (this.instructions.width * 0.5));
            this.instructions.y = ((this.title.y + this.title.height) + 10);
        }
        public function storeLocation():void{
            this.lastLocation = new Point(Locator.LONGITUDE, Locator.LATITUDE);
            if (this.lastSpot == null){
                this.lastSpot = ((this.lastSpot) || (new IntroSpot(new Place("last position", Locator.LONGITUDE, Locator.LATITUDE), this.rect, 1)));
                this.lastSpot.addEventListener(MouseEvent.ROLL_OVER, this.onRoll);
                this.lastSpot.addEventListener(MouseEvent.ROLL_OUT, this.onRoll);
                this.lastSpot.addEventListener(MouseEvent.MOUSE_OUT, this.onRoll);
                this.lastSpot.addEventListener(NavigatorEvent.SET_START_LOCATION, this.onDown);
                this.container.addChild(this.lastSpot);
                this.spots.push(this.lastSpot);
            };
            this.lastSpot.reset(Locator.LONGITUDE, Locator.LATITUDE);
            this.lastSpot.alpha = 1;
            stage.addEventListener(MouseEvent.MOUSE_WHEEL, this.onWheel);
        }
        private function onWheel(e:MouseEvent):void{
            if (e.delta > 0){
                this.start(this.lastLocation);
            };
        }

    }
}//package wd.intro 
