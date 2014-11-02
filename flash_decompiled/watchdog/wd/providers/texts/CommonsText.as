package wd.providers.texts {

    public class CommonsText {

        private static var xml:XMLList;

        public function CommonsText(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get longitude():String{
            return (xml.longitude);
        }
        public static function get latitude():String{
            return (xml.latitude);
        }
        public static function get paris():String{
            return (xml.paris);
        }
        public static function get berlin():String{
            return (xml.berlin);
        }
        public static function get london():String{
            return (xml.london);
        }
        public static function get loading():String{
            return (xml.loading);
        }
        public static function get mapInstructions():String{
            return (xml.mapInstructions);
        }
        public static function get selectLocation():String{
            return (xml.selectLocation);
        }

    }
}//package wd.providers.texts 
