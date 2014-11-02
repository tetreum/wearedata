package away3d.primitives {
    import __AS3__.vec.*;
    import away3d.core.base.*;

    public class PlaneGeometry extends PrimitiveBase {

        private var _segmentsW:uint;
        private var _segmentsH:uint;
        private var _yUp:Boolean;
        private var _width:Number;
        private var _height:Number;
        private var _doubleSided:Boolean;

        public function PlaneGeometry(width:Number=100, height:Number=100, segmentsW:uint=1, segmentsH:uint=1, yUp:Boolean=true, doubleSided:Boolean=false){
            super();
            this._segmentsW = segmentsW;
            this._segmentsH = segmentsH;
            this._yUp = yUp;
            this._width = width;
            this._height = height;
            this._doubleSided = doubleSided;
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
        public function get doubleSided():Boolean{
            return (this._doubleSided);
        }
        public function set doubleSided(value:Boolean):void{
            this._doubleSided = value;
            invalidateGeometry();
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
            this._height = value;
            invalidateGeometry();
        }
        override protected function buildGeometry(target:SubGeometry):void{
            var vertices:Vector.<Number>;
            var normals:Vector.<Number>;
            var tangents:Vector.<Number>;
            var indices:Vector.<uint>;
            var x:Number;
            var y:Number;
            var base:uint;
            var xi:uint;
            var i:int;
            var mult:int;
            var numIndices:uint;
            var tw:uint = (this._segmentsW + 1);
            var numVertices:uint = ((this._segmentsH + 1) * tw);
            if (this._doubleSided){
                numVertices = (numVertices * 2);
            };
            if (numVertices == target.numVertices){
                vertices = target.vertexData;
                normals = target.vertexNormalData;
                tangents = target.vertexTangentData;
                indices = target.indexData;
            } else {
                vertices = new Vector.<Number>((numVertices * 3), true);
                normals = new Vector.<Number>((numVertices * 3), true);
                tangents = new Vector.<Number>((numVertices * 3), true);
                numIndices = ((this._segmentsH * this._segmentsW) * 6);
                if (this._doubleSided){
                    numIndices = (numIndices << 1);
                };
                indices = new Vector.<uint>(numIndices, true);
            };
            numIndices = 0;
            numVertices = 0;
            var yi:uint;
            while (yi <= this._segmentsH) {
                xi = 0;
                while (xi <= this._segmentsW) {
                    x = (((xi / this._segmentsW) - 0.5) * this._width);
                    y = (((yi / this._segmentsH) - 0.5) * this._height);
                    vertices[numVertices] = x;
                    normals[numVertices] = 0;
                    var _temp1 = numVertices;
                    numVertices = (numVertices + 1);
                    var _local16 = _temp1;
                    tangents[_local16] = 1;
                    if (this._yUp){
                        vertices[numVertices] = 0;
                        normals[numVertices] = 1;
                        var _temp2 = numVertices;
                        numVertices = (numVertices + 1);
                        var _local17 = _temp2;
                        tangents[_local17] = 0;
                        vertices[numVertices] = y;
                        normals[numVertices] = 0;
                        var _temp3 = numVertices;
                        numVertices = (numVertices + 1);
                        var _local18 = _temp3;
                        tangents[_local18] = 0;
                    } else {
                        vertices[numVertices] = y;
                        normals[numVertices] = 0;
                        var _temp4 = numVertices;
                        numVertices = (numVertices + 1);
                        _local17 = _temp4;
                        tangents[_local17] = 0;
                        vertices[numVertices] = 0;
                        normals[numVertices] = -1;
                        var _temp5 = numVertices;
                        numVertices = (numVertices + 1);
                        _local18 = _temp5;
                        tangents[_local18] = 0;
                    };
                    if (this._doubleSided){
                        i = 0;
                        while (i < 3) {
                            vertices[numVertices] = vertices[(numVertices - 3)];
                            normals[numVertices] = -(normals[(numVertices - 3)]);
                            tangents[numVertices] = -(tangents[(numVertices - 3)]);
                            numVertices++;
                            i++;
                        };
                    };
                    if (((!((xi == this._segmentsW))) && (!((yi == this._segmentsH))))){
                        base = (xi + (yi * tw));
                        mult = ((this._doubleSided) ? 2 : 1);
                        var _temp6 = numIndices;
                        numIndices = (numIndices + 1);
                        _local17 = _temp6;
                        indices[_local17] = (base * mult);
                        var _temp7 = numIndices;
                        numIndices = (numIndices + 1);
                        _local18 = _temp7;
                        indices[_local18] = ((base + tw) * mult);
                        var _temp8 = numIndices;
                        numIndices = (numIndices + 1);
                        var _local19 = _temp8;
                        indices[_local19] = (((base + tw) + 1) * mult);
                        var _temp9 = numIndices;
                        numIndices = (numIndices + 1);
                        var _local20 = _temp9;
                        indices[_local20] = (base * mult);
                        var _temp10 = numIndices;
                        numIndices = (numIndices + 1);
                        var _local21 = _temp10;
                        indices[_local21] = (((base + tw) + 1) * mult);
                        var _temp11 = numIndices;
                        numIndices = (numIndices + 1);
                        var _local22 = _temp11;
                        indices[_local22] = ((base + 1) * mult);
                        if (this._doubleSided){
                            var _temp12 = numIndices;
                            numIndices = (numIndices + 1);
                            var _local23 = _temp12;
                            indices[_local23] = ((((base + tw) + 1) * mult) + 1);
                            var _temp13 = numIndices;
                            numIndices = (numIndices + 1);
                            var _local24 = _temp13;
                            indices[_local24] = (((base + tw) * mult) + 1);
                            var _temp14 = numIndices;
                            numIndices = (numIndices + 1);
                            var _local25 = _temp14;
                            indices[_local25] = ((base * mult) + 1);
                            var _temp15 = numIndices;
                            numIndices = (numIndices + 1);
                            var _local26 = _temp15;
                            indices[_local26] = (((base + 1) * mult) + 1);
                            var _temp16 = numIndices;
                            numIndices = (numIndices + 1);
                            var _local27 = _temp16;
                            indices[_local27] = ((((base + tw) + 1) * mult) + 1);
                            var _temp17 = numIndices;
                            numIndices = (numIndices + 1);
                            var _local28 = _temp17;
                            indices[_local28] = ((base * mult) + 1);
                        };
                    };
                    xi++;
                };
                yi++;
            };
            target.updateVertexData(vertices);
            target.updateVertexNormalData(normals);
            target.updateVertexTangentData(tangents);
            target.updateIndexData(indices);
        }
        override protected function buildUVs(target:SubGeometry):void{
            var xi:uint;
            var uvs:Vector.<Number> = new Vector.<Number>();
            var numUvs:uint = (((this._segmentsH + 1) * (this._segmentsW + 1)) * 2);
            if (((target.UVData) && ((numUvs == target.UVData.length)))){
                uvs = target.UVData;
            } else {
                uvs = new Vector.<Number>(numUvs, true);
            };
            numUvs = 0;
            var yi:uint;
            while (yi <= this._segmentsH) {
                xi = 0;
                while (xi <= this._segmentsW) {
                    var _temp1 = numUvs;
                    numUvs = (numUvs + 1);
                    var _local6 = _temp1;
                    uvs[_local6] = (xi / this._segmentsW);
                    var _temp2 = numUvs;
                    numUvs = (numUvs + 1);
                    var _local7 = _temp2;
                    uvs[_local7] = (1 - (yi / this._segmentsH));
                    xi++;
                };
                yi++;
            };
            target.updateUVData(uvs);
        }

    }
}//package away3d.primitives 
