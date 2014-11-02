package wd.d3.geom.metro {
    import flash.utils.*;
    import __AS3__.vec.*;
    import wd.hud.*;
    import flash.geom.*;

    public class HEdge {

        private static var edges:Dictionary = new Dictionary();

        public var busy:Boolean;
        private var _line:MetroLine;
        private var _start:MetroStation;
        private var _end:MetroStation;
        private var _startPosition:Vector3D;
        private var _endPosition:Vector3D;
        private var color:int;
        private var thickness:Number;

        public function HEdge(line:MetroLine, start:MetroStation, end:MetroStation, color:int=-1, thickness:Number=1){
            super();
            this.thickness = thickness;
            this.color = color;
            this.line = line;
            this.start = start;
            this.startPosition = start.position.clone();
            this.startPosition.y = ((start.addLine(line) - 1) * -2);
            this.end = end;
            this.endPosition = end.position.clone();
            this.endPosition.y = ((end.addLine(line) - 1) * -2);
            if (edges[line.name] == null){
                edges[line.name] = new Vector.<HEdge>();
            };
            edges[line.name].push(this);
        }
        public static function exists(line:MetroLine, start:MetroStation, end:MetroStation):Boolean{
            var he:HEdge;
            if (edges[line.name] == null){
                return (false);
            };
            var tmp:Vector.<HEdge> = edges[line.name];
            for each (he in tmp) {
                if (he.equals(start, end)){
                    return (true);
                };
            };
            return (false);
        }
        public static function getEdge(line:MetroLine, start:MetroStation, end:MetroStation):HEdge{
            var he:HEdge;
            if (edges[line.name] == null){
                return (null);
            };
            var tmp:Vector.<HEdge> = edges[line.name];
            for each (he in tmp) {
                if ((((he.start.ref == start.ref)) && ((he.end.ref == end.ref)))){
                    return (he);
                };
            };
            he = new HEdge(line, start, end);
            Metro.addEdge(he);
            if (start.lineCount == 1){
                Hud.addStation(line, start, false);
            };
            if (end.lineCount == 1){
                Hud.addStation(line, end, false);
            };
            return (null);
        }

        public function equals(start:MetroStation, end:MetroStation):Boolean{
            return ((((start.ref == this.start.ref)) && ((end.ref == this.end.ref))));
        }
        public function get line():MetroLine{
            return (this._line);
        }
        public function set line(value:MetroLine):void{
            this._line = value;
        }
        public function get startPosition():Vector3D{
            return (this._startPosition);
        }
        public function set startPosition(value:Vector3D):void{
            this._startPosition = value;
        }
        public function get endPosition():Vector3D{
            return (this._endPosition);
        }
        public function set endPosition(value:Vector3D):void{
            this._endPosition = value;
        }
        public function get start():MetroStation{
            return (this._start);
        }
        public function set start(value:MetroStation):void{
            this._start = value;
        }
        public function get end():MetroStation{
            return (this._end);
        }
        public function set end(value:MetroStation):void{
            this._end = value;
        }

    }
}//package wd.d3.geom.metro 
