package wd.hud.popins.textpopin {
    import flash.events.*;
    import wd.hud.common.text.*;
    import flash.display.*;
    import aze.motion.*;
    import aze.motion.easing.*;
    import wd.hud.popins.*;

    public class TextPopin extends Popin {

        protected var text:CustomTextField;
        protected var MAX_HEIGHT:uint = 240;
        protected var txtY0:uint;
        protected var sbar:TextPopinScrollbar;
        protected var txtMask:Sprite;

        public function TextPopin(){
            super();
            this.MAX_HEIGHT = (this.MAX_HEIGHT * 1.7);
            POPIN_WIDTH = (POPIN_WIDTH * 1.2);
        }
        override protected function addBtnClose():void{
            btnClose = new CrossAsset();
            btnClose.x = ((POPIN_WIDTH * 1.2) - btnClose.width);
            btnClose.buttonMode = true;
            btnClose.addEventListener(MouseEvent.CLICK, close);
            this.addChild(btnClose);
            addTweenInItem([btnClose, {alpha:0}, {alpha:1}]);
        }
        protected function clearText():void{
            if (this.text){
                this.removeChild(this.text);
            };
            if (this.sbar){
                this.sbar.removeEventListener(TextPopinScrollbar.SCROLL_EVENT, this.scroll);
                this.removeChild(this.sbar);
                this.sbar = null;
            };
        }
        protected function setText(txt:String, cssClass:String="popinTextBtn"):void{
            this.clearText();
            this.text = new CustomTextField(txt, cssClass);
            this.text.width = (POPIN_WIDTH - ICON_WIDTH);
            this.text.x = ICON_WIDTH;
            this.text.y = (line.y + 10);
            this.addChild(this.text);
            addTweenInItem([this.text]);
            if (this.text.height > this.MAX_HEIGHT){
                this.txtY0 = this.text.y;
                this.text.width = (((POPIN_WIDTH - ICON_WIDTH) - TextPopinScrollbar.BAR_WIDTH) - 5);
                this.txtMask = new Sprite();
                this.txtMask.graphics.beginFill(0xFF0000, 0.5);
                this.txtMask.graphics.drawRect(0, 0, this.text.width, this.MAX_HEIGHT);
                this.txtMask.x = this.text.x;
                this.txtMask.y = this.text.y;
                this.addChild(this.txtMask);
                this.sbar = new TextPopinScrollbar(this.MAX_HEIGHT, this.text.height, this);
                this.sbar.x = ((this.text.x + this.text.width) + 5);
                this.sbar.y = this.text.y;
                this.addChild(this.sbar);
                addTweenInItem([this.sbar]);
                this.text.mask = this.txtMask;
                this.sbar.addEventListener(TextPopinScrollbar.SCROLL_EVENT, this.scroll);
            };
        }
        override public function get width():Number{
            return (super.width);
        }
        override public function set width(value:Number):void{
            super.width = value;
        }
        override public function get height():Number{
            return (((line.y + 10) + this.MAX_HEIGHT));
        }
        private function scroll(e:Event):void{
            eaze(this.text).easing(Cubic.easeOut).to(0.5, {y:(this.txtY0 - this.sbar.desty)});
        }

    }
}//package wd.hud.popins.textpopin 
