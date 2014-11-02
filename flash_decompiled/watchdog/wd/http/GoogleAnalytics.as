package wd.http {
    import flash.utils.*;
    import flash.external.*;
    import wd.core.*;

    public class GoogleAnalytics {

        public static const APP_TOPVIEW:String = "/app/topview";
        public static const APP_MAP:String = "/app/map";
        public static const TUTORIAL_CLOSE:String = "/tutorial/close";
        public static const TUTORIAL_FIRST:String = "/tutorial/first";
        public static const TUTORIAL_SECOND:String = "/tutorial/second";
        public static const TUTORIAL_THIRD:String = "/tutorial/third";
        public static const TUTORIAL_FOURTH:String = "/tutorial/fourth";
        public static const TUTORIAL_FIFTH:String = "/tutorial/fifth";
        public static const TUTORIAL_SIXTH:String = "/tutorial/sixth";
        public static const TUTORIAL_SEVENTH:String = "/tutorial/seventh";
        public static const APP_FACEBOOK:String = "/app/facebook";
        public static const APP_FACEBOOK_DISCLAIMER:String = "/app/facebook/disclaimer";
        public static const APP_FACEBOOK_CONNECTED:String = "/app/facebook/connected";
        public static const FOOTER_WD:String = "/footer/wd";
        public static const FOOTER_UBI:String = "/footer/ubi";
        public static const FOOTER_SHARE_TWITTER:String = "/footer/share/twitter";
        public static const FOOTER_SHARE_FACEBOOK:String = "/footer/share/facebook";
        public static const FOOTER_SHARE_GOOGLE:String = "/footer/share/google";
        public static const FOOTER_SHARE_URLCOPY:String = "/footer/share/urlcopy";
        public static const FOOTER_ABOUT:String = "/footer/about";
        public static const FOOTER_LEGALS:String = "/footer/legals";
        public static const FOOTER_HELP:String = "/footer/help";
        public static const FOOTER_LANGUAGE:String = "/footer/language";
        public static const FOOTER_SOUND:String = "/footer/sound";
        public static const FOOTER_FULLSCREEN:String = "/footer/fullscreen";
        public static const MAP_ITEM_CLICK:String = "mapItemClick";
        public static const FB_ITEM_CLICK:String = "fbItemClick";
        public static const PAGE_VIEW:String = "_pageView";
        public static const TRACK_EVENT:String = "_trackEvent";

        public static var TRANSPORTS:String = "transports";
        public static var NETWORKS:String = "networks";
        public static var STREET_FURNITURE:String = "street furnitures";
        public static var SOCIAL:String = "social";
        private static var tags:Dictionary = new Dictionary();

        private var campaignId:String;

        public function GoogleAnalytics(xml:XMLList){
            var t:XML;
            var tag:GoogleAnalyticsTag;
            super();
            TRANSPORTS = ((xml.transports) || ("transports"));
            NETWORKS = ((xml.networks) || ("networks"));
            STREET_FURNITURE = ((xml.streetFurniture) || ("street furnitures"));
            SOCIAL = ((xml.social) || ("social"));
            for each (t in xml.tag) {
                tag = new GoogleAnalyticsTag(t.@id, t.@type, t.@format);
                tags[tag.id] = tag;
            };
        }
        public static function callPageView(value:String):void{
            var tag:GoogleAnalyticsTag = tags[value];
            if (ExternalInterface.available){
                ExternalInterface.call("pushPageview", tag.format);
            };
        }
        public static function mapItemClick(datatype:int=0):void{
            var str:String = (Config.CITY + ",");
            str = (str + (getCategoryFromData(datatype) + ","));
            str = (str + (getRawDataName(datatype) + ","));
            str = (str + "0");
            if (ExternalInterface.available){
                ExternalInterface.call("pushEvent", Config.CITY, getCategoryFromData(datatype), getRawDataName(datatype), "0");
            };
        }
        public static function FBItemClick(datatype:int=0):void{
            var tag:GoogleAnalyticsTag = tags[FB_ITEM_CLICK];
            var str:String = tag.format.replace("city", Config.CITY);
            if (ExternalInterface.available){
                ExternalInterface.call("pushEvent", str);
            };
        }
        private static function getCategoryFromData(type:int):String{
            if (type == DataType.ADS){
                return (STREET_FURNITURE);
            };
            if (type == DataType.ATMS){
                return (STREET_FURNITURE);
            };
            if (type == DataType.CAMERAS){
                return (STREET_FURNITURE);
            };
            if (type == DataType.ELECTROMAGNETICS){
                return (NETWORKS);
            };
            if (type == DataType.FLICKRS){
                return (SOCIAL);
            };
            if (type == DataType.FOUR_SQUARE){
                return (SOCIAL);
            };
            if (type == DataType.INSTAGRAMS){
                return (SOCIAL);
            };
            if (type == DataType.INTERNET_RELAYS){
                return (NETWORKS);
            };
            if (type == DataType.METRO_STATIONS){
                return (TRANSPORTS);
            };
            if (type == DataType.MOBILES){
                return (NETWORKS);
            };
            if (type == DataType.PLACES){
                return ("places");
            };
            if (type == DataType.RADARS){
                return (STREET_FURNITURE);
            };
            if (type == DataType.TOILETS){
                return (STREET_FURNITURE);
            };
            if (type == DataType.TRAFFIC_LIGHTS){
                return (STREET_FURNITURE);
            };
            if (type == DataType.TRAINS){
                return (TRANSPORTS);
            };
            if (type == DataType.TWITTERS){
                return (SOCIAL);
            };
            if (type == DataType.VELO_STATIONS){
                return (TRANSPORTS);
            };
            if (type == DataType.WIFIS){
                return (NETWORKS);
            };
            return ("");
        }
        private static function getRawDataName(type:int):String{
            if (type == DataType.ADS){
                return ("ads");
            };
            if (type == DataType.ATMS){
                return ("atms");
            };
            if (type == DataType.CAMERAS){
                return ("cameras");
            };
            if (type == DataType.ELECTROMAGNETICS){
                return ("electromagnetics");
            };
            if (type == DataType.FLICKRS){
                return ("flickrs");
            };
            if (type == DataType.FOUR_SQUARE){
                return ("fourSquare");
            };
            if (type == DataType.INSTAGRAMS){
                return ("instagram");
            };
            if (type == DataType.INTERNET_RELAYS){
                return ("internetRelays");
            };
            if (type == DataType.METRO_STATIONS){
                return ("metro");
            };
            if (type == DataType.MOBILES){
                return ("mobile");
            };
            if (type == DataType.PLACES){
                return ("places");
            };
            if (type == DataType.RADARS){
                return ("radars");
            };
            if (type == DataType.TOILETS){
                return ("toilets");
            };
            if (type == DataType.TRAFFIC_LIGHTS){
                return ("traffic");
            };
            if (type == DataType.TRAINS){
                return ("trains");
            };
            if (type == DataType.TWITTERS){
                return ("twitter");
            };
            if (type == DataType.VELO_STATIONS){
                return ("bicycle");
            };
            if (type == DataType.WIFIS){
                return ("wifi");
            };
            return ("");
        }

    }
}//package wd.http 
