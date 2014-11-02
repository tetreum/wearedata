package wd.hud.aidenMessages {
    import flash.display.*;
    import flash.events.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import flash.net.*;
    import flash.utils.*;
    import aze.motion.*;
    import wd.landing.effect.*;
    import wd.hud.panels.*;

    public class AidenMessages extends Sprite {

        private var timerMessages:Timer;
        private var timerAutoHide:Timer;
        private var container:Sprite;
        private var bg:Sprite;
        private var txtContainer:Sprite;
        private var title:CustomTextField;
        private var txt:CustomTextField;
        private var link:CustomTextField;
        private var img:AidanFaceAsset;
        private var messageIndex:int = 0;
        private var POPIN_WIDH:uint = 400;
        private var btnClose:DistrictPanelInfoBubbleCloseAsset;
        private var stopped:Boolean = false;

        public function AidenMessages(){
            super();
            this.container = new Sprite();
            this.bg = new Sprite();
            this.bg.buttonMode = true;
            this.bg.addEventListener(MouseEvent.CLICK, this.gotoLink);
            this.container.addChild(this.bg);
            this.txtContainer = new Sprite();
            this.title = new CustomTextField(AidenTexts.xml.aidenName, "aidenMessageTitle");
            this.title.wordWrap = false;
            this.txtContainer.addChild(this.title);
            this.txt = new CustomTextField("Empty<br/>Empty", "aidenMessageText");
            this.txt.y = this.title.height;
            this.txt.width = 281;
            this.txtContainer.buttonMode = true;
            this.txtContainer.mouseChildren = false;
            this.txtContainer.addEventListener(MouseEvent.CLICK, this.gotoLink);
            this.txtContainer.addChild(this.txt);
            this.link = new CustomTextField(AidenTexts.xml.link_label, "aidenMessageLink");
            this.link.y = (this.txt.y + this.txt.height);
            this.link.wordWrap = false;
            this.txtContainer.addChild(this.link);
            this.img = new AidanFaceAsset();
            this.img.x = 17;
            this.img.y = 17;
            this.img.buttonMode = true;
            this.img.addEventListener(MouseEvent.CLICK, this.gotoLink);
            this.container.addChild(this.img);
            this.txtContainer.y = (this.img.y - 5);
            this.txtContainer.x = ((this.img.x + this.img.width) + 7);
            this.container.addChild(this.txtContainer);
            this.btnClose = new DistrictPanelInfoBubbleCloseAsset();
            this.btnClose.y = 17;
            this.btnClose.x = ((this.POPIN_WIDH - 17) - this.btnClose.width);
            this.btnClose.buttonMode = true;
            this.btnClose.addEventListener(MouseEvent.CLICK, this.stopItNow);
            this.container.addChild(this.btnClose);
            this.addChild(this.container);
            this.setBg();
            this.alpha = 0;
            this.visible = false;
        }
        public function gotoLink(e:Event):void{
            navigateToURL(new URLRequest(AidenTexts.xml.link_url), "_blank");
        }
        public function stopItNow(e:Event):void{
            this.stopped = true;
            this.hideMessage(e);
        }
        public function start():void{
            this.timerMessages = new Timer((1000 * 60), 1);
            this.timerMessages.addEventListener(TimerEvent.TIMER_COMPLETE, this.showMessage);
            this.timerMessages.start();
            this.timerAutoHide = new Timer(5000, 1);
            this.timerAutoHide.addEventListener(TimerEvent.TIMER_COMPLETE, this.hideMessage);
        }
        public function showMessage(e:Event):void{
            this.txt.text = AidenTexts.xml.meassages.message[this.messageIndex];
            this.link.y = (this.txt.y + this.txt.height);
            this.setBg();
            this.resize();
            this.alpha = 0;
            this.visible = true;
            eaze(this).to(0.5, {alpha:1});
            this.timerAutoHide.reset();
            this.timerAutoHide.start();
            this.messageIndex++;
            if (this.messageIndex == AidenTexts.xml.meassages.message.length()){
                this.messageIndex = 0;
            };
            DistortImg_sglT.instance.startEffect(this.container, 50);
        }
        private function hideMessage(e:Event):void{
            eaze(this).to(0.5, {alpha:0}).onComplete(this.disable);
            DistortImg_sglT.instance.startEffect(this.container, 50);
        }
        private function disable():void{
            if (!(this.stopped)){
                this.timerMessages.reset();
                this.timerMessages.start();
            };
            this.visible = false;
        }
        private function setBg():void{
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(0xFFFFFF, 0.2);
            this.bg.graphics.drawRect(0, 0, this.POPIN_WIDH, (((this.txtContainer.y + this.link.y) + this.link.height) + 17));
        }
        override public function get width():Number{
            return (this.POPIN_WIDH);
        }
        override public function set width(value:Number):void{
            super.width = value;
        }
        override public function get height():Number{
            return (this.bg.height);
        }
        override public function set height(value:Number):void{
            super.height = value;
        }
        public function resize():void{
            this.x = (((stage.stageWidth - Panel.RIGHT_PANEL_WIDTH) - 65) - this.width);
            this.y = (-(this.height) - 25);
        }

    }
}//package wd.hud.aidenMessages 
