package wd.footer {
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import flash.display.*;
    import flash.events.*;
    import wd.hud.*;
    import flash.net.*;
    import wd.http.*;
    import wd.utils.*;
    import aze.motion.*;

    public class ShareMenu extends Sprite {

        public static const HEIGHT:uint = 20;
        public static const SQUARE_WIDTH:uint = 25;

        private const BG_ALPHA:Number = 0.32;
        private const ITEM_PADDING:uint = 10;
        private const config:Array;

        private var label:CustomTextField;
        private var iconsContainer:Sprite;
        private var bg:Shape;
        private var mouseZone:Shape;
        private var arrow:DropListArrowAsset;
        public var bgRenderStep:Number = 0;

        public function ShareMenu(){
            var d:Object;
            this.config = [{
                id:"mail",
                icon:new ShareIconLinkAsset(),
                click:this.clickMail
            }, {
                id:"gplus",
                icon:new ShareIconGplusAsset(),
                click:this.clickGplus
            }, {
                id:"fb",
                icon:new ShareIconFbAsset(),
                click:this.clickFb
            }, {
                id:"twitter",
                icon:new ShareIconTwitterAsset(),
                click:this.clickTwitter
            }];
            super();
            this.label = new CustomTextField(FooterText.share.toUpperCase(), "centerFooterItem");
            this.label.wordWrap = false;
            this.label.y = ((HEIGHT - this.label.height) / 2);
            this.addChild(this.label);
            this.bg = new Shape();
            this.bg.graphics.beginFill(0xFFFFFF, this.BG_ALPHA);
            this.bg.graphics.drawRoundRect(0, 0, SQUARE_WIDTH, HEIGHT, 4, 4);
            this.addChild(this.bg);
            this.bg.x = ((this.label.x + this.label.width) + 5);
            this.iconsContainer = new Sprite();
            this.iconsContainer.visible = false;
            this.iconsContainer.y = ((-((HEIGHT + this.ITEM_PADDING)) * this.config.length) + 5);
            this.iconsContainer.x = (this.bg.x + 4);
            this.addChild(this.iconsContainer);
            var y0:int;
            for each (d in this.config) {
                this.addItem(d, y0);
                y0 = (y0 + (HEIGHT + this.ITEM_PADDING));
            };
            this.mouseZone = new Shape();
            this.mouseZone.graphics.beginFill(0xFF0000, 0);
            this.mouseZone.graphics.drawRect(0, 0, ((this.label.width + SQUARE_WIDTH) + 5), HEIGHT);
            this.addChildAt(this.mouseZone, 0);
            this.addEventListener(MouseEvent.ROLL_OVER, this.expand);
            this.addEventListener(MouseEvent.ROLL_OUT, this.reduce);
            this.arrow = new DropListArrowAsset();
            this.arrow.x = (this.bg.x + (SQUARE_WIDTH / 2));
            this.arrow.y = ((HEIGHT / 2) - 2);
            this.addChild(this.arrow);
        }
        private function addItem(d:Object, posY:uint):void{
            var it:ShareMenuItem = new ShareMenuItem(d.id, d.icon, d.click, HEIGHT, HEIGHT);
            it.y = posY;
            this.iconsContainer.addChild(it);
        }
        private function renderBg():void{
            var h:int = (HEIGHT + (this.bgRenderStep * ((this.mouseZone.height - HEIGHT) - 10)));
            var dy:int = ((-((HEIGHT + this.ITEM_PADDING)) * this.config.length) * this.bgRenderStep);
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(0xFFFFFF, this.BG_ALPHA);
            this.bg.graphics.drawRoundRect(0, 0, SQUARE_WIDTH, h, 3, 3);
            this.bg.y = dy;
        }
        private function clickMail(e:Event):void{
            this.dispatchEvent(new Event(HudEvents.OPEN_SHARE_LINK_POPIN, true));
        }
        private function clickMailCallBack(shortened:String):void{
            navigateToURL(new URLRequest(((("mailto:?subject=" + ShareText.FBGtitle) + "&body=") + shortened)));
        }
        private function clickGplus(e:Event):void{
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_SHARE_GOOGLE);
            URLFormater.shorten(this.googleCallBack);
        }
        private function googleCallBack(shortened:String):void{
            JsPopup.open(((("https://plus.google.com/share?url=" + shortened) + "&text=") + URLFormater.replaceTags(ShareText.TwitterText)));
        }
        private function clickTwitter(e:Event):void{
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_SHARE_TWITTER);
            URLFormater.shorten(this.twitterCallBack, URLFormater.SHARE_TO_TWITTER);
        }
        private function twitterCallBack(shortened:String):void{
            JsPopup.open(((("https://twitter.com/intent/tweet?url=" + shortened) + "&text=") + URLFormater.replaceTags(ShareText.TwitterText)));
        }
        private function clickFb(e:Event):void{
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_SHARE_FACEBOOK);
            FacebookConnector.share();
        }
        private function expand(e:Event):void{
            this.mouseZone.height = ((HEIGHT + this.ITEM_PADDING) * (this.config.length + 1));
            this.mouseZone.y = (-((HEIGHT + this.ITEM_PADDING)) * this.config.length);
            this.iconsContainer.visible = true;
            eaze(this.arrow).to(0.25, {
                rotation:-180,
                y:((HEIGHT / 2) + 2)
            });
            eaze(this).to(0.25, {bgRenderStep:1}).onUpdate(this.renderBg);
            eaze(this.iconsContainer).delay(0.25).to(0.25, {alpha:1});
        }
        private function reduce(e:Event=null):void{
            this.mouseZone.y = 0;
            eaze(this.iconsContainer).to(0.25, {alpha:0});
            eaze(this).delay(0.25).to(0.25, {bgRenderStep:0}).onUpdate(this.renderBg);
            eaze(this.arrow).to(0.25, {
                rotation:0,
                y:((HEIGHT / 2) - 2)
            });
        }

    }
}//package wd.footer 

import flash.display.*;
import flash.events.*;

class ShareMenuItem extends Sprite {

    private var id:String;

    public function ShareMenuItem(id:String, icon:Sprite, clickFunc:Function, w:uint, h:uint){
        super();
        var sh:Shape = new Shape();
        sh.graphics.beginFill(0xFF0000, 0);
        sh.graphics.drawRect(0, 0, w, h);
        this.addChild(sh);
        this.addChild(icon);
        this.buttonMode = true;
        this.addEventListener(MouseEvent.CLICK, clickFunc);
        this.addChild(icon);
    }
}
