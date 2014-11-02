package wd.hud.popins.datapopins {
    import wd.hud.items.datatype.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import flash.display.*;
    import wd.hud.popins.datapopins.triangledatapopin.*;

    public class ElectromagneticPopin extends DataPopin {

        private var txt1:CustomTextField;
        private var txt2:CustomTextField;
        private var txtGps:CustomTextField;
        private var txtLatLabel:CustomTextField;
        private var txtLatData:CustomTextField;
        private var txtLongLabel:CustomTextField;
        private var txtLongData:CustomTextField;

        public function ElectromagneticPopin(data:Object){
            var expString:String;
            super(data);
            var vdata:ElectroMagneticTrackerData = (tdata as ElectroMagneticTrackerData);
            trace(("data :" + vdata));
            var valStr:String = "";
            var val:Number = parseFloat(vdata.level);
            var exp:int;
            if ((((val < 0.01)) && ((val > 0)))){
                while (val < 1) {
                    val = (val * 10);
                    exp = (exp + 1);
                };
            };
            if (exp > 0){
                expString = ((exp)<10) ? ("0" + exp.toString()) : exp.toString();
                valStr = ((val.toFixed(3).toString() + "E-") + expString);
            } else {
                valStr = vdata.level;
            };
            this.txt1 = new CustomTextField((((((valStr + " ") + CityTexts.electroMagneticFieldsLevelUnit) + " <span class=\"elecDataInfo\">") + CityTexts.electroMagneticFieldsLevelLabel) + "</span>"), "elecPopinTxt1");
            this.txt1.width = POPIN_WIDTH;
            this.txt1.y = (this.line.y + 20);
            this.addChild(this.txt1);
            addTweenInItem([this.txt1]);
            this.txt2 = new CustomTextField((((vdata.date + " <span class=\"elecDataInfo\">") + DataDetailText.electroMagneticFieldsMeasurementDate) + "</span>"), "elecPopinTxt1");
            this.txt2.width = POPIN_WIDTH;
            this.txt2.y = (this.txt1.y + this.txt1.height);
            this.addChild(this.txt2);
            addTweenInItem([this.txt2]);
            this.txt1.x = (this.txt2.x = ICON_WIDTH);
            var bgGps:Shape = new Shape();
            bgGps.graphics.lineStyle(1, 0xFFFFFF, 0.5);
            bgGps.graphics.beginFill(0, 1);
            bgGps.y = ((this.txt2.y + this.txt2.height) + 10);
            bgGps.x = ICON_WIDTH;
            this.addChild(bgGps);
            addTweenInItem([bgGps]);
            this.txtGps = new CustomTextField(DataDetailText.electroMagneticFieldsGpsCoordinates.toUpperCase(), "elecGps");
            this.txtGps.wordWrap = false;
            this.txtGps.x = (10 + ICON_WIDTH);
            this.addChild(this.txtGps);
            addTweenInItem([this.txtGps]);
            bgGps.graphics.drawRect(0, 0, (this.txtGps.width + 20), 25);
            this.txtGps.y = (bgGps.y + ((bgGps.height - this.txtGps.height) / 2));
            var d1:TriangleDataPopinData = new TriangleDataPopinData(CommonsText.latitude, tdata.lat);
            var d2:TriangleDataPopinData = new TriangleDataPopinData(CommonsText.longitude, tdata.lon);
            var td:TriangleDataPopin = new TriangleDataPopin(d1, d2);
            this.addChild(td);
            td.x = (bgGps.x + bgGps.width);
            td.y = (bgGps.y + bgGps.height);
            addTweenInItem([td, td.start]);
        }
        override protected function get titleData():String{
            return (DataDetailText.electroMagneticFields);
        }
        override protected function getIcon(type:uint):Sprite{
            var i:Sprite = new ElectroPopinIconAsset();
            return (i);
        }
        override protected function disposeHeader():void{
            super.disposeHeader();
            icon.x = (icon.y = 0);
        }

    }
}//package wd.hud.popins.datapopins 
