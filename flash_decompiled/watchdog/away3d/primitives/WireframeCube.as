package away3d.primitives {
    import flash.geom.*;

    public class WireframeCube extends WireframePrimitiveBase {

        private var _width:Number;
        private var _height:Number;
        private var _depth:Number;

        public function WireframeCube(width:Number=100, height:Number=100, depth:Number=100, color:uint=0xFFFFFF, thickness:Number=1){
            super(color, thickness);
            this._width = width;
            this._height = height;
            this._depth = depth;
        }
        public function get width():Number{
            return (this._width);
        }
        public function set width(value:Number):void{
            this._width = value;
            invalidateGeometry();
        }
        public function get height():Number{
            return (this._height);
        }
        public function set height(value:Number):void{
            if (value <= 0){
                throw (new Error("Value needs to be greater than 0"));
            };
            this._height = value;
            invalidateGeometry();
        }
        public function get depth():Number{
            return (this._depth);
        }
        public function set depth(value:Number):void{
            this._depth = value;
            invalidateGeometry();
        }
        override protected function buildGeometry():void{
            var hw:Number;
            var hh:Number;
            var hd:Number;
            var v0:Vector3D = new Vector3D();
            var v1:Vector3D = new Vector3D();
            hw = (this._width * 0.5);
            hh = (this._height * 0.5);
            hd = (this._depth * 0.5);
            v0.x = -(hw);
            v0.y = hh;
            v0.z = -(hd);
            v1.x = -(hw);
            v1.y = -(hh);
            v1.z = -(hd);
            updateOrAddSegment(0, v0, v1);
            v0.z = hd;
            v1.z = hd;
            updateOrAddSegment(1, v0, v1);
            v0.x = hw;
            v1.x = hw;
            updateOrAddSegment(2, v0, v1);
            v0.z = -(hd);
            v1.z = -(hd);
            updateOrAddSegment(3, v0, v1);
            v0.x = -(hw);
            v0.y = -(hh);
            v0.z = -(hd);
            v1.x = hw;
            v1.y = -(hh);
            v1.z = -(hd);
            updateOrAddSegment(4, v0, v1);
            v0.y = hh;
            v1.y = hh;
            updateOrAddSegment(5, v0, v1);
            v0.z = hd;
            v1.z = hd;
            updateOrAddSegment(6, v0, v1);
            v0.y = -(hh);
            v1.y = -(hh);
            updateOrAddSegment(7, v0, v1);
            v0.x = -(hw);
            v0.y = -(hh);
            v0.z = -(hd);
            v1.x = -(hw);
            v1.y = -(hh);
            v1.z = hd;
            updateOrAddSegment(8, v0, v1);
            v0.y = hh;
            v1.y = hh;
            updateOrAddSegment(9, v0, v1);
            v0.x = hw;
            v1.x = hw;
            updateOrAddSegment(10, v0, v1);
            v0.y = -(hh);
            v1.y = -(hh);
            updateOrAddSegment(11, v0, v1);
        }

    }
}//package away3d.primitives 
