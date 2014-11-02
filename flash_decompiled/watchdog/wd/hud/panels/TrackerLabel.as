package wd.hud.panels {
    import flash.display.*;
    import aze.motion.*;
    import flash.events.*;
    import wd.hud.items.*;
    import wd.hud.items.datatype.*;
    import aze.motion.easing.*;
    import flash.utils.*;
    import wd.http.*;
    import flash.geom.*;

    public class TrackerLabel extends Sprite {

        protected const PADDING:uint = 5;
        protected const DELTA_X:uint = 40;
        protected const DELTA_Y:uint = 20;

        protected var line:Sprite;
        protected var dot:Shape;
        protected var mainLabel:Label;
        protected var subLabel:Label;
        protected var posX:int = 0;
        protected var posY:int = 0;
        protected var currentTracker:Tracker;
        protected var lineDrawStep:uint = 0;
        protected var lineDrawStepMax:uint = 5;
        protected var lineEnded:Boolean = false;
        protected var LINE_ICON_POS:Dictionary;
        protected var hasSub:Boolean;

        public function TrackerLabel(){
            super();
            this.visible = false;
            this.line = new Sprite();
            this.mouseEnabled = false;
            this.mouseChildren = false;
            addChild(this.line);
            this.mainLabel = new Label("");
            this.addChild(this.mainLabel);
            this.subLabel = new Label("");
            this.addChild(this.subLabel);
            this.dot = this.makeDot();
            addChild(this.dot);
            this.initDic();
        }
        public function rolloutHandler(t:Tracker):void{
            this.line.graphics.clear();
            eaze(this.dot).to(0.2, {
                scaleX:0,
                scaleY:0
            });
            eaze(this.subLabel).to(0.2, {alpha:0}).delay(0.1);
            eaze(this.mainLabel).to(0.2, {alpha:0});
            this.removeEventListener(Event.ENTER_FRAME, this.render);
        }
        public function rolloverHandler(t:Tracker, text:String="", textSub:String=""):void{
            this.currentTracker = t;
            if (text == ""){
                text = t.data.labelData;
            };
            if (textSub == ""){
                textSub = t.data.labelSubData;
            };
            text = text.toUpperCase();
            textSub = textSub.toUpperCase();
            this.mainLabel.setText(text, (this.currentTracker is TrainTrackerData));
            if (textSub != ""){
                this.hasSub = true;
                this.subLabel.setText(textSub);
                this.subLabel.visible = true;
            } else {
                this.hasSub = false;
                this.subLabel.visible = false;
            };
            this.visible = true;
            if (this.trackertIsOnTheLeft()){
                this.posX = -(this.DELTA_X);
            } else {
                this.posX = this.DELTA_X;
            };
            if (this.trackertIsOnTop()){
                this.posY = -(this.DELTA_Y);
            } else {
                this.posY = this.DELTA_Y;
            };
            this.posX = (this.posX + this.currentTracker.screenPosition.x);
            this.posY = (this.posY + this.currentTracker.screenPosition.y);
            this.lineDrawStep = 0;
            this.dot.x = this.posX;
            this.dot.y = this.posY;
            this.dot.scaleX = (this.dot.scaleY = 0);
            this.lineEnded = false;
            this.addEventListener(Event.ENTER_FRAME, this.render);
        }
        public function makeDot():Shape{
            var s:Shape = new Shape();
            s.graphics.lineStyle(2, 0xFFFFFF, 1);
            s.graphics.beginFill(0, 1);
            s.graphics.drawCircle(-2, 0, 4);
            return (s);
        }
        public function render(e:Event=null):void{
            var iconDeltaX:Number = ((this.LINE_ICON_POS[this.currentTracker.data.type]) ? this.LINE_ICON_POS[this.currentTracker.data.type].x : 5);
            var iconDeltaY:Number = ((this.LINE_ICON_POS[this.currentTracker.data.type]) ? this.LINE_ICON_POS[this.currentTracker.data.type].y : 5);
            if (this.trackertIsOnTheLeft()){
                iconDeltaX = -(iconDeltaX);
                this.mainLabel.x = (((this.dot.x - this.mainLabel.width) + this.PADDING) - 2);
                this.subLabel.x = (((this.dot.x - this.subLabel.width) + this.PADDING) - 2);
            } else {
                this.mainLabel.x = ((this.dot.x + this.PADDING) - 2);
                this.subLabel.x = this.mainLabel.x;
            };
            if (this.trackertIsOnTop()){
                iconDeltaY = -(iconDeltaY);
            };
            if (this.hasSub){
                this.mainLabel.y = ((this.dot.y - this.mainLabel.height) + 3);
                this.subLabel.y = ((this.mainLabel.y + this.mainLabel.height) - 1);
                this.subLabel.render();
            } else {
                this.mainLabel.y = ((this.dot.y - (this.mainLabel.height / 2)) + 3);
            };
            this.mainLabel.render();
            var lx0:Number = (this.currentTracker.screenPosition.x + iconDeltaX);
            var ly0:Number = (this.currentTracker.screenPosition.y + iconDeltaY);
            var lxt:Number = (lx0 + ((this.dot.x - lx0) * (this.lineDrawStep / this.lineDrawStepMax)));
            var lyt:Number = (ly0 + ((this.dot.y - ly0) * (this.lineDrawStep / this.lineDrawStepMax)));
            var g:Graphics = this.line.graphics;
            g.clear();
            g.moveTo(lx0, ly0);
            g.lineStyle(1, 0x575757, 1);
            g.lineTo(lxt, lyt);
            this.lineDrawStep++;
            this.lineDrawStep = Math.min(this.lineDrawStep, this.lineDrawStepMax);
            if ((((this.lineEnded == false)) && ((this.lineDrawStep == this.lineDrawStepMax)))){
                this.lineEnded = true;
                this.showDot();
            };
        }
        private function showDot():void{
            eaze(this.dot).to(0.5, {
                scaleX:1,
                scaleY:1
            }).easing(Back.easeInOut);
            eaze(this.mainLabel).to(0.3, {alpha:1}).delay(0.2);
            if (this.hasSub){
                eaze(this.subLabel).to(0.3, {alpha:1}).delay(0.2);
            };
        }
        protected function trackertIsOnTheLeft():Boolean{
            return ((this.currentTracker.screenPosition.x > (stage.stageWidth / 2)));
        }
        protected function trackertIsOnTop():Boolean{
            return ((this.currentTracker.screenPosition.y > (stage.stageHeight / 2)));
        }
        private function initDic():void{
            this.LINE_ICON_POS = new Dictionary();
            this.LINE_ICON_POS[DataType.METRO_STATIONS] = new Point(6, 6);
            this.LINE_ICON_POS[DataType.TOILETS] = new Point(9, 10);
            this.LINE_ICON_POS[DataType.INTERNET_RELAYS] = new Point(8, 11);
            this.LINE_ICON_POS[DataType.MOBILES] = new Point(8, 8);
            this.LINE_ICON_POS[DataType.ADS] = new Point(11, 11);
            this.LINE_ICON_POS[DataType.TOILETS] = new Point(10, 10);
            this.LINE_ICON_POS[DataType.VELO_STATIONS] = new Point(10, 10);
            this.LINE_ICON_POS[DataType.INSTAGRAMS] = new Point(13, 8);
            this.LINE_ICON_POS[DataType.WIFIS] = new Point(9, 12);
            this.LINE_ICON_POS[DataType.ELECTROMAGNETICS] = new Point(6, 6);
            this.LINE_ICON_POS[DataType.TRAFFIC_LIGHTS] = new Point(6, 6);
            this.LINE_ICON_POS[DataType.CAMERAS] = new Point(6, 9);
            this.LINE_ICON_POS[DataType.TWITTERS] = new Point(12, 8);
            this.LINE_ICON_POS[DataType.FOUR_SQUARE] = new Point(10, 8);
            this.LINE_ICON_POS[DataType.ATMS] = new Point(8, 8);
            this.LINE_ICON_POS[DataType.FLICKRS] = new Point(12, 10);
            this.LINE_ICON_POS[DataType.PLACES] = new Point(3, 3);
            this.LINE_ICON_POS[DataType.RADARS] = new Point(8, 8);
        }

    }
}//package wd.hud.panels 

import flash.display.*;
import wd.hud.common.text.*;

class Label extends Sprite {

    private const PADDING:uint = 5;

    private var labeltxt:CustomTextField;
    private var bg:Sprite;

    public function Label(txt:String){
        super();
        this.bg = new Sprite();
        this.addChild(this.bg);
        this.labeltxt = new CustomTextField("", "rolloverTrackerLabel");
        this.labeltxt.mouseEnabled = false;
        this.labeltxt.wordWrap = false;
        addChild(this.labeltxt);
    }
    public function setText(txt:String, tweening:Boolean=true):void{
        if (tweening){
            this.labeltxt.startTween(txt);
        } else {
            this.labeltxt.text = txt;
        };
    }
    public function render():void{
        this.bg.graphics.clear();
        this.bg.graphics.lineStyle(1, 0x575757, 1, false, "normel", CapsStyle.SQUARE);
        this.bg.graphics.beginFill(0, 1);
        this.bg.graphics.drawRect(-(this.PADDING), (-(this.PADDING) / 2), (this.labeltxt.width + (this.PADDING * 2)), (this.labeltxt.height + this.PADDING));
    }

}
