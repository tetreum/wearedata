package wd.landing.sound {
    import flash.net.*;
    import flash.media.*;

    public class soundAmbiancyToPlay {

        private var _ambiancySound:Sound;
        private var _chanelAmbiancy:SoundChannel;
        private var _transform:SoundTransform;
        private var _pausePoint:Number;
        private var _currentVol:Number = 1;

        public function soundAmbiancyToPlay(_arg1:String):void{
            this._ambiancySound = new Sound();
            var _local2:SoundLoaderContext = new SoundLoaderContext(2000, true);
            this._ambiancySound.load(new URLRequest(_arg1), _local2);
            this._chanelAmbiancy = new SoundChannel();
        }
        public function playSound(_arg1:int=1000):void{
            this._chanelAmbiancy = this._ambiancySound.play(0, _arg1);
            this._transform = this._chanelAmbiancy.soundTransform;
            this._transform.volume = this._currentVol;
            this._chanelAmbiancy.soundTransform = this._transform;
        }
        private function stopIt():void{
            this._chanelAmbiancy.stop();
        }

    }
}//package wd.landing.sound 
