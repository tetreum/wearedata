package wd.utils {
    import flash.net.*;
    import flash.events.*;
    import __AS3__.vec.*;
    import wd.hud.*;
    import wd.hud.items.*;
    import wd.http.*;

    public class CSVLoader {

        private var uload:URLLoader;

        public function CSVLoader(url:String){
            super();
            var req:URLRequest = new URLRequest(encodeURI(url));
            this.uload = new URLLoader();
            this.uload.addEventListener(Event.COMPLETE, this.onComplete);
            this.uload.load(req);
        }
        private function onComplete(e:Event):void{
            var _s:String;
            var labels:Vector.<String>;
            var i:int;
            var s:String = this.uload.data;
            s = s.replace(/\n/gi, ";");
            s = s.replace(/\r/gi, ";");
            s = s.replace(";;", ";");
            var tmp:Array = s.split(";");
            var places:Array = [];
            for each (_s in tmp) {
                if (_s == ""){
                } else {
                    places.push(_s);
                };
            };
            labels = Vector.<String>([]);
            i = 0;
            while (i < places.length) {
                labels.push(places[i]);
                i = (i + 3);
            };
            SpriteSheetFactory2.addTexts(labels);
            Hud.getInstance().majTexture();
            i = 0;
            while (i < places.length) {
                Hud.addItem(new TrackerData(DataType.PLACES, 0, places[(i + 2)], places[(i + 1)], places[i]));
                i = (i + 3);
            };
        }

    }
}//package wd.utils 
