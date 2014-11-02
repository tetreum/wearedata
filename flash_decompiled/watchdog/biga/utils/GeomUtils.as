package biga.utils {
    import flash.geom.*;
    import __AS3__.vec.*;

    public class GeomUtils {

        private static var ip:Point = new Point();

        public static function angle(p0:Point, p1:Point):Number{
            return (Math.atan2((p1.y - p0.y), (p1.x - p0.x)));
        }
        public static function angleDifference(a0:Number, a1:Number):Number{
            var difference:Number = (a1 - a0);
            while (difference < -(Math.PI)) {
                difference = (difference + (Math.PI * 2));
            };
            while (difference > Math.PI) {
                difference = (difference - (Math.PI * 2));
            };
            return (difference);
        }
        public static function slope(p0:Point, p1:Point):Number{
            return (((p1.y - p0.y) / (p1.x - p0.x)));
        }
        public static function distance(p0:Point, p1:Point):Number{
            return (Math.sqrt(squareDistance(p0.x, p0.y, p1.x, p1.y)));
        }
        public static function squareDistance(x0:Number, y0:Number, x1:Number, y1:Number):Number{
            return ((((x0 - x1) * (x0 - x1)) + ((y0 - y1) * (y0 - y1))));
        }
        public static function toFixed(value:Number, step:Number=10):Number{
            return ((int((value * step)) / step));
        }
        public static function snap(value:Number, step:Number):Number{
            return ((int((value / step)) * step));
        }
        public static function clamp(value:Number, min:Number, max:Number):Number{
            return ((((value < min)) ? min : (((value > max)) ? max : value)));
        }
        public static function lerp(t:Number, a:Number, b:Number):Number{
            return ((a + ((b - a) * t)));
        }
        public static function normalize(value:Number, a:Number, b:Number):Number{
            return (((value - a) / (b - a)));
        }
        public static function map(value:Number, min1:Number, max1:Number, min2:Number, max2:Number):Number{
            return (lerp(normalize(value, min1, max1), min2, max2));
        }
        public static function determinant(p:Point, a:Point, b:Point):Number{
            return ((((a.x - b.x) * (p.y - b.y)) - ((p.x - b.x) * (a.y - b.y))));
        }
        public static function isLeft(p:Point, a:Point, b:Point):Boolean{
            return ((determinant(p, a, b) >= 0));
        }
        public static function isRight(p:Point, a:Point, b:Point):Boolean{
            return ((determinant(p, a, b) <= 0));
        }
        public static function normalizeVector(p:Point):Point{
            return (new Point((p.x / p.length), (p.y / p.length)));
        }
        public static function dotProduct(u:Point, v:Point):Number{
            return (((u.x * v.x) + (u.y * v.y)));
        }
        public static function crossProduct(u:Point, v:Point):Number{
            return (((u.x * v.y) - (u.y * v.x)));
        }
        public static function center(p0:Point, p1:Point):Point{
            return (new Point((p0.x + ((p1.x - p0.x) / 2)), (p0.y + ((p1.y - p0.y) / 2))));
        }
        public static function leftNormal(p0:Point, p1:Point):Point{
            return (new Point((p0.x + (p1.y - p0.y)), (p0.y - (p1.x - p0.x))));
        }
        public static function normal(p0:Point, p1:Point):Point{
            return (new Point(-((p1.y - p0.y)), (p1.x - p0.x)));
        }
        public static function rightNormal(p0:Point, p1:Point):Point{
            return (new Point((p0.x - (p1.y - p0.y)), (p0.y + (p1.x - p0.x))));
        }
        public static function project(p:Point, a:Point, b:Point):Point{
            var len:Number = distance(a, b);
            var r:Number = ((((a.y - p.y) * (a.y - b.y)) - ((a.x - p.x) * (b.x - a.x))) / (len * len));
            var px:Number = (a.x + (r * (b.x - a.x)));
            var py:Number = (a.y + (r * (b.y - a.y)));
            return (new Point(px, py));
        }
        public static function getClosestPointInList(p:Point, list:Vector.<Point>):Point{
            var dist:Number;
            var closest:Point;
            var item:Point;
            if (list.length <= 0){
                return (null);
            };
            if (list.length == 1){
                return (list[0]);
            };
            var min:Number = Number.POSITIVE_INFINITY;
            for each (item in list) {
                if (item == p){
                } else {
                    if (item.equals(p)){
                        return (item);
                    };
                    dist = squareDistance(p.x, p.y, item.x, item.y);
                    if (dist < min){
                        min = dist;
                        closest = item;
                    };
                };
            };
            return (closest);
        }
        public static function getPointAt(t:Number, points:Vector.<Point>, p:Point=null, loop:Boolean=false):Point{
            var length:int = points.length;
            if (!(loop)){
                length--;
            };
            var i:int = int((length * t));
            var delta:Number = (1 / length);
            t = ((t - (i * delta)) / delta);
            if (p == null){
                p = new Point(lerp(t, points[i].x, points[((i + 1) % points.length)].x), lerp(t, points[i].y, points[((i + 1) % points.length)].y));
            } else {
                p.x = lerp(t, points[i].x, points[((i + 1) % points.length)].x);
                p.y = lerp(t, points[i].y, points[((i + 1) % points.length)].y);
            };
            return (p);
        }
        public static function constrain(p:Point, a:Point, b:Point):Point{
            var t:Number;
            var dx:Number = (b.x - a.x);
            var dy:Number = (b.y - a.y);
            if ((((dx == 0)) && ((dy == 0)))){
                return (a);
            };
            t = ((((p.x - a.x) * dx) + ((p.y - a.y) * dy)) / ((dx * dx) + (dy * dy)));
            t = Math.min(Math.max(0, t), 1);
            return (new Point((a.x + (t * dx)), (a.y + (t * dy))));
        }
        public static function lineIntersectLine(A:Point, B:Point, E:Point, F:Point, ABasSeg:Boolean=true, EFasSeg:Boolean=true):Point{
            var a1:Number;
            var a2:Number;
            var b1:Number;
            var b2:Number;
            var c1:Number;
            var c2:Number;
            a1 = (B.y - A.y);
            b1 = (A.x - B.x);
            a2 = (F.y - E.y);
            b2 = (E.x - F.x);
            var denom:Number = ((a1 * b2) - (a2 * b1));
            if (denom == 0){
                return (null);
            };
            c1 = ((B.x * A.y) - (A.x * B.y));
            c2 = ((F.x * E.y) - (E.x * F.y));
            ip = new Point();
            ip.x = (((b1 * c2) - (b2 * c1)) / denom);
            ip.y = (((a2 * c1) - (a1 * c2)) / denom);
            if (A.x == B.x){
                ip.x = A.x;
            } else {
                if (E.x == F.x){
                    ip.x = E.x;
                };
            };
            if (A.y == B.y){
                ip.y = A.y;
            } else {
                if (E.y == F.y){
                    ip.y = E.y;
                };
            };
            if (ABasSeg){
                if (((A.x)<B.x) ? (((ip.x < A.x)) || ((ip.x > B.x))) : (((ip.x > A.x)) || ((ip.x < B.x)))){
                    return (null);
                };
                if (((A.y)<B.y) ? (((ip.y < A.y)) || ((ip.y > B.y))) : (((ip.y > A.y)) || ((ip.y < B.y)))){
                    return (null);
                };
            };
            if (EFasSeg){
                if (((E.x)<F.x) ? (((ip.x < E.x)) || ((ip.x > F.x))) : (((ip.x > E.x)) || ((ip.x < F.x)))){
                    return (null);
                };
                if (((E.y)<F.y) ? (((ip.y < E.y)) || ((ip.y > F.y))) : (((ip.y > E.y)) || ((ip.y < F.y)))){
                    return (null);
                };
            };
            return (ip);
        }
        public static function centroid(points:Vector.<Point>):Point{
            var p:Point;
            var c:Point = new Point();
            for each (p in points) {
                c.x = (c.x + p.x);
                c.y = (c.y + p.y);
            };
            c.x = (c.x / points.length);
            c.y = (c.y / points.length);
            return (c);
        }
        public static function shortestAngle(angle:Number, destAngle:Number):Vector.<Number>{
            if (Math.abs((destAngle - angle)) > Math.PI){
                if (destAngle > angle){
                    angle = (angle + (Math.PI * 2));
                } else {
                    destAngle = (destAngle + (Math.PI * 2));
                };
            };
            return (Vector.<Number>([angle, destAngle]));
        }

    }
}//package biga.utils 
