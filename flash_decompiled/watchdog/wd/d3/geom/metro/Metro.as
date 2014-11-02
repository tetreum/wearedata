package wd.d3.geom.metro {
    import flash.geom.*;
    import wd.providers.*;
    import away3d.containers.*;
    import flash.utils.*;
    import __AS3__.vec.*;
    import wd.http.*;
    import wd.events.*;
    import wd.d3.geom.segments.*;
    import wd.hud.*;
    import wd.d3.*;
    import flash.events.*;

    public class Metro extends EventDispatcher {

        public static const STATIONS:String = "stations";
        public static const WAYS:String = "ways";
        public static const TAGS:String = "tags";
        public static const INDEX:String = "index";
        public static const UPDATE_EVERY_MINUTE:Number = 8;

        public static var BERLIN_LINE_COLORS:Dictionary;
        public static var LONDON_LINE_COLORS:Dictionary;
        public static var LONDON_LINE_ID:Dictionary;
        public static var PARIS_LINE_COLORS:Dictionary;
        private static var instance:Metro;

        public var container:ObjectContainer3D;
        private var service:MetroService;
        private var lines:Vector.<MetroLine>;
        private var stations:Vector.<MetroStation>;
        public var segments:SegmentColorGridSortableMesh;
        private var schedule:Schedule;

        public function Metro(){
            super();
            instance = this;
            this.container = new ObjectContainer3D();
            LONDON_LINE_ID = new Dictionary();
            this.lines = new Vector.<MetroLine>();
            this.stations = new Vector.<MetroStation>();
            this.service = new MetroService();
            this.service.addEventListener(ServiceEvent.METRO_COMPLETE, this.onComplete);
            this.service.addEventListener(ServiceEvent.METRO_CANCEL, this.onCancel);
        }
        public static function getInstance():Metro{
            return (instance);
        }
        public static function addSegment(s:Vector3D, n:Vector3D, color:int, thickness:Number):void{
            instance.segments.addSegment(s, n, color, thickness);
        }
        public static function addEdge(edge:HEdge):void{
            instance.segments.addSegment(edge.startPosition, edge.endPosition, MetroLineColors.getColorByName(edge.line.name), 1);
        }

        public function dispose():void{
            this.lines.length = 0;
            this.segments.dispose();
        }
        public function init(ceilSize:int, _b:Rectangle):void{
            if (this.segments == null){
                this.segments = new SegmentColorGridSortableMesh(1);
            };
            this.segments.init(ceilSize, _b);
            this.service.call(false);
        }
        private function onComplete(e:ServiceEvent):void{
            var key:*;
            var prop:*;
            var line:MetroLine;
            var n:int;
            var s:String;
            var obj_line:Object;
            var obj_station:Object;
            var station:MetroStation;
            var multi:Boolean;
            var result:Object = e.data;
            if (result == null){
                return;
            };
            this.lines = ((this.lines) || (new Vector.<MetroLine>()));
            for (key in result["line"]) {
                obj_line = result["line"][key];
                line = new MetroLine(obj_line["ref"], obj_line["name"], obj_line["way"], obj_line["trainset"]);
                this.lines.push(line);
            };
            for (key in result["station"]) {
                obj_station = result["station"][key];
                station = new MetroStation(obj_station["id"], obj_station["ref"], obj_station["name"], obj_station["lng"], obj_station["lat"], obj_station["passengers"]);
                this.stations.push(station);
            };
            dispatchEvent(new ServiceEvent(ServiceEvent.METRO_TEXT_READY, this.stations));
            if (this.lines == null){
                return;
            };
            if (this.stations == null){
                return;
            };
            for each (line in this.lines) {
                s = line.name;
                n = s.indexOf("_");
                if (n != -1){
                    s = s.substring(0, n);
                };
                line.buildMesh(MetroLineColors.getColorByName(s), 1);
            };
            for each (station in this.stations) {
                if (station.lineCount == 0){
                    trace("station", station.name, "has no lines");
                } else {
                    multi = (station.lineCount > 1);
                    Hud.addStation(station.defaultLine, station, multi);
                };
            };
            this.schedule = ((this.schedule) || (new Schedule()));
            this.schedule.stations = this.stations;
            this.schedule.reset(result["time"], result["trips"]);
            dispatchEvent(new ServiceEvent(ServiceEvent.METRO_COMPLETE));
            this.service.removeEventListener(ServiceEvent.METRO_COMPLETE, this.onComplete);
            this.service.addEventListener(ServiceEvent.METRO_COMPLETE, this.onUpdate);
            setTimeout(this.updateTrips, (UPDATE_EVERY_MINUTE * 60000));
        }
        private function updateTrips():void{
            this.service.call(true);
        }
        private function onUpdate(e:ServiceEvent):void{
            var key:*;
            var obj_station:Object;
            var station:MetroStation;
            var result:Object = e.data;
            if (result == null){
                return;
            };
            for (key in result["station"]) {
                obj_station = result["station"][key];
                station = MetroStation.getStationById(obj_station["id"]);
                station.passengers = obj_station["passengers"];
            };
            this.schedule.reset(result["time"], result["trips"]);
            setTimeout(this.updateTrips, (UPDATE_EVERY_MINUTE * 60000));
        }
        private function onCancel(e:ServiceEvent):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.METRO_CANCEL));
        }
        public function sortSegment(scene:Simulation, radius:uint):void{
            if (this.segments){
                this.segments.sortSegment(scene, radius);
            };
        }

    }
}//package wd.d3.geom.metro 
