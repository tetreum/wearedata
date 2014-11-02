package away3d.core.traverse {
    import away3d.core.base.*;
    import away3d.core.data.*;
    import away3d.lights.*;

    public class ShadowCasterCollector extends EntityCollector {

        public function ShadowCasterCollector(){
            super();
        }
        override public function applySkyBox(renderable:IRenderable):void{
        }
        override public function applyRenderable(renderable:IRenderable):void{
            var item:RenderableListItem;
            if (((renderable.castsShadows) && (renderable.material))){
                _numOpaques++;
                item = _renderableListItemPool.getItem();
                item.renderable = renderable;
                item.next = _opaqueRenderableHead;
                item.zIndex = renderable.zIndex;
                item.renderOrderId = renderable.material._uniqueId;
                _opaqueRenderableHead = item;
            };
        }
        override public function applyUnknownLight(light:LightBase):void{
        }

    }
}//package away3d.core.traverse 
