package wd.intro {
    import wd.http.*;
    import wd.events.*;
    import flash.geom.*;
    import wd.hud.panels.district.*;
    import flash.utils.*;
    import biga.utils.*;
    import __AS3__.vec.*;
    import flash.display.*;

    public class IntroDistricts extends Sprite {

        private var service:DistrictService;
        private var districts:Dictionary;
        private var current:DistrictClip;
        private var checkInterval:uint;
        private var rect:Rectangle;
        private var _spots:Vector.<IntroSpot>;
        private var spot:IntroSpot;

        public function IntroDistricts(rect:Rectangle){
            super();
            this.rect = rect;
            this.service = new DistrictService();
            this.service.addEventListener(ServiceEvent.DISTRICT_COMPLETE, this.onServiceComplete);
            this.service.call();
            mouseChildren = false;
            buttonMode = true;
        }
        private function onServiceComplete(e:ServiceEvent):void{
            var info:Object;
            var k:*;
            var district:District;
            var dc:DistrictClip;
            trace("complete");
            this.districts = new Dictionary(true);
            var result:Object = e.data;
            for (k in result) {
                info = result[k];
                district = new District(info[ServiceConstants.KEY_ID], info[ServiceConstants.KEY_NAME], info[ServiceConstants.KEY_VERTICES]);
                dc = new DistrictClip(district, this.rect);
                dc.render(graphics);
                this.districts[info[ServiceConstants.KEY_ID]] = dc;
                dc.alpha = 0;
            };
            this.start();
        }
        private function update():void{
            var dc:DistrictClip;
            graphics.clear();
            for each (dc in this.districts) {
                dc.render(graphics);
            };
        }
        public function start():void{
            this.current = null;
            this.checkLocation();
            clearInterval(this.checkInterval);
            this.checkInterval = setInterval(this.checkLocation, (1000 / 40));
        }
        public function stop():void{
            clearInterval(this.checkInterval);
        }
        public function checkLocation():void{
            var dc:DistrictClip;
            graphics.clear();
            for each (dc in this.districts) {
                if (PolygonUtils.contains(mouseX, mouseY, dc.points)){
                    if (dc.alpha < 0.15){
                        dc.alpha = (dc.alpha + 0.05);
                    };
                    dc.selectSpots();
                } else {
                    if (dc.alpha >= 0){
                        dc.alpha = (dc.alpha - 0.02);
                    };
                    dc.unSelectSpots();
                };
                dc.render(graphics);
            };
        }
        public function get spots():Vector.<IntroSpot>{
            return (this._spots);
        }
        public function set spots(value:Vector.<IntroSpot>):void{
            var dc:DistrictClip;
            var s:IntroSpot;
            this._spots = value;
            for each (dc in this.districts) {
                dc.spots = new Vector.<IntroSpot>();
                for each (s in this.spots) {
                    if (PolygonUtils.contains(s.x, s.y, dc.points)){
                        dc.spots.push(s);
                    };
                };
            };
        }

    }
}//package wd.intro 
