package wd.providers.texts {

    public class DataDetailText {

        private static var xml:XMLList;

        public function DataDetailText(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get metro():String{
            return (xml.metro);
        }
        public static function get metroTrainPerHour():String{
            return (xml.metroTrainPerHour);
        }
        public static function get metroNextTrainsTerminus1():String{
            return (xml.metroNextTrainsTerminus1);
        }
        public static function get metroNextTrainsTerminus2():String{
            return (xml.metroNextTrainsTerminus2);
        }
        public static function get metroCommutersPerDay():String{
            return (xml.metroCommutersPerDay);
        }
        public static function get metroNextTrains():String{
            return (xml.metroNextTrains);
        }
        public static function get metroDisclaimer():String{
            return (xml.metroDisclaimer);
        }
        public static function get bicycle():String{
            return (xml.bicycle);
        }
        public static function get bicycleAvailable():String{
            return (xml.bicycleAvailable);
        }
        public static function get bicycleAvailableSlots():String{
            return (xml.bicycleAvailableSlots);
        }
        public static function get bicycleUpdatedAt():String{
            return (xml.bicycleUpdatedAt);
        }
        public static function get networks():String{
            return (xml.networks);
        }
        public static function get internetRelays():String{
            return (xml.internetRelays);
        }
        public static function get internetSubscribers():String{
            return (xml.internetSubscribers);
        }
        public static function get wifiHotSpots():String{
            return (xml.wifiHotSpots);
        }
        public static function get mobile():String{
            return (xml.mobile);
        }
        public static function get mobileAntenna():String{
            return (xml.mobileAntenna);
        }
        public static function get mobileNetworks2G3G():String{
            return (xml.mobileNetworks2G3G);
        }
        public static function get mobileProvider():String{
            return (xml.mobileProvider);
        }
        public static function get mobileMultipleProviders():String{
            return (xml.mobileMultipleProviders);
        }
        public static function get electroMagneticFields():String{
            return (xml.electroMagneticFields);
        }
        public static function get electroMagneticFieldsOverAllLevelOfExposure():String{
            return (xml.electroMagneticFieldsOverAllLevelOfExposure);
        }
        public static function get electroMagneticFieldsMeasurementDate():String{
            return (xml.electroMagneticFieldsMeasurementDate);
        }
        public static function get electroMagneticFieldsGpsCoordinates():String{
            return (xml.electroMagneticFieldsGpsCoordinates);
        }
        public static function get electroMagneticFieldsLevelUnit():String{
            return (xml.electroMagneticFieldsLevelUnit);
        }
        public static function get streetFurniture():String{
            return (xml.streetFurniture);
        }
        public static function get atm():String{
            return (xml.atm);
        }
        public static function get adBillboards():String{
            return (xml.adBillboards);
        }
        public static function get adBillboard():String{
            return (xml.adBillboard);
        }
        public static function get adDigitalBillboard():String{
            return (xml.adDigitalBillboard);
        }
        public static function get adConsumerExposedPerDay():String{
            return (xml.adConsumerExposedPerDay);
        }
        public static function get trafficLights():String{
            return (xml.trafficLights);
        }
        public static function get publicToilets():String{
            return (xml.publicToilets);
        }
        public static function get cctv():String{
            return (xml.cctv);
        }
        public static function get cctvPolice():String{
            return (xml.cctvPolice);
        }
        public static function get cctvTraffic():String{
            return (xml.cctvTraffic);
        }
        public static function get social():String{
            return (xml.social);
        }
        public static function get instargram():String{
            return (xml.instargram);
        }
        public static function get instagramNewInstagramPicture():String{
            return (xml.instagramNewInstagramPicture);
        }
        public static function get instagramHasPostedAnewPic():String{
            return (xml.instagramHasPostedAnewPic);
        }
        public static function get instragramDisclaimer():String{
            return (xml.instragramDisclaimer);
        }
        public static function get fourSquare():String{
            return (xml.fourSquare);
        }
        public static function get fourSquareNewCheckIn():String{
            return (xml.fourSquareNewCheckIn);
        }
        public static function get fourSquareIsTheNewMayorOf():String{
            return (xml.fourSquareIsTheNewMayorOf);
        }
        public static function get fourSquarePowered():String{
            return (xml.fourSquarePowered);
        }
        public static function get fourSquareDisclaimer():String{
            return (xml.fourSquareDisclaimer);
        }
        public static function get twitter():String{
            return (xml.twitter);
        }
        public static function get twitterReply():String{
            return (xml.twitterReply);
        }
        public static function get twitterRetweet():String{
            return (xml.twitterRetweet);
        }
        public static function get twitterFavorites():String{
            return (xml.twitterFavorites);
        }
        public static function get twitterFollow():String{
            return (xml.twitterFollow);
        }
        public static function get twitterSeeConversation():String{
            return (xml.twitterSeeConversation);
        }
        public static function get flickrDisclaimer():String{
            return (xml.flickrDisclaimer);
        }
        public static function get twitterDisclaimer():String{
            return (xml.twitterDisclaimer);
        }

    }
}//package wd.providers.texts 
