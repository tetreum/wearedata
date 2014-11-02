package away3d.core.partition {
    import away3d.lights.*;
    import away3d.core.traverse.*;

    public class LightNode extends EntityNode {

        private var _light:LightBase;

        public function LightNode(light:LightBase){
            super(light);
            this._light = light;
        }
        public function get light():LightBase{
            return (this._light);
        }
        override public function acceptTraverser(traverser:PartitionTraverser):void{
            if (traverser.enterNode(this)){
                super.acceptTraverser(traverser);
                traverser.applyUnknownLight(this._light);
            };
            traverser.leaveNode(this);
        }

    }
}//package away3d.core.partition 
