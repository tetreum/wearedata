package away3d.core.partition {
    import away3d.lights.*;
    import away3d.core.traverse.*;

    public class PointLightNode extends EntityNode {

        private var _light:PointLight;

        public function PointLightNode(light:PointLight){
            super(light);
            this._light = light;
        }
        public function get light():PointLight{
            return (this._light);
        }
        override public function acceptTraverser(traverser:PartitionTraverser):void{
            if (traverser.enterNode(this)){
                super.acceptTraverser(traverser);
                traverser.applyPointLight(this._light);
            };
            traverser.leaveNode(this);
        }

    }
}//package away3d.core.partition 
