package wd.http {
    import flash.net.*;
    import wd.utils.*;
    import wd.hud.panels.district.*;
    import wd.events.*;

    public class DistrictService extends Service {

        public static var debug:Boolean = true;

        private var districtResponder:Responder;
        private var statsResponder:Responder;

        public function DistrictService(){
            super();
            this.districtResponder = new Responder(this.onDistrictComplete, this.onDistrictCancel);
            this.statsResponder = new Responder(this.onStatsComplete, this.onStatsCancel);
        }
        public function call():void{
            customCall(Service.METHOD_DISTRICT, this.districtResponder, Locator.CITY);
        }
        public function getStats(district:District):void{
            connection.call(Service.METHOD_STAISTICS, this.statsResponder, district.name, Locator.CITY);
        }
        private function onDistrictComplete(result:Object):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.DISTRICT_COMPLETE, result));
        }
        private function onDistrictCancel(fault:Object):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.DISTRICT_CANCEL));
        }
        private function onStatsComplete(result:Object):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.STATISTICS_COMPLETE, result));
        }
        private function onStatsCancel(fault:Object):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.STATISTICS_CANCEL, fault));
        }

    }
}//package wd.http 
