package wd.wq.datas {

    public class UVCoord {

        public var x:Number;
        public var y:Number;
        public var xC:Number;
        public var yC:Number;
        public var realW:Number;
        public var realH:Number;

        public function UVCoord(_x:Number, _y:Number, _w:Number, _h:Number, _rw:Number=0, _rh:Number=0){
            super();
            this.x = _x;
            this.y = _y;
            this.xC = (_x + _w);
            this.yC = (_y + _h);
            this.realW = _rw;
            this.realH = _rh;
        }
        public function toString():String{
            return (((((((("UVCoord x:" + this.x) + " y:") + this.y) + " xCorner:") + this.xC) + " yCorner:") + this.yC));
        }

    }
}//package wd.wq.datas 
