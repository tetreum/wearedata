package wd.landing.sound {
    import flash.events.*;

    public class LandingSoundManager extends EventDispatcher {

        private static var _oI:LandingSoundManager;

        private var _sound_out:soundAmbiancyToPlay;
        private var _sound_over:soundAmbiancyToPlay;
        private var _ambiancy:soundAmbiancyToPlay;

        public function LandingSoundManager(_arg1:PrivateConstructorAccess){
            this.init();
        }
        public static function getInstance():LandingSoundManager{
            if (!_oI){
                _oI = new LandingSoundManager(new PrivateConstructorAccess());
            };
            return (_oI);
        }

        private function init():void{
            this._sound_out = new soundAmbiancyToPlay("mobile/cdn_assets/audios/PAGE_HOME_ROLLOVER_VILLE_DISPARITION_V2.mp3");
            this._sound_over = new soundAmbiancyToPlay("mobile/cdn_assets/audios/PAGE_HOME_ROLLOVER_VILLE_APPARITION_V1.mp3");
            this._ambiancy = new soundAmbiancyToPlay("mobile/cdn_assets/audios/BOUCLE_AMBIANCE_HOME.mp3");
            this._ambiancy.playSound();
        }
        public function playSound(_arg1:String):void{
            switch (_arg1){
                case SoundsName.OUT:
                    this._sound_out.playSound(1);
                    break;
                case SoundsName.OVER:
                    this._sound_over.playSound(1);
                    break;
            };
        }

    }
}//package wd.landing.sound 

class PrivateConstructorAccess {

    public function PrivateConstructorAccess(){
    }
}
