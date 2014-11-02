package away3d.events {
    import away3d.core.base.*;
    import flash.events.*;

    public class GeometryEvent extends Event {

        public static const SUB_GEOMETRY_ADDED:String = "SubGeometryAdded";
        public static const SUB_GEOMETRY_REMOVED:String = "SubGeometryRemoved";
        public static const BOUNDS_INVALID:String = "BoundsInvalid";

        private var _subGeometry:SubGeometry;

        public function GeometryEvent(type:String, subGeometry:SubGeometry=null):void{
            super(type, false, false);
            this._subGeometry = subGeometry;
        }
        public function get subGeometry():SubGeometry{
            return (this._subGeometry);
        }
        override public function clone():Event{
            return (new GeometryEvent(type, this._subGeometry));
        }

    }
}//package away3d.events 
