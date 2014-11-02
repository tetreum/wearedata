package wd.landing.effect {
    import flash.utils.*;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.filters.*;

    public class DistortImg_sglT extends EventDispatcher {

        public static const LOW:int = 0;
        public static const MED:int = 1;
        public static const HIGH:int = 2;
        public static const NORMAL:int = 3;
        public static const RGB:int = 4;

        private static var _instance:DistortImg_sglT;

        private var _timerEffect:Timer;
        private var mcMapFilter:mcBmp2;
        private var _dmFilter:DisplacementMapFilter;
        private var _mcItemToDistort:DisplayObjectContainer;
        private var staticTimes:int = 50;
        private var XfuzzMin:int = 0;
        private var XfuzzMax:int = 0;
        private var YfuzzMin:int = 0;
        private var YfuzzMax:int = 0;
        private var MaxPoint:int = 0;
        private var MinPoint:int = 0;
        private var level:int = 0;
        private var _distortRGB:Boolean = false;
        private var nextLevel:int;
        private var incrNormal:int = 0;

        public function DistortImg_sglT(requires:SingletonEnforcer){
            super();
            if (!(requires)){
                throw (new Error("AssetsManager is a singleton, use static instance."));
            };
            this.init();
        }
        public static function get instance():DistortImg_sglT{
            if (!(_instance)){
                _instance = new DistortImg_sglT(new SingletonEnforcer());
            };
            return (_instance);
        }

        private function init():void{
            this.mcMapFilter = new mcBmp2();
            this._dmFilter = getDisplacementMap.getInstance().GetDisplacementMap(CopyToBmp.mcToBmp(this.mcMapFilter, this.mcMapFilter.width, this.mcMapFilter.height).bitmapData);
            this._timerEffect = new Timer(1000, 0);
            this._timerEffect.addEventListener(TimerEvent.TIMER, this.displayStatic);
            this._timerEffect.addEventListener(TimerEvent.TIMER_COMPLETE, this.onComplete);
        }
        private function onComplete(e:TimerEvent):void{
            this.level = NORMAL;
            this.displayStatic();
        }
        public function startEffect(mc:DisplayObjectContainer, durationFrame:Number=0):void{
            this._mcItemToDistort = mc;
            this.incrNormal = 0;
            this.level = LOW;
            this.setStaticLow();
            this.staticTimes = 60;
            this._timerEffect.reset();
            this._timerEffect.repeatCount = durationFrame;
            this._timerEffect.start();
        }
        public function stopEffect():void{
            this._timerEffect.stop();
        }
        private function displayStatic(e:TimerEvent=null):void{
            this.staticTimes--;
            if (this.level != NORMAL){
                this._dmFilter.scaleX = getDisplacementMap.getInstance().randRange(this.XfuzzMin, this.XfuzzMax);
                this._dmFilter.scaleY = getDisplacementMap.getInstance().randRange(this.YfuzzMin, this.YfuzzMax);
                this._dmFilter.mapPoint = new Point(getDisplacementMap.getInstance().randRange(this.MinPoint, this.MaxPoint), getDisplacementMap.getInstance().randRange(this.MinPoint, this.MaxPoint));
                this._mcItemToDistort.filters = new Array(this._dmFilter);
            } else {
                this._mcItemToDistort.filters = null;
            };
            if (this.staticTimes <= 0){
                this.level = (Math.random() * 4);
                if (this.level != NORMAL){
                    this.incrNormal++;
                    if (this.incrNormal > 4){
                        this.level = NORMAL;
                        this.incrNormal = 0;
                    };
                };
                if (this.level == NORMAL){
                    this.incrNormal = 0;
                };
                switch (this.level){
                    case LOW:
                        this.setStaticLow();
                        break;
                    case MED:
                        this.setStaticMedium();
                        break;
                    case HIGH:
                        this.setStaticHigh();
                        break;
                    case NORMAL:
                        this.setStaticNormal();
                        break;
                    default:
                        this.setStaticHigh();
                };
            };
        }
        private function showLevel():void{
            switch (this.level){
                case HIGH:
                    trace("HIGH -->");
                    break;
                case MED:
                    trace("MED");
                    break;
                case LOW:
                    trace("LOW");
                    break;
                case RGB:
                    trace("RGB <--");
                    break;
                case NORMAL:
                    trace("--NORMAL--");
                    break;
            };
        }
        private function setStaticMedium():void{
            this.level = MED;
            this.XfuzzMin = -100;
            this.XfuzzMax = 5;
            this.YfuzzMin = -10;
            this.YfuzzMax = 5;
            this.MinPoint = 0;
            this.MaxPoint = 500;
            this.staticTimes = (10 + (Math.random() * 15));
            this._timerEffect.delay = 50;
        }
        private function setStaticHigh():void{
            this.level = HIGH;
            this.XfuzzMin = -200;
            this.XfuzzMax = 700;
            this.YfuzzMin = -10;
            this.YfuzzMax = 10;
            this.MinPoint = 0;
            this.MaxPoint = 500;
            this.staticTimes = (Math.random() * 10);
            this._timerEffect.delay = 50;
        }
        private function setStaticLow():void{
            this.level = LOW;
            this.XfuzzMin = -300;
            this.XfuzzMax = 700;
            this.YfuzzMin = -20;
            this.YfuzzMax = 20;
            this.MinPoint = -200;
            this.MaxPoint = 300;
            this.staticTimes = (5 + (Math.random() * 15));
            this._timerEffect.delay = 20;
        }
        private function setStaticNormal():void{
            this.level = NORMAL;
            this.XfuzzMin = 0;
            this.XfuzzMax = 0;
            this.YfuzzMin = 0;
            this.YfuzzMax = 0;
            this.MinPoint = 0;
            this.MaxPoint = 0;
            this.staticTimes = (50 + (Math.random() * 30));
            this._timerEffect.delay = 100;
        }

    }
}//package wd.landing.effect 

class SingletonEnforcer {

    public function SingletonEnforcer(){
    }
}
