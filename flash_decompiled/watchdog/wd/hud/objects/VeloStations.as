package wd.hud.objects {
    import wd.http.*;
    import wd.events.*;
    import flash.utils.*;
    import wd.core.*;
    import wd.hud.items.datatype.*;
    import wd.hud.items.*;
    import wd.hud.*;

    public class VeloStations {

        private static var instance:VeloStations;
        public static var UPDATE_FREQUENCY:int = 600000;

        private var service:VeloStationService;
        private var interval:uint;

        public function VeloStations(){
            super();
            this.service = new VeloStationService();
            this.reset();
            instance = this;
        }
        public static function call():void{
            if (instance != null){
                instance.update();
            };
        }

        public function reset():void{
            this.stop();
            this.service.radius = 500;
            this.service.addEventListener(ServiceEvent.VELO_STATIONS_COMPLETE, this.onComplete);
            this.service.removeEventListener(ServiceEvent.VELO_STATIONS_COMPLETE, this.onUpdate);
            this.service.call(false);
        }
        public function start():void{
            this.stop();
            this.interval = setInterval(this.update, UPDATE_FREQUENCY);
        }
        public function stop():void{
            clearInterval(this.interval);
        }
        private function update():void{
            this.service.radius = Config.SETTINGS_DATA_RADIUS;
            this.service.call(true);
        }
        private function onComplete(e:ServiceEvent):void{
            var k:*;
            var stationInfo:Object;
            var p:*;
            var vtd:VeloTrackerData;
            for (k in e.data.bicycles) {
                stationInfo = e.data.bicycles[k];
                for (p in stationInfo) {
                    if (TrackerData.exists(stationInfo[ServiceConstants.KEY_ID])){
                    } else {
                        vtd = new VeloTrackerData(DataType.VELO_STATIONS, stationInfo[ServiceConstants.KEY_ID], stationInfo[ServiceConstants.KEY_LONGITUDE], stationInfo[ServiceConstants.KEY_LATITUDE], stationInfo[ServiceConstants.KEY_TAGS]);
                        if (vtd.isValid){
                            Hud.addItem(vtd);
                        };
                    };
                };
            };
            this.service.removeEventListener(ServiceEvent.VELO_STATIONS_COMPLETE, this.onComplete);
            this.service.addEventListener(ServiceEvent.VELO_STATIONS_COMPLETE, this.onUpdate);
            call();
        }
        private function onUpdate(e:ServiceEvent):void{
            var k:*;
            var stationInfo:Object;
            var p:*;
            var vt:VeloTrackerData;
            for (k in e.data.bicycles) {
                stationInfo = e.data.bicycles[k];
                for (p in stationInfo) {
                    if (TrackerData.ids[stationInfo[ServiceConstants.KEY_ID]] == null){
                    } else {
                        vt = (TrackerData.ids[stationInfo[ServiceConstants.KEY_ID]] as VeloTrackerData);
                        vt.update(stationInfo[ServiceConstants.KEY_TAGS]);
                    };
                };
            };
        }
        private function onCancel(e:ServiceEvent):void{
        }

    }
}//package wd.hud.objects 
