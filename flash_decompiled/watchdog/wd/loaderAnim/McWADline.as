package wd.loaderAnim {
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class McWADline {

        private var _mcWad:mcLineWAD;
        private var _tabColorMc:Array;
        private var _mcColor:MovieClip;
        private var _timeDistort:Timer;
        private var _i:int;

        public function McWADline(mcWad:mcLineWAD):void{
            this._tabColorMc = [];
            super();
            this._mcWad = mcWad;
            this._tabColorMc = [this._mcWad.mcRed, this._mcWad.mcGreen, this._mcWad.mcBlue];
        }
        private function distortIt(e:Event):void{
            this._mcWad.mcWhite.alpha = 0.3;
            this._i = 0;
            while (this._i < this._tabColorMc.length) {
                this._mcColor = MovieClip(this._tabColorMc[this._i]);
                this._mcColor.y = this.randRange(-2, 2);
                this._mcColor.x = this.randRange(-2, 2);
                this._mcColor.alpha = (this.randRange(2, 4) / 10);
                this._i++;
            };
        }
        private function resetDistort(e:Event):void{
            this._mcWad.mcWhite.alpha = 1;
            this._i = 0;
            while (this._i < this._tabColorMc.length) {
                this._mcColor = MovieClip(this._tabColorMc[this._i]);
                this._mcColor.y = 0;
                this._mcColor.x = 0;
                this._mcColor.alpha = 0;
                this._i++;
            };
        }
        private function randRange(min:int, max:int):int{
            var randomNum:int = (Math.floor((Math.random() * ((max - min) + 1))) + min);
            return (randomNum);
        }
        public function startDistortEffect():void{
            if (this._timeDistort){
                this._timeDistort.removeEventListener(TimerEvent.TIMER, this.distortIt);
                this._timeDistort.removeEventListener(TimerEvent.TIMER_COMPLETE, this.resetDistort);
                this._timeDistort = null;
            };
            this._timeDistort = new Timer(100, 5);
            this._timeDistort.addEventListener(TimerEvent.TIMER, this.distortIt);
            this._timeDistort.addEventListener(TimerEvent.TIMER_COMPLETE, this.resetDistort);
            this._timeDistort.start();
        }

    }
}//package wd.loaderAnim 
