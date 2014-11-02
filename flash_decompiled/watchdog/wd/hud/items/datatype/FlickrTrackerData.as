package wd.hud.items.datatype {
    import wd.hud.items.*;

    public class FlickrTrackerData extends TrackerData {

        public var title:String;
        public var description:String;
        public var owner:String;
        public var userName:String;
        public var time:String;
        public var url:String;
        public var width:int;
        public var height:int;
        public var httpUrl:String;

        public function FlickrTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            super(type, id, lon, lat, extra);
            this.time = ((extra["dateupload"]) || (""));
            this.description = ((extra["description"]) || (""));
            this.height = parseInt(extra["height_s"]);
            this.width = parseInt(extra["width_s"]);
            this.owner = ((extra["owner"]) || (""));
            this.userName = ((extra["ownername"]) || (""));
            this.title = ((extra["title"]) || (""));
            this.url = extra["url_s"];
            this.httpUrl = (((("http://www.flickr.com/photos/" + this.owner) + "/") + extra["id"]) + "/");
        }
        override public function get isValid():Boolean{
            return (((!((this.url == null))) && (!((this.url == "")))));
        }
        public function toString():String{
            return (((((((((((((((((((((("FlickrTrackerData:" + "\ntime \t\t\t") + this.time) + "") + "\ndescription \t\t") + this.description) + "") + "\nheight \t\t\t") + this.height) + "") + "\nwidth \t\t\t") + this.width) + "") + "\nuserName \t\t") + this.userName) + "") + "\ntitle \t\t\t") + this.title) + "") + "\nurl \t\t\t\t") + this.url) + ""));
        }

    }
}//package wd.hud.items.datatype 
