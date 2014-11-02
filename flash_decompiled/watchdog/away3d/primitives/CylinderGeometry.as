package away3d.primitives {
    import __AS3__.vec.*;
    import away3d.core.base.*;

    public class CylinderGeometry extends PrimitiveBase {

        protected var _topRadius:Number;
        protected var _bottomRadius:Number;
        protected var _height:Number;
        protected var _segmentsW:uint;
        protected var _segmentsH:uint;
        protected var _topClosed:Boolean;
        protected var _bottomClosed:Boolean;
        protected var _surfaceClosed:Boolean;
        protected var _yUp:Boolean;
        private var _rawVertexPositions:Vector.<Number>;
        private var _rawVertexNormals:Vector.<Number>;
        private var _rawVertexTangents:Vector.<Number>;
        private var _rawUvs:Vector.<Number>;
        private var _rawIndices:Vector.<uint>;
        private var _nextVertexIndex:uint;
        private var _currentIndex:uint;
        private var _currentTriangleIndex:uint;
        private var _vertexIndexOffset:uint;
        private var _numVertices:uint;
        private var _numTriangles:uint;

        public function CylinderGeometry(topRadius:Number=50, bottomRadius:Number=50, height:Number=100, segmentsW:uint=16, segmentsH:uint=1, topClosed:Boolean=true, bottomClosed:Boolean=true, surfaceClosed:Boolean=true, yUp:Boolean=true){
            super();
            this._topRadius = topRadius;
            this._bottomRadius = bottomRadius;
            this._height = height;
            this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
            this._topClosed = topClosed;
            this._bottomClosed = bottomClosed;
            this._surfaceClosed = surfaceClosed;
            this._yUp = yUp;
        }
        private function addVertex(px:Number, py:Number, pz:Number, nx:Number, ny:Number, nz:Number, tx:Number, ty:Number, tz:Number):void{
            var compVertInd:uint = (this._nextVertexIndex * 3);
            this._rawVertexPositions[compVertInd] = px;
            this._rawVertexPositions[(compVertInd + 1)] = py;
            this._rawVertexPositions[(compVertInd + 2)] = pz;
            this._rawVertexNormals[compVertInd] = nx;
            this._rawVertexNormals[(compVertInd + 1)] = ny;
            this._rawVertexNormals[(compVertInd + 2)] = nz;
            this._rawVertexTangents[compVertInd] = tx;
            this._rawVertexTangents[(compVertInd + 1)] = ty;
            this._rawVertexTangents[(compVertInd + 2)] = tz;
            this._nextVertexIndex++;
        }
        private function addTriangleClockWise(cwVertexIndex0:uint, cwVertexIndex1:uint, cwVertexIndex2:uint):void{
            var _local4 = this._currentIndex++;
            this._rawIndices[_local4] = cwVertexIndex0;
            var _local5 = this._currentIndex++;
            this._rawIndices[_local5] = cwVertexIndex1;
            var _local6 = this._currentIndex++;
            this._rawIndices[_local6] = cwVertexIndex2;
            this._currentTriangleIndex++;
        }
        override protected function buildGeometry(target:SubGeometry):void{
            var i:uint;
            var j:uint;
            var x:Number;
            var y:Number;
            var z:Number;
            var radius:Number;
            var revolutionAngle:Number;
            var dr:Number;
            var latNormElev:Number;
            var latNormBase:Number;
            var numVertComponents:uint;
            var a:uint;
            var b:uint;
            var c:uint;
            var d:uint;
            var na0:Number;
            var na1:Number;
            this._numVertices = 0;
            this._numTriangles = 0;
            this._nextVertexIndex = 0;
            this._currentIndex = 0;
            this._currentTriangleIndex = 0;
            if (this._surfaceClosed){
                this._numVertices = (this._numVertices + ((this._segmentsH + 1) * (this._segmentsW + 1)));
                this._numTriangles = (this._numTriangles + ((this._segmentsH * this._segmentsW) * 2));
            };
            if (this._topClosed){
                this._numVertices = (this._numVertices + (2 * (this._segmentsW + 1)));
                this._numTriangles = (this._numTriangles + this._segmentsW);
            };
            if (this._bottomClosed){
                this._numVertices = (this._numVertices + (2 * (this._segmentsW + 1)));
                this._numTriangles = (this._numTriangles + this._segmentsW);
            };
            if (this._numVertices == target.numVertices){
                this._rawVertexPositions = target.vertexData;
                this._rawVertexNormals = target.vertexNormalData;
                this._rawVertexTangents = target.vertexTangentData;
                this._rawIndices = target.indexData;
            } else {
                numVertComponents = (this._numVertices * 3);
                this._rawVertexPositions = new Vector.<Number>(numVertComponents, true);
                this._rawVertexNormals = new Vector.<Number>(numVertComponents, true);
                this._rawVertexTangents = new Vector.<Number>(numVertComponents, true);
                this._rawIndices = new Vector.<uint>((this._numTriangles * 3), true);
            };
            var revolutionAngleDelta:Number = ((2 * Math.PI) / this._segmentsW);
            if (((this._topClosed) && ((this._topRadius > 0)))){
                z = (-0.5 * this._height);
                i = 0;
                while (i <= this._segmentsW) {
                    if (this._yUp){
                        this.addVertex(0, -(z), 0, 0, 1, 0, 1, 0, 0);
                    } else {
                        this.addVertex(0, 0, z, 0, 0, -1, 1, 0, 0);
                    };
                    revolutionAngle = (i * revolutionAngleDelta);
                    x = (this._topRadius * Math.cos(revolutionAngle));
                    y = (this._topRadius * Math.sin(revolutionAngle));
                    if (this._yUp){
                        this.addVertex(x, -(z), y, 0, 1, 0, 1, 0, 0);
                    } else {
                        this.addVertex(x, y, z, 0, 0, -1, 1, 0, 0);
                    };
                    if (i > 0){
                        this.addTriangleClockWise((this._nextVertexIndex - 1), (this._nextVertexIndex - 3), (this._nextVertexIndex - 2));
                    };
                    i++;
                };
                this._vertexIndexOffset = this._nextVertexIndex;
            };
            if (((this._bottomClosed) && ((this._bottomRadius > 0)))){
                z = (0.5 * this._height);
                i = 0;
                while (i <= this._segmentsW) {
                    if (this._yUp){
                        this.addVertex(0, -(z), 0, 0, -1, 0, 1, 0, 0);
                    } else {
                        this.addVertex(0, 0, z, 0, 0, 1, 1, 0, 0);
                    };
                    revolutionAngle = (i * revolutionAngleDelta);
                    x = (this._bottomRadius * Math.cos(revolutionAngle));
                    y = (this._bottomRadius * Math.sin(revolutionAngle));
                    if (this._yUp){
                        this.addVertex(x, -(z), y, 0, -1, 0, 1, 0, 0);
                    } else {
                        this.addVertex(x, y, z, 0, 0, 1, 1, 0, 0);
                    };
                    if (i > 0){
                        this.addTriangleClockWise((this._nextVertexIndex - 2), (this._nextVertexIndex - 3), (this._nextVertexIndex - 1));
                    };
                    i++;
                };
                this._vertexIndexOffset = this._nextVertexIndex;
            };
            dr = (this._bottomRadius - this._topRadius);
            latNormElev = (dr / this._height);
            latNormBase = ((latNormElev)==0) ? 1 : (this._height / dr);
            if (this._surfaceClosed){
                j = 0;
                while (j <= this._segmentsH) {
                    radius = (this._topRadius - ((j / this._segmentsH) * (this._topRadius - this._bottomRadius)));
                    z = (-((this._height / 2)) + ((j / this._segmentsH) * this._height));
                    i = 0;
                    while (i <= this._segmentsW) {
                        revolutionAngle = (i * revolutionAngleDelta);
                        x = (radius * Math.cos(revolutionAngle));
                        y = (radius * Math.sin(revolutionAngle));
                        na0 = (latNormBase * Math.cos(revolutionAngle));
                        na1 = (latNormBase * Math.sin(revolutionAngle));
                        if (this._yUp){
                            this.addVertex(x, -(z), y, na0, latNormElev, na1, na1, 0, -(na0));
                        } else {
                            this.addVertex(x, y, z, na0, na1, latNormElev, na1, -(na0), 0);
                        };
                        if ((((i > 0)) && ((j > 0)))){
                            a = (this._nextVertexIndex - 1);
                            b = (this._nextVertexIndex - 2);
                            c = ((b - this._segmentsW) - 1);
                            d = ((a - this._segmentsW) - 1);
                            this.addTriangleClockWise(a, b, c);
                            this.addTriangleClockWise(a, c, d);
                        };
                        i++;
                    };
                    j++;
                };
            };
            target.updateVertexData(this._rawVertexPositions);
            target.updateVertexNormalData(this._rawVertexNormals);
            target.updateVertexTangentData(this._rawVertexTangents);
            target.updateIndexData(this._rawIndices);
        }
        override protected function buildUVs(target:SubGeometry):void{
            var i:int;
            var j:int;
            var x:Number;
            var y:Number;
            var revolutionAngle:Number;
            var numUvs:uint = (this._numVertices * 2);
            if (((target.UVData) && ((numUvs == target.UVData.length)))){
                this._rawUvs = target.UVData;
            } else {
                this._rawUvs = new Vector.<Number>(numUvs, true);
            };
            var revolutionAngleDelta:Number = ((2 * Math.PI) / this._segmentsW);
            var currentUvCompIndex:uint;
            if (this._topClosed){
                i = 0;
                while (i <= this._segmentsW) {
                    revolutionAngle = (i * revolutionAngleDelta);
                    x = (0.5 + (0.5 * Math.cos(revolutionAngle)));
                    y = (0.5 + (0.5 * Math.sin(revolutionAngle)));
                    var _temp1 = currentUvCompIndex;
                    currentUvCompIndex = (currentUvCompIndex + 1);
                    var _local10 = _temp1;
                    this._rawUvs[_local10] = 0.5;
                    var _temp2 = currentUvCompIndex;
                    currentUvCompIndex = (currentUvCompIndex + 1);
                    var _local11 = _temp2;
                    this._rawUvs[_local11] = 0.5;
                    var _temp3 = currentUvCompIndex;
                    currentUvCompIndex = (currentUvCompIndex + 1);
                    var _local12 = _temp3;
                    this._rawUvs[_local12] = x;
                    var _temp4 = currentUvCompIndex;
                    currentUvCompIndex = (currentUvCompIndex + 1);
                    var _local13 = _temp4;
                    this._rawUvs[_local13] = y;
                    i++;
                };
            };
            if (this._bottomClosed){
                i = 0;
                while (i <= this._segmentsW) {
                    revolutionAngle = (i * revolutionAngleDelta);
                    x = (0.5 + (0.5 * Math.cos(revolutionAngle)));
                    y = (0.5 + (0.5 * Math.sin(revolutionAngle)));
                    var _temp5 = currentUvCompIndex;
                    currentUvCompIndex = (currentUvCompIndex + 1);
                    _local10 = _temp5;
                    this._rawUvs[_local10] = 0.5;
                    var _temp6 = currentUvCompIndex;
                    currentUvCompIndex = (currentUvCompIndex + 1);
                    _local11 = _temp6;
                    this._rawUvs[_local11] = 0.5;
                    var _temp7 = currentUvCompIndex;
                    currentUvCompIndex = (currentUvCompIndex + 1);
                    _local12 = _temp7;
                    this._rawUvs[_local12] = x;
                    var _temp8 = currentUvCompIndex;
                    currentUvCompIndex = (currentUvCompIndex + 1);
                    _local13 = _temp8;
                    this._rawUvs[_local13] = y;
                    i++;
                };
            };
            if (this._surfaceClosed){
                j = 0;
                while (j <= this._segmentsH) {
                    i = 0;
                    while (i <= this._segmentsW) {
                        var _temp9 = currentUvCompIndex;
                        currentUvCompIndex = (currentUvCompIndex + 1);
                        _local10 = _temp9;
                        this._rawUvs[_local10] = (i / this._segmentsW);
                        var _temp10 = currentUvCompIndex;
                        currentUvCompIndex = (currentUvCompIndex + 1);
                        _local11 = _temp10;
                        this._rawUvs[_local11] = (j / this._segmentsH);
                        i++;
                    };
                    j++;
                };
            };
            target.updateUVData(this._rawUvs);
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
            this._height = value;
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
        public function get topClosed():Boolean{
            return (this._topClosed);
        }
        public function set topClosed(value:Boolean):void{
            this._topClosed = value;
            invalidateGeometry();
        }
        public function get bottomClosed():Boolean{
            return (this._bottomClosed);
        }
        public function set bottomClosed(value:Boolean):void{
            this._bottomClosed = value;
            invalidateGeometry();
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
