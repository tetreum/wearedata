package away3d.core.pick {
    import flash.geom.*;
    import away3d.core.base.*;

    public interface IPickingCollider {

        function setLocalRay(_arg1:Vector3D, _arg2:Vector3D):void;
        function testSubMeshCollision(_arg1:SubMesh, _arg2:PickingCollisionVO, _arg3:Number):Boolean;

    }
}//package away3d.core.pick 
