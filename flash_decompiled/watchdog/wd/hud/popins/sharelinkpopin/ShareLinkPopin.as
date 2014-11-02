package wd.hud.popins.sharelinkpopin {
    import wd.providers.texts.*;
    import flash.display.*;
    import wd.hud.common.text.*;
    import flash.events.*;
    import wd.http.*;
    import wd.utils.*;
    import flash.system.*;
    import wd.hud.popins.*;

    public class ShareLinkPopin extends Popin {

        public static const BAR_HEIGHT:uint = 33;

        private var copyBtn:Sprite;
        private var txtLink:CustomTextField;

        public function ShareLinkPopin(){
            super();
            setTitle(FooterText.share);
            setLine();
            setIcon(new Sprite());
            disposeHeader();
            var txt:CustomTextField = new CustomTextField(ShareText.FBGtitle, "sharePopinTxt");
            txt.width = (POPIN_WIDTH - ICON_WIDTH);
            this.addChild(txt);
            txt.y = (line.y + 5);
            txt.x = line.x;
            addTweenInItem([txt]);
            var btn:CopyButton = new CopyButton();
            btn.addEventListener(MouseEvent.CLICK, this.copyClick);
            var bg:Sprite = new Sprite();
            bg.graphics.beginFill(0xFFFFFF, 1);
            bg.graphics.drawRect(0, 0, ((POPIN_WIDTH - ICON_WIDTH) - btn.width), BAR_HEIGHT);
            bg.y = ((txt.y + txt.height) + 5);
            bg.x = line.x;
            btn.x = (bg.x + bg.width);
            btn.y = bg.y;
            var icon:Sprite = new SharePopinLinkAsset();
            icon.x = 10;
            icon.y = ((BAR_HEIGHT - icon.height) / 2);
            bg.addChild(icon);
            this.txtLink = new CustomTextField(" ", "sharePopinLink");
            this.txtLink.wordWrap = false;
            this.txtLink.y = (bg.y + ((BAR_HEIGHT - this.txtLink.height) / 2));
            this.txtLink.x = (((bg.x + icon.x) + icon.width) + 10);
            this.addChild(bg);
            addTweenInItem([bg]);
            this.addChild(this.txtLink);
            this.addChild(btn);
            addTweenInItem([btn]);
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_SHARE_URLCOPY);
            URLFormater.shorten(this.setShortLink);
        }
        private function setShortLink(l:String):void{
            this.txtLink.text = l;
        }
        private function copyClick(e:Event):void{
            System.setClipboard(this.txtLink.text);
        }

    }
}//package wd.hud.popins.sharelinkpopin 

import flash.display.*;
import wd.hud.common.text.*;
import flash.events.*;
import aze.motion.*;

class CopyButton extends Sprite {

    private var rovState:Sprite;
    private var rouState:Sprite;

    public function CopyButton():void{
        super();
        var txtRov:CustomTextField = new CustomTextField("COPY", "sharePopinBtn_rollover");
        txtRov.wordWrap = false;
        this.rovState = new Sprite();
        this.rovState.graphics.lineStyle(1, 0, 1, false, "normal", CapsStyle.SQUARE);
        this.rovState.graphics.beginFill(0xFFFFFF, 1);
        this.rovState.graphics.drawRect(0, 0, (txtRov.width + 40), 33);
        txtRov.x = ((this.rovState.width - txtRov.width) / 2);
        txtRov.y = ((this.rovState.height - txtRov.height) / 2);
        this.rovState.addChild(txtRov);
        var txtRou:CustomTextField = new CustomTextField("COPY", "sharePopinBtn_rollout");
        txtRou.wordWrap = false;
        this.rouState = new Sprite();
        this.rouState.graphics.lineStyle(1, 0xFFFFFF, 0.5, false, "normal", CapsStyle.SQUARE);
        this.rouState.graphics.beginFill(0, 1);
        this.rouState.graphics.drawRect(0, 0, (txtRov.width + 40), 33);
        txtRou.x = ((this.rouState.width - txtRou.width) / 2);
        txtRou.y = ((this.rouState.height - txtRou.height) / 2);
        this.rouState.addChild(txtRou);
        this.addChild(this.rovState);
        this.addChild(this.rouState);
        this.buttonMode = true;
        this.mouseChildren = false;
        this.addEventListener(MouseEvent.ROLL_OVER, this.rov);
        this.addEventListener(MouseEvent.ROLL_OUT, this.rou);
    }
    private function rov(e:Event):void{
        eaze(this.rouState).to(0.5, {alpha:0});
        eaze(this.rovState).to(0.5, {alpha:1});
    }
    private function rou(e:Event):void{
        eaze(this.rouState).to(0.5, {alpha:1});
        eaze(this.rovState).to(0.5, {alpha:0});
    }

}
