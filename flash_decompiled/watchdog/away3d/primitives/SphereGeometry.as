package away3d.primitives {
    import __AS3__.vec.*;
    import away3d.core.base.*;

    public class SphereGeometry extends PrimitiveBase {

        private var _radius:Number;
        private var _segmentsW:uint;
        private var _segmentsH:uint;
        private var _yUp:Boolean;

        public function SphereGeometry(radius:Number=50, segmentsW:uint=16, segmentsH:uint=12, yUp:Boolean=true){
            super();
            this._radius = radius;
            this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
            this._yUp = yUp;
        }
        override protected function buildGeometry(target:SubGeometry):void{
            var vertices:Vector.<Number>;
            var vertexNormals:Vector.<Number>;
            var vertexTangents:Vector.<Number>;
            var indices:Vector.<uint>;
            var i:uint;
            var j:uint;
            var triIndex:uint;
            var horangle:Number;
            var z:Number;
            var ringradius:Number;
            var verangle:Number;
            var x:Number;
            var y:Number;
            var normLen:Number;
            var tanLen:Number;
            var a:int;
            var b:int;
            var c:int;
            var d:int;
            var numVerts:uint = ((this._segmentsH + 1) * (this._segmentsW + 1));
            if (numVerts == target.numVertices){
                vertices = target.vertexData;
                vertexNormals = target.vertexNormalData;
                vertexTangents = target.vertexTangentData;
                indices = target.indexData;
            } else {
                vertices = new Vector.<Number>((numVerts * 3), true);
                vertexNormals = new Vector.<Number>((numVerts * 3), true);
                vertexTangents = new Vector.<Number>((numVerts * 3), true);
                indices = new Vector.<uint>((((this._segmentsH - 1) * this._segmentsW) * 6), true);
            };
            numVerts = 0;
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
                    normLen = (1 / Math.sqrt((((x * x) + (y * y)) + (z * z))));
                    tanLen = Math.sqrt(((y * y) + (x * x)));
                    if (this._yUp){
                        vertexNormals[numVerts] = (x * normLen);
                        vertexTangents[numVerts] = (((tanLen > 0.007)) ? (-(y) / tanLen) : 1);
                        var _temp1 = numVerts;
                        numVerts = (numVerts + 1);
                        var _local22 = _temp1;
                        vertices[_local22] = x;
                        vertexNormals[numVerts] = (-(z) * normLen);
                        vertexTangents[numVerts] = 0;
                        var _temp2 = numVerts;
                        numVerts = (numVerts + 1);
                        var _local23 = _temp2;
                        vertices[_local23] = -(z);
                        vertexNormals[numVerts] = (y * normLen);
                        vertexTangents[numVerts] = (((tanLen > 0.007)) ? (x / tanLen) : 0);
                        var _temp3 = numVerts;
                        numVerts = (numVerts + 1);
                        var _local24 = _temp3;
                        vertices[_local24] = y;
                    } else {
                        vertexNormals[numVerts] = (x * normLen);
                        vertexTangents[numVerts] = (((tanLen > 0.007)) ? (-(y) / tanLen) : 1);
                        var _temp4 = numVerts;
                        numVerts = (numVerts + 1);
                        _local22 = _temp4;
                        vertices[_local22] = x;
                        vertexNormals[numVerts] = (y * normLen);
                        vertexTangents[numVerts] = (((tanLen > 0.007)) ? (x / tanLen) : 0);
                        var _temp5 = numVerts;
                        numVerts = (numVerts + 1);
                        _local23 = _temp5;
                        vertices[_local23] = y;
                        vertexNormals[numVerts] = (z * normLen);
                        vertexTangents[numVerts] = 0;
                        var _temp6 = numVerts;
                        numVerts = (numVerts + 1);
                        _local24 = _temp6;
                        vertices[_local24] = z;
                    };
                    if ((((i > 0)) && ((j > 0)))){
                        a = (((this._segmentsW + 1) * j) + i);
                        b = ((((this._segmentsW + 1) * j) + i) - 1);
                        c = ((((this._segmentsW + 1) * (j - 1)) + i) - 1);
                        d = (((this._segmentsW + 1) * (j - 1)) + i);
                        if (j == this._segmentsH){
                            var _temp7 = triIndex;
                            triIndex = (triIndex + 1);
                            _local22 = _temp7;
                            indices[_local22] = a;
                            var _temp8 = triIndex;
                            triIndex = (triIndex + 1);
                            _local23 = _temp8;
                            indices[_local23] = c;
                            var _temp9 = triIndex;
                            triIndex = (triIndex + 1);
                            _local24 = _temp9;
                            indices[_local24] = d;
                        } else {
                            if (j == 1){
                                var _temp10 = triIndex;
                                triIndex = (triIndex + 1);
                                _local22 = _temp10;
                                indices[_local22] = a;
                                var _temp11 = triIndex;
                                triIndex = (triIndex + 1);
                                _local23 = _temp11;
                                indices[_local23] = b;
                                var _temp12 = triIndex;
                                triIndex = (triIndex + 1);
                                _local24 = _temp12;
                                indices[_local24] = c;
                            } else {
                                var _temp13 = triIndex;
                                triIndex = (triIndex + 1);
                                _local22 = _temp13;
                                indices[_local22] = a;
                                var _temp14 = triIndex;
                                triIndex = (triIndex + 1);
                                _local23 = _temp14;
                                indices[_local23] = b;
                                var _temp15 = triIndex;
                                triIndex = (triIndex + 1);
                                _local24 = _temp15;
                                indices[_local24] = c;
                                var _temp16 = triIndex;
                                triIndex = (triIndex + 1);
                                var _local25 = _temp16;
                                indices[_local25] = a;
                                var _temp17 = triIndex;
                                triIndex = (triIndex + 1);
                                var _local26 = _temp17;
                                indices[_local26] = c;
                                var _temp18 = triIndex;
                                triIndex = (triIndex + 1);
                                var _local27 = _temp18;
                                indices[_local27] = d;
                            };
                        };
                    };
                    i++;
                };
                j++;
            };
            target.updateVertexData(vertices);
            target.updateVertexNormalData(vertexNormals);
            target.updateVertexTangentData(vertexTangents);
            target.updateIndexData(indices);
        }
        override protected function buildUVs(target:SubGeometry):void{
            var i:int;
            var j:int;
            var uvData:Vector.<Number>;
            var numUvs:uint = (((this._segmentsH + 1) * (this._segmentsW + 1)) * 2);
            if (((target.UVData) && ((numUvs == target.UVData.length)))){
                uvData = target.UVData;
            } else {
                uvData = new Vector.<Number>(numUvs, true);
            };
            numUvs = 0;
            j = 0;
            while (j <= this._segmentsH) {
                i = 0;
                while (i <= this._segmentsW) {
                    var _temp1 = numUvs;
                    numUvs = (numUvs + 1);
                    var _local6 = _temp1;
                    uvData[_local6] = (i / this._segmentsW);
                    var _temp2 = numUvs;
                    numUvs = (numUvs + 1);
                    var _local7 = _temp2;
                    uvData[_local7] = (j / this._segmentsH);
                    i++;
                };
                j++;
            };
            target.updateUVData(uvData);
        }
        public function get radius():Number{
            return (this._radius);
        }
        public function set radius(value:Number):void{
            this._radius = value;
            invalidateGeometry();
        }
        public function get segmentsW():uint{
            return (this._segmentsW);
        }
        public function set segmentsW(value:uint):void{
            this._segmentsW = value;
            invalidateGeometry();
            invalidateUVs();
        }
        public function get segmentsH():uint{
            return (this._segmentsH);
        }
        public function set segmentsH(value:uint):void{
            this._segmentsH = value;
            invalidateGeometry();
            invalidateUVs();
        }
        public function get yUp():Boolean{
            return (this._yUp);
        }
        public function set yUp(value:Boolean):void{
            this._yUp = value;
            invalidateGeometry();
        }

    }
}//package away3d.primitives 
