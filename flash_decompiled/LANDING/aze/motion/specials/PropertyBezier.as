package aze.motion.specials {
    import aze.motion.*;

    public class PropertyBezier extends EazeSpecial {

        private var fvalue:Array;
        private var through:Boolean;
        private var length:int;
        private var segments:Array;

        public function PropertyBezier(_arg1:Object, _arg2, _arg3, _arg4:EazeSpecial){
            super(_arg1, _arg2, _arg3, _arg4);
            this.fvalue = _arg3;
            if ((this.fvalue[0] is Array)){
                this.through = true;
                this.fvalue = this.fvalue[0];
            };
        }
        public static function register():void{
            EazeTween.specialProperties["__bezier"] = PropertyBezier;
        }

        override public function init(_arg1:Boolean):void{
            var _local3:Number;
            var _local4:Number;
            var _local2:Number = target[property];
            this.fvalue = [_local2].concat(this.fvalue);
            if (_arg1){
                this.fvalue.reverse();
            };
            var _local5:Number = this.fvalue[0];
            var _local6:int = (this.fvalue.length - 1);
            var _local7 = 1;
            var _local8:Number = NaN;
            this.segments = [];
            this.length = 0;
            while (_local7 < _local6) {
                _local3 = _local5;
                _local4 = this.fvalue[_local7];
                ++_local7;
                _local5 = this.fvalue[_local7];
                if (this.through){
                    if (!this.length){
                        _local8 = ((_local5 - _local3) / 4);
                        var _local9 = this.length++;
                        this.segments[_local9] = new BezierSegment(_local3, (_local4 - _local8), _local4);
                    };
                    _local9 = this.length++;
                    this.segments[_local9] = new BezierSegment(_local4, (_local4 + _local8), _local5);
                    _local8 = (_local5 - (_local4 + _local8));
                } else {
                    if (_local7 != _local6){
                        _local5 = ((_local4 + _local5) / 2);
                    };
                    _local9 = this.length++;
                    this.segments[_local9] = new BezierSegment(_local3, _local4, _local5);
                };
            };
            this.fvalue = null;
            if (_arg1){
                this.update(0, false);
            };
        }
        override public function update(_arg1:Number, _arg2:Boolean):void{
            var _local3:BezierSegment;
            var _local5:int;
            var _local4:int = (this.length - 1);
            if (_arg2){
                _local3 = this.segments[_local4];
                target[property] = (_local3.p0 + _local3.d2);
            } else {
                if (this.length == 1){
                    _local3 = this.segments[0];
                    target[property] = _local3.calculate(_arg1);
                } else {
                    _local5 = ((_arg1 * this.length) >> 0);
                    if (_local5 < 0){
                        _local5 = 0;
                    } else {
                        if (_local5 > _local4){
                            _local5 = _local4;
                        };
                    };
                    _local3 = this.segments[_local5];
                    _arg1 = (this.length * (_arg1 - (_local5 / this.length)));
                    target[property] = _local3.calculate(_arg1);
                };
            };
        }
        override public function dispose():void{
            this.fvalue = null;
            this.segments = null;
            super.dispose();
        }

    }
}//package aze.motion.specials 

class BezierSegment {

    public var p0:Number;
    public var d1:Number;
    public var d2:Number;

    public function BezierSegment(_arg1:Number, _arg2:Number, _arg3:Number){
        this.p0 = _arg1;
        this.d1 = (_arg2 - _arg1);
        this.d2 = (_arg3 - _arg1);
    }
    public function calculate(_arg1:Number):Number{
        return ((this.p0 + (_arg1 * (((2 * (1 - _arg1)) * this.d1) + (_arg1 * this.d2)))));
    }

}
