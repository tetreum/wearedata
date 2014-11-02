package away3d.core.traverse {
    import __AS3__.vec.*;
    import away3d.lights.*;
    import away3d.core.data.*;
    import away3d.cameras.*;
    import away3d.core.base.*;
    import away3d.core.partition.*;
    import away3d.materials.*;
    import away3d.entities.*;

    public class EntityCollector extends PartitionTraverser {

        protected var _skyBox:IRenderable;
        protected var _opaqueRenderableHead:RenderableListItem;
        protected var _blendedRenderableHead:RenderableListItem;
        private var _entityHead:EntityListItem;
        protected var _renderableListItemPool:RenderableListItemPool;
        protected var _entityListItemPool:EntityListItemPool;
        protected var _lights:Vector.<LightBase>;
        private var _directionalLights:Vector.<DirectionalLight>;
        private var _pointLights:Vector.<PointLight>;
        private var _lightProbes:Vector.<LightProbe>;
        protected var _numEntities:uint;
        protected var _numOpaques:uint;
        protected var _numBlended:uint;
        protected var _numLights:uint;
        protected var _numTriangles:uint;
        protected var _numMouseEnableds:uint;
        protected var _camera:Camera3D;
        private var _numDirectionalLights:uint;
        private var _numPointLights:uint;
        private var _numLightProbes:uint;

        public function EntityCollector(){
            super();
            this.init();
        }
        private function init():void{
            this._lights = new Vector.<LightBase>();
            this._directionalLights = new Vector.<DirectionalLight>();
            this._pointLights = new Vector.<PointLight>();
            this._lightProbes = new Vector.<LightProbe>();
            this._renderableListItemPool = new RenderableListItemPool();
            this._entityListItemPool = new EntityListItemPool();
        }
        public function get numOpaques():uint{
            return (this._numOpaques);
        }
        public function get numBlended():uint{
            return (this._numBlended);
        }
        public function get camera():Camera3D{
            return (this._camera);
        }
        public function set camera(value:Camera3D):void{
            this._camera = value;
            _entryPoint = this._camera.scenePosition;
        }
        public function get numMouseEnableds():uint{
            return (this._numMouseEnableds);
        }
        public function get skyBox():IRenderable{
            return (this._skyBox);
        }
        public function get opaqueRenderableHead():RenderableListItem{
            return (this._opaqueRenderableHead);
        }
        public function set opaqueRenderableHead(value:RenderableListItem):void{
            this._opaqueRenderableHead = value;
        }
        public function get blendedRenderableHead():RenderableListItem{
            return (this._blendedRenderableHead);
        }
        public function set blendedRenderableHead(value:RenderableListItem):void{
            this._blendedRenderableHead = value;
        }
        public function get entityHead():EntityListItem{
            return (this._entityHead);
        }
        public function get lights():Vector.<LightBase>{
            return (this._lights);
        }
        public function get directionalLights():Vector.<DirectionalLight>{
            return (this._directionalLights);
        }
        public function get pointLights():Vector.<PointLight>{
            return (this._pointLights);
        }
        public function get lightProbes():Vector.<LightProbe>{
            return (this._lightProbes);
        }
        public function clear():void{
            this._numTriangles = (this._numMouseEnableds = 0);
            this._blendedRenderableHead = null;
            this._opaqueRenderableHead = null;
            this._entityHead = null;
            this._renderableListItemPool.freeAll();
            this._entityListItemPool.freeAll();
            this._skyBox = null;
            if (this._numLights > 0){
                this._lights.length = (this._numLights = 0);
            };
            if (this._numDirectionalLights > 0){
                this._directionalLights.length = (this._numDirectionalLights = 0);
            };
            if (this._numPointLights > 0){
                this._pointLights.length = (this._numPointLights = 0);
            };
            if (this._numLightProbes > 0){
                this._lightProbes.length = (this._numLightProbes = 0);
            };
        }
        override public function enterNode(node:NodeBase):Boolean{
            return (node.isInFrustum(this._camera));
        }
        override public function applySkyBox(renderable:IRenderable):void{
            this._skyBox = renderable;
        }
        override public function applyRenderable(renderable:IRenderable):void{
            var material:MaterialBase;
            var item:RenderableListItem;
            if (renderable.mouseEnabled){
                this._numMouseEnableds++;
            };
            this._numTriangles = (this._numTriangles + renderable.numTriangles);
            material = renderable.material;
            if (material){
                item = this._renderableListItemPool.getItem();
                item.renderable = renderable;
                item.materialId = material._uniqueId;
                item.renderOrderId = material._renderOrderId;
                item.zIndex = renderable.zIndex;
                if (material.requiresBlending){
                    item.next = this._blendedRenderableHead;
                    this._blendedRenderableHead = item;
                    this._numBlended++;
                } else {
                    item.next = this._opaqueRenderableHead;
                    this._opaqueRenderableHead = item;
                    this._numOpaques++;
                };
            };
        }
        override public function applyEntity(entity:Entity):void{
            this._numEntities++;
            var item:EntityListItem = this._entityListItemPool.getItem();
            item.entity = entity;
            item.next = this._entityHead;
            this._entityHead = item;
        }
        override public function applyUnknownLight(light:LightBase):void{
            var _local2 = this._numLights++;
            this._lights[_local2] = light;
        }
        override public function applyDirectionalLight(light:DirectionalLight):void{
            var _local2 = this._numLights++;
            this._lights[_local2] = light;
            var _local3 = this._numDirectionalLights++;
            this._directionalLights[_local3] = light;
        }
        override public function applyPointLight(light:PointLight):void{
            var _local2 = this._numLights++;
            this._lights[_local2] = light;
            var _local3 = this._numPointLights++;
            this._pointLights[_local3] = light;
        }
        override public function applyLightProbe(light:LightProbe):void{
            var _local2 = this._numLights++;
            this._lights[_local2] = light;
            var _local3 = this._numLightProbes++;
            this._lightProbes[_local3] = light;
        }
        public function get numTriangles():uint{
            return (this._numTriangles);
        }
        public function cleanUp():void{
            var node:EntityListItem = this._entityHead;
            while (node) {
                node.entity.popModelViewProjection();
                node = node.next;
            };
        }

    }
}//package away3d.core.traverse 
