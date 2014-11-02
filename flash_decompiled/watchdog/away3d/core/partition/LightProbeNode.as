package away3d.core.partition {
    import away3d.lights.*;
    import away3d.core.traverse.*;

    public class LightProbeNode extends EntityNode {

        private var _light:LightProbe;

        public function LightProbeNode(light:LightProbe){
            super(light);
            this._light = light;
        }
        public function get light():LightProbe{
            return (this._light);
        }
        override public function acceptTraverser(traverser:PartitionTraverser):void{
            if (traverser.enterNode(this)){
                super.acceptTraverser(traverser);
                traverser.applyLightProbe(this._light);
            };
            traverser.leaveNode(this);
        }

    }
}//package away3d.core.partition 
