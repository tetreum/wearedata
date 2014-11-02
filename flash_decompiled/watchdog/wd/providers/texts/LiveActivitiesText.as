package wd.providers.texts {

    public class LiveActivitiesText {

        private static var xml:XMLList;

        public function LiveActivitiesText(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get title0():String{
            return (xml.title0);
        }
        public static function get text01():String{
            return (xml.text01);
        }
        public static function get text02():String{
            return (xml.text02);
        }
        public static function get faceBookConnectButton():String{
            return (xml.faceBookConnectButton);
        }
        public static function get feed0():String{
            return (xml.feed0);
        }
        public static function get title1():String{
            return (xml.title1);
        }
        public static function get text11():String{
            return (xml.text11);
        }
        public static function get title2():String{
            return (xml.title2);
        }
        public static function get feed1():String{
            return (xml.feed1);
        }
        public static function get popinTitle():String{
            return (xml.popinTitle);
        }
        public static function get disclaimerText():String{
            return (xml.disclaimerText);
        }
        public static function get okButton():String{
            return (xml.okButton);
        }
        public static function get cancelButton():String{
            return (xml.cancelButton);
        }
        public static function get fakeActivities():XML{
            return (xml.fakeActivities[0]);
        }

    }
}//package wd.providers.texts 
