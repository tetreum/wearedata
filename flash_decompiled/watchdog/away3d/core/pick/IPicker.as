package away3d.core.pick {
    import away3d.containers.*;
    import flash.geom.*;

    public interface IPicker {

        function getViewCollision(_arg1:Number, _arg2:Number, _arg3:View3D):PickingCollisionVO;
        function getSceneCollision(_arg1:Vector3D, _arg2:Vector3D, _arg3:Scene3D):PickingCollisionVO;

    }
}//package away3d.core.pick 
