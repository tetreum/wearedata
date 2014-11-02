package wd.hud.panels.district.distictDataDisplay {
    import wd.hud.common.text.*;
    import wd.hud.panels.district.*;

    public class DistrictDataAmount extends DistrictDataDisplay {

        private var unit:String = "XX";
        private var per:String = "XX";
        private var dataValue:CustomTextField;

        public function DistrictDataAmount(data:DistrictData, property:String, labelTxt:String, w:uint, _y:Number, unit:String, per:String=""){
            super(data, property, labelTxt, w, _y);
            this.unit = unit;
            this.per = per;
            this.dataValue = new CustomTextField("", ("statsPanelDataAmountValue_" + property));
            this.dataValue.x = 0;
            this.dataValue.y = (label.height - 5);
            this.dataValue.width = alowedWidth;
            value = data[property];
            this.addChild(this.dataValue);
        }
        override protected function render():void{
            super.render();
            var d:String = this.addDots(value.toFixed(0).toString());
            if ((((value == 0)) || ((value == -1)))){
                d = "--- ";
            };
            if (this.unit == "£"){
                this.dataValue.text = ((((this.unit + d.replace(".", ",")) + " <span class='statsPanelDataAmountUnitSmall'>") + this.per) + "</span>");
            } else {
                this.dataValue.text = ((((d + this.unit) + " <span class='statsPanelDataAmountUnitSmall'>") + this.per) + "</span>");
            };
        }
        private function addDots(val:String):String{
            var r:String = "";
            var pad:uint;
            if (val.length < 4){
                return (val);
            };
            var i:int = (val.length - 1);
            while (i >= 0) {
                r = val.charAt(i).concat(r);
                if ((((pad == 2)) && ((i > 0)))){
                    r = ".".concat(r);
                    pad = 0;
                } else {
                    pad++;
                };
                i--;
            };
            return (r);
        }

    }
}//package wd.hud.panels.district.distictDataDisplay 
