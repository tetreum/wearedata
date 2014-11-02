package wd.d3.control {
    import wd.http.*;
    import wd.events.*;
    import flash.geom.*;
    import wd.utils.*;
    import flash.utils.*;
    import wd.d3.geom.parcs.*;
    import wd.d3.geom.rails.*;
    import wd.hud.objects.*;
    import flash.events.*;

    public class Navigator extends EventDispatcher {

        public static var instance:Navigator;

        public var building_service:BuildingService;
        private var location:Location;
        private var refreshrate:int;
        private var checkInterval:uint;
        private var loading:Boolean;
        private var origin:Point;
        private var data:DataService;
        public var previous:Point;

        public function Navigator(location:Location, refreshrate:int=100){
            super();
            this.location = location;
            this.refreshrate = refreshrate;
            this.building_service = new BuildingService();
            this.building_service.addEventListener(ServiceEvent.BUILDINGS_COMPLETE, this.onBuildingComplete);
            this.building_service.addEventListener(ServiceEvent.BUILDINGS_CANCEL, this.onBuildingCancel);
            this.data = new DataService();
            this.data.addEventListener(ServiceEvent.BATCH_COMPLETE, this.onBatchComplete);
            this.origin = new Point(Locator.LONGITUDE, Locator.LATITUDE);
            this.previous = new Point(Locator.LONGITUDE, Locator.LATITUDE);
            instance = this;
        }
        public function reset():void{
            clearInterval(this.checkInterval);
            this.checkInterval = setInterval(this.checkPosition, this.refreshrate);
            this.callService();
        }
        private function checkPosition():void{
            if (((!(this.loading)) && ((Locator.DISTANCE(this.origin.x, this.origin.y, Locator.LONGITUDE, Locator.LATITUDE) > (ServiceConstants.REQ_RADIUS * 0.5))))){
                this.callService();
            };
        }
        private function callService():void{
            this.loading = true;
            this.previous.x = this.origin.x;
            this.previous.y = this.origin.y;
            this.origin.x = Locator.LONGITUDE;
            this.origin.y = Locator.LATITUDE;
            dispatchEvent(new NavigatorEvent(NavigatorEvent.LOADING_START));
            Parcs.call(true);
            Rails.call(true);
            VeloStations.call();
            this.data.batchCall();
            this.building_service.callBuildings(true);
        }
        private function onBuildingComplete(e:ServiceEvent):void{
            dispatchEvent(e);
            if (e.data.next_page != null){
                this.building_service.callBuildings(false);
            } else {
                dispatchEvent(new NavigatorEvent(NavigatorEvent.LOADING_STOP));
                this.loading = false;
                this.data.batchCall();
                Parcs.call(true);
                Rails.call(true);
                VeloStations.call();
            };
        }
        private function onBuildingCancel(e:ServiceEvent):void{
            this.loading = false;
            dispatchEvent(e);
        }
        private function onBatchComplete(e:ServiceEvent):void{
            dispatchEvent(e);
        }

    }
}//package wd.d3.control 
