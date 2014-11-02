package aze.motion.specials {
    import aze.motion.*;
    import flash.media.*;

    public class PropertyVolume extends EazeSpecial {

        private var start:Number;
        private var delta:Number;
        private var vvalue:Number;
        private var targetVolume:Boolean;

        public function PropertyVolume(_arg1:Object, _arg2, _arg3, _arg4:EazeSpecial){
            super(_arg1, _arg2, _arg3, _arg4);
            this.vvalue = _arg3;
        }
        public static function register():void{
            EazeTween.specialProperties.volume = PropertyVolume;
        }

        override public function init(_arg1:Boolean):void{
            var _local3:Number;
            this.targetVolume = ("soundTransform" in target);
            var _local2:SoundTransform = ((this.targetVolume) ? target.soundTransform : SoundMixer.soundTransform);
            if (_arg1){
                this.start = this.vvalue;
                _local3 = _local2.volume;
            } else {
                _local3 = this.vvalue;
                this.start = _local2.volume;
            };
            this.delta = (_local3 - this.start);
        }
        override public function update(_arg1:Number, _arg2:Boolean):void{
            var _local3:SoundTransform = ((this.targetVolume) ? target.soundTransform : SoundMixer.soundTransform);
            _local3.volume = (this.start + (this.delta * _arg1));
            if (this.targetVolume){
                target.soundTransform = _local3;
            } else {
                SoundMixer.soundTransform = _local3;
            };
        }

    }
}//package aze.motion.specials 
