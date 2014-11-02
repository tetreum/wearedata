package biga.utils {
    import flash.geom.*;
    import __AS3__.vec.*;

    public class PolygonUtils {

        public static function containsPoint(p:Point, points:Vector.<Point>):Boolean{
            return (contains(p.x, p.y, points));
        }
        public static function contains(x:Number, y:Number, points:Vector.<Point>):Boolean{
            var i:int;
            var p1:Point;
            var p2:Point;
            if ((((points == null)) || ((points.length == 0)))){
                return (false);
            };
            var counter:int;
            var xinters:Number = 0;
            var p:Point = new Point(x, y);
            var n:int = points.length;
            p1 = points[0];
            i = 1;
            while (i <= n) {
                p2 = points[(i % n)];
                if (p.y > ((p1.y)<p2.y) ? p1.y : p2.y){
                    if (p.y <= ((p1.y)>p2.y) ? p1.y : p2.y){
                        if (p.x <= ((p1.x)>p2.x) ? p1.x : p2.x){
                            if (p1.y != p2.y){
                                xinters = ((((p.y - p1.y) * (p2.x - p1.x)) / (p2.y - p1.y)) + p1.x);
                                if ((((p1.x == p2.x)) || ((p.x <= xinters)))){
                                    counter++;
                                };
                            };
                        };
                    };
                };
                p1 = p2;
                i++;
            };
            if ((counter % 2) == 0){
                return (false);
            };
            return (true);
        }
        public static function area(original:Vector.<Point>):Number{
            var i1:int;
            var area:Number = 0;
            var n:int = original.length;
            var i:int;
            while (i < n) {
                i1 = ((i + 1) % n);
                area = (area + (((original[i].y + original[i1].y) * (original[i1].x - original[i].x)) / 2));
                i++;
            };
            return (area);
        }
        public static function convexHull(original:Vector.<Point>):Vector.<Point>{
            var bestAngle:Number;
            var bestIndex:int;
            var i:int;
            var testPoint:Point;
            var dx:Number;
            var dy:Number;
            var testAngle:Number;
            if ((((original == null)) || ((original.length == 0)))){
                return (null);
            };
            var points:Vector.<Point> = original.concat();
            points.sort(xSort);
            var angle:Number = (Math.PI / 2);
            var point:Point = points[0];
            var hull:Array = [];
            while (point != hull[0]) {
                hull.push(point);
                bestAngle = Number.MAX_VALUE;
                i = 0;
                while (i < points.length) {
                    testPoint = (points[i] as Point);
                    if (testPoint == point){
                    } else {
                        dx = (testPoint.x - point.x);
                        dy = (testPoint.y - point.y);
                        testAngle = Math.atan2(dy, dx);
                        testAngle = (testAngle - angle);
                        while (testAngle < 0) {
                            testAngle = (testAngle + (Math.PI * 2));
                        };
                        if (testAngle < bestAngle){
                            bestAngle = testAngle;
                            bestIndex = i;
                        };
                    };
                    i++;
                };
                point = points[bestIndex];
                angle = (angle + bestAngle);
            };
            return (Vector.<Point>(hull));
        }
        private static function xSort(a:Point, b:Point):Number{
            return ((((a.x < b.x)) ? -1 : 1));
        }

    }
}//package biga.utils 
