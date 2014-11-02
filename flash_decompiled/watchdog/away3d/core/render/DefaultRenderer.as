package away3d.core.render {
    import away3d.core.managers.*;
    import away3d.core.traverse.*;
    import flash.display3D.textures.*;
    import flash.geom.*;
    import away3d.lights.*;
    import __AS3__.vec.*;
    import flash.display3D.*;
    import away3d.core.base.*;
    import away3d.materials.*;
    import away3d.cameras.*;
    import away3d.core.data.*;

    public class DefaultRenderer extends RendererBase {

        private static var RTT_PASSES:int = 1;
        private static var SCREEN_PASSES:int = 2;
        private static var ALL_PASSES:int = 3;

        private var _activeMaterial:MaterialBase;
        private var _distanceRenderer:DepthRenderer;
        private var _depthRenderer:DepthRenderer;

        public function DefaultRenderer(){
            super();
            this._depthRenderer = new DepthRenderer();
            this._distanceRenderer = new DepthRenderer(false, true);
        }
        override function set stage3DProxy(value:Stage3DProxy):void{
            super.stage3DProxy = value;
            this._distanceRenderer.stage3DProxy = (this._depthRenderer.stage3DProxy = value);
        }
        override protected function executeRender(entityCollector:EntityCollector, target:TextureBase=null, scissorRect:Rectangle=null, surfaceSelector:int=0):void{
            this.updateLights(entityCollector);
            if (target){
                this.drawRenderables(entityCollector.opaqueRenderableHead, entityCollector, RTT_PASSES);
                this.drawRenderables(entityCollector.blendedRenderableHead, entityCollector, RTT_PASSES);
            };
            super.executeRender(entityCollector, target, scissorRect, surfaceSelector);
        }
        private function updateLights(entityCollector:EntityCollector):void{
            var len:uint;
            var i:uint;
            var light:LightBase;
            var dirLights:Vector.<DirectionalLight> = entityCollector.directionalLights;
            var pointLights:Vector.<PointLight> = entityCollector.pointLights;
            len = dirLights.length;
            i = 0;
            while (i < len) {
                light = dirLights[i];
                if (light.castsShadows){
                    light.shadowMapper.renderDepthMap(_stage3DProxy, entityCollector, this._depthRenderer);
                };
                i++;
            };
            len = pointLights.length;
            i = 0;
            while (i < len) {
                light = pointLights[i];
                if (light.castsShadows){
                    light.shadowMapper.renderDepthMap(_stage3DProxy, entityCollector, this._distanceRenderer);
                };
                i++;
            };
        }
        override protected function draw(entityCollector:EntityCollector, target:TextureBase):void{
            if (entityCollector.skyBox){
                if (this._activeMaterial){
                    this._activeMaterial.deactivate(_stage3DProxy);
                };
                this._activeMaterial = null;
                this.drawSkyBox(entityCollector);
            };
            _context.setDepthTest(true, Context3DCompareMode.LESS);
            _context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
            var which:int = ((target) ? SCREEN_PASSES : ALL_PASSES);
            this.drawRenderables(entityCollector.opaqueRenderableHead, entityCollector, which);
            this.drawRenderables(entityCollector.blendedRenderableHead, entityCollector, which);
            if (this._activeMaterial){
                this._activeMaterial.deactivate(_stage3DProxy);
            };
            _context.setDepthTest(false, Context3DCompareMode.LESS);
            this._activeMaterial = null;
        }
        private function drawSkyBox(entityCollector:EntityCollector):void{
            var skyBox:IRenderable = entityCollector.skyBox;
            var material:MaterialBase = skyBox.material;
            var camera:Camera3D = entityCollector.camera;
            material.activatePass(0, _stage3DProxy, camera, _textureRatioX, _textureRatioY);
            material.renderPass(0, skyBox, _stage3DProxy, entityCollector);
            material.deactivatePass(0, _stage3DProxy);
        }
        private function drawRenderables(item:RenderableListItem, entityCollector:EntityCollector, which:int):void{
            var numPasses:uint;
            var j:uint;
            var item2:RenderableListItem;
            var rttMask:int;
            var camera:Camera3D = entityCollector.camera;
            while (item) {
                this._activeMaterial = item.renderable.material;
                this._activeMaterial.updateMaterial(_context);
                numPasses = this._activeMaterial.numPasses;
                j = 0;
                do  {
                    item2 = item;
                    rttMask = ((this._activeMaterial.passRendersToTexture(j)) ? 1 : 2);
                    if ((rttMask & which) != 0){
                        _context.setDepthTest(true, Context3DCompareMode.LESS);
                        this._activeMaterial.activatePass(j, _stage3DProxy, camera, _textureRatioX, _textureRatioY);
                        do  {
                            this._activeMaterial.renderPass(j, item2.renderable, _stage3DProxy, entityCollector);
                            item2 = item2.next;
                        } while (((item2) && ((item2.renderable.material == this._activeMaterial))));
                        this._activeMaterial.deactivatePass(j, _stage3DProxy);
                    } else {
                        do  {
                            item2 = item2.next;
                        } while (((item2) && ((item2.renderable.material == this._activeMaterial))));
                    };
                    ++j;
                } while (j < numPasses);
                item = item2;
            };
        }
        override function dispose():void{
            super.dispose();
            this._depthRenderer.dispose();
            this._distanceRenderer.dispose();
            this._depthRenderer = null;
            this._distanceRenderer = null;
        }

    }
}//package away3d.core.render 
