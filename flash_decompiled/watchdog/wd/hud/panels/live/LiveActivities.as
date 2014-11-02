package wd.hud.panels.live {
    import flash.display.*;
    import aze.motion.*;
    import flash.events.*;
    import wd.d3.control.*;
    import wd.http.*;

    public class LiveActivities extends Sprite {

        private const ITEM_HEIGHT:uint = 42;
        private const LIVE_MAX_ITEMS:uint = 4;

        private var items:Array;
        public var aWidth:uint;
        private var bottom:Shape;

        public function LiveActivities(w:uint){
            super();
            this.aWidth = w;
            this.items = new Array();
            this.bottom = new Shape();
            this.bottom.graphics.beginBitmapFill(new RayPatternAsset(5, 5));
            this.bottom.graphics.drawRect(0, 0, this.aWidth, 9);
            this.bottom.alpha = 0.5;
            this.addChild(this.bottom);
        }
        public function addItem(user:String, doWhat:String, lat:Number, long:Number):void{
            var ittoremove:LiveItem;
            var it:LiveItem = new LiveItem(user, doWhat, this.aWidth, this.ITEM_HEIGHT, lat, long);
            it.alpha = 0;
            eaze(it).delay(0.4).to(0.7, {alpha:1});
            this.items.unshift(it);
            if (((!((lat == 0))) && (!((long == 0))))){
                it.buttonMode = true;
                it.mouseChildren = false;
                it.addEventListener(MouseEvent.CLICK, this.itemClick);
            };
            this.addChild(it);
            var hcounter:uint = it.height;
            var i:uint = 1;
            while (i < this.items.length) {
                eaze(this.items[i]).to(0.7, {y:hcounter});
                hcounter = (hcounter + this.items[i].height);
                i++;
            };
            if (this.items.length > this.LIVE_MAX_ITEMS){
                ittoremove = this.items.pop();
                hcounter = (hcounter - ittoremove.height);
                this.removeChild(ittoremove);
            };
            this.bottom.y = (hcounter + 6);
        }
        protected function itemClick(e:Event):void{
            CameraController.instance.setTarget(null, (e.target as LiveItem).longitude, (e.target as LiveItem).latitude);
            GoogleAnalytics.FBItemClick(-1);
        }
        public function clear():void{
            var i:uint;
            while (i < this.items.length) {
                this.removeChild(this.items[i]);
                i++;
            };
            this.items = new Array();
            this.bottom.y = 0;
        }

    }
}//package wd.hud.panels.live 
