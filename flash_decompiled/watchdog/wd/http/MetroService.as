package wd.http {
    import flash.net.*;
    import wd.utils.*;
    import wd.events.*;

    public class MetroService extends Service {

        public static var debug:Boolean = true;

        private var metroResponder:Responder;

        public function MetroService(){
            super();
            this.metroResponder = new Responder(this.onMetroComplete, this.onMetroCancel);
        }
        public function call(refresh:Boolean=false):void{
            connection.call(Service.METHOD_METRO, this.metroResponder, Locator.CITY, ((refresh) ? "1" : "0"));
        }
        private function onMetroComplete(result):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.METRO_COMPLETE, result));
        }
        private function onMetroCancel(fault:Object):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.METRO_CANCEL));
        }

    }
}//package wd.http 
