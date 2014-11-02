package wd.landing {
    import flash.events.*;
    import wd.landing.loading.*;
    import wd.landing.effect.*;
    import flash.display.*;
    import wd.landing.sound.*;
    import flash.utils.*;
    import wd.landing.tag.*;
    import wd.landing.text.*;
    import flash.external.*;

    public class MainLanding extends Sprite {

        public static const SPEED_Y:Number = 0.3;
        public static const RADIUS:Number = 220;
        public static const WIDTH:Number = 800;
        public static const HEIGHT:Number = 600;

        public static var CITY:String;
        public static var LOCALE:String;
        public static var LONG:String;
        public static var LAT:String;
        public static var PLACE:String;
        public static var LAYER:String;

        private var _bgBlack:mcBg;
        private var _bgCircle:BackgroundSphere;
        private var _sphere:Sphere;
        private var _stars:Stars;
        private var _titleLanding:TitleLanding;
        private var _key:String = "";
        private var ROOT_URL:String;
        private var FONTS_FILE:String;
        private var CSS_FILE:String;
        private var XML_FILE:String;

        public function MainLanding():void{
            if (stage){
                this.init();
            } else {
                addEventListener(Event.ADDED_TO_STAGE, this.init);
            };
        }
        private function init(_arg1:Event=null):void{
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            removeEventListener(Event.ADDED_TO_STAGE, this.init);
            var _local2:Object = {};
            _local2 = stage.loaderInfo.parameters;
            CITY = _local2.city;
            LOCALE = _local2.locale;
            LONG = _local2.place_lon;
            LAT = _local2.place_lat;
            PLACE = _local2.place_name;
            if (!LOCALE){
                LOCALE = "fr-FR";
            };
            this.loadAssets();
        }
        private function loadAssets():void{
            this.createBg();
            this.createSphere();
            this.createStars();
            this.loadXmlConfing();
            this.startListen();
            stage.addEventListener(Event.RESIZE, this.resizeStageHandler);
            this.resizeStageHandler(null);
            var _local1:Timer = new Timer(3000, 0);
            _local1.addEventListener(TimerEvent.TIMER, this.setEffect);
            _local1.start();
        }
        private function begin():void{
            this.initSound();
            this.createButtons();
            this.createTitle();
            this.resizeStageHandler(null);
            if (ExternalInterface.available){
                ExternalInterface.call("__landing.show");
            };
        }
        private function initSound():void{
            LandingSoundManager.getInstance();
        }
        private function loadXmlConfing():void{
            XmlLoading2.getInstance().addEventListener(XmlLoading.XML_IS_READY, this.onXmlConfigLoaded);
            XmlLoading2.getInstance().startToLoad("assets/xml/config.xml");
        }
        private function onXmlConfigLoaded(_arg1:Event):void{
            var e:* = _arg1;
            XmlLoading2.getInstance().removeEventListener(XmlLoading.XML_IS_READY, this.onXmlLoaded);
            this.ROOT_URL = XMLList(XmlLoading2.getInstance().getXml()).rootUrl.@url;
            this.FONTS_FILE = XMLList(XmlLoading2.getInstance().getXml()).languages.lang.(@locale == LOCALE).@fonts;
            this.CSS_FILE = ("assets/css/" + XMLList(XmlLoading2.getInstance().getXml()).languages.lang.(@locale == LOCALE).@css);
            this.XML_FILE = (("assets/xml/" + LOCALE) + "/landing.xml");
            if (this.FONTS_FILE != "system"){
                Tdf_landing.embedFonts = true;
                this.FONTS_FILE = ("assets/fonts/" + this.FONTS_FILE);
            } else {
                Tdf_landing.embedFonts = false;
            };
            this.loadXmlContent();
        }
        private function loadXmlContent():void{
            XmlLoading.getInstance().addEventListener(XmlLoading.XML_IS_READY, this.onXmlLoaded);
            XmlLoading.getInstance().startToLoad(this.XML_FILE);
        }
        private function onXmlLoaded(_arg1:Event):void{
            SendTag.tagPageView(XMLList(XmlLoading.getInstance().getXml()).content.tag);
            XmlLoading.getInstance().removeEventListener(XmlLoading.XML_IS_READY, this.onXmlLoaded);
            if (Tdf_landing.embedFonts){
                this.loadFont();
            } else {
                this.loadCss();
            };
        }
        private function loadFont():void{
            FontLoading.getInstance().addEventListener(FontLoading.FONT_ARE_READY, this.onFontLoaded);
            FontLoading.getInstance().loadFont(this.FONTS_FILE);
        }
        private function onFontLoaded(_arg1:Event):void{
            FontLoading.getInstance().removeEventListener(FontLoading.FONT_ARE_READY, this.onFontLoaded);
            this.loadCss();
        }
        private function loadCss():void{
            CssLoading.getInstance().addEventListener(CssLoading.CSS_IS_READY, this.onCssLoaded);
            CssLoading.getInstance().startToLoad(this.CSS_FILE);
        }
        private function onCssLoaded(_arg1:Event):void{
            this.begin();
            FontLoading.getInstance().removeEventListener(CssLoading.CSS_IS_READY, this.onCssLoaded);
        }
        private function resizeStageHandler(_arg1:Event):void{
            if (this._bgBlack){
                this._bgBlack.width = stage.stageWidth;
                this._bgBlack.height = stage.stageHeight;
            };
            if (this._bgCircle){
                this._bgCircle.x = (stage.stageWidth >> 1);
                this._bgCircle.y = (stage.stageHeight >> 1);
            };
            if (this._sphere){
                this._sphere.x = (stage.stageWidth >> 1);
                this._sphere.y = (stage.stageHeight >> 1);
            };
            if (this._stars){
                this._stars.x = (stage.stageWidth >> 1);
                this._stars.y = (stage.stageHeight >> 1);
            };
            if (this._titleLanding){
                this._titleLanding.x = (stage.stageWidth >> 1);
                this._titleLanding.y = ((stage.stageHeight - this._titleLanding.height) >> 1);
            };
        }
        private function createSphere():void{
            this._sphere = new Sphere(new imageMap());
            addChild(this._sphere);
        }
        private function createStars():void{
            this._stars = new Stars();
            addChild(this._stars);
        }
        private function createBg():void{
            this._bgCircle = new BackgroundSphere();
            addChild(this._bgCircle);
        }
        private function createTitle():void{
            this._titleLanding = new TitleLanding(XMLList(XmlLoading.getInstance().getXml()).content.info);
            addChild(this._titleLanding);
            DistortImg_sglT.instance.startEffect(this._titleLanding, 15);
        }
        private function createButtons():void{
            this._stars.createButton(XMLList(XmlLoading.getInstance().getXml()).content.buttons, this.ROOT_URL);
        }
        private function setEffect(_arg1:TimerEvent):void{
            var _local2:int = (Math.random() * 4);
            switch (_local2){
                case 1:
                    DistortImg_sglT.instance.startEffect(this._sphere, 15);
                    break;
                case 2:
                    DistortImg_sglT.instance.startEffect(this._stars, 15);
                    break;
                case 3:
                    break;
            };
        }
        private function startListen():void{
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyPressedDown);
        }
        private function keyPressedDown(_arg1:KeyboardEvent):void{
            var _local2:uint = _arg1.keyCode;
            this._key = (this._key + String(_local2));
            if (this._key.search("38384040373937396665") >= 0){
                this._titleLanding.visible = false;
                this._key = "";
                this._sphere.stopEnterFrame();
                removeChild(this._sphere);
                this._sphere = new Sphere(new lapin());
                addChild(this._sphere);
                this.resizeStageHandler(null);
            };
        }

    }
}//package wd.landing 
