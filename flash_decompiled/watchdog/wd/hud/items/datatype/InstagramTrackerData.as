package wd.hud.items.datatype {
    import wd.hud.items.*;

    public class InstagramTrackerData extends TrackerData {

        public var title:String;
        public var name:String;
        public var time:String;
        public var comments:int;
        public var likes:int;
        public var link:String;
        public var tags:Array;
        public var width:int;
        public var height:int;
        public var profile:String;
        public var thumbnail:String;
        public var picture:String;

        public function InstagramTrackerData(type:int, id:int, lon:Number, lat:Number, extra:Array){
            super(type, id, lon, lat, extra);
            this.title = ((extra["caption"]) || (""));
            this.name = ((extra["full_name"]) || (""));
            this.time = ((extra["created_time"]) || (""));
            this.comments = parseInt(extra["comments"]);
            this.likes = parseInt(extra["likes"]);
            this.link = ((extra["link"]) || (""));
            this.tags = (((extra["tags"] == false)) ? [] : extra["tags"]);
            this.width = parseInt(extra["width"]);
            this.height = parseInt(extra["height"]);
            this.profile = ((extra["profile_picture"]) || (""));
            this.picture = ((extra["picture"]) || (""));
            this.thumbnail = ((extra["thumbnail"]) || (""));
        }
        override public function get isValid():Boolean{
            return (((!((this.title == null))) && (((!((this.picture == null))) || (!((this.picture == "")))))));
        }
        public function toString():String{
            return ((((((((((((((((((((((((((((((((((((("InstagramTrackerData " + "\ntitle       ") + this.title) + "") + "\nname        ") + this.name) + "") + "\ntime        ") + this.time) + "") + "\ncomments    ") + this.comments) + "") + "\nlikes       ") + this.likes) + "") + "\nlink        ") + this.link) + "") + "\ntags        ") + this.tags) + "") + "\nheight      ") + this.height) + "") + "\nwidth       ") + this.width) + "") + "\nprofile     ") + this.profile) + "") + "\nthumbnail   ") + this.thumbnail) + "") + "\npicture     ") + this.picture) + ""));
        }

    }
}//package wd.hud.items.datatype 
