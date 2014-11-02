package wd.hud.items.datatype {
    import wd.http.*;
    import wd.providers.texts.*;
    import wd.hud.items.*;

    public class InternetRelaysTrackerData extends TrackerData {

        public var name:String;
        public var subscribers:Number;

        public function InternetRelaysTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            var tag:String;
            super(type, id, lon, lat, extra);
            var tags:Array = [ServiceConstants.TAG_NAME, ServiceConstants.TAG_SUBSCRIBERS];
            for each (tag in tags) {
                if (((!((extra[tag] == null))) && (!((extra[tag] == ""))))){
                    if (tag == "subscribers"){
                        this[tag] = parseFloat(extra[tag]);
                    } else {
                        this[tag] = extra[tag];
                    };
                };
            };
        }
        public function toString():String{
            return (((("InternetRelaysTrackerData: name" + this.name) + ", subscribers: ") + this.subscribers));
        }
        override public function get labelData():String{
            return (super.labelData);
        }
        override public function get labelSubData():String{
            var r:String = "";
            if (!(isNaN(this.subscribers))){
                r = (((super.labelSubData + this.subscribers) + " ") + DataDetailText.internetSubscribers);
            };
            return (r);
        }

    }
}//package wd.hud.items.datatype 
