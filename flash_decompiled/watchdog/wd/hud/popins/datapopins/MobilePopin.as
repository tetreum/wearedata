package wd.hud.popins.datapopins {
    import wd.hud.common.text.*;
    import wd.hud.items.datatype.*;
    import wd.providers.texts.*;
    import flash.display.*;

    public class MobilePopin extends DataPopin {

        private var txt1:CustomTextField;

        public function MobilePopin(data:Object){
            var txt:String;
            super(data);
            this.txt1 = new CustomTextField("", "mobilePopinText");
            this.txt1.width = (POPIN_WIDTH - ICON_WIDTH);
            var out:String = "";
            if ((data as MobilesTrackerData).operator != null){
                txt = (data as MobilesTrackerData).operator.toLowerCase();
                if (txt.lastIndexOf("gsm") != -1){
                    out = (out + "2G");
                };
                if (txt.lastIndexOf("umt") != -1){
                    if (out != ""){
                        out = (out + "  ");
                    };
                    out = (out + "3G");
                };
                if (txt.lastIndexOf("lte") != -1){
                    if (out != ""){
                        out = (out + "  ");
                    };
                    out = (out + "4G");
                };
                if (out.length == 5){
                    out = out.substr(0, 2);
                };
            } else {
                out = DataLabel.mobile;
            };
            this.txt1.text = ((DataDetailText.mobileNetworks2G3G + " ") + out);
            this.txt1.y = line.y;
            this.txt1.x = ICON_WIDTH;
            this.addChild(this.txt1);
            addTweenInItem([this.txt1]);
        }
        override protected function getIcon(type:uint):Sprite{
            return (new MobilePopinIconAsset());
        }
        override protected function disposeHeader():void{
            super.disposeHeader();
            icon.x = (icon.y = 0);
        }

    }
}//package wd.hud.popins.datapopins 
