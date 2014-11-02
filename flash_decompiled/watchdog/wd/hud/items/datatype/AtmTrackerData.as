package wd.hud.items.datatype {
    import wd.http.*;
    import wd.hud.items.*;

    public class AtmTrackerData extends TrackerData {

        public var amenity:String;
        public var name:String;
        public var note:String;

        public function AtmTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            var tag:String;
            super(type, id, lon, lat, extra);
            var tags:Array = [ServiceConstants.TAG_AMENITY, ServiceConstants.TAG_NAME, ServiceConstants.TAG_NOTE];
            for each (tag in tags) {
                if (((!((extra[tag] == null))) && (!((extra[tag] == ""))))){
                    this[tag] = extra[tag];
                };
            };
        }
        public function toString():String{
            return (((((("AtmTrackerData: name" + this.name) + ", amenity: ") + this.amenity) + " note: ") + this.note));
        }
        override public function get labelData():String{
            return (super.labelData);
        }

    }
}//package wd.hud.items.datatype 
