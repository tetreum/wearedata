package wd.providers.texts {

    public class AboutText {

        private static var xml:XMLList;

        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get title():String{
            return (xml.title);
        }
        public static function get text():String{
            return (xml.text1);
        }

        public function StatsText(xml:XMLList):void{
            reset(xml);
        }

    }
}//package wd.providers.texts 
