package wd.hud.items.datatype {
    import wd.http.*;
    import wd.hud.items.*;

    public class CamerasTrackerData extends TrackerData {

        public var name:String;
        public var surveillance:String;
        public var man_made:String;
        public var height:String;
        public var camera_type:String;
        public var camera_mount:String;
        public var operator:String;
        public var surveillance_type:String;
        public var amenity:String;
        public var direction:String;

        public function CamerasTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            var tag:String;
            super(type, id, lon, lat, extra);
            var tags:Array = [ServiceConstants.TAG_NAME, ServiceConstants.TAG_SURVEILLANCE, ServiceConstants.TAG_MAN_MADE, ServiceConstants.TAG_HEIGHT, ServiceConstants.TAG_CAMERA_TYPE, ServiceConstants.TAG_CAMERA_MOUNT, ServiceConstants.TAG_OPERATOR, ServiceConstants.TAG_SURVEILLANCE_TYPE, ServiceConstants.TAG_AMENITY, ServiceConstants.TAG_DIRECTION];
            for each (tag in tags) {
                if (((!((extra[tag] == null))) && (!((extra[tag] == ""))))){
                    this[tag] = extra[tag];
                };
            };
        }
        public function toString():String{
            return (((((((((((((((((((("CamerasTrackerData:  name " + this.name) + "surveillance ") + this.surveillance) + "man_made ") + this.man_made) + "height ") + this.height) + "camera_type ") + this.camera_type) + "camera_mount ") + this.camera_mount) + "operator ") + this.operator) + "surveillance_type ") + this.surveillance_type) + "amenity ") + this.amenity) + "direction ") + this.direction));
        }
        override public function get labelData():String{
            var add:String = "";
            if (this.name != null){
                add = (" " + this.name);
            };
            return ((super.labelData + add));
        }

    }
}//package wd.hud.items.datatype 
