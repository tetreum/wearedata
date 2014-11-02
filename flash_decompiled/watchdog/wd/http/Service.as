package wd.http {
    import flash.geom.*;
    import wd.utils.*;
    import wd.core.*;
    import flash.net.*;
    import flash.display.*;

    public class Service extends Sprite {

        public static const METHOD_ADS:String = "WatchDog.getAdvertisements";
        public static const METHOD_ATM:String = "WatchDog.getAtms";
        public static const METHOD_BUILDINGS:String = "WatchDog.getBuildings";
        public static const METHOD_CAMERAS:String = "WatchDog.getCameras";
        public static const METHOD_DISTRICT:String = "WatchDog.getDistrict";
        public static const METHOD_ELECTROMAGNETIC:String = "WatchDog.getElectromagnicals";
        public static const METHOD_FLICKRS:String = "WatchDog.getFlickrs";
        public static const METHOD_FOUR_SQUARE:String = "WatchDog.getVenues";
        public static const METHOD_INSTAGRAMS:String = "WatchDog.getInstagrams";
        public static const METHOD_INTERNET_RELAYS:String = "WatchDog.getNras";
        public static const METHOD_METRO:String = "WatchDog.getMetro";
        public static const METHOD_MOBILE:String = "WatchDog.getAntennas";
        public static const METHOD_PARCS:String = "WatchDog.getParcs";
        public static const METHOD_PLACES:String = "WatchDog.getPlaces";
        public static const METHOD_STAISTICS:String = "WatchDog.getStatistics";
        public static const METHOD_RADARS:String = "WatchDog.getRadars";
        public static const METHOD_RIVERS:String = "WatchDog.getRivers";
        public static const METHOD_TOILETS:String = "WatchDog.getToilets";
        public static const METHOD_TRAFFIC:String = "WatchDog.getSignals";
        public static const METHOD_VELO_STATIONS:String = "WatchDog.getVeloStations";
        public static const METHOD_WIFI:String = "WatchDog.getWifis";
        public static const METHOD_TWITTERS:String = "WatchDog.getTweets";
        public static const METHOD_TINYURL:String = "WatchDog.tinyUrl";
        public static const METHOD_RAILS:String = "WatchDog.getRails";

        public static var gateway:String = "http://ubisoft-ctos-dev.betc.fr/amfserver.php";
        public static var debug:Boolean = false;

        protected var connection:NetConnection;

        public function Service(){
            super();
            this.connection = new NetConnection();
            this.connection.connect(Config.GATEWAY);
            if (Config.DEBUG_SERVICES){
                trace(this, "gateway", gateway);
            };
        }
        public static function initServiceConstants():ServiceConstants{
            var param:ServiceConstants = new ServiceConstants();
            resetServiceConstants(param);
            return (param);
        }
        public static function resetServiceConstants(param:ServiceConstants):void{
            var p:Point = new Point(Locator.LONGITUDE, Locator.LATITUDE);
            param[ServiceConstants.PREV_LONGITUDE] = ("" + String(p.x));
            param[ServiceConstants.PREV_LATTITUDE] = ("" + String(p.y));
            param[ServiceConstants.LONGITUDE] = ("" + String(Locator.LONGITUDE));
            param[ServiceConstants.LATTITUDE] = ("" + String(Locator.LATITUDE));
            param[ServiceConstants.RADIUS] = ("" + ServiceConstants.REQ_RADIUS);
            param[ServiceConstants.ITEMS_PER_PAGE] = ServiceConstants.REQ_ITEM_PER_PAGE;
            param[ServiceConstants.PAGE] = 0;
            param[ServiceConstants.TOWN] = Config.CITY;
        }

        public function customCall(serviceName:String, responder:Responder, args=null):void{
            try {
                this.connection.call(serviceName, responder, args);
                if (Config.DEBUG_SERVICES){
                    trace(this, "customCall", serviceName, "-> args", args);
                };
            } catch(err:Error) {
            };
        }

    }
}//package wd.http 
