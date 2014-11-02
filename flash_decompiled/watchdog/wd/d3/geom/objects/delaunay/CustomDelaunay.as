package wd.d3.geom.objects.delaunay {
    import flash.geom.*;
    import __AS3__.vec.*;

    public class CustomDelaunay {

        public static var EPSILON:Number = Number.MIN_VALUE;
        public static var SUPER_TRIANGLE_RADIUS:Number = 0x3B9ACA00;
        private static var _instance:CustomDelaunay;

        private var indices:Vector.<int>;
        private var _circles:Vector.<Number>;

        public function CustomDelaunay(secret:Secret){
            super();
            if (secret == null){
                throw (new Error((this + ", is a signleton, use CustomDelaunay.instance instead")));
            };
        }
        public static function get instance():CustomDelaunay{
            if (_instance == null){
                _instance = new CustomDelaunay(new Secret());
            };
            return (_instance);
        }
        public static function set instance(value:CustomDelaunay):void{
            _instance = value;
        }

        public function compute(points:Vector.<Vector3D>):Vector.<int>{
            var i:int;
            var j:int;
            var k:int;
            var id0:int;
            var id1:int;
            var id2:int;
            if (points == null){
                return (null);
            };
            var nv:int = points.length;
            if (nv < 3){
                return (null);
            };
            var d:Number = SUPER_TRIANGLE_RADIUS;
            points.push(new Vector3D(0, 0, -(d)), new Vector3D(d, 0, d), new Vector3D(-(d), 0, d));
            this.indices = Vector.<int>([(points.length - 3), (points.length - 2), (points.length - 1)]);
            this.circles = Vector.<Number>([0, 0, d]);
            var edgeIds:Vector.<int> = new Vector.<int>();
            i = 0;
            while (i < nv) {
                j = 0;
                while (j < this.indices.length) {
                    if ((((this.circles[(j + 2)] > EPSILON)) && (this.circleContains(j, points[i])))){
                        id0 = this.indices[j];
                        id1 = this.indices[(j + 1)];
                        id2 = this.indices[(j + 2)];
                        edgeIds.push(id0, id1, id1, id2, id2, id0);
                        this.indices.splice(j, 3);
                        this.circles.splice(j, 3);
                        j = (j - 3);
                    };
                    j = (j + 3);
                };
                j = 0;
                while (j < edgeIds.length) {
                    k = (j + 2);
                    while (k < edgeIds.length) {
                        if ((((((edgeIds[j] == edgeIds[k])) && ((edgeIds[(j + 1)] == edgeIds[(k + 1)])))) || ((((edgeIds[(j + 1)] == edgeIds[k])) && ((edgeIds[j] == edgeIds[(k + 1)])))))){
                            edgeIds.splice(k, 2);
                            edgeIds.splice(j, 2);
                            j = (j - 2);
                            k = (k - 2);
                            if (j < 0){
                                break;
                            };
                            if (k < 0){
                                break;
                            };
                        };
                        k = (k + 2);
                    };
                    j = (j + 2);
                };
                j = 0;
                while (j < edgeIds.length) {
                    this.indices.push(edgeIds[j], edgeIds[(j + 1)], i);
                    this.computeCircle(points, edgeIds[j], edgeIds[(j + 1)], i);
                    j = (j + 2);
                };
                edgeIds.length = 0;
                i++;
            };
            id0 = (points.length - 3);
            id1 = (points.length - 2);
            id2 = (points.length - 1);
            i = 0;
            while (i < this.indices.length) {
                if ((((((((((((((((((this.indices[i] == id0)) || ((this.indices[i] == id1)))) || ((this.indices[i] == id2)))) || ((this.indices[(i + 1)] == id0)))) || ((this.indices[(i + 1)] == id1)))) || ((this.indices[(i + 1)] == id2)))) || ((this.indices[(i + 2)] == id0)))) || ((this.indices[(i + 2)] == id1)))) || ((this.indices[(i + 2)] == id2)))){
                    this.indices.splice(i, 3);
                    this.circles.splice(i, 3);
                    i = (i - 3);
                };
                i = (i + 3);
            };
            points.pop();
            points.pop();
            points.pop();
            return (this.indices);
        }
        private function circleContains(circleId:int, p:Vector3D):Boolean{
            var dx:Number = (this.circles[circleId] - p.x);
            var dy:Number = (this.circles[(circleId + 1)] - p.z);
            return ((this.circles[(circleId + 2)] > ((dx * dx) + (dy * dy))));
        }
        private function computeCircle(points:Vector.<Vector3D>, id0:int, id1:int, id2:int):void{
            var p0:Vector3D = points[id0];
            var p1:Vector3D = points[id1];
            var p2:Vector3D = points[id2];
            var A:Number = (p1.x - p0.x);
            var B:Number = (p1.z - p0.z);
            var C:Number = (p2.x - p0.x);
            var D:Number = (p2.z - p0.z);
            var E:Number = ((A * (p0.x + p1.x)) + (B * (p0.z + p1.z)));
            var F:Number = ((C * (p0.x + p2.x)) + (D * (p0.z + p2.z)));
            var G:Number = (2 * ((A * (p2.z - p1.z)) - (B * (p2.x - p1.x))));
            var x:Number = (((D * E) - (B * F)) / G);
            this.circles.push(x);
            var z:Number = (((A * F) - (C * E)) / G);
            this.circles.push(z);
            x = (x - p0.x);
            z = (z - p0.z);
            this.circles.push(((x * x) + (z * z)));
        }
        public function get circles():Vector.<Number>{
            return (this._circles);
        }
        public function set circles(value:Vector.<Number>):void{
            this._circles = value;
        }

    }
}//package wd.d3.geom.objects.delaunay 

class Secret {

    public function Secret(){
    }
}
