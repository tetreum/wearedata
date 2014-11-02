package wd.http {
    import wd.core.*;
    import wd.utils.*;
    import flash.net.*;
    import flash.events.*;
    import wd.hud.items.datatype.*;
    import flash.utils.*;
    import wd.hud.items.*;
    import wd.events.*;

    public class TwitterService extends EventDispatcher {

        public static var FREQUECY:int = 20000;

        private var loader:URLLoader;
        private var req:URLRequest;
        private var date:Date;

        public function TwitterService(){
            super();
            this.date = new Date();
            this.callService();
        }
        private function callService():void{
            var rpp:String = "100";
            var lang:String = Config.LANG;
            var geocode:String = (((((Locator.LATITUDE + ",") + Locator.LONGITUDE) + ",") + ServiceConstants.REQ_RADIUS) + "km");
            var searchUrl:String = (((Config.ROOT_URL + "html/tweets/?q=&rpp=") + rpp) + "&include_entities=true&result_type=mixed");
            searchUrl = (searchUrl + (("&geocode=" + geocode) + "&callback=?"));
            this.req = new URLRequest(searchUrl);
            this.loader = new URLLoader(this.req);
            this.loader.addEventListener(Event.COMPLETE, this.onComplete);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
        }
        private function onError(e:IOErrorEvent):void{
        }
        private function onComplete(e:Event):void{
            var o:* = null;
            var str:* = null;
            var obj:* = undefined;
            var lon:* = NaN;
            var lat:* = NaN;
            var params:* = null;
            var tweet:* = null;
            var e:* = e;
            try {
                str = this.loader.data;
                str = str.substring(2, (str.length - 2));
                obj = JSON.parse(str);
            } catch(err:Error) {
                setTimeout(callService, FREQUECY);
                return;
            };
            var result:* = [];
            for each (o in obj.statuses) {
                if (((!((o.coordinates == null))) && ((o.coordinates.type == "Point")))){
                    if (TrackerData.exists(uint(o.id))){
                    } else {
                        lon = parseFloat(o.coordinates.coordinates[0]);
                        lat = parseFloat(o.coordinates.coordinates[1]);
                        params = [];
                        params.id = o.id_str;
                        params.caption = o.text;
                        params.created_time = (Date.parse(o.created_at) * 0.001).toFixed(0);
                        params.from_user_id = o.user.id;
                        params.pseudo = o.user.screen_name;
                        params.full_name = o.user.name;
                        params.profile_picture = o.user.profile_image_url;
                        tweet = new TwitterTrackerData(DataType.TWITTERS, o.id, lon, lat, params);
                        result.push(tweet);
                    };
                };
            };
            dispatchEvent(new ServiceEvent(ServiceEvent.TWITTERS_COMPLETE, result));
            setTimeout(this.callService, FREQUECY);
        }

    }
}//package wd.http 
