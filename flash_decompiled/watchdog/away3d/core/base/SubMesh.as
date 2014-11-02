package away3d.core.base {
    import away3d.entities.*;
    import away3d.materials.*;
    import flash.geom.*;
    import flash.display3D.*;
    import away3d.core.managers.*;
    import away3d.animators.*;
    import __AS3__.vec.*;
    import away3d.bounds.*;

    public class SubMesh implements IRenderable {

        var _material:MaterialBase;
        private var _parentMesh:Mesh;
        private var _subGeometry:SubGeometry;
        var _index:uint;
        private var _uvTransform:Matrix;
        private var _uvTransformDirty:Boolean;
        private var _uvRotation:Number = 0;
        private var _scaleU:Number = 1;
        private var _scaleV:Number = 1;
        private var _offsetU:Number = 0;
        private var _offsetV:Number = 0;

        public function SubMesh(subGeometry:SubGeometry, parentMesh:Mesh, material:MaterialBase=null){
            super();
            this._parentMesh = parentMesh;
            this._subGeometry = subGeometry;
            this.material = material;
        }
        public function get shaderPickingDetails():Boolean{
            return (this.sourceEntity.shaderPickingDetails);
        }
        public function get offsetU():Number{
            return (this._offsetU);
        }
        public function set offsetU(value:Number):void{
            if (value == this._offsetU){
                return;
            };
            this._offsetU = value;
            this._uvTransformDirty = true;
        }
        public function get offsetV():Number{
            return (this._offsetV);
        }
        public function set offsetV(value:Number):void{
            if (value == this._offsetV){
                return;
            };
            this._offsetV = value;
            this._uvTransformDirty = true;
        }
        public function get scaleU():Number{
            return (this._scaleU);
        }
        public function set scaleU(value:Number):void{
            if (value == this._scaleU){
                return;
            };
            this._scaleU = value;
            this._uvTransformDirty = true;
        }
        public function get scaleV():Number{
            return (this._scaleV);
        }
        public function set scaleV(value:Number):void{
            if (value == this._scaleV){
                return;
            };
            this._scaleV = value;
            this._uvTransformDirty = true;
        }
        public function get uvRotation():Number{
            return (this._uvRotation);
        }
        public function set uvRotation(value:Number):void{
            if (value == this._uvRotation){
                return;
            };
            this._uvRotation = value;
            this._uvTransformDirty = true;
        }
        public function get sourceEntity():Entity{
            return (this._parentMesh);
        }
        public function get subGeometry():SubGeometry{
            return (this._subGeometry);
        }
        public function set subGeometry(value:SubGeometry):void{
            this._subGeometry = value;
        }
        public function get material():MaterialBase{
            return (((this._material) || (this._parentMesh.material)));
        }
        public function set material(value:MaterialBase):void{
            if (this._material){
                this._material.removeOwner(this);
            };
            this._material = value;
            if (this._material){
                this._material.addOwner(this);
            };
        }
        public function get zIndex():Number{
            return (this._parentMesh.zIndex);
        }
        public function get sceneTransform():Matrix3D{
            return (this._parentMesh.sceneTransform);
        }
        public function get inverseSceneTransform():Matrix3D{
            return (this._parentMesh.inverseSceneTransform);
        }
        public function getVertexBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (this._subGeometry.getVertexBuffer(stage3DProxy));
        }
        public function getVertexNormalBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (this._subGeometry.getVertexNormalBuffer(stage3DProxy));
        }
        public function getVertexTangentBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (this._subGeometry.getVertexTangentBuffer(stage3DProxy));
        }
        public function getUVBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (this._subGeometry.getUVBuffer(stage3DProxy));
        }
        public function getIndexBuffer(stage3DProxy:Stage3DProxy):IndexBuffer3D{
            return (this._subGeometry.getIndexBuffer(stage3DProxy));
        }
        public function getIndexBuffer2(stage3DProxy:Stage3DProxy):IndexBuffer3D{
            return (this._subGeometry.getIndexBuffer2(stage3DProxy));
        }
        public function get modelViewProjection():Matrix3D{
            return (this._parentMesh.modelViewProjection);
        }
        public function getModelViewProjectionUnsafe():Matrix3D{
            return (this._parentMesh.getModelViewProjectionUnsafe());
        }
        public function get numTriangles():uint{
            return (this._subGeometry.numTriangles);
        }
        public function get numTriangles2():uint{
            return (this._subGeometry.numTriangles2);
        }
        public function get animator():IAnimator{
            return (this._parentMesh.animator);
        }
        public function get mouseEnabled():Boolean{
            return (((this._parentMesh.mouseEnabled) || (this._parentMesh._ancestorsAllowMouseEnabled)));
        }
        public function get castsShadows():Boolean{
            return (this._parentMesh.castsShadows);
        }
        function get parentMesh():Mesh{
            return (this._parentMesh);
        }
        function set parentMesh(value:Mesh):void{
            this._parentMesh = value;
        }
        public function get uvTransform():Matrix{
            if (this._uvTransformDirty){
                this.updateUVTransform();
            };
            return (this._uvTransform);
        }
        private function updateUVTransform():void{
            this._uvTransform = ((this._uvTransform) || (new Matrix()));
            this._uvTransform.identity();
            if (this._uvRotation != 0){
                this._uvTransform.rotate(this._uvRotation);
            };
            if (((!((this._scaleU == 1))) || (!((this._scaleV == 1))))){
                this._uvTransform.scale(this._scaleU, this._scaleV);
            };
            this._uvTransform.translate(this._offsetU, this._offsetV);
            this._uvTransformDirty = false;
        }
        public function getSecondaryUVBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (this._subGeometry.getSecondaryUVBuffer(stage3DProxy));
        }
        public function getCustomBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D{
            return (this._subGeometry.getCustomBuffer(stage3DProxy));
        }
        public function dispose():void{
            this.material = null;
        }
        public function get vertexBufferOffset():int{
            return (this._subGeometry.vertexBufferOffset);
        }
        public function get normalBufferOffset():int{
            return (this._subGeometry.normalBufferOffset);
        }
        public function get tangentBufferOffset():int{
            return (this._subGeometry.tangentBufferOffset);
        }
        public function get UVBufferOffset():int{
            return (this._subGeometry.UVBufferOffset);
        }
        public function get secondaryUVBufferOffset():int{
            return (this._subGeometry.secondaryUVBufferOffset);
        }
        public function get vertexData():Vector.<Number>{
            return (this._subGeometry.vertexData);
        }
        public function get indexData():Vector.<uint>{
            return (this._subGeometry.indexData);
        }
        public function get UVData():Vector.<Number>{
            return (this._subGeometry.UVData);
        }
        public function get bounds():BoundingVolumeBase{
            return (this._parentMesh.bounds);
        }
        public function get visible():Boolean{
            return (this._parentMesh.visible);
        }

    }
}//package away3d.core.base 
