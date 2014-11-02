package wd.d3.geom.metro {
    import flash.utils.*;
    import flash.geom.*;
    import __AS3__.vec.*;
    import wd.d3.geom.metro.trains.*;
    import wd.utils.*;

    public class MetroStation {

        public static var stations:Dictionary = new Dictionary();
        public static var stations_ids:Dictionary = new Dictionary();
        private static var pos:Point = new Point();

        public var ref:String;
        public var id:int;
        public var name:String;
        public var lon:Number;
        public var lat:Number;
        public var passengers:String;
        public var position:Vector3D;
        public var hasLabel:Boolean;
        private var trains:Vector.<Train>;
        private var lines:Vector.<MetroLine>;
        private var positions:Vector.<Point>;
        private var depth:Number;
        private var lastTrainset:Number = 0;

        public function MetroStation(id:int, ref:String, name:String, lon:Number, lat:Number, passengers:String){
            this.trains = new Vector.<Train>();
            super();
            this.id = id;
            this.ref = ref;
            this.name = name;
            this.lon = lon;
            this.lat = lat;
            this.passengers = passengers;
            this.lines = new Vector.<MetroLine>();
            stations[ref] = this;
            stations_ids[id] = this;
            Locator.REMAP(lon, lat, pos);
            this.position = new Vector3D(pos.x, 0, pos.y);
            this.lines = new Vector.<MetroLine>();
            this.positions = new Vector.<Point>();
        }
        public static function getStationByRef(ref:String):MetroStation{
            return (stations[ref]);
        }
        public static function getStationById(id:uint):MetroStation{
            return (stations_ids[id]);
        }

        public function getClosestTrains():Vector.<Train>{
            this.trains.sort(this.arrivalTime);
            return (this.trains);
        }
        private function arrivalTime(a:Train, b:Train):Number{
            return ((((a.arrivalTime < b.arrivalTime)) ? -1 : 1));
        }
        public function addLine(line:MetroLine):int{
            var _l:MetroLine;
            if (this.lines.indexOf(line) != -1){
                return (this.lines.length);
            };
            for each (_l in this.lines) {
                if (line.name == _l.name){
                    return (this.lines.length);
                };
            };
            this.lines.push(line);
            return (this.lines.length);
        }
        public function getLineByRef(ref:String):MetroLine{
            var _l:MetroLine;
            var _ref:String;
            for each (_l in this.lines) {
                _ref = _l.ref;
                _ref = _ref.replace("_r", "");
                _ref = _ref.replace("_f", "");
                if (ref == _ref){
                    return (_l);
                };
            };
            return (null);
        }
        public function getLineByName(name:String):MetroLine{
            var _l:MetroLine;
            for each (_l in this.lines) {
                if (name == _l.name){
                    return (_l);
                };
            };
            return (null);
        }
        public function get defaultLine():MetroLine{
            return ((((this.lines == null)) ? null : this.lines[0]));
        }
        public function get lineCount():int{
            return ((((this.lines == null)) ? 0 : this.lines.length));
        }
        public function getLineDepth(name:String):Number{
            var l:MetroLine = this.getLineByName(name);
            if (l == null){
                return (0);
            };
            return (this.lines.indexOf(l));
        }
        public function addTrain(t:Train):void{
            this.trains.push(t);
        }
        public function removeTrain(t:Train):void{
            if (this.trains.indexOf(t) == -1){
                return;
            };
            this.trains.splice(this.trains.indexOf(t), 1);
        }
        public function getTrainset():Number{
            var t:Train;
            var trainset:int;
            for each (t in this.trains) {
                trainset = (trainset + t.trainset);
            };
            if ((((this.lastTrainset < trainset)) || (!((trainset == 0))))){
                this.lastTrainset = trainset;
            };
            if (trainset == 0){
                return (this.lastTrainset);
            };
            return (trainset);
        }
        public function trainHasLeft(train:Train):void{
            this.trains.push(train);
        }
        public function trainHasArrived(train:Train):void{
            this.removeTrain(train);
        }

    }
}//package wd.d3.geom.metro 
