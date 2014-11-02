package away3d.core.pick {
    import away3d.entities.*;
    import flash.geom.*;
    import away3d.core.base.*;

    public class PickingCollisionVO {

        public var entity:Entity;
        public var localPosition:Vector3D;
        public var localNormal:Vector3D;
        public var uv:Point;
        public var localRayPosition:Vector3D;
        public var localRayDirection:Vector3D;
        public var rayOriginIsInsideBounds:Boolean;
        public var rayEntryDistance:Number;
        public var renderable:IRenderable;

        public function PickingCollisionVO(entity:Entity){
            super();
            this.entity = entity;
        }
    }
}//package away3d.core.pick 
