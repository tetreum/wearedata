package wd.hud.tutorial {
    import wd.hud.common.ui.*;
    import wd.providers.texts.*;
    import flash.events.*;
    import aze.motion.*;

    public class TutorialWindowIntro extends TutorialWindow {

        private var btnNok:SimpleButton;

        public function TutorialWindowIntro(xmlData:XML, index:uint, w:uint=300, skipped:Boolean=false){
            super(xmlData, w);
            if (skipped){
                this.clickNok();
            };
        }
        override protected function setNextButton(label:String=""):void{
            nextButton = new SimpleButton(TutorialText.btnOk, clickNext);
            nextButton.y = ((txt.y + txt.height) + 5);
            nextButton.x = PADDING_H;
            ctn.addChild(nextButton);
            this.btnNok = new SimpleButton(TutorialText.btnNok, this.clickNok);
            this.btnNok.y = ((txt.y + txt.height) + 5);
            this.btnNok.x = ((nextButton.x + nextButton.width) + 5);
            ctn.addChild(this.btnNok);
        }
        private function clickNok(e:Event=null):void{
            txt.text = TutorialText.xml.step1.textRemember;
            ctn.removeChild(this.btnNok);
            ctn.removeChild(nextButton);
            skipButton.removeEventListener(MouseEvent.CLICK, clickSkip);
            skipButton.addEventListener(MouseEvent.CLICK, end);
        }
        override public function show():void{
            super.show();
            this.btnNok.alpha = 0;
            eaze(this.btnNok).delay(0.3).to(0.5, {alpha:1});
        }

    }
}//package wd.hud.tutorial 
