package wd.hud.popins.datapopins {
    import wd.hud.common.text.*;
    import wd.hud.items.datatype.*;
    import wd.providers.texts.*;
    import flash.display.*;

    public class AdPopin extends DataPopin {

        private var txt1:CustomTextField;

        public function AdPopin(data:Object){
            super(data);
            this.txt1 = new CustomTextField(((((Math.round((int((tdata as AdsTrackerData).weekviews) / 1000)) * 1000) + " <span class=\"adPopinTxt2\">") + CityTexts.adConsumerExposedUnit) + "</span>"), "adPopinTxt1");
            this.txt1.width = (POPIN_WIDTH - ICON_WIDTH);
            this.txt1.y = line.y;
            this.txt1.x = ICON_WIDTH;
            addTweenInItem([this.txt1, {alpha:0}, {alpha:1}]);
            this.addChild(this.txt1);
        }
        override protected function getIcon(type:uint):Sprite{
            return (new AdPopinIconAsset());
        }
        override protected function disposeHeader():void{
            super.disposeHeader();
            icon.x = (icon.y = 0);
        }

    }
}//package wd.hud.popins.datapopins 
