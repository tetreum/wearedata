package aze.motion.specials {
    import flash.geom.*;
    import aze.motion.*;

    public class PropertyTint extends EazeSpecial {

        private var start:ColorTransform;
        private var tvalue:ColorTransform;
        private var delta:ColorTransform;

        public function PropertyTint(_arg1:Object, _arg2, _arg3, _arg4:EazeSpecial){
            var _local5:Number;
            var _local6:Number;
            var _local7:uint;
            var _local8:Array;
            super(_arg1, _arg2, _arg3, _arg4);
            if (_arg3 === null){
                this.tvalue = new ColorTransform();
            } else {
                _local5 = 1;
                _local6 = 0;
                _local7 = 0;
                _local8 = (((_arg3 is Array)) ? _arg3 : [_arg3]);
                if (_local8[0] === null){
                    _local5 = 0;
                    _local6 = 1;
                } else {
                    if (_local8.length > 1){
                        _local5 = _local8[1];
                    };
                    if (_local8.length > 2){
                        _local6 = _local8[2];
                    } else {
                        _local6 = (1 - _local5);
                    };
                    _local7 = _local8[0];
                };
                this.tvalue = new ColorTransform();
                this.tvalue.redMultiplier = _local6;
                this.tvalue.greenMultiplier = _local6;
                this.tvalue.blueMultiplier = _local6;
                this.tvalue.redOffset = (_local5 * ((_local7 >> 16) & 0xFF));
                this.tvalue.greenOffset = (_local5 * ((_local7 >> 8) & 0xFF));
                this.tvalue.blueOffset = (_local5 * (_local7 & 0xFF));
            };
        }
        public static function register():void{
            EazeTween.specialProperties.tint = PropertyTint;
        }

        override public function init(_arg1:Boolean):void{
            if (_arg1){
                this.start = this.tvalue;
                this.tvalue = target.transform.colorTransform;
            } else {
                this.start = target.transform.colorTransform;
            };
            this.delta = new ColorTransform((this.tvalue.redMultiplier - this.start.redMultiplier), (this.tvalue.greenMultiplier - this.start.greenMultiplier), (this.tvalue.blueMultiplier - this.start.blueMultiplier), 0, (this.tvalue.redOffset - this.start.redOffset), (this.tvalue.greenOffset - this.start.greenOffset), (this.tvalue.blueOffset - this.start.blueOffset));
            this.tvalue = null;
            if (_arg1){
                this.update(0, false);
            };
        }
        override public function update(_arg1:Number, _arg2:Boolean):void{
            var _local3:ColorTransform = target.transform.colorTransform;
            _local3.redMultiplier = (this.start.redMultiplier + (this.delta.redMultiplier * _arg1));
            _local3.greenMultiplier = (this.start.greenMultiplier + (this.delta.greenMultiplier * _arg1));
            _local3.blueMultiplier = (this.start.blueMultiplier + (this.delta.blueMultiplier * _arg1));
            _local3.redOffset = (this.start.redOffset + (this.delta.redOffset * _arg1));
            _local3.greenOffset = (this.start.greenOffset + (this.delta.greenOffset * _arg1));
            _local3.blueOffset = (this.start.blueOffset + (this.delta.blueOffset * _arg1));
            target.transform.colorTransform = _local3;
        }
        override public function dispose():void{
            this.start = (this.delta = null);
            this.tvalue = null;
            super.dispose();
        }

    }
}//package aze.motion.specials 
