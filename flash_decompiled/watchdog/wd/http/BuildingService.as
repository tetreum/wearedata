package wd.http {
    import flash.net.*;
    import __AS3__.vec.*;
    import wd.d3.geom.building.*;
    import wd.events.*;
    import flash.events.*;
    import flash.geom.*;

    public class BuildingService extends Service {

        public static var indices:Vector.<uint>;
        public static var vertices:Vector.<Number>;
        public static var height:Number;
        public static var lon:Number;
        public static var lat:Number;
        public static var id:uint;
        public static var debug:Boolean = false;

        public var rect:Rectangle;
        public var buildings:Vector.<Building>;
        private var responder:Responder;
        private var params:ServiceConstants;
        private var valid:Boolean;
        private var buildings_ids:Vector.<uint>;

        public function BuildingService(){
            super();
            this.params = initServiceConstants();
            this.responder = new Responder(this.onComplete, this.onCancel);
            this.buildings_ids = new Vector.<uint>();
        }
        public function callBuildings(flush:Boolean=false):void{
            if (flush){
                resetServiceConstants(this.params);
            };
            customCall(METHOD_BUILDINGS, this.responder, this.params);
        }
        private function onComplete(result:Object):void{
            var buildingInformation:Array;
            var i:int;
            var buildingInfo:Object;
            var p:*;
            var item_count:int = result[ServiceConstants.KEY_ITEM_COUNT];
            if (debug){
                trace(this, "count", item_count);
            };
            if (!(isNaN(item_count))){
                buildingInformation = (result.buildings as Array);
                i = 0;
                while (i < buildingInformation.length) {
                    buildingInfo = buildingInformation[i];
                    if (debug){
                        for (p in buildingInfo) {
                            trace("\t", p, "->", buildingInfo[p]);
                        };
                    };
                    id = buildingInfo[ServiceConstants.KEY_BUILDING_ID];
                    if (BuildingMesh3.buildingExist(id)){
                    } else {
                        lon = buildingInfo[ServiceConstants.KEY_LONGITUDE];
                        lat = buildingInfo[ServiceConstants.KEY_LATITUDE];
                        height = buildingInfo[ServiceConstants.KEY_BUILDING_HEIGHT];
                        this.valid = buildingInfo[ServiceConstants.KEY_COMPLETE];
                        indices = Vector.<uint>(buildingInfo[ServiceConstants.KEY_INDICES]);
                        vertices = Vector.<Number>(buildingInfo[ServiceConstants.KEY_VERTICES]);
                        new Building3(id, vertices, indices, height, lon, lat, this.valid);
                    };
                    i++;
                };
            };
            this.params[ServiceConstants.PAGE] = result.next_page;
            dispatchEvent(new ServiceEvent(ServiceEvent.BUILDINGS_COMPLETE, result));
        }
        private function onCancel(fault:Object):void{
            var p:*;
            if (debug){
                for (p in fault) {
                    trace("\t", p, "->", fault[p]);
                };
            };
            dispatchEvent(new Event(Event.CANCEL));
        }

    }
}//package wd.http 
