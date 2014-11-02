package wd.hud.tutorial {
    import flash.display.*;
    import wd.hud.common.text.*;
    import flash.events.*;
    import wd.providers.texts.*;
    import wd.hud.common.ui.*;
    import aze.motion.*;

    public class TutorialWindow extends Sprite {

        protected const PADDING_H:uint = 15;
        protected const PADDING_V:uint = 15;

        private var bg:Shape;
        protected var ctn:Sprite;
        protected var popinWidth:uint;
        protected var data:XML;
        protected var nextButton:SimpleButton;
        protected var skipButton:Sprite;
        protected var title:CustomTextField;
        protected var txt:CustomTextField;
        protected var pos:int = 1;

        public function TutorialWindow(xmlData:XML, index:uint, w:uint=300){
            super();
            this.pos = (index - 1);
            this.popinWidth = w;
            this.data = xmlData;
            this.setTexts();
            this.setNextButton();
            this.setSkipButton();
            this.setIndex();
            this.drawBg();
        }
        private function setTexts():void{
            this.ctn = new Sprite();
            this.addChild(this.ctn);
            this.bg = new Shape();
            this.ctn.addChild(this.bg);
            this.title = new CustomTextField(this.data.title, "tutoTitle");
            this.title.x = this.PADDING_H;
            this.title.y = (this.PADDING_V - 5);
            this.title.width = ((this.popinWidth - (this.PADDING_H * 2)) - 60);
            this.ctn.addChild(this.title);
            this.txt = new CustomTextField(this.data.text, "tutoText");
            this.txt.y = (this.title.y + this.title.height);
            this.txt.x = this.title.x;
            this.txt.width = (this.popinWidth - (this.PADDING_H * 2));
            this.ctn.addChild(this.txt);
        }
        protected function setSkipButton():void{
            this.skipButton = new BlackCrossAsset();
            this.skipButton.y = this.PADDING_V;
            this.skipButton.x = ((this.popinWidth - this.skipButton.width) - this.PADDING_H);
            this.skipButton.buttonMode = true;
            this.skipButton.mouseChildren = false;
            this.skipButton.addEventListener(MouseEvent.CLICK, this.clickSkip);
            this.ctn.addChild(this.skipButton);
        }
        protected function setNextButton(label:String=""):void{
            if (label == ""){
                label = TutorialText.btnNext;
            };
            this.nextButton = new SimpleButton(label, this.clickNext);
            this.nextButton.y = ((this.txt.y + this.txt.height) + 5);
            this.nextButton.x = ((this.popinWidth - this.PADDING_H) - this.nextButton.width);
            this.ctn.addChild(this.nextButton);
        }
        protected function drawBg():void{
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(0xFFFFFF, 0.85);
            this.bg.graphics.lineStyle(1, 0xFFFFFF, 0.85);
            this.bg.graphics.drawRect(0, 0, (this.ctn.width + (2 * this.PADDING_H)), ((this.ctn.height + this.PADDING_V) + 5));
        }
        protected function setIndex():void{
            var bg:Shape;
            var c:CustomTextField;
            if ((((this.pos > 0)) && ((this.pos < 8)))){
                bg = new Shape();
                bg.graphics.beginFill(0, 1);
                this.ctn.addChild(bg);
                c = new CustomTextField((this.pos + "/7"), "tutoIndex");
                c.wordWrap = false;
                bg.y = (c.y = this.PADDING_V);
                bg.x = (c.x = ((this.skipButton.x - c.width) - 10));
                this.ctn.addChild(c);
                bg.graphics.drawRect(0, 0, c.width, c.height);
            };
        }
        override public function set x(value:Number):void{
            trace(((x + "> ") + (stage.stageWidth / 2)));
            if (value > (stage.stageWidth / 2)){
                this.ctn.x = -(this.ctn.width);
            };
            super.x = value;
        }
        override public function set y(value:Number):void{
            if (value > (stage.stageHeight / 2)){
                this.ctn.y = -(this.ctn.height);
            };
            super.y = value;
        }
        public function show():void{
            this.visible = true;
            this.ctn.alpha = 0;
            this.nextButton.alpha = 0;
            eaze(this.ctn).to(0.5, {alpha:1});
            eaze(this.nextButton).delay(0.2).to(0.5, {alpha:1});
        }
        protected function clickNext(e:Event):void{
            this.dispatchEvent(new Event(TutorialManager.TUTORIAL_NEXT));
        }
        protected function clickSkip(e:Event):void{
            this.dispatchEvent(new Event(TutorialManager.TUTORIAL_SKIP));
        }
        protected function end(e:Event):void{
            this.dispatchEvent(new Event(TutorialManager.TUTORIAL_END));
        }

    }
}//package wd.hud.tutorial 
