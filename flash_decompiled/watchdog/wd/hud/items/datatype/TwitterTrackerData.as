package wd.hud.items.datatype {
    import wd.core.*;
    import flash.xml.*;
    import wd.hud.items.*;

    public class TwitterTrackerData extends TrackerData {

        private var xmlDoc:XMLDocument;
        public var caption:String;
        public var time:String;
        public var name:String;
        public var profile_picture:String;
        public var source:String;
        public var iso_language:String;
        public var from_user:String;
        public var from_user_id:String;
        public var from_user_id_str:String;
        public var place:Object;
        public var place_name:String;
        public var metadata:Object;
        public var user_id:String;
        public var user_id_str:String;
        public var tweet_id:String;

        public function TwitterTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            super(type, id, lon, lat, extra);
            this.tweet_id = ((extra.id) || (""));
            this.caption = ((this.htmlUnescape(extra.caption)) || (""));
            this.time = ((extra.created_time) || (""));
            this.from_user_id = ((extra.from_user_id) || (""));
            this.name = ((this.htmlUnescape(extra.pseudo)) || (""));
            this.from_user = ((this.htmlUnescape(extra.full_name)) || (""));
            this.profile_picture = ((extra.profile_picture) || (""));
            this.place_name = Config.CITY;
        }
        public function htmlUnescape(str:String):String{
            this.xmlDoc = ((this.xmlDoc) || (new XMLDocument(str)));
            this.xmlDoc.parseXML(str);
            return (this.xmlDoc.firstChild.nodeValue);
        }
        override public function get isValid():Boolean{
            return (((((!((this.caption == ""))) && (!((this.from_user == ""))))) && (!((this.tweet_id == "")))));
        }
        public function toString():String{
            return (((((((((((((((((((((((((((((((((((((((((((((((("TwitterTrackerData: \n" + "lon/lat \t\t\t\t") + lon) + " / ") + lat) + "\n") + "caption \t\t\t\t") + this.caption) + "\n") + "time \t\t\t\t") + this.time) + "\n") + "name \t\t\t\t") + this.name) + "\n") + "user_id \t\t\t\t") + this.user_id) + "\n") + "user_id_str\t\t\t") + this.user_id_str) + "\n") + "profile_picture \t\t") + this.profile_picture) + "\n") + "source \t\t\t\t") + this.source) + "\n") + "iso_language \t\t") + this.iso_language) + "\n") + "from_user \t\t\t") + this.from_user) + "\n") + "from_user_id \t\t") + this.from_user_id) + "\n") + "from_user_id_str \t") + this.from_user_id_str) + "\n") + "place \t\t\t\t") + this.place) + "\n") + "place_name \t\t\t") + this.place_name) + "\n") + "metadata \t\t\t") + this.metadata) + "\n"));
        }

    }
}//package wd.hud.items.datatype 
