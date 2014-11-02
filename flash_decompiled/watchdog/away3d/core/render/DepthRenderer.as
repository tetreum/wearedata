package away3d.core.render {
    import flash.display3D.*;
    import away3d.core.traverse.*;
    import flash.display3D.textures.*;
    import away3d.core.data.*;
    import away3d.cameras.*;
    import away3d.materials.*;

    public class DepthRenderer extends RendererBase {

        private var _activeMaterial:MaterialBase;
        private var _renderBlended:Boolean;
        private var _distanceBased:Boolean;

        public function DepthRenderer(renderBlended:Boolean=false, distanceBased:Boolean=false){
            super();
            this._renderBlended = renderBlended;
            this._distanceBased = distanceBased;
            _backgroundR = 1;
            _backgroundG = 1;
            _backgroundB = 1;
        }
        override function set backgroundR(value:Number):void{
        }
        override function set backgroundG(value:Number):void{
        }
        override function set backgroundB(value:Number):void{
        }
        override protected function draw(entityCollector:EntityCollector, target:TextureBase):void{
            _context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
            _context.setDepthTest(true, Context3DCompareMode.LESS);
            this.drawRenderables(entityCollector.opaqueRenderableHead, entityCollector);
            if (this._renderBlended){
                this.drawRenderables(entityCollector.blendedRenderableHead, entityCollector);
            };
            if (this._activeMaterial){
                this._activeMaterial.deactivateForDepth(_stage3DProxy);
            };
            this._activeMaterial = null;
        }
        private function drawRenderables(item:RenderableListItem, entityCollector:EntityCollector):void{
            var item2:RenderableListItem;
            var camera:Camera3D = entityCollector.camera;
            while (item) {
                this._activeMaterial = item.renderable.material;
                this._activeMaterial.activateForDepth(_stage3DProxy, camera, this._distanceBased, _textureRatioX, _textureRatioY);
                item2 = item;
                do  {
                    this._activeMaterial.renderDepth(item2.renderable, _stage3DProxy, camera);
                    item2 = item2.next;
                } while (((item2) && ((item2.renderable.material == this._activeMaterial))));
                this._activeMaterial.deactivateForDepth(_stage3DProxy);
                item = item2;
            };
        }

    }
}//package away3d.core.render 
