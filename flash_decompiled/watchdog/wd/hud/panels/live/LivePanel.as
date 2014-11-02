package wd.hud.panels.live {
    import wd.core.*;
    import wd.hud.common.graphics.*;
    import flash.geom.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import flash.external.*;
    import wd.http.*;
    import flash.events.*;
    import flash.utils.*;
    import wd.utils.*;
    import wd.hud.*;
    import wd.footer.*;
    import wd.hud.panels.*;

    public class LivePanel extends Panel {

        public static var tutoStartPoint:Point;

        private var line:Line;
        private var text:CustomTextField;
        private var fbButton:FbButton;
        private var liveActivities:LiveActivities;
        private var fakeTimer:Timer;
        private var fakeIndex:uint = 0;
        private var spaceFromBottom:uint = 0;
        private var l2:Line;
        private var gettingDataAttempt:int = 0;

        public function LivePanel(){
            super();
            if (Config.FACEBOOK_CONNECT_AVAILABLE){
                this.line = new Line(RIGHT_PANEL_WIDTH);
                LivePanel.tutoStartPoint = new Point(this.x, this.y);
                this.addChild(this.line);
                title = new CustomTextField(LiveActivitiesText.title0, "panelTitle");
                title.y = LINE_H_MARGIN;
                this.addChild(title);
                this.text = new CustomTextField(CommonsText.loading, "livePanelSubtitle");
                this.text.y = (title.y + title.height);
                this.text.width = 80;
                this.addChild(this.text);
                addArrow((RIGHT_PANEL_WIDTH - 7));
                title.width = (RIGHT_PANEL_WIDTH - arrow.width);
                this.l2 = new Line(RIGHT_PANEL_WIDTH);
                this.l2.y = ((this.text.y + this.text.height) + LINE_H_MARGIN);
                this.addChild(this.l2);
                if (ExternalInterface.available){
                    FacebookConnector.init();
                    FacebookConnector.evtDispatcher.addEventListener(FacebookConnector.FB_LOGGED_IN, this.logged);
                    FacebookConnector.evtDispatcher.addEventListener(FacebookConnector.FB_NOT_LOGGED, this.notLogged);
                } else {
                    this.notLogged();
                };
                this.feedFakeActivities();
            };
        }
        private function notLogged(e:Event=null):void{
            this.text.text = LiveActivitiesText.text01;
            this.text.y = (title.y + title.height);
            this.fbButton = new FbButton(LiveActivitiesText.faceBookConnectButton, this.clickConnect);
            this.fbButton.x = (RIGHT_PANEL_WIDTH - this.fbButton.width);
            this.fbButton.y = (this.text.y + ((this.text.height - this.fbButton.height) / 2));
            this.addChild(this.fbButton);
            this.text.width = ((RIGHT_PANEL_WIDTH - this.fbButton.width) - 5);
            this.l2.y = ((this.text.y + this.text.height) + LINE_H_MARGIN);
            this.replace();
        }
        private function logged(e:Event):void{
            if (this.fbButton){
                this.removeChild(this.fbButton);
            };
            this.text.text = "Getting Facebook data ...";
            this.text.width = LEFT_PANEL_WIDTH;
            setTimeout(this.getUserData, 1000);
            this.gettingDataAttempt = 0;
        }
        private function getUserData():void{
            this.gettingDataAttempt++;
            FacebookConnector.getUserData();
            FacebookConnector.evtDispatcher.addEventListener(FacebookConnector.FB_ON_DATA, this.fbIdentComplete);
            FacebookConnector.evtDispatcher.addEventListener(FacebookConnector.FB_ERROR, this.fbError);
            GoogleAnalytics.callPageView(GoogleAnalytics.APP_FACEBOOK_CONNECTED);
        }
        private function fbIdentComplete(e:Event):void{
            var i:*;
            var data:Object = FacebookConnector.currentData;
            trace("data : ");
            for (i in data) {
                trace(((i + ":") + data[i]));
            };
            if (((!(data.name)) || (!(data.birthday)))){
                if (this.gettingDataAttempt == 5){
                    this.notLogged();
                } else {
                    setTimeout(this.getUserData, 2000);
                };
            } else {
                title.text = LiveActivitiesText.title1;
                this.text.text = (("<span class=\"livePanelUserName\">" + data.name) + "</span><br/>");
                this.text.text = (this.text.text + ((this.getAge(data.birthday) + ",") + data.work[0].employer.name));
                this.text.width = RIGHT_PANEL_WIDTH;
                this.text.y = (title.y + title.height);
                this.liveActivities.y = (this.l2.y = ((this.text.y + this.text.height) + LINE_H_MARGIN));
                SocketInterface.init();
                SocketInterface.login(data.id, data.first_name, data.last_name, this.getAge(data.birthday), data.work[0].employer.name, data.locale, CommonsText[Locator.CITY]);
                SocketInterface.bridge.addEventListener("NEW_MESSAGE", this.addLastMessage);
                this.stopAndClearFake();
                this.replace();
            };
        }
        private function getAge(fbBday:String):String{
            trace(("fbBday : " + fbBday));
            if (fbBday == null){
                return ("--");
            };
            var da:Array = fbBday.split("/");
            var bDate:Date = new Date(da[2], da[0], da[1]);
            var today:Date = new Date();
            var age:Date = new Date((today.time - bDate.time));
            age.fullYear = (age.fullYear - 1970);
            return (age.fullYear.toString());
        }
        private function fbError(e:Event):void{
        }
        public function clickConnect(e:Event):void{
            this.dispatchEvent(new Event(HudEvents.OPEN_DISCLAIMER_POPIN));
            GoogleAnalytics.callPageView(GoogleAnalytics.APP_FACEBOOK);
        }
        private function addLastMessage(e:Event):void{
            var data:Object;
            if (_enabled){
                data = SocketInterface.messageFifo.shift();
                this.liveActivities.addItem((((((((((data.firstName + " ") + data.lastName) + " <span class=\"liveActivityDataColor\">") + data.age) + ", ") + data.job) + ", ") + data.country) + "</span>"), (((("<span class=\"liveActivityDataColor\">" + LiveActivitiesText.feed1) + "</span> <u>") + data.action) + "</u>"), data.longLat[1], data.longLat[0]);
                this.y = ((stage.stageHeight - this.height) - Footer.FOOTER_HEIGHT);
                enlight();
            };
            this.replace();
        }
        private function feedFakeActivities():void{
            this.liveActivities = new LiveActivities(RIGHT_PANEL_WIDTH);
            this.liveActivities.y = this.l2.y;
            this.fakeTimer = new Timer((1000 + (5000 * Math.random())), 1);
            this.fakeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.addFakeActivity);
            this.fakeTimer.start();
            expandedContainer.addChild(this.liveActivities);
        }
        private function addFakeActivity(e:Event):void{
            var fake:XML;
            this.fakeTimer.delay = (1000 + (5000 * Math.random()));
            this.fakeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.addFakeActivity);
            this.fakeTimer.start();
            if (_enabled){
                fake = LiveActivitiesText.fakeActivities.data[this.fakeIndex];
                this.liveActivities.addItem(fake.user, (((("<span class=\"liveActivityDataColor\">" + LiveActivitiesText.feed1) + "</span> <u>") + fake.lookingAt) + "</u>"), 0, 0);
                this.fakeIndex++;
                if (this.fakeIndex == LiveActivitiesText.fakeActivities.data.length()){
                    this.fakeIndex = 0;
                };
                enlight();
            };
            this.replace();
        }
        public function replace():void{
            if (((this.liveActivities) && (!(reduced)))){
                this.liveActivities.y = this.l2.y;
                setBg(RIGHT_PANEL_WIDTH, (this.l2.y + this.liveActivities.height));
            } else {
                setBg(RIGHT_PANEL_WIDTH, this.l2.y);
            };
            if (stage){
                this.y = ((this.stage.stageHeight - this.height) - Footer.FOOTER_HEIGHT);
            };
            LivePanel.tutoStartPoint = new Point(this.x, this.y);
        }
        override public function get height():Number{
            if (reduced){
                return (this.l2.y);
            };
            return (super.height);
        }
        override protected function reduceTrigger(e:Event):void{
            super.reduceTrigger(e);
            this.replace();
        }
        override public function set height(value:Number):void{
            super.height = value;
        }
        private function stopAndClearFake():void{
            this.fakeTimer.stop();
            this.liveActivities.clear();
        }

    }
}//package wd.hud.panels.live 
