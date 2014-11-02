package wd.d3.geom.segments {
    import wd.core.*;
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.display3D.*;
    import away3d.core.managers.*;
    import away3d.entities.*;
    import away3d.materials.*;
    import away3d.animators.*;
    import away3d.bounds.*;
    import away3d.core.partition.*;
    import away3d.core.base.*;

    public class WireSegmentSetV2 extends Entity implements IRenderable {

        public var _segments:Vector.<WireSegment>;
        public var VERTEX_BUFFER_LENGTH:int = 7;
        private var _material:MaterialBase;
        private var _vertices:Vector.<Number>;
        private var _animator:IAnimator;
        private var _numVertices:uint = 0;
        private var _indices:Vector.<uint>;
        private var _numIndices:uint;
        private var _vertexBufferDirty:Boolean;
        private var _indexBufferDirty:Boolean;
        private var _vertexContext3D:Context3D;
        private var _indexContext3D:Context3D;
        private var _vertexBuffer:VertexBuffer3D;
        private var _indexBuffer:IndexBuffer3D;
        private var _lineCount:uint;
        private var _startColor:int;
        private var sr:Number;
        private var sg:Number;
        private var sb:Number;
        private var _thickness:Number;

        public function WireSegmentSetV2(startColor:int=-1, thickness:Number=1){
            this.thickness = thickness;
            if (startColor == -1){
                startColor = Constants.BUILDING_SEGMENTS_TOP_COLOR;
            };
            this.startColor = startColor;
            super();
            this._vertices = new Vector.<Number>();
            this._indices = new Vector.<uint>();
            this.material = new WireSegmentMaterialV2(startColor, thickness);
        }
        public function addSegment(s:Vector3D, e:Vector3D):void{
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
            this._vertices[_local10] = this.thickness;
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
            this._vertices[_local17] = -(this.thickness);
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
            this._vertices[_local24] = -(this.thickness);
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
            this._vertices[_local31] = this.thickness;
            index = (this._lineCount << 2);
            this._indices.push(index, (index + 1), (index + 2), (index + 3), (index + 2), (index + 1));
            this._numVertices = (this._vertices.length / this.VERTEX_BUFFER_LENGTH);
            this._numIndices = this._indices.length;
            this._vertexBufferDirty = true;
            this._indexBufferDirty = true;
            this._lineCount++;
        }
        private function removeSegmentByIndex(index:uint):void{
            var indVert:uint = (this._indices[index] * this.VERTEX_BUFFER_LENGTH);
            this._indices.splice(index, 6);
            this._vertices.splice(indVert, (4 * this.VERTEX_BUFFER_LENGTH));
            this._numVertices = (this._vertices.length / this.VERTEX_BUFFER_LENGTH);
            this._numIndices = this._indices.length;
            this._vertexBufferDirty = true;
            this._indexBufferDirty = true;
        }
        public function removeSegment(segment:WireSegment):void{
            var index:uint;
            var i:uint;
            while (i < this._segments.length) {
                if (this._segments[i] == segment){
                    segment.segmentsBase = null;
                    this._segments.splice(i, 1);
                    this.removeSegmentByIndex(segment.index);
                    segment = null;
                    this._lineCount--;
                } else {
                    this._segments[i].index = index;
                    index = (index + 6);
                };
                i++;
            };
            this._vertexBufferDirty = true;
            this._indexBufferDirty = true;
        }
        public function getSegment(index:uint):WireSegment{
            return (this._segments[index]);
        }
        public function removeAllSegments():void{
            this._vertices.length = 0;
            this._indices.length = 0;
            this._segments.length = 0;
            this._numVertices = 0;
            this._numIndices = 0;
            this._lineCount = 0;
            this._vertexBufferDirty = true;
            this._indexBufferDirty = true;
        }
        public function getIndexBuffer2(stage3DProxy:Stage3DProxy):IndexBuffer3D{
            return (null);
        }
        public function getIndexBuffer(stage3DProxy:Stage3DProxy):IndexBuffer3D{
            if (((!((this._indexContext3D == stage3DProxy.context3D))) || (this._indexBufferDirty))){
                this._indexBuffer = stage3DProxy._context3D.createIndexBuffer(this._numIndices);
                this._indexBuffer.uploadFromVector(this._indices, 0, this._numIndices);
                this._indexBufferDirty = false;
                this._indexContext3D = stage3DProxy.context3D;
            };
            return (this._indexBuffer);
        }
        public function getVertexBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            if (this._numVertices == 0){
                this.addSegment(new Vector3D(0, 0, 0), new Vector3D(0, 0, 0));
            };
            if (((!((this._vertexContext3D == stage3DProxy.context3D))) || (this._vertexBufferDirty))){
                this._vertexBuffer = stage3DProxy._context3D.createVertexBuffer(this._numVertices, this.VERTEX_BUFFER_LENGTH);
                this._vertexBuffer.uploadFromVector(this._vertices, 0, this._numVertices);
                this._vertexBufferDirty = false;
                this._vertexContext3D = stage3DProxy.context3D;
            };
            return (this._vertexBuffer);
        }
        override public function dispose():void{
            super.dispose();
            if (this._vertexBuffer){
                this._vertexBuffer.dispose();
            };
            if (this._indexBuffer){
                this._indexBuffer.dispose();
            };
        }
        public function getUVBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (null);
        }
        public function getVertexNormalBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (null);
        }
        public function getVertexTangentBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (null);
        }
        override public function get mouseEnabled():Boolean{
            return (false);
        }
        public function get numTriangles2():uint{
            return (0);
        }
        public function get numTriangles():uint{
            return ((this._numIndices / 3));
        }
        public function get sourceEntity():Entity{
            return (this);
        }
        public function get castsShadows():Boolean{
            return (false);
        }
        public function get material():MaterialBase{
            return (this._material);
        }
        public function get animator():IAnimator{
            return (this._animator);
        }
        public function set material(value:MaterialBase):void{
            if (value == this._material){
                return;
            };
            if (this._material){
                this._material.removeOwner(this);
            };
            this._material = value;
            if (this._material){
                this._material.addOwner(this);
            };
        }
        override protected function getDefaultBoundingVolume():BoundingVolumeBase{
            return (new BoundingSphere());
        }
        override protected function updateBounds():void{
            _bounds.fromExtremes(-10000, -10000, 0, 10000, 10000, 0);
            _boundsInvalid = false;
        }
        override protected function createEntityPartitionNode():EntityNode{
            return (new RenderableNode(this));
        }
        public function get uvTransform():Matrix{
            return (null);
        }
        public function getSecondaryUVBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (null);
        }
        public function get vertexData():Vector.<Number>{
            return (this._vertices);
        }
        public function get indexData():Vector.<uint>{
            return (this._indices);
        }
        public function get UVData():Vector.<Number>{
            return (null);
        }
        public function getCustomBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (null);
        }
        public function get vertexBufferOffset():int{
            return (0);
        }
        public function get normalBufferOffset():int{
            return (0);
        }
        public function get tangentBufferOffset():int{
            return (0);
        }
        public function get UVBufferOffset():int{
            return (0);
        }
        public function get secondaryUVBufferOffset():int{
            return (0);
        }
        public function get startColor():int{
            return (this._startColor);
        }
        public function set startColor(value:int):void{
            this._startColor = value;
            this.sr = (((value >> 16) & 0xFF) / 0xFF);
            this.sg = (((value >> 8) & 0xFF) / 0xFF);
            this.sb = ((value & 0xFF) / 0xFF);
        }
        public function get thickness():Number{
            return (this._thickness);
        }
        public function set thickness(value:Number):void{
            this._thickness = value;
        }

    }
}//package wd.d3.geom.segments 
