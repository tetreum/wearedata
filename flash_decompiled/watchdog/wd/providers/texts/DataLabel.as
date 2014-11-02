package wd.providers.texts {

    public class DataLabel {

        private static var xml:XMLList;

        public function DataLabel(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get transports():String{
            return (xml.transports);
        }
        public static function get metro():String{
            return (xml.metro);
        }
        public static function get bicycle():String{
            return (xml.bicycle);
        }
        public static function get auto():String{
            return (xml.auto);
        }
        public static function get networks():String{
            return (xml.networks);
        }
        public static function get electromagnetics():String{
            return (xml.electromagnetic);
        }
        public static function get internetRelays():String{
            return (xml.internetRelays);
        }
        public static function get wifiHotSpots():String{
            return (xml.wifiHotSpots);
        }
        public static function get mobile():String{
            return (xml.mobile);
        }
        public static function get streetFurniture():String{
            return (xml.streetFurniture);
        }
        public static function get atm():String{
            return (xml.atm);
        }
        public static function get ad():String{
            return (xml.ad);
        }
        public static function get traffic():String{
            return (xml.traffic);
        }
        public static function get radars():String{
            return (xml.radars);
        }
        public static function get toilets():String{
            return (xml.toilets);
        }
        public static function get cameras():String{
            return (xml.cameras);
        }
        public static function get social():String{
            return (xml.social);
        }
        public static function get twitter():String{
            return (xml.twitter);
        }
        public static function get instagram():String{
            return (xml.instagram);
        }
        public static function get fourSquare():String{
            return (xml.fourSquare);
        }
        public static function get flickr():String{
            return (xml.flickr);
        }
        public static function get train_line():String{
            return (xml.train_line);
        }
        public static function get train_frequency():String{
            return (xml.train_frequency);
        }
        public static function get train_frequency_unit():String{
            return (xml.train_frequency_unit);
        }
        public static function get train_from():String{
            return (xml.train_from);
        }
        public static function get train_to():String{
            return (xml.train_to);
        }
        public static function get train_arrival_time():String{
            return (xml.train_arrival_time);
        }
        public static function get train_arrival_time_unit():String{
            return (xml.train_arrival_time_unit);
        }

    }
}//package wd.providers.texts 
