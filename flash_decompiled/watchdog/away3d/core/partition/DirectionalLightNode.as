package away3d.core.partition {
    import away3d.lights.*;
    import away3d.core.traverse.*;

    public class DirectionalLightNode extends EntityNode {

        private var _light:DirectionalLight;

        public function DirectionalLightNode(light:DirectionalLight){
            super(light);
            this._light = light;
        }
        public function get light():DirectionalLight{
            return (this._light);
        }
        override public function acceptTraverser(traverser:PartitionTraverser):void{
            if (traverser.enterNode(this)){
                super.acceptTraverser(traverser);
                traverser.applyDirectionalLight(this._light);
            };
            traverser.leaveNode(this);
        }

    }
}//package away3d.core.partition 
