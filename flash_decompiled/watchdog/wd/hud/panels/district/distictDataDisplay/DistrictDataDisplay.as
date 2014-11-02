package wd.hud.panels.district.distictDataDisplay {
    import __AS3__.vec.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import wd.hud.panels.district.*;
    import aze.motion.*;
    import flash.display.*;

    public class DistrictDataDisplay extends Sprite {

        public static var datatsDisplays:Vector.<DistrictDataDisplay> = new Vector.<DistrictDataDisplay>();
;

        protected var data:DistrictData;
        public var property:String;
        protected var alowedWidth:uint;
        protected var label:CustomTextField;
        protected var labelTxt:String;
        public var value:Number;

        public function DistrictDataDisplay(data:DistrictData, property:String, labelTxt:String, w:uint, _y:Number){
            super();
            this.data = data;
            this.property = property;
            this.y = _y;
            this.alowedWidth = w;
            this.label = new CustomTextField((((((labelTxt + " <a href ='event:info_") + property) + "'>") + StatsText.infoPopinBtn) + "</a>"), "statsPanelDataLabel");
            this.labelTxt = labelTxt;
            this.label.width = this.alowedWidth;
            addChild(this.label);
            datatsDisplays.push(this);
        }
        protected function register():void{
        }
        public function update(duration:Number=0.25, delay:Number=0.1):void{
            if (isNaN(this.value)){
                this.value = 0;
            };
            if ((((this.data[this.property] == null)) || (isNaN(this.data[this.property])))){
                this.data[this.property] = 0;
            };
            eaze(this).delay(delay).to(duration, {value:this.data[this.property]}).onUpdate(this.render);
        }
        protected function render():void{
        }

    }
}//package wd.hud.panels.district.distictDataDisplay 
