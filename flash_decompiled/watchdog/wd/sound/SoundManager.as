package wd.sound {
    import flash.events.*;
    import wd.utils.*;

    public class SoundManager {

        public static var MASTER_VOLUME:Number = 0;
        private static var currentSoundPlayed:SoundFX;
        private static var currentVibe:SoundFX;
        private static var locked:Boolean;

        public static function playVibe(s:String, vol:int):void{
            if (currentVibe != null){
                currentVibe.fadeOut();
            };
            currentVibe = new SoundFX(s, 0, true);
            currentVibe.fadeIn();
        }
        public static function playFX(s:String, vol:Number=1, checkIsPlayed:Boolean=false):void{
            if (MASTER_VOLUME == 0){
                return;
            };
            if (((checkIsPlayed) && (locked))){
                trace("playing");
            };
            var sound:SoundFX = new SoundFX(s, vol);
            sound.addEventListener(SoundFX.COMPLETE, unLockFXSound);
            locked = true;
        }
        protected static function unLockFXSound(event:Event):void{
            var sound:SoundFX = (event.target as SoundFX);
            sound.removeEventListener(SoundFX.COMPLETE, unLockFXSound);
            sound = null;
            trace("stopped playing");
            locked = false;
        }
        public static function swapMute(e:Event):void{
            setMasterVolume((((MASTER_VOLUME == 1)) ? 0 : 1));
        }
        public static function setMasterVolume(v:Number, updateSol:Boolean=true):void{
            MASTER_VOLUME = v;
            if (currentVibe != null){
                currentVibe.volume = currentVibe.volume;
            };
            if (updateSol){
                SharedData.soundVolume = MASTER_VOLUME;
            };
        }
        public static function init():void{
            if (SharedData.firstTime){
                setMasterVolume(1);
            } else {
                setMasterVolume(SharedData.soundVolume, false);
            };
            SoundLibrary.init();
        }

    }
}//package wd.sound 
