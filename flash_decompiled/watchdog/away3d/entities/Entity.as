package away3d.entities {
    import away3d.core.pick.*;
    import away3d.bounds.*;
    import away3d.core.partition.*;
    import away3d.containers.*;
    import away3d.library.assets.*;
    import away3d.cameras.*;
    import away3d.errors.*;
    import flash.geom.*;
    import __AS3__.vec.*;

    public class Entity extends ObjectContainer3D {

        private var _showBounds:Boolean;
        private var _partitionNode:EntityNode;
        private var _boundsIsShown:Boolean = false;
        private var _shaderPickingDetails:Boolean;
        var _pickingCollisionVO:PickingCollisionVO;
        var _pickingCollider:IPickingCollider;
        protected var _mvpTransformStack:Vector.<Matrix3D>;
        protected var _zIndices:Vector.<Number>;
        protected var _mvpIndex:int = -1;
        protected var _stackLen:uint;
        protected var _bounds:BoundingVolumeBase;
        protected var _boundsInvalid:Boolean = true;

        public function Entity(){
            this._mvpTransformStack = new Vector.<Matrix3D>();
            this._zIndices = new Vector.<Number>();
            super();
            this._bounds = this.getDefaultBoundingVolume();
        }
        public function get shaderPickingDetails():Boolean{
            return (this._shaderPickingDetails);
        }
        public function set shaderPickingDetails(value:Boolean):void{
            this._shaderPickingDetails = value;
        }
        public function get pickingCollisionVO():PickingCollisionVO{
            if (!(this._pickingCollisionVO)){
                this._pickingCollisionVO = new PickingCollisionVO(this);
            };
            return (this._pickingCollisionVO);
        }
        function collidesBefore(shortestCollisionDistance:Number, findClosest:Boolean):Boolean{
            return (true);
        }
        public function get showBounds():Boolean{
            return (this._showBounds);
        }
        public function set showBounds(value:Boolean):void{
            if (value == this._showBounds){
                return;
            };
            this._showBounds = value;
            if (this._showBounds){
                this.addBounds();
            } else {
                this.removeBounds();
            };
        }
        override public function get minX():Number{
            if (this._boundsInvalid){
                this.updateBounds();
            };
            return (this._bounds.min.x);
        }
        override public function get minY():Number{
            if (this._boundsInvalid){
                this.updateBounds();
            };
            return (this._bounds.min.y);
        }
        override public function get minZ():Number{
            if (this._boundsInvalid){
                this.updateBounds();
            };
            return (this._bounds.min.z);
        }
        override public function get maxX():Number{
            if (this._boundsInvalid){
                this.updateBounds();
            };
            return (this._bounds.max.x);
        }
        override public function get maxY():Number{
            if (this._boundsInvalid){
                this.updateBounds();
            };
            return (this._bounds.max.y);
        }
        override public function get maxZ():Number{
            if (this._boundsInvalid){
                this.updateBounds();
            };
            return (this._bounds.max.z);
        }
        public function get bounds():BoundingVolumeBase{
            if (this._boundsInvalid){
                this.updateBounds();
            };
            return (this._bounds);
        }
        public function set bounds(value:BoundingVolumeBase):void{
            this.removeBounds();
            this._bounds = value;
            this._boundsInvalid = true;
            if (this._showBounds){
                this.addBounds();
            };
        }
        override function set implicitPartition(value:Partition3D):void{
            if (value == _implicitPartition){
                return;
            };
            if (_implicitPartition){
                this.notifyPartitionUnassigned();
            };
            super.implicitPartition = value;
            this.notifyPartitionAssigned();
        }
        override public function set scene(value:Scene3D):void{
            if (value == _scene){
                return;
            };
            if (_scene){
                _scene.unregisterEntity(this);
            };
            if (value){
                value.registerEntity(this);
            };
            super.scene = value;
        }
        override public function get assetType():String{
            return (AssetType.ENTITY);
        }
        public function get modelViewProjection():Matrix3D{
            return (this._mvpTransformStack[uint((uint((this._mvpIndex > 0)) * this._mvpIndex))]);
        }
        public function get zIndex():Number{
            return (this._zIndices[this._mvpIndex]);
        }
        public function get pickingCollider():IPickingCollider{
            return (this._pickingCollider);
        }
        public function set pickingCollider(value:IPickingCollider):void{
            this._pickingCollider = value;
        }
        public function pushModelViewProjection(camera:Camera3D):void{
            if (++this._mvpIndex == this._stackLen){
                this._mvpTransformStack[this._mvpIndex] = new Matrix3D();
                this._stackLen++;
            };
            var mvp:Matrix3D = this._mvpTransformStack[this._mvpIndex];
            mvp.copyFrom(sceneTransform);
            mvp.append(camera.viewProjection);
            mvp.copyColumnTo(3, _pos);
            this._zIndices[this._mvpIndex] = -(_pos.z);
        }
        public function getModelViewProjectionUnsafe():Matrix3D{
            return (this._mvpTransformStack[this._mvpIndex]);
        }
        public function popModelViewProjection():void{
            this._mvpIndex--;
        }
        public function getEntityPartitionNode():EntityNode{
            return ((this._partitionNode = ((this._partitionNode) || (this.createEntityPartitionNode()))));
        }
        protected function createEntityPartitionNode():EntityNode{
            throw (new AbstractMethodError());
        }
        protected function getDefaultBoundingVolume():BoundingVolumeBase{
            return (new AxisAlignedBoundingBox());
        }
        protected function updateBounds():void{
            throw (new AbstractMethodError());
        }
        override protected function invalidateSceneTransform():void{
            super.invalidateSceneTransform();
            this.notifySceneBoundsInvalid();
        }
        protected function invalidateBounds():void{
            this._boundsInvalid = true;
            this.notifySceneBoundsInvalid();
        }
        override protected function updateMouseChildren():void{
            var collider:IPickingCollider;
            if (((_parent) && (!(this.pickingCollider)))){
                if ((_parent is Entity)){
                    collider = Entity(_parent).pickingCollider;
                    if (collider){
                        this.pickingCollider = collider;
                    };
                };
            };
            super.updateMouseChildren();
        }
        private function notifySceneBoundsInvalid():void{
            if (_scene){
                _scene.invalidateEntityBounds(this);
            };
        }
        private function notifyPartitionAssigned():void{
            if (_scene){
                _scene.registerPartition(this);
            };
        }
        private function notifyPartitionUnassigned():void{
            if (_scene){
                _scene.unregisterPartition(this);
            };
        }
        private function addBounds():void{
            if (!(this._boundsIsShown)){
                this._boundsIsShown = true;
                addChild(this._bounds.boundingRenderable);
            };
        }
        private function removeBounds():void{
            if (this._boundsIsShown){
                this._boundsIsShown = false;
                removeChild(this._bounds.boundingRenderable);
                this._bounds.disposeRenderable();
            };
        }
        function internalUpdate():void{
            if (_controller){
                _controller.update();
            };
        }

    }
}//package away3d.entities 
