package {
    import flash.display.*;
    import wd.utils.*;
    import wd.core.*;
    import wd.http.*;
    import wd.events.*;
    import flash.events.*;
    import wd.providers.texts.*;
    import wd.loaderAnim.*;
    import aze.motion.*;
    import flash.net.*;
    import wd.hud.common.text.*;
    import flash.utils.*;

    public class Preloader extends MovieClip {

        private var textProvider:TextProvider;
        private var fontLoader:URLLoader;
        private var fontsLoaded:Boolean = false;
        private var cfg:Config;
        private var token:String;
        private var preloadClip:PreloaderWD;
        private var tc:TokenChecker;
        private var loadingProfile:String;
        private var agent:String;

        public function Preloader(){
            super();
            if (stage){
                stage.scaleMode = StageScaleMode.NO_SCALE;
                stage.align = StageAlign.TOP_LEFT;
            };
            this.token = loaderInfo.parameters["ticket"];
            this.loadingProfile = ((loaderInfo.parameters["profile"]) || ("average"));
            this.agent = ((loaderInfo.parameters["agent"]) || (""));
            var locale:String = loaderInfo.parameters["locale"];
            if ((((((loaderInfo.parameters["locale"] == undefined)) || ((locale == null)))) || ((locale == "")))){
                locale = "fr-FR";
            };
            var city:String = loaderInfo.parameters["city"];
            if ((((((loaderInfo.parameters["city"] == undefined)) || ((city == null)))) || ((city == "")))){
                city = Locator.PARIS;
            };
            var lon:Number = parseFloat(loaderInfo.parameters["place_lon"]);
            if ((((loaderInfo.parameters["place_lon"] == undefined)) || ((lon == 0)))){
                lon = NaN;
            };
            var lat:Number = parseFloat(loaderInfo.parameters["place_lat"]);
            if ((((loaderInfo.parameters["place_lat"] == undefined)) || ((lat == 0)))){
                lat = NaN;
            };
            var name:String = loaderInfo.parameters["place_name"];
            if ((((((loaderInfo.parameters["place_name"] == undefined)) || ((name == null)))) || ((name == "")))){
                name = "";
            };
            if (((!(isNaN(lon))) && (!(isNaN(lat))))){
                Config.STARTING_PLACE = new Place(name, lon, lat);
            };
            var state:uint = (((loaderInfo.parameters["app_state"] == null)) ? DataType.METRO_STATIONS : loaderInfo.parameters["app_state"]);
            new AppState(state);
            AppState.activate(DataType.TRAINS);
            this.cfg = new Config(city, locale, this.loadingProfile, this.agent);
            this.cfg.addEventListener(LoadingEvent.CONFIG_COMPLETE, this.onConfigLoaded);
            this.cfg.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
            URLFormater.setData({
                lat:lat,
                long:lon,
                appState:state,
                place:name,
                city:city,
                locale:locale
            });
            this.cfg.load();
        }
        private function onConfigLoaded(e:LoadingEvent):void{
            if (Config.DEBUG){
                trace("config XML loaded");
            };
            this.cfg.removeEventListener(LoadingEvent.CONFIG_COMPLETE, this.onConfigLoaded);
            this.tc = new TokenChecker();
            this.tc.addEventListener(ServiceEvent.TOKEN_VALID, this.onTokenChecked);
            if (((!((this.token == ""))) && (!((this.token == null))))){
                this.tc.load(this.token);
            } else {
                this.tc.load(Config.TOKEN);
            };
        }
        private function onTokenChecked(e:ServiceEvent=null):void{
            this.tc.removeEventListener(ServiceEvent.TOKEN_VALID, this.onTokenChecked);
            this.cfg.addEventListener(LoadingEvent.CITY_COMPLETE, this.onCityLoaded);
            this.cfg.loadCity();
        }
        private function onCityLoaded(e:LoadingEvent):void{
            if (Config.DEBUG){
                trace("CITY loaded");
            };
            this.cfg.removeEventListener(LoadingEvent.CITY_COMPLETE, this.onCityLoaded);
            this.textProvider = new TextProvider();
            this.textProvider.addEventListener(Event.COMPLETE, this.onTextComplete);
            this.textProvider.resetLanguage();
        }
        private function onTextComplete(e:Event):void{
            if (Config.DEBUG){
                trace("text XML loaded");
            };
            this.textProvider.removeEventListener(Event.COMPLETE, this.onTextComplete);
            this.preloadClip = new PreloaderWD();
            this.preloadClip.alpha = 0;
            addChild(this.preloadClip);
            this.preloadClip.addEventListener(Event.RESIZE, this.onResize);
            this.onResize(null);
            eaze(this.preloadClip).to(1, {alpha:1});
            addEventListener(Event.ENTER_FRAME, this.checkFrame);
            loaderInfo.addEventListener(ProgressEvent.PROGRESS, this.progress);
            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
            trace(("Config.FONTS_FILE : " + Config.FONTS_FILE));
            if (Config.FONTS_FILE != "system"){
                this.fontLoader = new URLLoader();
                this.fontLoader.dataFormat = "binary";
                this.fontLoader.addEventListener(ProgressEvent.PROGRESS, this.progress);
                this.fontLoader.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
                this.fontLoader.addEventListener(Event.COMPLETE, this.fontsLoadCompleteHandler);
                this.fontLoader.load(new URLRequest(("assets/fonts/" + Config.FONTS_FILE)));
            } else {
                this.fontsLoaded = true;
                CustomTextField.embedFonts = false;
            };
        }
        private function onResize(e:Event):void{
            this.preloadClip.x = (stage.stageWidth * 0.5);
            this.preloadClip.y = (stage.stageHeight * 0.5);
        }
        private function fontsLoadCompleteHandler(e:Event):void{
            var ld:Loader = new Loader();
            ld.loadBytes(e.target.data);
            ld.contentLoaderInfo.addEventListener(Event.INIT, this.fontsInit);
        }
        private function fontsInit(e:Event):void{
            this.fontsLoaded = true;
        }
        private function ioError(e:IOErrorEvent):void{
            trace(e.text);
        }
        private function progress(e:ProgressEvent):void{
            var ratio:Number;
            if (Config.FONTS_FILE == "system"){
                ratio = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
            } else {
                ratio = ((loaderInfo.bytesLoaded + this.fontLoader.bytesLoaded) / (loaderInfo.bytesTotal + this.fontLoader.bytesTotal));
            };
            this.preloadClip.onProgress((ratio * 100));
        }
        private function checkFrame(e:Event):void{
            if ((((currentFrame == totalFrames)) && (this.fontsLoaded))){
                stop();
                removeEventListener(Event.ENTER_FRAME, this.checkFrame);
                eaze(this.preloadClip).to(1, {alpha:0}).onComplete(this.loadingFinished);
            };
            this.onResize(e);
        }
        private function loadingFinished():void{
            loaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.progress);
            loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.ioError);
            this.startup();
        }
        private function startup():void{
            var mainClass:Class = (getDefinitionByName("Main") as Class);
            addChild((new (mainClass)() as DisplayObject));
        }

    }
}//package 
