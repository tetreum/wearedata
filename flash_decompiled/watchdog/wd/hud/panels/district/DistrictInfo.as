package wd.hud.panels.district {
    import wd.http.*;
    import wd.events.*;
    import flash.utils.*;
    import wd.utils.*;
    import flash.display.*;

    public class DistrictInfo extends Sprite {

        private var service:DistrictService;
        private var districts:Dictionary;
        private var current:District;
        private var _data:DistrictData;

        public function DistrictInfo(){
            super();
            this.data = new DistrictData();
            this.data.reset(null);
            this.service = new DistrictService();
            this.service.addEventListener(ServiceEvent.DISTRICT_COMPLETE, this.onServiceComplete);
            this.service.call();
            this.service.addEventListener(ServiceEvent.STATISTICS_COMPLETE, this.onStatisticsComplete);
            this.service.addEventListener(ServiceEvent.STATISTICS_CANCEL, this.onStatisticsCancel);
        }
        private function onServiceComplete(e:ServiceEvent):void{
            var info:Object;
            var k:*;
            this.districts = new Dictionary(true);
            var result:Object = e.data;
            for (k in result) {
                info = result[k];
                this.districts[info[ServiceConstants.KEY_ID]] = new District(info[ServiceConstants.KEY_ID], info[ServiceConstants.KEY_NAME], info[ServiceConstants.KEY_VERTICES]);
            };
            this.current = null;
            this.checkLocation();
            setInterval(this.checkLocation, 100);
        }
        public function checkLocation():void{
            var next:District;
            var d:District;
            for each (d in this.districts) {
                if (d.contains(Locator.LONGITUDE, Locator.LATITUDE)){
                    next = d;
                };
            };
            if ((((next == null)) && (!((this.current == null))))){
                this.setDefaults();
                dispatchEvent(new ServiceEvent(ServiceEvent.STATISTICS_COMPLETE, null));
                this.current = null;
            };
            if (((!((next == null))) && (!((next == this.current))))){
                this.service.getStats(next);
                this.current = next;
            };
        }
        private function setDefaults():void{
            this.data.reset(null);
        }
        private function onStatisticsComplete(e:ServiceEvent):void{
            this.data.reset(e.data);
            dispatchEvent(e);
        }
        private function onStatisticsCancel(e:ServiceEvent):void{
            this.data.reset(null);
        }
        public function get data():DistrictData{
            return (this._data);
        }
        public function set data(value:DistrictData):void{
            this._data = value;
        }

    }
}//package wd.hud.panels.district 
