package wd.hud.items.datatype {
    import wd.http.*;
    import wd.hud.items.*;

    public class MobilesTrackerData extends TrackerData {

        public var address:String;
        public var height:String;
        public var operator:String;
        public var ref:String;
        public var zipcode:String;

        public function MobilesTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            var tag:String;
            super(type, id, lon, lat, extra);
            var tags:Array = [ServiceConstants.TAG_ADDRESS, ServiceConstants.TAG_HEIGHT, ServiceConstants.TAG_OPERATOR, ServiceConstants.TAG_REF, ServiceConstants.TAG_ZIPCODE];
            for each (tag in tags) {
                if (((!((extra[tag] == null))) && (!((extra[tag] == ""))))){
                    this[tag] = extra[tag];
                };
            };
        }
        public function toString():String{
            return (((((((((("MobileTrackerData: address" + this.address) + ", height: ") + this.height) + " operator (Array) : ") + this.operator) + ", ref: ") + this.ref) + ", zipcode: ") + this.zipcode));
        }

    }
}//package wd.hud.items.datatype 
