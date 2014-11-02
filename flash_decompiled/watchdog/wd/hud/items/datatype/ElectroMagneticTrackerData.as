package wd.hud.items.datatype {
    import wd.http.*;
    import wd.hud.items.*;

    public class ElectroMagneticTrackerData extends TrackerData {

        public var address:String;
        public var date:String;
        public var indoor:String;
        public var labo:String;
        public var level:String;
        public var name:String;
        public var place:String;
        public var ref:String;
        public var zipcode:String;

        public function ElectroMagneticTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            var tag:String;
            super(type, id, lon, lat, extra);
            var tags:Array = [ServiceConstants.TAG_ADDRESS, ServiceConstants.TAG_DATE, ServiceConstants.TAG_INDOOR, ServiceConstants.TAG_LABO, ServiceConstants.TAG_LEVEL, ServiceConstants.TAG_NAME, ServiceConstants.TAG_PLACE, ServiceConstants.TAG_REF, ServiceConstants.TAG_ZIPCODE];
            for each (tag in tags) {
                if (((!((extra[tag] == null))) && (!((extra[tag] == ""))))){
                    this[tag] = extra[tag];
                };
            };
        }
        public function toString():String{
            return (((((((((((((((((("ElectroMagneticTrackerData: " + this.address) + "\n") + this.date) + "\n") + this.indoor) + "\n") + this.labo) + "\n") + this.level) + "\n") + this.name) + "\n") + this.place) + "\n") + this.ref) + "\n") + this.zipcode));
        }

    }
}//package wd.hud.items.datatype 
