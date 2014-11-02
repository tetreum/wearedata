package wd.core {
    import wd.http.*;

    public class Colors {

        public static function getColorByType(type:int=0):int{
            if (type == DataType.ADS){
                return (0xFF9600);
            };
            if (type == DataType.ANTENNAS){
                return (2835711);
            };
            if (type == DataType.ATMS){
                return (4504439);
            };
            if (type == DataType.CAMERAS){
                return (0xE80000);
            };
            if (type == DataType.ELECTROMAGNETICS){
                return (13160522);
            };
            if (type == DataType.FOUR_SQUARE){
                return (3262707);
            };
            if (type == DataType.FLICKRS){
                return (0xFE0072);
            };
            if (type == DataType.INSTAGRAMS){
                return (0xFF9600);
            };
            if (type == DataType.INTERNET_RELAYS){
                return (2835711);
            };
            if (type == DataType.MOBILES){
                return (13160522);
            };
            if (type == DataType.TRAFFIC_LIGHTS){
                return (14880537);
            };
            if (type == DataType.TOILETS){
                return (13160522);
            };
            if (type == DataType.TWITTERS){
                return (3262707);
            };
            if (type == DataType.VELO_STATIONS){
                return (5083929);
            };
            if (type == DataType.WIFIS){
                return (2835711);
            };
            return (0xFFFFFF);
        }

    }
}//package wd.core 
