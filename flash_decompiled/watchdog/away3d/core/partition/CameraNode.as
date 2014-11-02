package away3d.core.partition {
    import away3d.cameras.*;
    import away3d.core.traverse.*;

    public class CameraNode extends EntityNode {

        public function CameraNode(camera:Camera3D){
            super(camera);
        }
        override public function acceptTraverser(traverser:PartitionTraverser):void{
        }
        override public function isInFrustum(camera:Camera3D):Boolean{
            return (true);
        }

    }
}//package away3d.core.partition 
