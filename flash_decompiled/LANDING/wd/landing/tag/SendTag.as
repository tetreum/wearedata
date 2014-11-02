package wd.landing.tag {
    import flash.external.*;

    public class SendTag {

        private static var param1:String;
        private static var param2:String;

        public function SendTag():void{
        }
        public static function tagPageView(_arg1:String):void{
            if (ExternalInterface.available){
                ExternalInterface.call("pushTag", _arg1);
            };
        }
        public static function tagTrackEvent(_arg1:String):void{
            param1 = "";
            param2 = "";
            if (ExternalInterface.available){
                ExternalInterface.call("pushTrackEvent", param1, param2);
            };
        }

    }
}//package wd.landing.tag 
