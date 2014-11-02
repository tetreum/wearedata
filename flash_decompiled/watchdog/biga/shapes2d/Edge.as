package biga.shapes2d {
    import biga.utils.*;
    import flash.geom.*;
    import flash.display.*;

    public final class Edge {

        private var _p0:Point;
        private var _p1:Point;
        private var _id:int;
        private var _angle:Number;
        private var _length:Number;

        public function Edge(p0:Point=null, p1:Point=null, id:int=-1){
            super();
            this.p0 = p0;
            this.p1 = p1;
            this.id = id;
            if (((!((p0 == null))) && (!((p1 == null))))){
                this._angle = GeomUtils.angle(p0, p1);
                this._length = GeomUtils.distance(p0, p1);
            };
        }
        public function get p0():Point{
            return (this._p0);
        }
        public function set p0(value:Point):void{
            this._p0 = value;
        }
        public function get p1():Point{
            return (this._p1);
        }
        public function set p1(value:Point):void{
            this._p1 = value;
        }
        public function get id():int{
            return (this._id);
        }
        public function set id(value:int):void{
            this._id = value;
        }
        public function intersect(e:Edge, asSegment0:Boolean=true, asSegment1:Boolean=true):Point{
            return (GeomUtils.lineIntersectLine(this.p0, this.p1, e.p0, e.p1, asSegment0, asSegment1));
        }
        public function equals(e:Edge, sameDirection:Boolean=true):Boolean{
            if (sameDirection){
                return (((this.p0.equals(e.p0)) && (this.p1.equals(e.p1))));
            };
            return ((((((this.p0 == e.p0)) && ((this.p1 == e.p1)))) || ((((this.p0 == e.p1)) && ((this.p1 == e.p0))))));
        }
        public function getPointAt(t:Number):Point{
            return (new Point((this.p0.x + ((Math.cos(this.angle) * this.length) * t)), (this.p0.y + ((Math.sin(this.angle) * this.length) * t))));
        }
        public function get center():Point{
            return (new Point((this.p0.x + (this.width * 0.5)), (this.p0.y + (this.height * 0.5))));
        }
        public function get angle():Number{
            return (GeomUtils.angle(this.p0, this.p1));
        }
        public function get squareLength():Number{
            return (GeomUtils.squareDistance(this.p0.x, this.p0.y, this.p1.x, this.p1.y));
        }
        public function get length():Number{
            return (GeomUtils.distance(this.p0, this.p1));
        }
        public function get width():Number{
            return ((this.p1.x - this.p0.x));
        }
        public function get height():Number{
            return ((this.p1.y - this.p0.y));
        }
        public function get leftNormal():Edge{
            return (new Edge(this.p0, new Point((this.p0.x + this.height), (this.p0.y - this.width))));
        }
        public function get rightNormal():Edge{
            return (new Edge(this.p0, new Point((this.p0.x - this.height), (this.p0.y + this.width))));
        }
        public function draw(graphics:Graphics=null):void{
            graphics.moveTo(this.p0.x, this.p0.y);
            graphics.lineTo(this.p1.x, this.p1.y);
        }

    }
}//package biga.shapes2d 
