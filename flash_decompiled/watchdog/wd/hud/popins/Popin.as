package wd.hud.popins {
    import flash.events.*;
    import wd.sound.*;
    import flash.display.*;
    import wd.hud.common.text.*;
    import wd.hud.common.graphics.*;
    import wd.hud.*;

    public class Popin extends HudElement {

        public static const ICON_WIDTH:uint = 43;

        protected var title:CustomTextField;
        protected var titleCtn:Sprite;
        protected var line:Line;
        protected var icon:Sprite;
        public var POPIN_WIDTH:uint = 476;
        protected var btnClose:Sprite;

        public function Popin(){
            super();
            this.addBtnClose();
        }
        protected function addBtnClose():void{
            this.btnClose = new CrossAsset();
            this.btnClose.x = (this.POPIN_WIDTH - this.btnClose.width);
            this.btnClose.buttonMode = true;
            this.btnClose.addEventListener(MouseEvent.CLICK, this.close);
            this.addChild(this.btnClose);
            addTweenInItem([this.btnClose, {alpha:0}, {alpha:1}]);
        }
        protected function close(e:Event=null):void{
            this.dispatchEvent(new Event("CLOSE"));
            SoundManager.playFX("ClicLieuxVille", 1);
        }
        protected function setTitle(str:String):void{
            this.titleCtn = new Sprite();
            this.title = new CustomTextField(str, "popinTitle");
            this.title.wordWrap = false;
            if (this.title.width > ((this.POPIN_WIDTH - ICON_WIDTH) - this.btnClose.width)){
                this.title.width = ((this.POPIN_WIDTH - ICON_WIDTH) - this.btnClose.width);
                this.title.wordWrap = true;
            };
            this.titleCtn.addChild(this.title);
            this.addChild(this.titleCtn);
            addTweenInItem([this.titleCtn, {alpha:0}, {alpha:1}]);
        }
        protected function setLine():void{
            this.line = new Line((this.POPIN_WIDTH - ICON_WIDTH), 0xFFFFFF);
            this.addChild(this.line);
            addTweenInItem([this.line, {scaleX:0}, {scaleX:1}]);
        }
        protected function setIcon(spr:Sprite=null):void{
            if (spr != null){
                this.icon = spr;
            } else {
                this.icon = new Sprite();
                this.icon.graphics.lineStyle(2, 0xFFFFFF);
                this.icon.graphics.drawCircle(0, 0, 20);
            };
            this.addChild(this.icon);
            addTweenInItem([this.icon, {alpha:0}, {alpha:1}]);
        }
        protected function disposeHeader():void{
            this.icon.x = (this.icon.y = (ICON_WIDTH / 2));
            this.title.x = ICON_WIDTH;
            this.line.x = ICON_WIDTH;
            this.line.y = (this.title.height + 10);
        }
        public function open():void{
        }
        public function clear():void{
        }

    }
}//package wd.hud.popins 
