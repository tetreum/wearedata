package wd.core {
    import flash.utils.*;
    import wd.http.*;

    public class FilterAvailability {

        public static var instance:FilterAvailability;

        private var xml:XMLList;
        private var list:Dictionary;

        public function FilterAvailability(){
            super();
            instance = this;
            this.list = new Dictionary(false);
            this.list[DataType.METRO_STATIONS] = "metro";
            this.list[DataType.VELO_STATIONS] = "bicycle";
            this.list[DataType.ELECTROMAGNETICS] = "electromagnetic";
            this.list[DataType.INTERNET_RELAYS] = "internetRelays";
            this.list[DataType.WIFIS] = "wifiHotSpots";
            this.list[DataType.MOBILES] = "mobile";
            this.list[DataType.ATMS] = "atm";
            this.list[DataType.ADS] = "ad";
            this.list[DataType.TRAINS] = "";
            this.list[DataType.TRAFFIC_LIGHTS] = "traffic";
            this.list[DataType.RADARS] = "traffic";
            this.list[DataType.TOILETS] = "toilets";
            this.list[DataType.CAMERAS] = "cameras";
            this.list[DataType.TWITTERS] = "twitter";
            this.list[DataType.INSTAGRAMS] = "instagram";
            this.list[DataType.FOUR_SQUARE] = "fourSquare";
            this.list[DataType.FLICKRS] = "flickr";
        }
        public static function isPopinActive(type:int):Boolean{
            return ((instance.xml.child(instance.list[type]).@showPopin == "1"));
        }
        public static function isDetailActive(type:int):Boolean{
            return ((instance.xml.child(instance.list[type]).@showDetail == "1"));
        }

        public function reset(xml:XMLList):void{
            this.xml = xml;
        }
        public function isActive(type:int):Boolean{
            return ((this.xml.child(this.list[type]).@active == "1"));
        }

    }
}//package wd.core 
