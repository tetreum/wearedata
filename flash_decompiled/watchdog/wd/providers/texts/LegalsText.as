package wd.providers.texts {

    public class LegalsText {

        private static var xml:XMLList;

        public function LegalsText(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get title():String{
            return (xml.title);
        }
        public static function get text():String{
            return (xml.text1);
        }
        public static function get text2():String{
            return (xml.text2);
        }
        public static function get btnTerms():String{
            return (xml.btnTerms);
        }
        public static function get btnCredits():String{
            return (xml.btnCredits);
        }

    }
}//package wd.providers.texts 
