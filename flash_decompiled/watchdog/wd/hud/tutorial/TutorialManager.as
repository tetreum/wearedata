package wd.hud.tutorial {
    import wd.footer.*;
    import flash.geom.*;
    import wd.hud.panels.*;
    import wd.http.*;
    import wd.hud.panels.search.*;
    import wd.hud.panels.layers.*;
    import wd.hud.panels.district.*;
    import wd.hud.panels.live.*;
    import wd.providers.texts.*;
    import wd.hud.common.tween.*;
    import flash.events.*;
    import flash.display.*;

    public class TutorialManager extends Sprite {

        public static const TUTORIAL_END:String = "TUTO_END";
        public static const TUTORIAL_SKIP:String = "TUTORIAL_SKIP";
        public static const TUTORIAL_START:String = "TUTORIAL_START";
        public static const TUTORIAL_NEXT:String = "TUTORIAL_NEXT";
        public static const INTRO_WINDOW_TYPE:String = "INTRO_WINDOW_TYPE";
        public static const COMPASS_WINDOW_TYPE:String = "COMPASS_WINDOW_TYPE";
        public static const BASE_WINDOW_TYPE:String = "BASE_WINDOW_TYPE";
        public static const END_WINDOW_TYPE:String = "END_WINDOW_TYPE";

        public static var isActive:Boolean = false;

        public var index:int = 0;
        private var currentWindow:TutorialWindow;
        private var skiped:Boolean = false;
        private var line:AnimatedLine;
        private var sequence:Array;
        private var line_destX:Sprite;
        private var line_destY:Sprite;

        public function TutorialManager(){
            this.sequence = [{
                targetClass:Footer,
                lineDelta:new Point(0, -70),
                windowType:INTRO_WINDOW_TYPE,
                width:226
            }, {
                targetClass:Compass,
                lineDelta:new Point(70, 0),
                windowType:COMPASS_WINDOW_TYPE,
                tag:GoogleAnalytics.TUTORIAL_FIRST,
                width:470
            }, {
                targetClass:Search,
                lineDelta:new Point(65, 0),
                windowType:BASE_WINDOW_TYPE,
                tag:GoogleAnalytics.TUTORIAL_SECOND,
                width:452
            }, {
                targetClass:LayerPanel,
                lineDelta:new Point(50, 0),
                windowType:BASE_WINDOW_TYPE,
                tag:GoogleAnalytics.TUTORIAL_THIRD,
                width:470
            }, {
                targetClass:DistrictPanel,
                lineDelta:new Point(-90, 0),
                windowType:BASE_WINDOW_TYPE,
                tag:GoogleAnalytics.TUTORIAL_FOURTH,
                width:500
            }, {
                targetClass:LivePanel,
                lineDelta:new Point(-100, 0),
                windowType:BASE_WINDOW_TYPE,
                tag:GoogleAnalytics.TUTORIAL_FIFTH,
                width:520
            }, {
                targetClass:CitySelector,
                lineDelta:new Point(0, -60),
                windowType:BASE_WINDOW_TYPE,
                tag:GoogleAnalytics.TUTORIAL_SEVENTH,
                width:375
            }, {
                targetClass:Footer,
                lineDelta:new Point(0, -60),
                windowType:END_WINDOW_TYPE,
                tag:GoogleAnalytics.TUTORIAL_CLOSE,
                width:320
            }];
            super();
        }
        public function launch():void{
            trace("launch");
            isActive = true;
            this.skiped = false;
            this.index = 0;
            this.startWindow();
        }
        private function clearWindow():void{
            if (this.currentWindow){
                this.currentWindow.removeEventListener(TUTORIAL_NEXT, this.showNextWindow);
                this.currentWindow.removeEventListener(TUTORIAL_SKIP, this.skip);
                this.currentWindow.removeEventListener(TUTORIAL_END, this.end);
                this.removeChild(this.currentWindow);
                this.removeChild(this.line);
                this.currentWindow = null;
            };
        }
        private function startWindow():void{
            var title:String = TutorialText.xml[("step" + (this.index + 1))].title;
            var text:String = TutorialText.xml[("step" + (this.index + 1))].text;
            if (this.currentWindow){
                this.clearWindow();
            };
            switch (this.sequence[this.index].windowType){
                case BASE_WINDOW_TYPE:
                    this.currentWindow = new TutorialWindow(TutorialText.xml[("step" + (this.index + 1))][0], (this.index + 1), this.sequence[this.index].width);
                    break;
                case INTRO_WINDOW_TYPE:
                    this.currentWindow = new TutorialWindowIntro(TutorialText.xml[("step" + (this.index + 1))][0], (this.index + 1), this.sequence[this.index].width, this.skiped);
                    break;
                case END_WINDOW_TYPE:
                    this.currentWindow = new TutorialEndWindow(TutorialText.xml[("step" + (this.index + 1))][0], (this.index + 1), this.sequence[this.index].width);
                    break;
                case COMPASS_WINDOW_TYPE:
                    this.currentWindow = new TuorialCompassWindow(TutorialText.xml[("step" + (this.index + 1))][0], (this.index + 1), this.sequence[this.index].width);
                    break;
                default:
                    this.currentWindow = new TutorialWindow(TutorialText.xml[("step" + (this.index + 1))][0], (this.index + 1), this.sequence[this.index].width);
            };
            if (this.sequence[this.index].tag){
                GoogleAnalytics.callPageView(this.sequence[this.index].tag);
            };
            this.currentWindow.visible = false;
            this.currentWindow.addEventListener(TUTORIAL_NEXT, this.showNextWindow);
            this.currentWindow.addEventListener(TUTORIAL_SKIP, this.skip);
            this.currentWindow.addEventListener(TUTORIAL_END, this.end);
            this.addChild(this.currentWindow);
            trace(("sequence[index].targetClass : " + this.sequence[this.index].targetClass));
            trace(("sequence[index].targetClass.tutoStartPoint" + this.sequence[this.index].targetClass.tutoStartPoint));
            this.line = new AnimatedLine(this.sequence[this.index].lineDelta);
            this.line.addEventListener(AnimatedLine.TWEEN_END, this.showWindow);
            this.resize();
            this.line.alpha = 0.85;
            this.addChild(this.line);
            this.dispatchEvent(new Event(TUTORIAL_NEXT));
        }
        private function replace():void{
        }
        private function showWindow(e:Event):void{
            trace("showWindow : ");
            this.currentWindow.show();
        }
        private function showNextWindow(e:Event):void{
            this.index++;
            if (this.index == this.sequence.length){
                this.end();
            } else {
                this.startWindow();
            };
        }
        private function skip(e:Event):void{
            this.skiped = true;
            this.index = 0;
            this.startWindow();
        }
        public function end(e:Event=null):void{
            this.clearWindow();
            isActive = false;
            this.dispatchEvent(new Event(TUTORIAL_END));
        }
        public function resize():void{
            var pStart:Point;
            if (isActive){
                if (this.sequence[this.index].targetClass == CitySelector){
                    pStart = Footer.tutoStartPoint2;
                } else {
                    pStart = this.sequence[this.index].targetClass.tutoStartPoint;
                };
                this.line.x = pStart.x;
                this.line.y = pStart.y;
                this.currentWindow.x = (pStart.x + this.sequence[this.index].lineDelta.x);
                this.currentWindow.y = (pStart.y + this.sequence[this.index].lineDelta.y);
            };
        }

    }
}//package wd.hud.tutorial 
