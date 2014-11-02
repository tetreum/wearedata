package aze.motion.specials {
    import flash.display.*;
    import aze.motion.*;

    public class PropertyFrame extends EazeSpecial {

        private var start:int;
        private var delta:int;
        private var frameStart;
        private var frameEnd;

        public function PropertyFrame(_arg1:Object, _arg2, _arg3, _arg4:EazeSpecial){
            var _local6:Array;
            var _local7:String;
            var _local8:int;
            super(_arg1, _arg2, _arg3, _arg4);
            var _local5:MovieClip = MovieClip(_arg1);
            if ((_arg3 is String)){
                _local7 = _arg3;
                if (_local7.indexOf("+") > 0){
                    _local6 = _local7.split("+");
                    this.frameStart = _local6[0];
                    this.frameEnd = _local7;
                } else {
                    if (_local7.indexOf(">") > 0){
                        _local6 = _local7.split(">");
                        this.frameStart = _local6[0];
                        this.frameEnd = _local6[1];
                    } else {
                        this.frameEnd = _local7;
                    };
                };
            } else {
                _local8 = int(_arg3);
                if (_local8 <= 0){
                    _local8 = (_local8 + _local5.totalFrames);
                };
                this.frameEnd = Math.max(1, Math.min(_local5.totalFrames, _local8));
            };
        }
        public static function register():void{
            EazeTween.specialProperties.frame = PropertyFrame;
        }

        override public function init(_arg1:Boolean):void{
            var _local2:MovieClip = MovieClip(target);
            if ((this.frameStart is String)){
                this.frameStart = this.findLabel(_local2, this.frameStart);
            } else {
                this.frameStart = _local2.currentFrame;
            };
            if ((this.frameEnd is String)){
                this.frameEnd = this.findLabel(_local2, this.frameEnd);
            };
            if (_arg1){
                this.start = this.frameEnd;
                this.delta = (this.frameStart - this.start);
            } else {
                this.start = this.frameStart;
                this.delta = (this.frameEnd - this.start);
            };
            _local2.gotoAndStop(this.start);
        }
        private function findLabel(_arg1:MovieClip, _arg2:String):int{
            var _local3:FrameLabel;
            for each (_local3 in _arg1.currentLabels) {
                if (_local3.name == _arg2){
                    return (_local3.frame);
                };
            };
            return (1);
        }
        override public function update(_arg1:Number, _arg2:Boolean):void{
            var _local3:MovieClip = MovieClip(target);
            _local3.gotoAndStop(Math.round((this.start + (this.delta * _arg1))));
        }
        public function getPreferredDuration():Number{
            var _local1:MovieClip = MovieClip(target);
            var _local2:Number = ((_local1.stage) ? _local1.stage.frameRate : 30);
            return (Math.abs((Number(this.delta) / _local2)));
        }

    }
}//package aze.motion.specials 
