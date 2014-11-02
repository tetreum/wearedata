package away3d.primitives {
    import __AS3__.vec.*;
    import flash.geom.*;

    public class WireframeSphere extends WireframePrimitiveBase {

        private var _segmentsW:uint;
        private var _segmentsH:uint;
        private var _radius:Number;

        public function WireframeSphere(radius:Number=50, segmentsW:uint=16, segmentsH:uint=12, color:uint=0xFFFFFF, thickness:Number=1){
            super(color, thickness);
            this._radius = radius;
            this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
        }
        override protected function buildGeometry():void{
            var i:uint;
            var j:uint;
            var index:int;
            var horangle:Number;
            var z:Number;
            var ringradius:Number;
            var verangle:Number;
            var x:Number;
            var y:Number;
            var a:int;
            var b:int;
            var c:int;
            var d:int;
            var vertices:Vector.<Number> = new Vector.<Number>();
            var v0:Vector3D = new Vector3D();
            var v1:Vector3D = new Vector3D();
            var numVerts:uint;
            j = 0;
            while (j <= this._segmentsH) {
                horangle = ((Math.PI * j) / this._segmentsH);
                z = (-(this._radius) * Math.cos(horangle));
                ringradius = (this._radius * Math.sin(horangle));
                i = 0;
                while (i <= this._segmentsW) {
                    verangle = (((2 * Math.PI) * i) / this._segmentsW);
                    x = (ringradius * Math.cos(verangle));
                    y = (ringradius * Math.sin(verangle));
                    var _temp1 = numVerts;
                    numVerts = (numVerts + 1);
                    var _local18 = _temp1;
                    vertices[_local18] = x;
                    var _temp2 = numVerts;
                    numVerts = (numVerts + 1);
                    var _local19 = _temp2;
                    vertices[_local19] = -(z);
                    var _temp3 = numVerts;
                    numVerts = (numVerts + 1);
                    var _local20 = _temp3;
                    vertices[_local20] = y;
                    i++;
                };
                j++;
            };
            j = 1;
            while (j <= this._segmentsH) {
                i = 1;
                while (i <= this._segmentsW) {
                    a = ((((this._segmentsW + 1) * j) + i) * 3);
                    b = (((((this._segmentsW + 1) * j) + i) - 1) * 3);
                    c = (((((this._segmentsW + 1) * (j - 1)) + i) - 1) * 3);
                    d = ((((this._segmentsW + 1) * (j - 1)) + i) * 3);
                    if (j == this._segmentsH){
                        v0.x = vertices[c];
                        v0.y = vertices[(c + 1)];
                        v0.z = vertices[(c + 2)];
                        v1.x = vertices[d];
                        v1.y = vertices[(d + 1)];
                        v1.z = vertices[(d + 2)];
                        var _temp4 = index;
                        index = (index + 1);
                        updateOrAddSegment(_temp4, v0, v1);
                        v0.x = vertices[a];
                        v0.y = vertices[(a + 1)];
                        v0.z = vertices[(a + 2)];
                        var _temp5 = index;
                        index = (index + 1);
                        updateOrAddSegment(_temp5, v0, v1);
                    } else {
                        if (j == 1){
                            v1.x = vertices[b];
                            v1.y = vertices[(b + 1)];
                            v1.z = vertices[(b + 2)];
                            v0.x = vertices[c];
                            v0.y = vertices[(c + 1)];
                            v0.z = vertices[(c + 2)];
                            var _temp6 = index;
                            index = (index + 1);
                            updateOrAddSegment(_temp6, v0, v1);
                        } else {
                            v1.x = vertices[b];
                            v1.y = vertices[(b + 1)];
                            v1.z = vertices[(b + 2)];
                            v0.x = vertices[c];
                            v0.y = vertices[(c + 1)];
                            v0.z = vertices[(c + 2)];
                            var _temp7 = index;
                            index = (index + 1);
                            updateOrAddSegment(_temp7, v0, v1);
                            v1.x = vertices[d];
                            v1.y = vertices[(d + 1)];
                            v1.z = vertices[(d + 2)];
                            var _temp8 = index;
                            index = (index + 1);
                            updateOrAddSegment(_temp8, v0, v1);
                        };
                    };
                    i++;
                };
                j++;
            };
        }

    }
}//package away3d.primitives 
