package away3d.primitives {
    import flash.geom.*;
    import __AS3__.vec.*;

    public class WireframeCylinder extends WireframePrimitiveBase {

        private static const TWO_PI:Number = 6.28318530717959;

        private var _topRadius:Number;
        private var _bottomRadius:Number;
        private var _height:Number;
        private var _segmentsW:uint;
        private var _segmentsH:uint;

        public function WireframeCylinder(topRadius:Number=50, bottomRadius:Number=50, height:Number=100, segmentsW:uint=16, segmentsH:uint=1, color:uint=0xFFFFFF, thickness:Number=1){
            super(color, thickness);
            this._topRadius = topRadius;
            this._bottomRadius = bottomRadius;
            this._height = height;
            this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
        }
        override protected function buildGeometry():void{
            var i:uint;
            var j:uint;
            var revolutionAngle:Number;
            var x:Number;
            var y:Number;
            var z:Number;
            var previousV:Vector3D;
            var vertex:Vector3D;
            var radius:Number = this._topRadius;
            var revolutionAngleDelta:Number = (TWO_PI / this._segmentsW);
            var nextVertexIndex:int;
            var lastLayer:Vector.<Vector.<Vector3D>> = new Vector.<Vector.<Vector3D>>((this._segmentsH + 1), true);
            j = 0;
            while (j <= this._segmentsH) {
                lastLayer[j] = new Vector.<Vector3D>((this._segmentsW + 1), true);
                radius = (this._topRadius - ((j / this._segmentsH) * (this._topRadius - this._bottomRadius)));
                z = (-((this._height / 2)) + ((j / this._segmentsH) * this._height));
                previousV = null;
                i = 0;
                while (i <= this._segmentsW) {
                    revolutionAngle = (i * revolutionAngleDelta);
                    x = (radius * Math.cos(revolutionAngle));
                    y = (radius * Math.sin(revolutionAngle));
                    if (previousV){
                        vertex = new Vector3D(x, -(z), y);
                        var _temp1 = nextVertexIndex;
                        nextVertexIndex = (nextVertexIndex + 1);
                        updateOrAddSegment(_temp1, vertex, previousV);
                        previousV = vertex;
                    } else {
                        previousV = new Vector3D(x, -(z), y);
                    };
                    if (j > 0){
                        var _temp2 = nextVertexIndex;
                        nextVertexIndex = (nextVertexIndex + 1);
                        updateOrAddSegment(_temp2, vertex, lastLayer[(j - 1)][i]);
                    };
                    lastLayer[j][i] = previousV;
                    i++;
                };
                j++;
            };
        }
        public function get topRadius():Number{
            return (this._topRadius);
        }
        public function set topRadius(value:Number):void{
            this._topRadius = value;
            invalidateGeometry();
        }
        public function get bottomRadius():Number{
            return (this._bottomRadius);
        }
        public function set bottomRadius(value:Number):void{
            this._bottomRadius = value;
            invalidateGeometry();
        }
        public function get height():Number{
            return (this._height);
        }
        public function set height(value:Number):void{
            if (this.height <= 0){
                throw (new Error("Height must be a value greater than zero."));
            };
            this._height = value;
            invalidateGeometry();
        }

    }
}//package away3d.primitives 
