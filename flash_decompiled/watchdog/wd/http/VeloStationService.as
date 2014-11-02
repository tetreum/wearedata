package wd.http {
    import flash.net.*;
    import wd.events.*;

    public class VeloStationService extends Service {

        public static var debug:Boolean = true;

        private var veloResponder:Responder;
        private var param:ServiceConstants;
        private var _radius:Number;

        public function VeloStationService(){
            super();
            this.param = Service.initServiceConstants();
            this.radius = 100;
            this.veloResponder = new Responder(this.onVeloComplete, this.onVeloCancel);
        }
        public function call(refresh:Boolean):void{
            connection.call(Service.METHOD_VELO_STATIONS, this.veloResponder, this.param, ((refresh) ? "1" : "0"));
        }
        private function onVeloComplete(result):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.VELO_STATIONS_COMPLETE, result));
        }
        private function onVeloCancel(fault:Object):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.VELO_STATIONS_CANCEL));
        }
        public function get radius():Number{
            return (this.param["radius"]);
        }
        public function set radius(value:Number):void{
            this.param["radius"] = value;
        }

    }
}//package wd.http 
