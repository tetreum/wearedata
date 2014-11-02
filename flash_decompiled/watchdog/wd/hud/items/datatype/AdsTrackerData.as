package wd.hud.items.datatype {
    import wd.http.*;
    import wd.hud.items.*;

    public class AdsTrackerData extends TrackerData {

        public var format:String;
        public var name:String;
        public var ad_type:String;
        public var weekviews:String;

        public function AdsTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            var tag:String;
            super(type, id, lon, lat, extra);
            var tags:Array = [ServiceConstants.TAG_FORMAT, ServiceConstants.TAG_NAME, ServiceConstants.TAG_TYPE, ServiceConstants.TAG_WEEK_VIEWS];
            for each (tag in tags) {
                if (((!((extra[tag] == null))) && (!((extra[tag] == ""))))){
                    if (tag == ServiceConstants.TAG_TYPE){
                        this.ad_type = extra[tag];
                    } else {
                        this[tag] = extra[tag];
                    };
                };
            };
        }
        public function toString():String{
            return (((((((("AtmTrackerData: name" + this.name) + ", ad_type: ") + this.ad_type) + " format: ") + this.format) + " weekviews: ") + this.weekviews));
        }

    }
}//package wd.hud.items.datatype 
