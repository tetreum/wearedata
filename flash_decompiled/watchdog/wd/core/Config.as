package wd.core {
    import flash.net.*;
    import flash.events.*;
    import wd.http.*;
    import wd.events.*;
    import flash.geom.*;
    import wd.providers.texts.*;
    import flash.text.*;
    import wd.utils.*;

    public class Config extends EventDispatcher {

        public static const FACEBOOK_LOGIN_OPTS:Object = {scope:"user_work_history, user_birthday"};

        private static var config:XML;
        private static var filterAvailability:FilterAvailability;
        public static var city_xml:XML;
        public static var STYLESHEET:StyleSheet;
        public static var ROOT_URL:String;
        public static var GATEWAY:String = "http://ubisoft-ctos-recette.betc.fr/amfserver.php";
        public static var LIVE_FEED_GATEWAY:String;
        public static var FACEBOOK_APP_ID:String = "519212701474404";
        public static var FACEBOOK_CONNECT_AVAILABLE:Boolean = true;
        public static var LIVE_WEBSOCKETSERVER_URL:String;
        public static var FONTS_FILE:String = "";
        public static var CSS_FILE:String = "";
        public static var DEBUG:Boolean;
        public static var DEBUG_FLASHVARS:Boolean;
        public static var DEBUG_SIMULATION:Boolean;
        public static var DEBUG_SERVICES:Boolean;
        public static var DEBUG_LOCATOR:Boolean;
        public static var DEBUG_HUD:Boolean;
        public static var DEBUG_TRACKER:Boolean;
        public static var NAVIGATION_LOCKED:Boolean;
        public static var TOKEN:String;
        public static var CITY:String;
        public static var LANG:String;
        public static var LOCALE:String;
        public static var COUNTRY:String;
        public static var STARTING_PLACE:Place;
        public static var WORLD_RECT:Rectangle;
        public static var WORLD_SCALE:Number;
        public static var MIN_BUILDING_HEIGHT:Number;
        public static var MAX_BUILDING_HEIGHT:Number;
        public static var BUILDING_DEBRIS_OFFSET:Number;
        public static var CAM_MIN_HEIGHT:Number;
        public static var CAM_MAX_HEIGHT:Number;
        public static var CAM_MIN_FOV:Number;
        public static var CAM_MAX_FOV:Number;
        public static var CAM_MIN_RADIUS:Number;
        public static var CAM_MAX_RADIUS:Number;
        public static var XML_LANG_MENU:XML;
        public static var SETTINGS_BUILDING_RADIUS:Number;
        public static var SETTINGS_BUILDING_PAGINATION:Number;
        public static var SETTINGS_DATA_RADIUS:Number;
        public static var SETTINGS_DATA_PAGINATION:Number;
        public static var AGENT:String;

        private var loader:URLLoader;
        private var req:URLRequest;
        private var loadingProfile:String;

        public function Config(city:String, locale:String, loadingProfile:String, agent:String, xmlUrl:String="assets/xml/config.xml"){
            super();
            this.loadingProfile = loadingProfile;
            CITY = city;
            LOCALE = locale;
            LANG = locale.split("-")[0];
            COUNTRY = locale.split("-")[1];
            AGENT = agent;
            this.req = new URLRequest(xmlUrl);
            this.loader = new URLLoader();
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.errorHandler);
            this.loader.addEventListener(Event.COMPLETE, this.xmlCompleteHandler);
        }
        public static function get CONTENT_FILE():String{
            return ((((("assets/xml/" + LANG.toLowerCase()) + "-") + COUNTRY.toUpperCase()) + "/content.xml"));
        }

        public function load():void{
            this.loader.load(this.req);
        }
        private function xmlCompleteHandler(e:Event):void{
            var e:* = e;
            config = new XML(this.loader.data);
            TOKEN = ((config.weAreData) || (""));
            GATEWAY = config.service.path.@url;
            var mode:* = this.loadingProfile;
            SETTINGS_BUILDING_RADIUS = parseFloat(config.service.mode.child(mode).building.@radius);
            SETTINGS_BUILDING_PAGINATION = parseFloat(config.service.mode.child(mode).building.@pagination);
            SETTINGS_DATA_RADIUS = parseFloat(config.service.mode.child(mode).data.@radius);
            SETTINGS_DATA_PAGINATION = parseFloat(config.service.mode.child(mode).data.@pagination);
            if (isNaN(SETTINGS_BUILDING_RADIUS)){
                SETTINGS_BUILDING_RADIUS = 0.5;
            };
            if (isNaN(SETTINGS_BUILDING_PAGINATION)){
                SETTINGS_BUILDING_PAGINATION = 5000;
            };
            if (isNaN(SETTINGS_DATA_RADIUS)){
                SETTINGS_DATA_RADIUS = 1;
            };
            if (isNaN(SETTINGS_DATA_PAGINATION)){
                SETTINGS_DATA_PAGINATION = 5000;
            };
            new GoogleAnalytics(config.googleAnalytics);
            FACEBOOK_APP_ID = config.facebook.appId;
            FACEBOOK_CONNECT_AVAILABLE = ((config.languages.lang.(@locale == LOCALE).@facebookConnectAvailable)=="false") ? false : true;
            LIVE_WEBSOCKETSERVER_URL = config.live.socketServer.@url;
            ROOT_URL = config.rootUrl.@url;
            FONTS_FILE = config.languages.lang.(@locale == LOCALE).@fonts;
            CSS_FILE = config.languages.lang.(@locale == LOCALE).@css;
            DEBUG = !((config.debug.@active == "0"));
            if (DEBUG){
                DEBUG_FLASHVARS = !((config.debug.flashVars == "0"));
                DEBUG_SIMULATION = !((config.debug.simulation == "0"));
                DEBUG_SERVICES = !((config.debug.service == "0"));
                DEBUG_LOCATOR = !((config.debug.locator == "0"));
                DEBUG_HUD = !((config.debug.hud == "0"));
                DEBUG_TRACKER = !((config.debug.tracker == "0"));
            };
            CAM_MIN_FOV = parseFloat(config.cameraController.minFOV);
            CAM_MAX_FOV = parseFloat(config.cameraController.maxFOV);
            XML_LANG_MENU = config.languages[0];
            this.loader.removeEventListener(Event.COMPLETE, this.xmlCompleteHandler);
            dispatchEvent(new LoadingEvent(LoadingEvent.CONFIG_COMPLETE));
        }
        public function loadCity():void{
            this.loader.addEventListener(Event.COMPLETE, this.cityCompleteHandler);
            var req:URLRequest = new URLRequest((("assets/xml/" + CITY.toLowerCase()) + ".xml"));
            this.loader.load(req);
        }
        private function cityCompleteHandler(e:Event):void{
            city_xml = new XML(this.loader.data);
            CAM_MIN_HEIGHT = parseFloat(city_xml.camera.minHeight);
            CAM_MAX_HEIGHT = parseFloat(city_xml.camera.maxHeight);
            CAM_MIN_RADIUS = parseFloat(city_xml.camera.minRadius);
            CAM_MAX_RADIUS = parseFloat(city_xml.camera.maxRadius);
            WORLD_RECT = new Rectangle(city_xml.bounds.@minlon, city_xml.bounds.@minlat, city_xml.bounds.@maxlon, city_xml.bounds.@maxlat);
            WORLD_SCALE = parseFloat(city_xml.worldScale);
            MIN_BUILDING_HEIGHT = parseFloat(city_xml.building.@minHeight);
            MAX_BUILDING_HEIGHT = parseFloat(city_xml.building.@maxHeight);
            BUILDING_DEBRIS_OFFSET = parseFloat(city_xml.building.@debrisOffset);
            trace(WORLD_SCALE, MIN_BUILDING_HEIGHT, MAX_BUILDING_HEIGHT, BUILDING_DEBRIS_OFFSET);
            filterAvailability = new FilterAvailability();
            filterAvailability.reset(city_xml.filters);
            this.loader.removeEventListener(Event.COMPLETE, this.cityCompleteHandler);
            this.loader.addEventListener(Event.COMPLETE, this.loaderCompleteHandler);
            var req:URLRequest = new URLRequest(("assets/css/" + CSS_FILE));
            this.loader.load(req);
            dispatchEvent(new LoadingEvent(LoadingEvent.CITY_COMPLETE));
            CityTexts.resetUnits(city_xml.dataUnits[0]);
        }
        public function loaderCompleteHandler(event:Event):void{
            STYLESHEET = new StyleSheet();
            STYLESHEET.parseCSS(this.loader.data);
            dispatchEvent(new LoadingEvent(LoadingEvent.CSS_COMPLETE));
        }
        public function errorHandler(e:IOErrorEvent):void{
            trace(this, e.text);
        }

    }
}//package wd.core 
