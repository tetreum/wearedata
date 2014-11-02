package wd.hud.items.datatype {
    import wd.http.*;
    import wd.hud.items.*;

    public class ToiletsTrackerData extends TrackerData {

        public var name:String;

        public function ToiletsTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            super(type, id, lon, lat, extra);
            this.name = ((extra[ServiceConstants.TAG_NAME]) || (""));
        }
        public function toString():String{
            return (("ToiletsTrackerData: name" + this.name));
        }

    }
}//package wd.hud.items.datatype 
