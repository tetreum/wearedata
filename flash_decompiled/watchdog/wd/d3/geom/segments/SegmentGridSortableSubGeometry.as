package wd.d3.geom.segments {
    import __AS3__.vec.*;
    import flash.geom.*;

    public class SegmentGridSortableSubGeometry {

        private static var _id:int = 0;

        public var VERTEX_BUFFER_LENGTH:int = 7;
        private var v_offset:uint;
        private var _numVertices:uint;
        private var _numTriangles:uint;
        private var _numIndices:uint;
        public var _vertices:Vector.<Number>;
        public var _indices:Vector.<uint>;
        public var _uvs:Vector.<Number>;
        private var _lineCount:uint = 0;
        private var _thickness:Number;
        public var id:int;

        public function SegmentGridSortableSubGeometry(thickness:Number=1){
            this._vertices = new Vector.<Number>();
            this._indices = new Vector.<uint>();
            this._uvs = new Vector.<Number>();
            super();
            this._thickness = thickness;
            this.id = _id++;
        }
        public function purge():void{
            this._vertices.length = 0;
            this._indices.length = 0;
            this._uvs.length = 0;
            this._vertices = null;
            this._indices = null;
            this._uvs = null;
        }
        public function get numVertices():uint{
            return (this._numVertices);
        }
        public function get numTriangles():uint{
            return (this._numTriangles);
        }
        public function mergeSegment(s:Vector3D, e:Vector3D):void{
            var index:uint = this._vertices.length;
            var _temp1 = index;
            index = (index + 1);
            var _local4 = _temp1;
            this._vertices[_local4] = s.x;
            var _temp2 = index;
            index = (index + 1);
            var _local5 = _temp2;
            this._vertices[_local5] = s.y;
            var _temp3 = index;
            index = (index + 1);
            var _local6 = _temp3;
            this._vertices[_local6] = s.z;
            var _temp4 = index;
            index = (index + 1);
            var _local7 = _temp4;
            this._vertices[_local7] = e.x;
            var _temp5 = index;
            index = (index + 1);
            var _local8 = _temp5;
            this._vertices[_local8] = e.y;
            var _temp6 = index;
            index = (index + 1);
            var _local9 = _temp6;
            this._vertices[_local9] = e.z;
            var _temp7 = index;
            index = (index + 1);
            var _local10 = _temp7;
            this._vertices[_local10] = this._thickness;
            var _temp8 = index;
            index = (index + 1);
            var _local11 = _temp8;
            this._vertices[_local11] = e.x;
            var _temp9 = index;
            index = (index + 1);
            var _local12 = _temp9;
            this._vertices[_local12] = e.y;
            var _temp10 = index;
            index = (index + 1);
            var _local13 = _temp10;
            this._vertices[_local13] = e.z;
            var _temp11 = index;
            index = (index + 1);
            var _local14 = _temp11;
            this._vertices[_local14] = s.x;
            var _temp12 = index;
            index = (index + 1);
            var _local15 = _temp12;
            this._vertices[_local15] = s.y;
            var _temp13 = index;
            index = (index + 1);
            var _local16 = _temp13;
            this._vertices[_local16] = s.z;
            var _temp14 = index;
            index = (index + 1);
            var _local17 = _temp14;
            this._vertices[_local17] = -(this._thickness);
            var _temp15 = index;
            index = (index + 1);
            var _local18 = _temp15;
            this._vertices[_local18] = s.x;
            var _temp16 = index;
            index = (index + 1);
            var _local19 = _temp16;
            this._vertices[_local19] = s.y;
            var _temp17 = index;
            index = (index + 1);
            var _local20 = _temp17;
            this._vertices[_local20] = s.z;
            var _temp18 = index;
            index = (index + 1);
            var _local21 = _temp18;
            this._vertices[_local21] = e.x;
            var _temp19 = index;
            index = (index + 1);
            var _local22 = _temp19;
            this._vertices[_local22] = e.y;
            var _temp20 = index;
            index = (index + 1);
            var _local23 = _temp20;
            this._vertices[_local23] = e.z;
            var _temp21 = index;
            index = (index + 1);
            var _local24 = _temp21;
            this._vertices[_local24] = -(this._thickness);
            var _temp22 = index;
            index = (index + 1);
            var _local25 = _temp22;
            this._vertices[_local25] = e.x;
            var _temp23 = index;
            index = (index + 1);
            var _local26 = _temp23;
            this._vertices[_local26] = e.y;
            var _temp24 = index;
            index = (index + 1);
            var _local27 = _temp24;
            this._vertices[_local27] = e.z;
            var _temp25 = index;
            index = (index + 1);
            var _local28 = _temp25;
            this._vertices[_local28] = s.x;
            var _temp26 = index;
            index = (index + 1);
            var _local29 = _temp26;
            this._vertices[_local29] = s.y;
            var _temp27 = index;
            index = (index + 1);
            var _local30 = _temp27;
            this._vertices[_local30] = s.z;
            var _temp28 = index;
            index = (index + 1);
            var _local31 = _temp28;
            this._vertices[_local31] = this._thickness;
            index = (this._lineCount << 2);
            this._indices.push(index, (index + 1), (index + 2), (index + 3), (index + 2), (index + 1));
            this._numVertices = (this._vertices.length / this.VERTEX_BUFFER_LENGTH);
            this._numIndices = this._indices.length;
            this._numTriangles = (this._indices.length / 3);
            this._lineCount++;
        }

    }
}//package wd.d3.geom.segments 
