package wd.hud.items {
    import wd.data.*;
    import flash.utils.*;
    import wd.http.*;
    import wd.core.*;
    import wd.hud.items.pictos.*;
    import wd.d3.geom.metro.*;
    import wd.hud.items.datatype.*;
    import wd.d3.geom.metro.trains.*;
    import flash.display.*;

    public class Trackers extends Sprite {

        public static var ADS:ListTracker = new ListTracker();
        public static var ATMS:ListTracker = new ListTracker();
        public static var CAMERAS:ListTracker = new ListTracker();
        public static var ELECTROMAGNETICS:ListTracker = new ListTracker();
        public static var FLICKRS:ListTracker = new ListTracker();
        public static var FOUR_SQUARES:ListTracker = new ListTracker();
        public static var INSTAGRAMS:ListTracker = new ListTracker();
        public static var INTERNET_RELAYS:ListTracker = new ListTracker();
        public static var METRO_STATIONS:ListTracker = new ListTracker();
        public static var MOBILES:ListTracker = new ListTracker();
        public static var PLACES:ListTracker = new ListTracker();
        public static var TRAFFIC_LIGHTS:ListTracker = new ListTracker();
        public static var RADARS:ListTracker = new ListTracker();
        public static var TRAINS:ListTracker = new ListTracker();
        public static var TOILETS:ListTracker = new ListTracker();
        public static var TWITTERS:ListTracker = new ListTracker();
        public static var VELO_STATIONS:ListTracker = new ListTracker();
        public static var WIFIS:ListTracker = new ListTracker();
        private static var textTrackers:Dictionary = new Dictionary(true);

        private var removeSpacePattern:RegExp;

        public function Trackers(){
            this.removeSpacePattern = /\s/g;
            super();
        }
        private static function getListByType(type:int):ListTracker{
            switch (type){
                case DataType.ADS:
                    return (ADS);
                case DataType.ATMS:
                    return (ATMS);
                case DataType.CAMERAS:
                    return (CAMERAS);
                case DataType.ELECTROMAGNETICS:
                    return (ELECTROMAGNETICS);
                case DataType.FLICKRS:
                    return (FLICKRS);
                case DataType.FOUR_SQUARE:
                    return (FOUR_SQUARES);
                case DataType.INSTAGRAMS:
                    return (INSTAGRAMS);
                case DataType.INTERNET_RELAYS:
                    return (INTERNET_RELAYS);
                case DataType.METRO_STATIONS:
                    return (METRO_STATIONS);
                case DataType.MOBILES:
                    return (MOBILES);
                case DataType.PLACES:
                    return (PLACES);
                case DataType.TRAFFIC_LIGHTS:
                    return (TRAFFIC_LIGHTS);
                case DataType.RADARS:
                    return (RADARS);
                case DataType.TRAINS:
                    return (TRAINS);
                case DataType.TOILETS:
                    return (TOILETS);
                case DataType.TWITTERS:
                    return (TWITTERS);
                case DataType.VELO_STATIONS:
                    return (VELO_STATIONS);
                case DataType.WIFIS:
                    return (WIFIS);
            };
            return (null);
        }
        public static function hideByType(type:int):void{
            var node2:ListNodeTracker;
            var list:ListTracker = getListByType(type);
            if (list == null){
                return;
            };
            var node:ListNodeTracker = list.head;
            while (node) {
                node.data.visible = false;
                node = node.next;
            };
        }
        public static function showByType(type:int):void{
            var node2:ListNodeTracker;
            var list:ListTracker = getListByType(type);
            if (list == null){
                return;
            };
            var node:ListNodeTracker = list.head;
            while (node) {
                node.data.visible = true;
                node = node.next;
            };
        }

        public function checkState():void{
            var type:int;
            for each (type in DataType.LIST) {
                if (AppState.isActive(type)){
                    this.open(type);
                } else {
                    this.close(type);
                };
            };
        }
        public function open(type:int):void{
            var list:ListTracker = getListByType(type);
            if (list == null){
                return;
            };
            var node:ListNodeTracker = list.head;
            while (node) {
                node.data.active = true;
                node = node.next;
            };
        }
        public function close(type:int):void{
            var list:ListTracker = getListByType(type);
            if (list == null){
                return;
            };
            var node:ListNodeTracker = list.head;
            while (node) {
                node.data.active = false;
                node = node.next;
            };
        }
        public function remove(type:int, node:ListNodeTracker):void{
            getListByType(type).remove(node);
        }
        public function addPlace(data:TrackerData):Tracker{
            var uv:UVPicto;
            var t:Tracker;
            if (textTrackers[data.extra] == null){
                uv = UVPicto.getTextUVs(data.extra);
                t = Tracker.getTracker(data, uv, 2, false);
                t.y = 20;
                t.nodeOnTrackersList = getListByType(data.type).insert(t);
                return (t);
            };
            return (null);
        }
        public function addDynamicTracker(data:TrackerData):void{
            var uv:UVPicto = UVPicto.getTrackerUVs(data.type);
            var n:String = DataType.toString(data.type);
            var t:Tracker = Tracker.getTracker(data, uv, 0, true);
            t.nodeOnTrackersList = getListByType(data.type).insert(t);
        }
        public function addStaticTracker(data:TrackerData):void{
            var uv:UVPicto = UVPicto.getTrackerUVs(data.type);
            var t:Tracker = Tracker.getTracker(data, uv, 0, false);
            t.nodeOnTrackersList = getListByType(data.type).insert(t);
        }
        public function addStation(data:TrackerData, line:MetroLine, station:MetroStation, multipleConnexions:Boolean=false):void{
            var uv:UVPicto;
            var str:String;
            var t:Tracker;
            if (!(station.hasLabel)){
                str = station.name.toUpperCase();
                str = str.replace(this.removeSpacePattern, "");
                if (textTrackers[str] == null){
                    uv = UVPicto.getTextUVs(station.name.toUpperCase());
                    if (uv != null){
                        t = Tracker.getTracker(data, uv, 2, false);
                        t.y = 20;
                        t.active = true;
                        t.nodeOnTrackersList = getListByType(data.type).insert(t);
                    };
                    textTrackers[str] = true;
                };
                uv = UVPicto.getStationUVs(line.ref, multipleConnexions);
                t = Tracker.getTracker(data, uv, 0, true);
                t.nodeOnTrackersList = getListByType(data.type).insert(t);
                station.hasLabel = true;
            };
        }
        public function addTrain(type:int, id:int, train:Train):void{
            var uv:UVPicto = UVPicto.getMetroUVs(train.line.ref);
            var data:TrainTrackerData = new TrainTrackerData(type, 0, 0, 0, train);
            data.object = train;
            var t:Tracker = Tracker.getTracker(data, uv, 1, true);
            t.nodeOnTrackersList = getListByType(type).insert(t);
        }
        public function removeTrain(train:Train):void{
            var node2:ListNodeTracker;
            var list:ListTracker = getListByType(DataType.TRAINS);
            if (list == null){
                return;
            };
            var node:ListNodeTracker = list.head;
            while (node) {
                node2 = node;
                node = node.next;
                if (node2.data.data.extra == train){
                    getListByType(DataType.TRAINS).remove(node2);
                    node2.data.recycle();
                    return;
                };
            };
        }
        private function tagsToString(tags=null):String{
            var p:*;
            if ((((tags == false)) || ((tags == null)))){
                return ("");
            };
            var str:String = "";
            for (p in tags) {
                str = (str + (tags[p] + "\n"));
            };
            return (str.replace(/null\n/gi, ""));
        }
        public function dispose():void{
            var id:String;
            for (id in textTrackers) {
                delete textTrackers[id];
            };
        }

    }
}//package wd.hud.items 
