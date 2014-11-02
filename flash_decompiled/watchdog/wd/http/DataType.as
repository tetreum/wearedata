package wd.http {
    import __AS3__.vec.*;
    import wd.providers.texts.*;

    public class DataType {

        public static const ADS:int = (1 << shift++);
        public static const ANTENNAS:int = (1 << shift++);
        public static const ATMS:int = (1 << shift++);
        public static const CAMERAS:int = (1 << shift++);
        public static const ELECTROMAGNETICS:int = (1 << shift++);
        public static const FOUR_SQUARE:int = (1 << shift++);
        public static const FLICKRS:int = (1 << shift++);
        public static const INSTAGRAMS:int = (1 << shift++);
        public static const INTERNET_RELAYS:int = (1 << shift++);
        public static const METRO_STATIONS:int = (1 << shift++);
        public static const MOBILES:int = (1 << shift++);
        public static const PLACES:int = (1 << shift++);
        public static const RADARS:int = (1 << shift++);
        public static const TRAFFIC_LIGHTS:int = (1 << shift++);
        public static const TRAINS:int = (1 << shift++);
        public static const TOILETS:int = (1 << shift++);
        public static const TWITTERS:int = (1 << shift++);
        public static const VELO_STATIONS:int = (1 << shift++);
        public static const WIFIS:int = (1 << shift++);
        public static const LIST:Vector.<int> = Vector.<int>([ADS, ATMS, CAMERAS, ELECTROMAGNETICS, FOUR_SQUARE, FLICKRS, INSTAGRAMS, INTERNET_RELAYS, METRO_STATIONS, MOBILES, PLACES, RADARS, TRAFFIC_LIGHTS, TRAINS, TOILETS, TWITTERS, VELO_STATIONS, WIFIS]);

        private static var shift:int = 0;

        public static function toString(type:int):String{
            if (type == ADS){
                return (DataLabel.ad);
            };
            if (type == ATMS){
                return (DataLabel.atm);
            };
            if (type == CAMERAS){
                return (DataLabel.cameras);
            };
            if (type == ELECTROMAGNETICS){
                return (DataLabel.electromagnetics);
            };
            if (type == FLICKRS){
                return (DataLabel.flickr);
            };
            if (type == FOUR_SQUARE){
                return (DataLabel.fourSquare);
            };
            if (type == INSTAGRAMS){
                return (DataLabel.instagram);
            };
            if (type == INTERNET_RELAYS){
                return (DataLabel.internetRelays);
            };
            if (type == METRO_STATIONS){
                return (DataLabel.metro);
            };
            if (type == MOBILES){
                return (DataLabel.mobile);
            };
            if (type == PLACES){
                return ("PLACES");
            };
            if (type == RADARS){
                return ("RADARS");
            };
            if (type == TOILETS){
                return (DataLabel.toilets);
            };
            if (type == TRAFFIC_LIGHTS){
                return (DataLabel.traffic);
            };
            if (type == TRAINS){
                return ("TRAINS");
            };
            if (type == TWITTERS){
                return (DataLabel.twitter);
            };
            if (type == VELO_STATIONS){
                return (DataLabel.bicycle);
            };
            if (type == WIFIS){
                return (DataLabel.wifiHotSpots);
            };
            return ("");
        }

    }
}//package wd.http 
