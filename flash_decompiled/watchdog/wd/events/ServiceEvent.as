package wd.events {
    import flash.events.*;

    public class ServiceEvent extends Event {

        public static const SINGLE_BUILDING_COMPLETE:String = "singleBuildingComplete";
        public static const SINGLE_BUILDING_CANCEL:String = "singleBuildingCancel";
        public static const BUILDINGS_COMPLETE:String = "buildingsComplete";
        public static const BUILDINGS_CANCEL:String = "buildingsCancel";
        public static const METRO_COMPLETE:String = "metroComplete";
        public static const METRO_TEXT_READY:String = "metroTextReady";
        public static const METRO_CANCEL:String = "metroCancel";
        public static const DISTRICT_COMPLETE:String = "districtComplete";
        public static const DISTRICT_CANCEL:String = "districtCancel";
        public static const TRAFFIC_COMPLETE:String = "trafficComplete";
        public static const TRAFFIC_CANCEL:String = "trafficCancel";
        public static const BATCH_COMPLETE:String = "batchComplete";
        public static const ATM_COMPLETE:String = "atmComplete";
        public static const ATM_CANCEL:String = "atmCancel";
        public static const CAMERA_COMPLETE:String = "cameraComplete";
        public static const CAMERA_CANCEL:String = "cameraCancel";
        public static const WIFI_COMPLETE:String = "wifiComplete";
        public static const WIFI_CANCEL:String = "wifiCancel";
        public static const ANTENNAS_COMPLETE:String = "antennasComplete";
        public static const ANTENNAS_CANCEL:String = "antennasCancel";
        public static const ELECTROMAGNETIC_COMPLETE:String = "electromagneticComplete";
        public static const ELECTROMAGNETIC_CANCEL:String = "electromagneticCancel";
        public static const TOILETS_COMPLETE:String = "toiletsComplete";
        public static const TOILETS_CANCEL:String = "toiletsCancel";
        public static const FLICKRS_COMPLETE:String = "flickrsComplete";
        public static const FLICKRS_CANCEL:String = "flickrsCancel";
        public static const FOUR_SQUARES_COMPLETE:String = "fourSquaresComplete";
        public static const FOUR_SQUARES_CANCEL:String = "fourSquaresCancel";
        public static const INSTAGRAMS_COMPLETE:String = "instagramComplete";
        public static const INSTAGRAMS_CANCEL:String = "instagramsCancel";
        public static const STATISTICS_COMPLETE:String = "statisticsComplete";
        public static const STATISTICS_CANCEL:String = "statisticsCancel";
        public static const VELO_STATIONS_COMPLETE:String = "veloStationsComplete";
        public static const VELO_STATIONS_CANCEL:String = "veloStationsCancel";
        public static const INETRNET_REALYS_COMPLETE:String = "inetrnetRealysComplete";
        public static const INETRNET_REALYS_CANCEL:String = "inetrnetRealysCancel";
        public static const MOBILES_COMPLETE:String = "mobilesComplete";
        public static const MOBILES_CANCEL:String = "mobilesCancel";
        public static const RADARS_COMPLETE:String = "radarsComplete";
        public static const RADARS_CANCEL:String = "radarsCancel";
        public static const ADS_COMPLETE:String = "adsComplete";
        public static const ADS_CANCEL:String = "adsCancel";
        public static const TWITTERS_COMPLETE:String = "twittersComplete";
        public static const TWITTERS_CANCEL:String = "twittersCancel";
        public static const PLACES_COMPLETE:String = "placesComplete";
        public static const PLACES_CANCEL:String = "placesCancel";
        public static const TOKEN_VALID:String = "tokenValid";

        public var data;

        public function ServiceEvent(type:String, data=null, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
            this.data = data;
        }
        override public function clone():Event{
            return (new ServiceEvent(type, this.data, bubbles, cancelable));
        }
        override public function toString():String{
            return (formatToString("ServiceEvent", "type", "data", "bubbles", "cancelable", "eventPhase"));
        }

    }
}//package wd.events 
