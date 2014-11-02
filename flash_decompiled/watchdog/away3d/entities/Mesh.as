package away3d.entities {
    import away3d.containers.*;
    import away3d.core.base.*;
    import away3d.core.partition.*;
    import away3d.events.*;
    import away3d.library.assets.*;
    import away3d.materials.*;
    import __AS3__.vec.*;
    import away3d.materials.utils.*;
    import away3d.animators.*;

    public class Mesh extends Entity implements IMaterialOwner, IAsset {

        private var _subMeshes:Vector.<SubMesh>;
        protected var _geometry:Geometry;
        private var _material:MaterialBase;
        private var _animator:IAnimator;
        private var _castsShadows:Boolean = true;

        public function Mesh(geometry:Geometry, material:MaterialBase=null){
            super();
            this._subMeshes = new Vector.<SubMesh>();
            this.geometry = geometry;
            this.material = ((material) || (DefaultMaterialManager.getDefaultMaterial(this)));
        }
        public function bakeTransformations():void{
            this.geometry.applyTransformation(transform);
            transform.identity();
        }
        override public function get assetType():String{
            return (AssetType.MESH);
        }
        private function onGeometryBoundsInvalid(event:GeometryEvent):void{
            invalidateBounds();
        }
        public function get castsShadows():Boolean{
            return (this._castsShadows);
        }
        public function set castsShadows(value:Boolean):void{
            this._castsShadows = value;
        }
        public function get animator():IAnimator{
            return (this._animator);
        }
        public function set animator(value:IAnimator):void{
            var subMesh:SubMesh;
            if (this._animator){
                this._animator.removeOwner(this);
            };
            this._animator = value;
            var oldMaterial:MaterialBase = this.material;
            this.material = null;
            this.material = oldMaterial;
            var len:uint = this._subMeshes.length;
            var i:int;
            while (i < len) {
                subMesh = this._subMeshes[i];
                oldMaterial = subMesh._material;
                if (oldMaterial){
                    subMesh.material = null;
                    subMesh.material = oldMaterial;
                };
                i++;
            };
            if (this._animator){
                this._animator.addOwner(this);
            };
        }
        public function get geometry():Geometry{
            return (this._geometry);
        }
        public function set geometry(value:Geometry):void{
            var i:uint;
            var subGeoms:Vector.<SubGeometry>;
            if (this._geometry){
                this._geometry.removeEventListener(GeometryEvent.BOUNDS_INVALID, this.onGeometryBoundsInvalid);
                this._geometry.removeEventListener(GeometryEvent.SUB_GEOMETRY_ADDED, this.onSubGeometryAdded);
                this._geometry.removeEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED, this.onSubGeometryRemoved);
                i = 0;
                while (i < this._subMeshes.length) {
                    this._subMeshes[i].dispose();
                    i++;
                };
                this._subMeshes.length = 0;
            };
            this._geometry = value;
            if (this._geometry){
                this._geometry.addEventListener(GeometryEvent.BOUNDS_INVALID, this.onGeometryBoundsInvalid);
                this._geometry.addEventListener(GeometryEvent.SUB_GEOMETRY_ADDED, this.onSubGeometryAdded);
                this._geometry.addEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED, this.onSubGeometryRemoved);
                subGeoms = this._geometry.subGeometries;
                i = 0;
                while (i < subGeoms.length) {
                    this.addSubMesh(subGeoms[i]);
                    i++;
                };
            };
            if (this._material){
                this._material.removeOwner(this);
                this._material.addOwner(this);
            };
        }
        public function get material():MaterialBase{
            return (this._material);
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
        public function get subMeshes():Vector.<SubMesh>{
            this._geometry.validate();
            return (this._subMeshes);
        }
        override public function dispose():void{
            super.dispose();
            this.material = null;
            this.geometry = null;
        }
        override public function clone():Object3D{
            var clone:Mesh = new Mesh(this.geometry, this._material);
            clone.transform = transform;
            clone.pivotPoint = pivotPoint;
            clone.partition = partition;
            clone.bounds = _bounds.clone();
            clone.name = name;
            clone.castsShadows = this.castsShadows;
            var len:int = this._subMeshes.length;
            var i:int;
            while (i < len) {
                clone._subMeshes[i]._material = this._subMeshes[i]._material;
                i++;
            };
            len = numChildren;
            i = 0;
            while (i < len) {
                clone.addChild(ObjectContainer3D(getChildAt(i).clone()));
                i++;
            };
            return (clone);
        }
        override protected function updateBounds():void{
            _bounds.fromGeometry(this._geometry);
            _boundsInvalid = false;
        }
        override protected function createEntityPartitionNode():EntityNode{
            return (new MeshNode(this));
        }
        private function onSubGeometryAdded(event:GeometryEvent):void{
            this.addSubMesh(event.subGeometry);
        }
        private function onSubGeometryRemoved(event:GeometryEvent):void{
            var subMesh:SubMesh;
            var i:uint;
            var subGeom:SubGeometry = event.subGeometry;
            var len:int = this._subMeshes.length;
            i = 0;
            while (i < len) {
                subMesh = this._subMeshes[i];
                if (subMesh.subGeometry == subGeom){
                    subMesh.dispose();
                    this._subMeshes.splice(i, 1);
                    break;
                };
                i++;
            };
            len--;
            while (i < len) {
                this._subMeshes[i]._index = i;
                i++;
            };
        }
        private function addSubMesh(subGeometry:SubGeometry):void{
            var subMesh:SubMesh = new SubMesh(subGeometry, this, null);
            var len:uint = this._subMeshes.length;
            subMesh._index = len;
            this._subMeshes[len] = subMesh;
            invalidateBounds();
        }
        public function getSubMeshForSubGeometry(subGeometry:SubGeometry):SubMesh{
            return (this._subMeshes[this._geometry.subGeometries.indexOf(subGeometry)]);
        }
        override function collidesBefore(shortestCollisionDistance:Number, findClosest:Boolean):Boolean{
            var subMesh:SubMesh;
            _pickingCollider.setLocalRay(_pickingCollisionVO.localRayPosition, _pickingCollisionVO.localRayDirection);
            _pickingCollisionVO.renderable = null;
            var len:int = this._subMeshes.length;
            var i:int;
            while (i < len) {
                subMesh = this._subMeshes[i];
                if (_pickingCollider.testSubMeshCollision(subMesh, _pickingCollisionVO, shortestCollisionDistance)){
                    shortestCollisionDistance = _pickingCollisionVO.rayEntryDistance;
                    _pickingCollisionVO.renderable = subMesh;
                    if (!(findClosest)){
                        return (true);
                    };
                };
                i++;
            };
            return (!((_pickingCollisionVO.renderable == null)));
        }

    }
}//package away3d.entities 
