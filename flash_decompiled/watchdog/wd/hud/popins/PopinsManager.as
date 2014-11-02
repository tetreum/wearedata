package wd.hud.popins {
    import flash.display.*;
    import flash.events.*;
    import wd.hud.mentions.*;
    import wd.d3.*;
    import wd.hud.items.*;
    import wd.core.*;
    import wd.hud.popins.datapopins.*;
    import wd.http.*;
    import wd.hud.popins.disclaimerpopin.*;
    import wd.hud.popins.legalspopin.*;
    import wd.hud.popins.aboutpopin.*;
    import wd.hud.popins.langpopin.*;
    import wd.hud.popins.sharelinkpopin.*;
    import wd.hud.*;
    import wd.sound.*;
    import aze.motion.*;
    import wd.footer.*;
    import wd.hud.panels.*;

    public class PopinsManager extends Sprite {

        private const BG_ALPHA:Number = 0.75;

        private var _currentPopin:Popin;
        private var bg:Sprite;
        private var sim:Simulation;
        private var mentions:Mentions;

        public function PopinsManager(sim:Simulation){
            super();
            this.sim = sim;
            this.bg = new Sprite();
            this.bg.addEventListener(MouseEvent.MOUSE_DOWN, this.onBgMouseDown);
            this.bg.visible = false;
            this.bg.alpha = 0;
            this.addChild(this.bg);
            this.mentions = new Mentions();
            this.addChild(this.mentions);
        }
        private function onBgMouseDown(e:MouseEvent):void{
            this.hide(null);
        }
        public function clear():void{
            if (((this.currentPopin) && (this.contains(this.currentPopin)))){
                this.currentPopin.removeEventListener("CLOSE", this.hide);
                this.removeChild(this.currentPopin);
                this.currentPopin = null;
            };
        }
        public function openPopin(data:Object):void{
            var tdata:TrackerData;
            var e:Event;
            this.clear();
            if (!((((data is Event)) || ((data is TrackerData))))){
                trace("Nico, t'es viré ...");
            };
            if ((data is TrackerData)){
                tdata = (data as TrackerData);
                if (((!(FilterAvailability.isPopinActive(tdata.type))) || (!(tdata.canOpenPopin)))){
                    return;
                };
                Config.NAVIGATION_LOCKED = true;
                switch (tdata.type){
                    case DataType.METRO_STATIONS:
                        this.currentPopin = new MetroPopin(tdata);
                        break;
                    case DataType.VELO_STATIONS:
                        this.currentPopin = new VeloPopin(tdata);
                        break;
                    case DataType.ELECTROMAGNETICS:
                        this.currentPopin = new ElectromagneticPopin(tdata);
                        break;
                    case DataType.INSTAGRAMS:
                        this.currentPopin = new InstagramPopin(tdata);
                        break;
                    case DataType.MOBILES:
                        this.currentPopin = new MobilePopin(tdata);
                        break;
                    case DataType.FOUR_SQUARE:
                        this.currentPopin = new FoursquarePopin(tdata);
                        break;
                    case DataType.ADS:
                        this.currentPopin = new AdPopin(tdata);
                        break;
                    case DataType.TWITTERS:
                        this.currentPopin = new TwitterPopin(tdata);
                        break;
                    case DataType.FLICKRS:
                        this.currentPopin = new FlickPopin(tdata);
                        break;
                };
                this.mentions.setState(tdata.type);
            } else {
                if ((data is Event)){
                    e = (data as Event);
                    switch (e.type){
                        case HudEvents.OPEN_HELP_POPIN:
                            this.currentPopin = new HelpPopin();
                            break;
                        case HudEvents.OPEN_DISCLAIMER_POPIN:
                            this.currentPopin = new DisclaimerPopin();
                            break;
                        case HudEvents.OPEN_LEGALS_POPIN:
                            this.currentPopin = new LegalsPopin();
                            break;
                        case HudEvents.OPEN_ABOUT_POPIN:
                            this.currentPopin = new AboutPopin();
                            break;
                        case HudEvents.OPEN_LANG_POPIN:
                            this.currentPopin = new LangPopin();
                            break;
                        case HudEvents.OPEN_SHARE_LINK_POPIN:
                            this.currentPopin = new ShareLinkPopin();
                            break;
                    };
                };
            };
            if (this.currentPopin){
                this.currentPopin.addEventListener("CLOSE", this.hide);
                this.addChild(this.currentPopin);
                this.resize();
                this.show();
            };
            SoundManager.playFX("PopIn", (0.5 + (Math.random() * 0.5)));
        }
        public function show():void{
            this.currentPopin.visible = (this.bg.visible = true);
            this.bg.alpha = 0;
            this.currentPopin.tweenIn(0.2);
            eaze(this.bg).to(0.5, {alpha:1});
            this.sim.pause();
        }
        public function hide(e:Event):void{
            if (this.currentPopin != null){
                eaze(this.currentPopin).to(0.3, {alpha:0}).onComplete(this.disposeCurrent);
            };
            eaze(this.bg).delay(0.15).to(0.3, {alpha:0});
            this.sim.start();
            dispatchEvent(new Event(Event.CLOSE));
            Config.NAVIGATION_LOCKED = false;
            this.mentions.alpha = 0;
        }
        private function disposeCurrent():void{
            this.currentPopin = null;
        }
        public function resize():void{
            if (this.currentPopin){
                this.currentPopin.x = ((stage.stageWidth - (this.currentPopin.POPIN_WIDTH + Popin.ICON_WIDTH)) / 2);
                this.currentPopin.y = (((stage.stageHeight - this.currentPopin.height) - Footer.FOOTER_HEIGHT) / 2);
            };
            this.bg.graphics.clear();
            this.bg.graphics.beginFill(0, this.BG_ALPHA);
            this.bg.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            this.mentions.x = (((stage.stageWidth - Panel.RIGHT_PANEL_WIDTH) - 20) - 3);
            this.mentions.y = (stage.stageHeight - 40);
        }
        public function get currentPopin():Popin{
            return (this._currentPopin);
        }
        public function set currentPopin(value:Popin):void{
            this._currentPopin = value;
        }

    }
}//package wd.hud.popins 
