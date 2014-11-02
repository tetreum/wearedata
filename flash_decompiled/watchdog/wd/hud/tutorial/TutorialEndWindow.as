package wd.hud.tutorial {
    import wd.providers.texts.*;
    import flash.events.*;

    public class TutorialEndWindow extends TutorialWindow {

        public function TutorialEndWindow(xmlData:XML, index:uint, w:uint=300){
            super(xmlData, index, w);
        }
        override protected function setNextButton(label:String=""):void{
            super.setNextButton(TutorialText.btnOk);
        }
        override protected function setSkipButton():void{
            super.setSkipButton();
            skipButton.removeEventListener(MouseEvent.CLICK, clickSkip);
            skipButton.addEventListener(MouseEvent.CLICK, clickNext);
        }

    }
}//package wd.hud.tutorial 
