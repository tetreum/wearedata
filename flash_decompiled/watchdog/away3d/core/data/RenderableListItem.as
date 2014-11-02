package away3d.core.data {
    import away3d.core.base.*;

    public final class RenderableListItem {

        public var next:RenderableListItem;
        public var renderable:IRenderable;
        public var materialId:int;
        public var renderOrderId:int;
        public var zIndex:Number;

    }
}//package away3d.core.data 
