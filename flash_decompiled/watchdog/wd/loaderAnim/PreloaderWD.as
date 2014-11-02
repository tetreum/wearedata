package wd.loaderAnim {
    import flash.events.*;
    import flash.utils.*;
    import wd.landing.effect.*;

    public class PreloaderWD extends PreloaderClip {

        public static const ON_END_ANIMATION:String = "onEndAnimation";

        private var _gotoFrame:int;
        private var _currentValue:int;
        private var _mcWadline:McWADline;
        private var _timeStartDistort:Timer;
        private var _posXinit:Number;

        public function PreloaderWD():void{
            super();
            this.stop();
            this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this.mcWAD.mask = this.mcMask;
            this.mcLines.stop();
            this._posXinit = -(this.mcProgress.mcBarre.width);
            this.mcProgress.mcBarre.x = this._posXinit;
        }
        private function onAddedToStage(e:Event):void{
            removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            this._mcWadline = new McWADline(this.mcWAD);
            this._timeStartDistort = new Timer(2000, 0);
            this._timeStartDistort.addEventListener(TimerEvent.TIMER, this.startDistortEffect);
            this._timeStartDistort.start();
        }
        private function startDistortEffect(e:TimerEvent):void{
            DistortImg_sglT.instance.startEffect(this.mcWAD, 10);
            this._mcWadline.startDistortEffect();
        }
        public function onProgress(value:Number):void{
            if (value > this._currentValue){
                this._currentValue++;
                this.mcProgress.mcBarre.x = (this._posXinit + (this.mcProgress.mcBarre.width * (this._currentValue / 100)));
                trace(this.mcProgress.mcBarre.x);
                this.mcProgress.txt_prct.text = (this._currentValue + "%");
                this._gotoFrame = ((this.totalFrames / 100) * this._currentValue);
                this.gotoAndStop(this._gotoFrame);
                this.mcMask.gotoAndStop(this._gotoFrame);
                this.mcLines.gotoAndStop(this._gotoFrame);
            } else {
                DistortImg_sglT.instance.startEffect(this.mcWAD, 30);
            };
            if (value >= 100){
                dispatchEvent(new Event(ON_END_ANIMATION));
                DistortImg_sglT.instance.startEffect(this.mcWAD, 30);
                this._timeStartDistort.stop();
                this._timeStartDistort.removeEventListener(TimerEvent.TIMER, this.startDistortEffect);
                this._timeStartDistort = null;
                this.mcWAD.mcWhite.gotoAndStop(1);
            };
        }

    }
}//package wd.loaderAnim 
