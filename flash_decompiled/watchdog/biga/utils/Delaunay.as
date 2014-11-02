package biga.utils {
    import flash.geom.*;
    import __AS3__.vec.*;
    import flash.display.*;

    public class Delaunay {

        public static var EPSILON:Number = Number.MIN_VALUE;
        public static var SUPER_TRIANGLE_RADIUS:Number = 0x3B9ACA00;

        private var indices:Vector.<int>;
        private var _circles:Vector.<Number>;

        public function Delaunay(){
            super();
        }
        public function compute(points:Vector.<Point>):Vector.<int>{
            var i:int;
            var j:int;
            var k:int;
            var id0:int;
            var id1:int;
            var id2:int;
            var nv:int = points.length;
            if (nv < 3){
                return (null);
            };
            var d:Number = SUPER_TRIANGLE_RADIUS;
            points.push(new Point(0, -(d)), new Point(d, d), new Point(-(d), d));
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
        private function circleContains(circleId:int, p:Point):Boolean{
            var dx:Number = (this.circles[circleId] - p.x);
            var dy:Number = (this.circles[(circleId + 1)] - p.y);
            return ((this.circles[(circleId + 2)] > ((dx * dx) + (dy * dy))));
        }
        private function computeCircle(points:Vector.<Point>, id0:int, id1:int, id2:int):void{
            var p0:Point = points[id0];
            var p1:Point = points[id1];
            var p2:Point = points[id2];
            var A:Number = (p1.x - p0.x);
            var B:Number = (p1.y - p0.y);
            var C:Number = (p2.x - p0.x);
            var D:Number = (p2.y - p0.y);
            var E:Number = ((A * (p0.x + p1.x)) + (B * (p0.y + p1.y)));
            var F:Number = ((C * (p0.x + p2.x)) + (D * (p0.y + p2.y)));
            var G:Number = (2 * ((A * (p2.y - p1.y)) - (B * (p2.x - p1.x))));
            var x:Number = (((D * E) - (B * F)) / G);
            this.circles.push(x);
            var y:Number = (((A * F) - (C * E)) / G);
            this.circles.push(y);
            x = (x - p0.x);
            y = (y - p0.y);
            this.circles.push(((x * x) + (y * y)));
        }
        public function render(graphics:Graphics, points:Vector.<Point>, indices:Vector.<int>):void{
            var id0:uint;
            var id1:uint;
            var id2:uint;
            var i:int;
            while (i < indices.length) {
                id0 = indices[i];
                id1 = indices[(i + 1)];
                id2 = indices[(i + 2)];
                graphics.moveTo(points[id0].x, points[id0].y);
                graphics.lineTo(points[id1].x, points[id1].y);
                graphics.lineTo(points[id2].x, points[id2].y);
                graphics.lineTo(points[id0].x, points[id0].y);
                i = (i + 3);
            };
        }
        public function get circles():Vector.<Number>{
            return (this._circles);
        }
        public function set circles(value:Vector.<Number>):void{
            this._circles = value;
        }

    }
}//package biga.utils 
