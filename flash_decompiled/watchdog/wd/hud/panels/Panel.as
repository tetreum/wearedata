package wd.hud.panels {
    import flash.events.*;
    import flash.utils.*;
    import flash.display.*;
    import aze.motion.*;
    import flash.text.*;
    import wd.hud.*;

    public class Panel extends HudElement {

        public static const LEFT_PANEL_WIDTH:uint = 160;
        public static const RIGHT_PANEL_WIDTH:uint = 190;
        public static const LINE_H_MARGIN:uint = 8;

        protected var title:TextField;
        protected var arrow:Sprite;
        protected var bg:Sprite;
        protected var reduced:Boolean = false;
        protected var expandedContainer:Sprite;
        protected var desactivateTimer:Timer;

        public function Panel(){
            super();
            this.addEventListener(MouseEvent.ROLL_OVER, this.rovHandler);
            this.addEventListener(MouseEvent.ROLL_OUT, this.rouHandler);
            this.desactivateTimer = new Timer(3000, 1);
            this.desactivateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, desactivate);
            this.expandedContainer = new Sprite();
            this.addChild(this.expandedContainer);
        }
        protected function addArrow(posX:uint):void{
            this.arrow = new ArrowAsset();
            this.arrow.x = posX;
            this.arrow.y = 24;
            this.arrow.buttonMode = true;
            this.arrow.addEventListener(MouseEvent.CLICK, this.reduceTrigger);
            this.addChild(this.arrow);
        }
        protected function reduceTrigger(e:Event):void{
            var destRotation:Number;
            var destAlpha:Number;
            if (this.reduced){
                this.reduced = false;
                eaze(this.arrow).to(0.3, {rotation:0});
                eaze(this.expandedContainer).to(0.3, {alpha:1});
            } else {
                this.reduced = true;
                eaze(this.arrow).to(0.3, {rotation:-180});
                eaze(this.expandedContainer).to(0.3, {alpha:0});
            };
            this.setBg(this.width, this.height);
        }
        protected function setBg(w:uint, h:uint):void{
            if (!(this.bg)){
                this.bg = new Sprite();
                this.addChildAt(this.bg, 0);
                addTweenInItem([this.bg]);
            } else {
                this.setChildIndex(this.bg, 0);
            };
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(0, 0.35);
            this.bg.graphics.drawRect(0, 0, w, h);
        }
        protected function rovHandler(e:Event):void{
            this.activate();
        }
        protected function rouHandler(e:Event):void{
            this.desactivateTimer.reset();
            this.desactivateTimer.start();
        }
        protected function enlight():void{
            this.activate();
            this.desactivateTimer.reset();
            this.desactivateTimer.start();
        }
        override protected function activate():void{
            super.activate();
            this.desactivateTimer.stop();
        }

    }
}//package wd.hud.panels 
