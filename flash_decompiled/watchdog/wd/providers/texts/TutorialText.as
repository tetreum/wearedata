package wd.providers.texts {

    public class TutorialText {

        public static var xml:XMLList;

        public function TutorialText(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get btnOk():String{
            return (xml.btnOk);
        }
        public static function get btnNext():String{
            return (xml.btnNext);
        }
        public static function get btnNok():String{
            return (xml.btnNok);
        }

    }
}//package wd.providers.texts 
