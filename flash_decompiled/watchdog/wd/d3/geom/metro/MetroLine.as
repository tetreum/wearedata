package wd.d3.geom.metro {
    import __AS3__.vec.*;
    import flash.utils.*;
    import flash.geom.*;
    import biga.utils.*;

    public class MetroLine {

        private static var edges:Vector.<HEdge> = new Vector.<HEdge>();
;
        private static var linesByName:Dictionary = new Dictionary();
        private static var linesByRef:Dictionary = new Dictionary();
        private static var position:Vector3D = new Vector3D();

        public var stationHeightByRef:Dictionary;
        public var ref:String;
        public var name:String;
        private var way:Array;
        public var trainset:int;
        private var vectors:Vector.<Vector3D>;

        public function MetroLine(ref:String, name:String, way:Array, trainset:int=-1){
            this.stationHeightByRef = new Dictionary();
            super();
            this.name = name.toUpperCase();
            this.ref = ref;
            this.way = way;
            this.trainset = trainset;
            linesByName[name] = this;
            linesByRef[this.ref] = this;
            this.vectors = new Vector.<Vector3D>();
        }
        public static function getLineByName(_name:String):MetroLine{
            return (linesByName[_name]);
        }
        public static function getLineByRef(_ref:String):MetroLine{
            return (linesByRef[_ref]);
        }

        public function buildMesh(color:int, thickness:Number=1):void{
            var he:HEdge;
            var prev:MetroStation;
            var start:MetroStation;
            var end:MetroStation;
            var i:int;
            while (i < (this.way.length - 1)) {
                prev = MetroStation.getStationByRef(this.way[i]);
                start = MetroStation.getStationByRef(this.way[i]);
                end = MetroStation.getStationByRef(this.way[(i + 1)]);
                if (!(HEdge.exists(this, start, end))){
                    edges.push(new HEdge(this, start, end, color, thickness));
                };
                if (!(HEdge.exists(this, end, start))){
                    edges.push(new HEdge(this, end, start, color, thickness));
                };
                i++;
            };
            for each (he in edges) {
                Metro.addSegment(he.startPosition, he.endPosition, color, thickness);
            };
        }
        public function getVectorAt(t:Number, v:Vector3D=null):Vector3D{
            if (this.vectors == null){
                return (position);
            };
            var length:int = this.vectors.length;
            var i0:int = int((length * t));
            i0 = (((i0 < (this.vectors.length - 1))) ? i0 : (this.vectors.length - 1));
            var i1:int = ((((i0 + 1) < this.vectors.length)) ? (i0 + 1) : i0);
            var delta:Number = (1 / length);
            t = ((t - (i0 * delta)) / delta);
            v = ((v) || (position));
            v.x = GeomUtils.lerp(t, this.vectors[i0].x, this.vectors[i1].x);
            v.y = GeomUtils.lerp(t, this.vectors[i0].y, this.vectors[i1].y);
            v.z = GeomUtils.lerp(t, this.vectors[i0].z, this.vectors[i1].z);
            return (v);
        }

    }
}//package wd.d3.geom.metro 
