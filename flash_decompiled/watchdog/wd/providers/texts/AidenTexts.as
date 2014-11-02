package wd.providers.texts {

    public class AidenTexts {

        public static var xml:XMLList;

        public function AidenTexts(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }

    }
}//package wd.providers.texts 
