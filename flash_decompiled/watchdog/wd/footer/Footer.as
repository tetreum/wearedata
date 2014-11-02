package wd.footer {
    import wd.providers.texts.*;
    import wd.core.*;
    import flash.display.*;
    import wd.hud.common.graphics.*;
    import wd.hud.aidenMessages.*;
    import flash.net.*;
    import flash.events.*;
    import wd.http.*;
    import wd.hud.*;
    import wd.sound.*;
    import aze.motion.*;
    import wd.hud.common.text.*;
    import wd.utils.*;
    import flash.geom.*;
    import wd.hud.popins.*;

    public class Footer extends HudElement {

        public static const FOOTER_HEIGHT:uint = 36;

        public static var tutoStartPoint:Point;
        public static var tutoStartPoint2:Point;

        private const FOOTER_MARGIN:uint = 20;
        private const LEFT_ITEMS_PADDING:uint = 26;
        private const LEFT_FOOTER_STRUCTURE:Array;

        private var line:Line;
        private var bg:Shape;
        private var leftItemsContainer:Sprite;
        private var citySelector:CitySelector;
        private var shareMenu:ShareMenu;
        protected var tuto:Sprite;
        private var aidenMessages:AidenMessages;
        private var helpButton:Sprite;
        private var ubiBtn:Sprite;
        private var sndBtnMask:Sprite;
        private var HQLabel:CustomTextField;
        private var _main:Main;
        private var _popin:PopinsManager;
        private var fullScreenAllowed:Boolean = true;

        public function Footer(main:Main){
            this.LEFT_FOOTER_STRUCTURE = [{
                label:FooterText.about,
                func:this.clickAbout
            }, {
                label:FooterText.legals,
                func:this.clickLegals
            }, {
                label:FooterText.help,
                func:this.clickHelp,
                isHelp:true
            }, {
                label:FooterText.languages,
                func:this.clickLanguages
            }, {
                asset:"SOUND",
                func:this.clickSound
            }, {
                asset:"FULLSCREEN",
                func:this.clickFullscreen
            }, {
                label:FooterText.hq,
                func:this.clickQualityswitch
            }];
            super();
            this.main = main;
            this.fullScreenAllowed = (Config.AGENT.toLowerCase().lastIndexOf("chrome") == -1);
            this.bg = new Shape();
            this.bg.graphics.beginFill(0, 0.5);
            this.bg.graphics.drawRect(0, 0, 1, FOOTER_HEIGHT);
            this.addChild(this.bg);
            addTweenInItem([this.bg, {alpha:0}, {alpha:1}]);
            this.line = new Line(1, 0xFFFFFF);
            this.line.alpha = 0.3;
            this.addChild(this.line);
            addTweenInItem([this.line, {scaleX:0}, {scaleX:1}]);
            var logo:Sprite = new FooterLogoAsset();
            this.addChild(logo);
            addTweenInItem([logo, {alpha:0}, {alpha:1}]);
            var l:Sprite = new Sprite();
            l.graphics.lineStyle(1, 0xFFFFFF, 1, false, "normal", CapsStyle.SQUARE);
            l.graphics.lineTo(0, 20);
            l.y = ((FOOTER_HEIGHT - l.height) / 2);
            l.x = ((logo.x + logo.width) + 17);
            l.alpha = 0.5;
            this.addChild(l);
            addTweenInItem([l, {scaleY:0}, {scaleY:1}]);
            var wdBtn:Sprite = this.makeItem({
                label:FooterText.watchdogs,
                func:this.openWdLink
            });
            wdBtn.x = (l.x + this.LEFT_ITEMS_PADDING);
            wdBtn.y = ((FOOTER_HEIGHT - wdBtn.height) / 2);
            addTweenInItem([wdBtn, {alpha:0}, {alpha:0.5}]);
            this.addChild(wdBtn);
            this.ubiBtn = this.makeItem({
                label:FooterText.ubisoft,
                func:this.openUbiLink
            });
            this.ubiBtn.x = ((wdBtn.x + wdBtn.width) + this.LEFT_ITEMS_PADDING);
            this.ubiBtn.y = ((FOOTER_HEIGHT - this.ubiBtn.height) / 2);
            addTweenInItem([this.ubiBtn, {alpha:0}, {alpha:0.5}]);
            this.addChild(this.ubiBtn);
            this.citySelector = new CitySelector();
            this.citySelector.y = ((FOOTER_HEIGHT - CitySelector.ITEM_HEIGHT) / 2);
            this.addChild(this.citySelector);
            addTweenInItem([this.citySelector, {alpha:0}, {alpha:1}]);
            this.shareMenu = new ShareMenu();
            this.shareMenu.y = ((FOOTER_HEIGHT - ShareMenu.HEIGHT) / 2);
            this.addChild(this.shareMenu);
            addTweenInItem([this.shareMenu, {alpha:0}, {alpha:1}]);
            this.aidenMessages = new AidenMessages();
            this.addChild(this.aidenMessages);
            this.aidenMessages.start();
            this.makeLeftItems();
            tweenInBaseDelay = 0.1;
            tweenInSpeed = 0.5;
            tweenIn();
        }
        private function openUbiLink(e:MouseEvent):void{
            navigateToURL(new URLRequest(FooterText.ubisoft_link), "_blank");
        }
        private function openWdLink(e:MouseEvent):void{
            navigateToURL(new URLRequest(FooterText.watchdogs_link), "_blank");
        }
        public function showIntroItems():void{
        }
        public function showAllItems():void{
        }
        public function reset():void{
        }
        private function clickAbout(e:MouseEvent):void{
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_ABOUT);
            this.dispatchEvent(new Event(HudEvents.OPEN_ABOUT_POPIN));
        }
        private function clickLegals(e:MouseEvent):void{
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_LEGALS);
            this.dispatchEvent(new Event(HudEvents.OPEN_LEGALS_POPIN));
        }
        private function clickHelp(e:MouseEvent):void{
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_HELP);
            this.dispatchEvent(new Event(HudEvents.OPEN_HELP_POPIN));
        }
        private function clickLanguages(e:MouseEvent):void{
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_LANGUAGE);
            this.dispatchEvent(new Event(HudEvents.OPEN_LANG_POPIN));
        }
        private function clickQualityswitch(e:MouseEvent):void{
            AppState.isHQ = !(AppState.isHQ);
            if (AppState.isHQ){
                this.HQLabel.text = FooterText.hq;
            } else {
                this.HQLabel.text = FooterText.lq;
            };
            this.dispatchEvent(new Event(HudEvents.QUALITY_CHANGE));
        }
        private function clickSound(e:MouseEvent):void{
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_SOUND);
            SoundManager.swapMute(null);
            if (SoundManager.MASTER_VOLUME == 0){
                eaze(this.sndBtnMask).to(0.5, {
                    y:10,
                    height:3
                });
            } else {
                eaze(this.sndBtnMask).to(0.5, {
                    y:0,
                    height:14
                });
            };
        }
        private function clickFullscreen(e:MouseEvent):void{
            GoogleAnalytics.callPageView(GoogleAnalytics.FOOTER_FULLSCREEN);
            this.main.stage.displayState = (((this.main.stage.displayState == StageDisplayState.FULL_SCREEN)) ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN);
            this.main.onResize();
        }
        private function makeLeftItems(isIntro:Boolean=true):void{
            var b:Sprite;
            this.leftItemsContainer = new Sprite();
            var w:uint;
            var i:uint;
            while (i < this.LEFT_FOOTER_STRUCTURE.length) {
                if (((this.fullScreenAllowed) || (!((this.LEFT_FOOTER_STRUCTURE[i].asset == "FULLSCREEN"))))){
                    b = this.makeItem(this.LEFT_FOOTER_STRUCTURE[i]);
                    b.x = w;
                    w = (w + (b.width + this.LEFT_ITEMS_PADDING));
                    b.alpha = 0;
                    if (this.LEFT_FOOTER_STRUCTURE[i].isHelp){
                        this.helpButton = b;
                    };
                    this.leftItemsContainer.addChild(b);
                    addTweenInItem([b, {
                        alpha:0,
                        y:20
                    }, {
                        alpha:0.5,
                        y:0
                    }]);
                };
                i++;
            };
            this.leftItemsContainer.y = ((FOOTER_HEIGHT - this.leftItemsContainer.height) / 2);
            this.addChild(this.leftItemsContainer);
        }
        private function makeItem(data:Object):Sprite{
            var t:CustomTextField;
            var _local4:Sprite;
            var r:Sprite = new Sprite();
            if (data.label){
                t = new CustomTextField(data.label.toUpperCase(), "leftFooterItem");
                t.wordWrap = false;
                r.addChild(t);
                if (data.label == FooterText.hq){
                    this.HQLabel = t;
                    t.text = ((SharedData.isHq) ? FooterText.hq : FooterText.lq);
                };
            } else {
                if (data.asset){
                    switch (data.asset){
                        case "SOUND":
                            _local4 = new SoundBtnAsset();
                            this.sndBtnMask = new Sprite();
                            this.sndBtnMask.graphics.beginFill(0xFF, 0.5);
                            this.sndBtnMask.graphics.drawRect(0, 0, _local4.width, _local4.height);
                            if (SoundManager.MASTER_VOLUME == 0){
                                this.sndBtnMask.y = 10;
                                this.sndBtnMask.height = 3;
                            };
                            r.graphics.beginFill(0xFF0000, 0);
                            r.graphics.drawRect(0, 0, _local4.width, _local4.height);
                            r.addChild(_local4);
                            r.addChild(this.sndBtnMask);
                            _local4.mask = this.sndBtnMask;
                            break;
                        case "FULLSCREEN":
                            r.addChild(new FullscreenBtnAsset());
                            break;
                    };
                };
            };
            r.mouseChildren = false;
            r.buttonMode = true;
            r.addEventListener(MouseEvent.ROLL_OVER, this.leftItemRov);
            r.addEventListener(MouseEvent.ROLL_OUT, this.leftItemRou);
            r.addEventListener(MouseEvent.CLICK, data.func);
            r.alpha = 0.5;
            return (r);
        }
        private function leftItemRov(e:MouseEvent):void{
            eaze(e.target).to(0.7, {alpha:1});
        }
        private function leftItemRou(e:MouseEvent):void{
            eaze(e.target).to(0.5, {alpha:0.5});
        }
        public function resize(stageWidth:uint, stageHeight:uint):void{
            this.y = (stageHeight - FOOTER_HEIGHT);
            this.x = this.FOOTER_MARGIN;
            this.line.width = (stageWidth - (2 * this.FOOTER_MARGIN));
            this.bg.width = (stageWidth - (2 * this.FOOTER_MARGIN));
            this.leftItemsContainer.x = (this.bg.width - this.leftItemsContainer.width);
            this.citySelector.x = (((this.ubiBtn.x + this.ubiBtn.width) + (((stageWidth - this.leftItemsContainer.width) - (this.ubiBtn.x + this.ubiBtn.width)) / 2)) - this.citySelector.width);
            this.shareMenu.x = ((this.citySelector.x + this.citySelector.width) + 10);
            if (this.tuto){
                this.tuto.x = this.citySelector.x;
            };
            if (this.popin != null){
                this.popin.resize();
            };
            this.aidenMessages.resize();
        }
        public function get main():Main{
            return (this._main);
        }
        public function set main(value:Main):void{
            this._main = value;
        }
        override public function set x(value:Number):void{
            super.x = value;
            tutoStartPoint = new Point((((this.x + this.leftItemsContainer.x) + this.helpButton.x) + (this.helpButton.width / 2)), this.y);
            tutoStartPoint2 = new Point(((this.x + this.citySelector.x) + (this.citySelector.width / 2)), this.y);
        }
        override public function set y(value:Number):void{
            super.y = value;
            tutoStartPoint = new Point((((this.x + this.leftItemsContainer.x) + this.helpButton.x) + (this.helpButton.width / 2)), this.y);
            tutoStartPoint2 = new Point(((this.x + this.citySelector.x) + (this.citySelector.width / 2)), this.y);
        }
        public function get popin():PopinsManager{
            return (this._popin);
        }
        public function set popin(value:PopinsManager):void{
            this._popin = value;
        }

    }
}//package wd.footer 
