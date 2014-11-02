package wd.hud.panels.search {
    import __AS3__.vec.*;
    import wd.http.*;
    import flash.events.*;
    import aze.motion.*;
    import wd.d3.geom.objects.linker.*;
    import wd.utils.*;
    import flash.display.*;

    public class ResultList extends Sprite {

        private const STATION:String = "station";
        private const PLACES:String = "places";
        private const VELIB:String = "velib";
        private const TWITTER:String = "twitter";
        private const INSTAGRAM:String = "instagram";
        private const FLICKR:String = "flickr";

        private var answerArrayTypes:Vector.<String>;
        private var answerTypes:Vector.<int>;
        private var items:Vector.<SearchItem>;
        private var service:SearchService;
        private var place:Place;

        public function ResultList(){
            this.answerArrayTypes = Vector.<String>([this.STATION, this.PLACES, this.VELIB, this.TWITTER, this.INSTAGRAM, this.FLICKR]);
            this.answerTypes = Vector.<int>([DataType.METRO_STATIONS, DataType.PLACES, DataType.VELO_STATIONS, DataType.TWITTERS, DataType.INSTAGRAMS, DataType.FLICKRS]);
            super();
            this.service = new SearchService(this);
            this.items = new Vector.<SearchItem>();
        }
        public function search(term:String):void{
            this.service.search(term);
        }
        public function onResult(result:Array):void{
            var type:String;
            var it:SearchItem;
            if (result == null){
                return;
            };
            this.flushItemList();
            var id:int;
            var i:int;
            while (i < this.answerArrayTypes.length) {
                type = this.answerArrayTypes[i];
                if (result[type] != null){
                    id++;
                    it = new SearchItem(this.answerTypes[i], result[type][0], this);
                    it.addEventListener(Event.SELECT, this.onSelect);
                    eaze(it).delay((id * 0.05)).to(0.25, {
                        alpha:1,
                        y:(-(id) * it.height)
                    });
                    this.items.push(it);
                };
                i++;
            };
            this.items.reverse();
            for each (it in this.items) {
                it.x = 10;
                it.alpha = 0;
                this.addChild(it);
            };
        }
        public function onSelect():void{
            dispatchEvent(new Event(Event.SELECT));
            this.flushItemList();
        }
        public function flushItemList():void{
            var itd:SearchItem;
            if (((this.items) && (this.items.length))){
                for each (itd in this.items) {
                    if (itd.destination != null){
                        Linker.removeLink(null, itd.destination);
                    };
                    itd.removeEventListener(Event.SELECT, this.onSelect);
                    eaze(itd).to(0.15, {
                        alpha:0,
                        y:0
                    }).onComplete(removeChild, itd);
                };
            };
            this.items.length = 0;
        }
        public function onCancel(result:Object):void{
            this.flushItemList();
        }

    }
}//package wd.hud.panels.search 
