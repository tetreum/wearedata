package wd.hud.panels.district.distictDataDisplay {
    import flash.geom.*;
    import wd.hud.common.text.*;
    import wd.hud.panels.district.*;
    import flash.display.*;

    public class DistrictDataSlider extends DistrictDataDisplay {

        private static var rect:Rectangle;

        private var dataValue:CustomTextField;

        public function DistrictDataSlider(data:DistrictData, property:String, labelTxt:String, w:uint, _y:Number){
            super(data, property, labelTxt, w, _y);
            rect = new Rectangle(0, 0, alowedWidth, 11);
            this.dataValue = new CustomTextField("0%", "statsPanelDataSilderValueOut");
            this.dataValue.x = 0;
            this.dataValue.width = alowedWidth;
            this.dataValue.y = (label.height - 2);
            value = data[property];
            this.addChild(this.dataValue);
            this.drawBg();
        }
        override public function update(duration:Number=0.25, delay:Number=0.1):void{
            super.update(duration, delay);
        }
        override protected function render():void{
            var val:Number;
            if (isNaN(value)){
                value = 0;
            };
            graphics.clear();
            this.drawBg();
            graphics.beginFill(0xFFFFFF);
            if (property == "crimes_thousand"){
                val = ((value * 0.1) * rect.width);
                if (Math.round((value * 100)) <= 0){
                    this.dataValue.text = "---";
                } else {
                    this.dataValue.text = (Math.round((value * 100)).toString() + "‰");
                };
            } else {
                val = ((value * 0.01) * rect.width);
                if ((((value.toFixed(2) == "0.00")) || ((value.toFixed(2) == "-1.00")))){
                    this.dataValue.text = "---";
                } else {
                    this.dataValue.text = (value.toFixed(2).toString() + "%");
                };
            };
            graphics.lineStyle(1, 0xFFFFFF, 0, false, "normal", CapsStyle.SQUARE);
            graphics.drawRect(0, int((label.height + 2)), val, rect.height);
            this.dataValue.x = val;
        }
        private function drawBg():void{
            var sh:int = (label.height + 2);
            graphics.beginFill(0xFFFFFF, 0.25);
            graphics.lineStyle(1, 0xFFFFFF, 0, false, "normal", CapsStyle.SQUARE);
            graphics.drawRect(0, sh, rect.width, rect.height);
            graphics.lineStyle(1, 0xFFFFFF, 1, false, "normal", CapsStyle.SQUARE);
            graphics.moveTo(0, sh);
            graphics.lineTo(0, (sh + rect.height));
            graphics.moveTo(rect.width, sh);
            graphics.lineTo(rect.width, (sh + rect.height));
        }

    }
}//package wd.hud.panels.district.distictDataDisplay 
