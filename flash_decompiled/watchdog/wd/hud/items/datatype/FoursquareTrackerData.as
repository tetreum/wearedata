package wd.hud.items.datatype {
    import wd.http.*;
    import wd.hud.items.*;

    public class FoursquareTrackerData extends TrackerData {

        public var mayor:Array;
        public var count:int;
        public var photoUrl:String = "";
        public var userName:String = "";
        public var userId:String = "";
        public var place:String;
        public var venueUrl:String;

        public function FoursquareTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            super(type, id, lon, lat, extra);
            this.place = extra[ServiceConstants.TAG_NAME];
            this.venueUrl = extra.url;
            if (extra[ServiceConstants.TAG_MAYOR] != null){
                this.mayor = extra[ServiceConstants.TAG_MAYOR];
                this.count = this.mayor["count"];
                this.photoUrl = this.mayor["photo"];
                this.userName = this.mayor["user"];
                this.userId = this.mayor["userid"];
            };
        }
        override public function get isValid():Boolean{
            return (((((!((extra[ServiceConstants.TAG_MAYOR] == null))) && (!((this.userId == ""))))) && (!((this.userName == "")))));
        }
        public function toString():String{
            return (((((((((("FoursquareTrackerData: place " + this.place) + " user: ") + this.userName) + " user ID: ") + this.userId) + " photo: ") + this.photoUrl) + " count: ") + this.count));
        }

    }
}//package wd.hud.items.datatype 
