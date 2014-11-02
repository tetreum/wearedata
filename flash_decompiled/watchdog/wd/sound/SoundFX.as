package wd.sound {
    import flash.media.*;
    import flash.events.*;
    import aze.motion.*;
    import aze.motion.easing.*;

    public class SoundFX extends EventDispatcher {

        public static var COMPLETE:String = "COMPLETE";

        private var snd:Sound;
        private var channel:SoundChannel;
        private var trans:SoundTransform;
        private var _vol:Number;
        public var label:String;
        private var isVibe:Boolean;

        public function SoundFX(s:String, vol:Number, isVibe:Boolean=false){
            super();
            this.isVibe = isVibe;
            this.label = s;
            this.snd = SoundLibrary.getSound(s);
            this.trans = new SoundTransform();
            this.volume = vol;
            this.play();
        }
        private function play():void{
            this.channel = this.snd.play(0, ((this.isVibe) ? 999 : 0), this.trans);
            if (this.isVibe){
            } else {
                if (this.channel){
                    this.snd.addEventListener(Event.SOUND_COMPLETE, this.destroy);
                };
            };
        }
        public function get volume():Number{
            return (this._vol);
        }
        public function set volume(v:Number):void{
            this._vol = v;
            this.trans.volume = (v * SoundManager.MASTER_VOLUME);
            if (this.channel){
                this.channel.soundTransform = this.trans;
            };
        }
        private function destroy(event:Event):void{
            this.dispose();
        }
        public function dispose():void{
            this.snd = null;
            if (this.channel){
                if (this.isVibe){
                } else {
                    this.channel.removeEventListener(Event.SOUND_COMPLETE, this.destroy);
                };
                this.channel.stop();
            };
            this.trans = null;
        }
        public function fadeOut():void{
            eaze(this).to(3, {volume:0}).easing(Expo.easeInOut).onComplete(this.dispose);
        }
        public function fadeIn():void{
            eaze(this).to(3, {volume:1}).easing(Expo.easeInOut);
        }

    }
}//package wd.sound 
