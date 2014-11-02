package wd.intro {
    import flash.geom.*;
    import __AS3__.vec.*;
    import wd.utils.*;
    import wd.hud.panels.district.*;
    import flash.display.*;

    public class DistrictClip {

        public var points:Vector.<Point>;
        public var spots:Vector.<IntroSpot>;
        public var alpha:Number;
        public var visible:Boolean;
        public var district:District;

        public function DistrictClip(district:District, rect:Rectangle){
            var p:Point;
            var rm:Point;
            super();
            this.district = district;
            this.points = new Vector.<Point>();
            for each (p in district.vertices) {
                rm = Locator.INTRO_REMAP(p.x, p.y, rect);
                rm.y = (rect.bottom - (rm.y - rect.top));
                this.points.push(rm.clone());
            };
            this.alpha = 0;
        }
        public function render(graphics:Graphics):void{
            if (this.alpha == 0){
                return;
            };
            if ((((this.points == null)) || ((this.points.length == 0)))){
                return;
            };
            var p:Point = this.points[0];
            graphics.beginFill(0xFFFFFF, ((this.alpha * 0.75) + ((this.alpha * 0.25) * Math.random())));
            graphics.moveTo(p.x, p.y);
            var i:int;
            while (i < this.points.length) {
                p = this.points[i];
                graphics.lineTo(p.x, p.y);
                i++;
            };
            graphics.endFill();
        }
        public function selectSpots():void{
            var s:IntroSpot;
            for each (s in this.spots) {
                s.select();
            };
        }
        public function unSelectSpots():void{
            var s:IntroSpot;
            for each (s in this.spots) {
                s.unselect();
            };
        }

    }
}//package wd.intro 
