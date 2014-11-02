package wd.hud.panels.live {
    import wd.hud.common.text.*;
    import wd.hud.common.graphics.*;
    import flash.display.*;

    public class LiveItem extends Sprite {

        private var txt:CustomTextField;
        public var latitude:Number;
        public var longitude:Number;

        public function LiveItem(user:String, doWhat:String, w:uint, h:uint, lat:Number=0, long:Number=0){
            super();
            this.latitude = lat;
            this.longitude = long;
            this.txt = new CustomTextField(((user + " ") + doWhat), "liveActivityData");
            this.txt.width = w;
            this.txt.wordWrap = true;
            this.txt.width = w;
            this.addChild(this.txt);
            this.txt.y = 5;
            var l:Line = new Line(w, 0x565656);
            l.y = (this.txt.height + 10);
            this.addChild(l);
        }
    }
}//package wd.hud.panels.live 
