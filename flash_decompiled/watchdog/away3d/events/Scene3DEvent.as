package away3d.events {
    import away3d.containers.*;
    import flash.events.*;

    public class Scene3DEvent extends Event {

        public static const ADDED_TO_SCENE:String = "addedToScene";
        public static const REMOVED_FROM_SCENE:String = "removedFromScene";

        public var objectContainer3D:ObjectContainer3D;

        public function Scene3DEvent(type:String, objectContainer:ObjectContainer3D){
            this.objectContainer3D = objectContainer;
            super(type);
        }
        override public function get target():Object{
            return (this.objectContainer3D);
        }
        override public function clone():Event{
            return (new Scene3DEvent(type, this.objectContainer3D));
        }

    }
}//package away3d.events 
