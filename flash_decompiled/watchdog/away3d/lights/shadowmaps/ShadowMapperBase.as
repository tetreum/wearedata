package away3d.lights.shadowmaps {
    import away3d.core.traverse.*;
    import away3d.textures.*;
    import away3d.lights.*;
    import away3d.core.managers.*;
    import away3d.core.render.*;
    import away3d.errors.*;
    import away3d.cameras.*;
    import flash.display3D.textures.*;
    import away3d.containers.*;

    public class ShadowMapperBase {

        protected var _casterCollector:ShadowCasterCollector;
        private var _depthMap:TextureProxyBase;
        protected var _depthMapSize:uint = 0x0800;
        protected var _light:LightBase;
        private var _explicitDepthMap:Boolean;

        public function ShadowMapperBase(){
            super();
            this._casterCollector = new ShadowCasterCollector();
        }
        function setDepthMap(depthMap:TextureProxyBase):void{
            if (this._depthMap == depthMap){
                return;
            };
            if (((this._depthMap) && (!(this._explicitDepthMap)))){
                this._depthMap.dispose();
            };
            this._depthMap = depthMap;
            this._explicitDepthMap = ((depthMap) ? true : false);
        }
        public function get light():LightBase{
            return (this._light);
        }
        public function set light(value:LightBase):void{
            this._light = value;
        }
        public function get depthMap():TextureProxyBase{
            return ((this._depthMap = ((this._depthMap) || (this.createDepthTexture()))));
        }
        public function get depthMapSize():uint{
            return (this._depthMapSize);
        }
        public function set depthMapSize(value:uint):void{
            if (value == this._depthMapSize){
                return;
            };
            this._depthMapSize = value;
            if (this._explicitDepthMap){
                throw (Error("Cannot set depth map size for the current renderer."));
            };
            if (this._depthMap){
                this._depthMap.dispose();
                this._depthMap = null;
            };
        }
        public function dispose():void{
            this._casterCollector = null;
            if (((this._depthMap) && (!(this._explicitDepthMap)))){
                this._depthMap.dispose();
            };
            this._depthMap = null;
        }
        protected function createDepthTexture():TextureProxyBase{
            return (new RenderTexture(this._depthMapSize, this._depthMapSize));
        }
        function renderDepthMap(stage3DProxy:Stage3DProxy, entityCollector:EntityCollector, renderer:DepthRenderer):void{
            this.updateDepthProjection(entityCollector.camera);
            this._depthMap = ((this._depthMap) || (this.createDepthTexture()));
            this.drawDepthMap(this._depthMap.getTextureForStage3D(stage3DProxy), entityCollector.scene, renderer);
        }
        protected function updateDepthProjection(viewCamera:Camera3D):void{
            throw (new AbstractMethodError());
        }
        protected function drawDepthMap(target:TextureBase, scene:Scene3D, renderer:DepthRenderer):void{
            throw (new AbstractMethodError());
        }

    }
}//package away3d.lights.shadowmaps 
