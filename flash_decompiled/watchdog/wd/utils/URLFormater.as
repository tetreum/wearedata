package wd.utils {
    import wd.core.*;
    import wd.http.*;
    import flash.net.*;
    import flash.events.*;

    public class URLFormater extends EventDispatcher {

        public static const SHARE_TO_TWITTER:String = "SHARE_TO_TWITTER";
        public static const SHARE_TO_FACEBOOK:String = "SHARE_TO_FACEBOOK";
        public static const SHARE_TO_GPLUS:String = "SHARE_TO_L'EXCLU_DE_TOUS";

        private static var _city:String;
        private static var _locale:String;
        private static var _appState:String;
        private static var _lat:Number;
        private static var _long:Number;
        private static var _place:String;
        private static var _district:String;
        private static var _activityType:int;
        private static var connection:NetConnection;
        private static var responder:Responder;
        private static var callback:Function;

        public function URLFormater(){
            super();
        }
        public static function get url():String{
            var r:String = (Config.ROOT_URL + "start.php?");
            r = (r + ("locale=" + Config.LOCALE));
            r = (r + ("&app_state=" + AppState.state));
            if (activityType != -1){
                r = (r + ("&place_lon=" + Locator.LONGITUDE));
                r = (r + ("&place_lat=" + Locator.LATITUDE));
                r = (r + ("&place_name=" + DataType.toString(activityType)));
            };
            r = (r + ("#/map/" + Config.CITY));
            return (r);
        }
        public static function changeLanguageUrl(locale:String):String{
            return (((((((Config.ROOT_URL + "start.php?locale=") + locale) + "&city=") + Config.CITY) + "#/map/") + Config.CITY));
        }
        public static function changeCityUrl(city:String):String{
            return (((((Config.ROOT_URL + "start.php?locale=") + Config.LOCALE) + "&city=") + city));
        }
        public static function shorten(callback:Function, shareTo:String=""):void{
            var u:String = url;
            if (shareTo == SHARE_TO_TWITTER){
                u = (u + "&utm_source=share&utm_campaign=wearedata&utm_medium=twitter");
            } else {
                if (shareTo == SHARE_TO_FACEBOOK){
                    u = (u + "&utm_source=share&utm_campaign=wearedata&utm_medium=facebook");
                } else {
                    if (shareTo == SHARE_TO_GPLUS){
                        u = (u + "&utm_source=share&utm_campaign=wearedata&utm_medium=gplus");
                    };
                };
            };
            if (connection == null){
                connection = new NetConnection();
                connection.connect(Config.GATEWAY);
                responder = new Responder(onSuccess, onFail);
            };
            URLFormater.callback = callback;
            connection.call(Service.METHOD_TINYURL, responder, url);
        }
        public static function shortenURL(specificUrl:String, callback:Function):void{
            if (connection == null){
                connection = new NetConnection();
                connection.connect(Config.GATEWAY);
                responder = new Responder(onSuccess, onFail);
            };
            URLFormater.callback = callback;
            connection.call(Service.METHOD_TINYURL, responder, specificUrl);
        }
        private static function onSuccess(result):void{
            callback((result as String));
        }
        private static function onFail(error):void{
            callback(Config.ROOT_URL);
        }
        public static function set city(value:String):void{
            _city = value;
        }
        public static function set locale(value:String):void{
            _locale = value;
        }
        public static function set appState(value:String):void{
            _appState = value;
        }
        public static function set lat(value:Number):void{
            _lat = value;
        }
        public static function set long(value:Number):void{
            _long = value;
        }
        public static function set place(value:String):void{
            _place = value;
        }
        public static function get city():String{
            return (_city);
        }
        public static function get locale():String{
            return (_locale);
        }
        public static function get place():String{
            return (_place);
        }
        public static function get district():String{
            return (_district);
        }
        public static function set district(value:String):void{
            _district = value;
        }
        public static function get activityType():int{
            return (_activityType);
        }
        public static function set activityType(value:int):void{
            _activityType = value;
        }
        public static function setData(data:Object):void{
            var i:String;
            for (i in data) {
                if (data[i]){
                    URLFormater[i] = data[i];
                };
            };
        }
        public static function addAnchors(text:String):String{
            var result:String = "";
            var pattern:RegExp = /(?<!\S)(((f|ht){1}tp[s]?:\/\/|(?<!\S)www\.)[-a-zA-Z0-9@:%_\+.~#?&\/\/=]+)/g;
            while (pattern.test(text)) {
                result = text.replace(pattern, "<u><a href=\"$&\" target=\"_blank\">$&</a></u>");
            };
            if (result == ""){
                result = (result + text);
            };
            return (result);
        }
        public static function replaceTags(input:String):String{
            var r:String = input;
            if (place == null){
                place = "";
            };
            r = r.replace("#type#", place);
            r = r.replace("#district#", district);
            r = r.replace("#city#", city);
            return (r);
        }

    }
}//package wd.utils 
