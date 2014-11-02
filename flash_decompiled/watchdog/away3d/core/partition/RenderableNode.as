package away3d.core.partition {
    import away3d.entities.*;
    import away3d.core.base.*;
    import away3d.core.traverse.*;

    public class RenderableNode extends EntityNode {

        private var _renderable:IRenderable;

        public function RenderableNode(renderable:IRenderable){
            super(Entity(renderable));
            this._renderable = renderable;
        }
        override public function acceptTraverser(traverser:PartitionTraverser):void{
            if (traverser.enterNode(this)){
                super.acceptTraverser(traverser);
                traverser.applyRenderable(this._renderable);
            };
            traverser.leaveNode(this);
        }

    }
}//package away3d.core.partition 
