package wd.intro {
    import wd.core.*;
    import wd.http.*;
    import flash.events.*;
    import wd.utils.*;
    import flash.geom.*;
    import wd.sound.*;
    import wd.events.*;
    import aze.motion.*;
    import flash.filters.*;
    import flash.display.*;

    public class IntroSpot extends Sprite {

        public var place:Place;
        private var rect:Rectangle;
        private var dir:int;
        private var color:int;
        private var _inDistrict:Boolean;

        public function IntroSpot(place:Place, rect:Rectangle, dir:int=-1){
            super();
            this.dir = dir;
            this.rect = rect;
            this.place = place;
            this.color = (((dir == -1)) ? Colors.getColorByType(DataType.TWITTERS) : 0xFF0000);
            graphics.beginFill(this.color);
            if (dir == -1){
                graphics.moveTo(0, -9);
                graphics.lineTo(6, 0);
                graphics.lineTo(-6, 0);
            } else {
                graphics.moveTo(0, 0);
                graphics.lineTo(6, -9);
                graphics.lineTo(-6, -9);
            };
            buttonMode = true;
            addEventListener(MouseEvent.ROLL_OVER, this.onRoll);
            addEventListener(MouseEvent.ROLL_OUT, this.onRoll);
            addEventListener(MouseEvent.CLICK, this.onClick);
            var p:Point = Locator.INTRO_REMAP(place.lon, place.lat, rect);
            this.x = p.x;
            this.y = (rect.bottom - (p.y - rect.top));
            alpha = 0;
        }
        protected function onRoll(event:MouseEvent):void{
            switch (event.type){
                case MouseEvent.ROLL_OVER:
                    SoundManager.playFX("RollOverLieuxVille", (0.5 + (Math.random() * 0.5)));
                    break;
                case MouseEvent.ROLL_OUT:
                    break;
            };
        }
        private function onClick(e:MouseEvent):void{
            var p:Point = new Point(this.place.lon, this.place.lat);
            dispatchEvent(new NavigatorEvent(NavigatorEvent.SET_START_LOCATION, p));
            e.stopImmediatePropagation();
            SoundManager.playFX("ClicLieuxVille", 1);
        }
        public function select():void{
            eaze(this).to(0.5, {alpha:1}).filter(GlowFilter, {
                color:this.color,
                blurX:20,
                blurY:20,
                strength:2,
                alpha:0.85
            });
        }
        public function unselect():void{
            eaze(this).to(0.5, {alpha:0.25}).filter(GlowFilter, {
                blurX:0,
                blurY:0,
                alpha:0
            }, true);
        }
        public function reset(lon:Number, lat:Number):void{
            var p:Point = Locator.INTRO_REMAP(lon, lat, this.rect);
            this.place.lon = lon;
            this.place.lat = lat;
            this.x = p.x;
            this.y = (this.rect.bottom - (p.y - this.rect.top));
        }
        public function get inDistrict():Boolean{
            return (this._inDistrict);
        }
        public function set inDistrict(value:Boolean):void{
            this._inDistrict = value;
        }

    }
}//package wd.intro 
