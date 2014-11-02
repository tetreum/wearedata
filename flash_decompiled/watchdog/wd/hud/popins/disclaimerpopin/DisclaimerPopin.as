package wd.hud.popins.disclaimerpopin {
    import wd.providers.texts.*;
    import flash.display.*;
    import wd.hud.common.text.*;
    import wd.hud.popins.*;
    import wd.http.*;
    import flash.events.*;

    public class DisclaimerPopin extends Popin {

        public function DisclaimerPopin(){
            super();
            setTitle(LiveActivitiesText.popinTitle);
            setIcon(new Sprite());
            setLine();
            disposeHeader();
            var txt:CustomTextField = new CustomTextField(LiveActivitiesText.disclaimerText, "disclaimerPopinText");
            txt.x = ICON_WIDTH;
            txt.y = (line.y + 10);
            txt.width = (POPIN_WIDTH - ICON_WIDTH);
            this.addChild(txt);
            addTweenInItem([txt]);
            var okButton:PopinButton = new PopinButton(LiveActivitiesText.okButton, this.clickOk);
            var cancelButton:PopinButton = new PopinButton(LiveActivitiesText.cancelButton, close);
            this.addChild(okButton);
            this.addChild(cancelButton);
            addTweenInItem([okButton]);
            addTweenInItem([cancelButton]);
            cancelButton.y = (okButton.y = ((txt.y + txt.height) + 30));
            cancelButton.x = (POPIN_WIDTH - cancelButton.width);
            okButton.x = (((POPIN_WIDTH - cancelButton.width) - okButton.width) - 30);
        }
        private function clickOk(e:Event):void{
            FacebookConnector.login();
            GoogleAnalytics.callPageView(GoogleAnalytics.APP_FACEBOOK_DISCLAIMER);
            close();
        }

    }
}//package wd.hud.popins.disclaimerpopin 
