package wd.hud.tutorial {
    import wd.hud.common.text.*;
    import flash.display.*;

    public class TuorialCompassWindow extends TutorialWindow {

        private var icons:Sprite;

        public function TuorialCompassWindow(xmlData:XML, index:uint, w:uint=300){
            super(xmlData, index, w);
        }
        override protected function setNextButton(label:String=""):void{
            super.setNextButton();
            this.icons = new ControlsAsset();
            this.icons.x = 0;
            this.icons.y = ((txt.y + txt.height) + 5);
            ctn.addChild(this.icons);
            var t1:CustomTextField = new CustomTextField(data.wheel, "tutoCompassText");
            t1.wordWrap = false;
            t1.x = (60 - (t1.width / 2));
            ctn.addChild(t1);
            var t2:CustomTextField = new CustomTextField(data.mouse, "tutoCompassText");
            t2.wordWrap = false;
            t2.x = (217 - (t2.width / 2));
            ctn.addChild(t2);
            var t3:CustomTextField = new CustomTextField(data.keyboard, "tutoCompassText");
            t3.wordWrap = false;
            t3.x = (390 - (t3.width / 2));
            ctn.addChild(t3);
            t1.y = (t2.y = (t3.y = ((this.icons.y + this.icons.height) - 20)));
            nextButton.y = ((t1.y + t1.height) + 5);
        }

    }
}//package wd.hud.tutorial 
