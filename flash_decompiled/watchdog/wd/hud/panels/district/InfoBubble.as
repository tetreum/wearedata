package wd.hud.panels.district {
    import flash.display.*;
    import wd.hud.common.text.*;
    import flash.events.*;
    import wd.providers.texts.*;
    import aze.motion.*;

    public class InfoBubble extends Sprite {

        private var bg:Sprite;
        private var ctf:CustomTextField;
        private var symbStart:DistrictPanelInfoBubbleStartAsset;
        private var symbEnd:DistrictPanelInfoBubbleEndAsset;
        private var symbClose:DistrictPanelInfoBubbleCloseAsset;

        public function InfoBubble(){
            super();
            this.bg = new Sprite();
            this.addChild(this.bg);
            this.ctf = new CustomTextField("", "infoPopin");
            this.addChild(this.ctf);
            this.symbStart = new DistrictPanelInfoBubbleStartAsset();
            this.addChild(this.symbStart);
            this.symbEnd = new DistrictPanelInfoBubbleEndAsset();
            this.addChild(this.symbEnd);
            this.symbEnd.x = -(this.symbEnd.width);
            this.symbClose = new DistrictPanelInfoBubbleCloseAsset();
            this.symbClose.x = ((-(this.symbEnd.width) - this.symbClose.width) - 8);
            this.symbClose.y = ((this.symbEnd.height - this.symbClose.height) / 2);
            this.symbClose.buttonMode = true;
            this.symbClose.mouseChildren = false;
            this.symbClose.addEventListener(MouseEvent.CLICK, this.close);
            this.addChild(this.symbClose);
            this.visible = false;
        }
        public function setText(propertyName:String):void{
            var txt:String = "";
            switch (propertyName){
                case "salary_monthly":
                    txt = StatsText.infoPopinTxtIncome;
                    break;
                case "unemployment":
                    txt = StatsText.infoPopinTxtUnemployment;
                    break;
                case "crimes_thousand":
                    txt = StatsText.infoPopinTxtCrime;
                    break;
                case "electricity":
                    txt = StatsText.infoPopinTxtElectricity;
                    break;
            };
            this.ctf.text = txt;
            this.ctf.width = 100;
            while (this.ctf.height > this.symbStart.height) {
                this.ctf.width = (this.ctf.width + 10);
            };
            this.ctf.x = ((this.symbClose.x - this.ctf.width) - 8);
            this.ctf.y = ((this.symbEnd.height - this.ctf.height) / 2);
            this.symbStart.x = ((this.ctf.x - this.symbStart.width) - 2);
            this.visible = true;
            this.alpha = 0;
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(0, 0.35);
            this.bg.graphics.drawRect(0, -1, this.width, this.height);
            this.bg.x = this.symbStart.x;
            eaze(this).to(0.4, {alpha:1});
        }
        private function close(e:MouseEvent):void{
            this.visible = false;
        }

    }
}//package wd.hud.panels.district 
