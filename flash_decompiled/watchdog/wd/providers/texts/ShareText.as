package wd.providers.texts {

    public class ShareText {

        private static var xml:XMLList;

        public function ShareText(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get FBGtitle():String{
            return (xml.FBGtitle);
        }
        public static function get FBGtext():String{
            return (xml.FBGtext);
        }
        public static function get FBGimage():String{
            return (xml.FBGimage);
        }
        public static function get TwitterTitle():String{
            return (xml.TwitterTitle);
        }
        public static function get TwitterText():String{
            return (xml.TwitterText);
        }
        public static function get CopyButton():String{
            return (xml.copyToClipBoard);
        }

    }
}//package wd.providers.texts 
