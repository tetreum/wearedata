package away3d.events {
    import away3d.core.base.*;
    import flash.events.*;

    public class Object3DEvent extends Event {

        public static const VISIBLITY_UPDATED:String = "visiblityUpdated";
        public static const SCENETRANSFORM_CHANGED:String = "scenetransformChanged";
        public static const SCENE_CHANGED:String = "sceneChanged";
        public static const POSITION_CHANGED:String = "positionChanged";
        public static const ROTATION_CHANGED:String = "rotationChanged";
        public static const SCALE_CHANGED:String = "scaleChanged";

        public var object:Object3D;

        public function Object3DEvent(type:String, object:Object3D){
            super(type);
            this.object = object;
        }
        override public function clone():Event{
            return (new Object3DEvent(type, this.object));
        }

    }
}//package away3d.events 
