package away3d.entities {
    import __AS3__.vec.*;
    import away3d.primitives.data.*;
    import away3d.materials.*;
    import flash.geom.*;
    import flash.display3D.*;
    import away3d.core.managers.*;
    import away3d.primitives.*;
    import away3d.animators.*;
    import away3d.bounds.*;
    import away3d.core.partition.*;
    import away3d.core.base.*;

    public class SegmentSet extends Entity implements IRenderable {

        public var _segments:Vector.<Segment>;
        private var _material:MaterialBase;
        private var _vertices:Vector.<Number>;
        private var _animator:IAnimator;
        private var _numVertices:uint;
        private var _indices:Vector.<uint>;
        private var _numIndices:uint;
        private var _vertexBufferDirty:Boolean;
        private var _indexBufferDirty:Boolean;
        private var _vertexContext3D:Context3D;
        private var _indexContext3D:Context3D;
        private var _vertexBuffer:VertexBuffer3D;
        private var _indexBuffer:IndexBuffer3D;
        private var _lineCount:uint;

        public function SegmentSet(){
            super();
            this._vertices = new Vector.<Number>();
            this._segments = new Vector.<Segment>();
            this._numVertices = 0;
            this._indices = new Vector.<uint>();
            this.material = new SegmentMaterial();
        }
        public function addSegment(segment:Segment):void{
            segment.index = this._vertices.length;
            segment.segmentsBase = this;
            this._segments.push(segment);
            this.updateSegment(segment);
            var index:uint = (this._lineCount << 2);
            this._indices.push(index, (index + 1), (index + 2), (index + 3), (index + 2), (index + 1));
            this._numVertices = (this._vertices.length / 11);
            this._numIndices = this._indices.length;
            this._vertexBufferDirty = true;
            this._indexBufferDirty = true;
            this._lineCount++;
        }
        function updateSegment(segment:Segment):void{
            var start:Vector3D = segment._start;
            var end:Vector3D = segment._end;
            var startX:Number = start.x;
            var startY:Number = start.y;
            var startZ:Number = start.z;
            var endX:Number = end.x;
            var endY:Number = end.y;
            var endZ:Number = end.z;
            var startR:Number = segment._startR;
            var startG:Number = segment._startG;
            var startB:Number = segment._startB;
            var endR:Number = segment._endR;
            var endG:Number = segment._endG;
            var endB:Number = segment._endB;
            var index:uint = segment.index;
            var t:Number = segment.thickness;
            var _temp1 = index;
            index = (index + 1);
            var _local18 = _temp1;
            this._vertices[_local18] = startX;
            var _temp2 = index;
            index = (index + 1);
            var _local19 = _temp2;
            this._vertices[_local19] = startY;
            var _temp3 = index;
            index = (index + 1);
            var _local20 = _temp3;
            this._vertices[_local20] = startZ;
            var _temp4 = index;
            index = (index + 1);
            var _local21 = _temp4;
            this._vertices[_local21] = endX;
            var _temp5 = index;
            index = (index + 1);
            var _local22 = _temp5;
            this._vertices[_local22] = endY;
            var _temp6 = index;
            index = (index + 1);
            var _local23 = _temp6;
            this._vertices[_local23] = endZ;
            var _temp7 = index;
            index = (index + 1);
            var _local24 = _temp7;
            this._vertices[_local24] = t;
            var _temp8 = index;
            index = (index + 1);
            var _local25 = _temp8;
            this._vertices[_local25] = startR;
            var _temp9 = index;
            index = (index + 1);
            var _local26 = _temp9;
            this._vertices[_local26] = startG;
            var _temp10 = index;
            index = (index + 1);
            var _local27 = _temp10;
            this._vertices[_local27] = startB;
            var _temp11 = index;
            index = (index + 1);
            var _local28 = _temp11;
            this._vertices[_local28] = 1;
            var _temp12 = index;
            index = (index + 1);
            var _local29 = _temp12;
            this._vertices[_local29] = endX;
            var _temp13 = index;
            index = (index + 1);
            var _local30 = _temp13;
            this._vertices[_local30] = endY;
            var _temp14 = index;
            index = (index + 1);
            var _local31 = _temp14;
            this._vertices[_local31] = endZ;
            var _temp15 = index;
            index = (index + 1);
            var _local32 = _temp15;
            this._vertices[_local32] = startX;
            var _temp16 = index;
            index = (index + 1);
            var _local33 = _temp16;
            this._vertices[_local33] = startY;
            var _temp17 = index;
            index = (index + 1);
            var _local34 = _temp17;
            this._vertices[_local34] = startZ;
            var _temp18 = index;
            index = (index + 1);
            var _local35 = _temp18;
            this._vertices[_local35] = -(t);
            var _temp19 = index;
            index = (index + 1);
            var _local36 = _temp19;
            this._vertices[_local36] = endR;
            var _temp20 = index;
            index = (index + 1);
            var _local37 = _temp20;
            this._vertices[_local37] = endG;
            var _temp21 = index;
            index = (index + 1);
            var _local38 = _temp21;
            this._vertices[_local38] = endB;
            var _temp22 = index;
            index = (index + 1);
            var _local39 = _temp22;
            this._vertices[_local39] = 1;
            var _temp23 = index;
            index = (index + 1);
            var _local40 = _temp23;
            this._vertices[_local40] = startX;
            var _temp24 = index;
            index = (index + 1);
            var _local41 = _temp24;
            this._vertices[_local41] = startY;
            var _temp25 = index;
            index = (index + 1);
            var _local42 = _temp25;
            this._vertices[_local42] = startZ;
            var _temp26 = index;
            index = (index + 1);
            var _local43 = _temp26;
            this._vertices[_local43] = endX;
            var _temp27 = index;
            index = (index + 1);
            var _local44 = _temp27;
            this._vertices[_local44] = endY;
            var _temp28 = index;
            index = (index + 1);
            var _local45 = _temp28;
            this._vertices[_local45] = endZ;
            var _temp29 = index;
            index = (index + 1);
            var _local46 = _temp29;
            this._vertices[_local46] = -(t);
            var _temp30 = index;
            index = (index + 1);
            var _local47 = _temp30;
            this._vertices[_local47] = startR;
            var _temp31 = index;
            index = (index + 1);
            var _local48 = _temp31;
            this._vertices[_local48] = startG;
            var _temp32 = index;
            index = (index + 1);
            var _local49 = _temp32;
            this._vertices[_local49] = startB;
            var _temp33 = index;
            index = (index + 1);
            var _local50 = _temp33;
            this._vertices[_local50] = 1;
            var _temp34 = index;
            index = (index + 1);
            var _local51 = _temp34;
            this._vertices[_local51] = endX;
            var _temp35 = index;
            index = (index + 1);
            var _local52 = _temp35;
            this._vertices[_local52] = endY;
            var _temp36 = index;
            index = (index + 1);
            var _local53 = _temp36;
            this._vertices[_local53] = endZ;
            var _temp37 = index;
            index = (index + 1);
            var _local54 = _temp37;
            this._vertices[_local54] = startX;
            var _temp38 = index;
            index = (index + 1);
            var _local55 = _temp38;
            this._vertices[_local55] = startY;
            var _temp39 = index;
            index = (index + 1);
            var _local56 = _temp39;
            this._vertices[_local56] = startZ;
            var _temp40 = index;
            index = (index + 1);
            var _local57 = _temp40;
            this._vertices[_local57] = t;
            var _temp41 = index;
            index = (index + 1);
            var _local58 = _temp41;
            this._vertices[_local58] = endR;
            var _temp42 = index;
            index = (index + 1);
            var _local59 = _temp42;
            this._vertices[_local59] = endG;
            var _temp43 = index;
            index = (index + 1);
            var _local60 = _temp43;
            this._vertices[_local60] = endB;
            var _temp44 = index;
            index = (index + 1);
            var _local61 = _temp44;
            this._vertices[_local61] = 1;
            this._vertexBufferDirty = true;
        }
        private function removeSegmentByIndex(index:uint):void{
            var indVert:uint = (this._indices[index] * 11);
            this._indices.splice(index, 6);
            this._vertices.splice(indVert, 44);
            this._numVertices = (this._vertices.length / 11);
            this._numIndices = this._indices.length;
            this._vertexBufferDirty = true;
            this._indexBufferDirty = true;
        }
        public function removeSegment(segment:Segment):void{
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
        public function getSegment(index:uint):Segment{
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
        public function get numTriangles2():uint{
            return (0);
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
                this.addSegment(new LineSegment(new Vector3D(0, 0, 0), new Vector3D(0, 0, 0)));
            };
            if (((!((this._vertexContext3D == stage3DProxy.context3D))) || (this._vertexBufferDirty))){
                this._vertexBuffer = stage3DProxy._context3D.createVertexBuffer(this._numVertices, 11);
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

    }
}//package away3d.entities 
