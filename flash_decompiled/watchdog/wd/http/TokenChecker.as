package wd.http {
    import flash.net.*;
    import wd.events.*;
    import flash.utils.*;
    import wd.core.*;

    public class TokenChecker extends Service {

        public static const TIME_OUT:Number = 1200000;

        private var loadResponder:Responder;
        private var checkResponder:Responder;
        private var token:String;

        public function TokenChecker(){
            super();
            this.loadResponder = new Responder(this.onComplete, this.onCancel);
            this.checkResponder = new Responder(this.onCheckComplete, this.onCancel);
        }
        public function load(token:String):void{
            this.token = token;
            customCall("WatchDog.helo", this.loadResponder, token);
        }
        private function onComplete(e):void{
            trace(" -- token complete success ? ", e);
            if (e){
                dispatchEvent(new ServiceEvent(ServiceEvent.TOKEN_VALID));
                setTimeout(this.check, TIME_OUT);
            } else {
                this.onCancel(null);
            };
        }
        public function check():void{
            customCall("WatchDog.connected", this.checkResponder);
        }
        private function onCheckComplete(e):void{
            trace(" -- check success ? ", e);
            if (e){
                setTimeout(this.check, TIME_OUT);
            } else {
                this.onCancel(null);
            };
        }
        private function onCancel(e):void{
            trace(" -- AUTH FAIL ");
            navigateToURL(new URLRequest(Config.ROOT_URL), "_self");
        }

    }
}//package wd.http 
