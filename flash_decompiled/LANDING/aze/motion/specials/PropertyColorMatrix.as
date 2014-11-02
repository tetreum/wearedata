package aze.motion.specials {
    import flash.display.*;
    import flash.filters.*;
    import aze.motion.*;

    public class PropertyColorMatrix extends EazeSpecial {

        private var removeWhenComplete:Boolean;
        private var colorMatrix:ColorMatrix;
        private var delta:Array;
        private var start:Array;
        private var temp:Array;

        public function PropertyColorMatrix(_arg1:Object, _arg2, _arg3, _arg4:EazeSpecial){
            var _local5:uint;
            super(_arg1, _arg2, _arg3, _arg4);
            this.colorMatrix = new ColorMatrix();
            if (_arg3.brightness){
                this.colorMatrix.adjustBrightness((_arg3.brightness * 0xFF));
            };
            if (_arg3.contrast){
                this.colorMatrix.adjustContrast(_arg3.contrast);
            };
            if (_arg3.hue){
                this.colorMatrix.adjustHue(_arg3.hue);
            };
            if (_arg3.saturation){
                this.colorMatrix.adjustSaturation((_arg3.saturation + 1));
            };
            if (_arg3.colorize){
                _local5 = ((("tint" in _arg3)) ? uint(_arg3.tint) : 0xFFFFFF);
                this.colorMatrix.colorize(_local5, _arg3.colorize);
            };
            this.removeWhenComplete = _arg3.remove;
        }
        public static function register():void{
            EazeTween.specialProperties["colorMatrixFilter"] = PropertyColorMatrix;
            EazeTween.specialProperties[ColorMatrixFilter] = PropertyColorMatrix;
        }

        override public function init(_arg1:Boolean):void{
            var _local4:Array;
            var _local5:Array;
            var _local2:DisplayObject = DisplayObject(target);
            var _local3:ColorMatrixFilter = (PropertyFilter.getCurrentFilter(ColorMatrixFilter, _local2, true) as ColorMatrixFilter);
            if (!_local3){
                _local3 = new ColorMatrixFilter();
            };
            if (_arg1){
                _local5 = _local3.matrix;
                _local4 = this.colorMatrix.matrix;
            } else {
                _local5 = this.colorMatrix.matrix;
                _local4 = _local3.matrix;
            };
            this.delta = new Array(20);
            var _local6:int;
            while (_local6 < 20) {
                this.delta[_local6] = (_local5[_local6] - _local4[_local6]);
                _local6++;
            };
            this.start = _local4;
            this.temp = new Array(20);
            PropertyFilter.addFilter(_local2, new ColorMatrixFilter(_local4));
        }
        override public function update(_arg1:Number, _arg2:Boolean):void{
            var _local3:DisplayObject = DisplayObject(target);
            (PropertyFilter.getCurrentFilter(ColorMatrixFilter, _local3, true) as ColorMatrixFilter);
            if (((this.removeWhenComplete) && (_arg2))){
                _local3.filters = _local3.filters;
                return;
            };
            var _local4:int;
            while (_local4 < 20) {
                this.temp[_local4] = (this.start[_local4] + (_arg1 * this.delta[_local4]));
                _local4++;
            };
            PropertyFilter.addFilter(_local3, new ColorMatrixFilter(this.temp));
        }
        override public function dispose():void{
            this.colorMatrix = null;
            this.delta = null;
            this.start = null;
            this.temp = null;
            super.dispose();
        }

    }
}//package aze.motion.specials 

import flash.filters.*;

class ColorMatrix {

    private static const LUMA_R:Number = 0.212671;
    private static const LUMA_G:Number = 0.71516;
    private static const LUMA_B:Number = 0.072169;
    private static const LUMA_R2:Number = 0.3086;
    private static const LUMA_G2:Number = 0.6094;
    private static const LUMA_B2:Number = 0.082;
    private static const ONETHIRD:Number = 0.333333333333333;
    private static const IDENTITY:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
    private static const RAD:Number = 0.0174532925199433;

    public var matrix:Array;

    public function ColorMatrix(_arg1:Object=null){
        if ((_arg1 is ColorMatrix)){
            this.matrix = _arg1.matrix.concat();
        } else {
            if ((_arg1 is Array)){
                this.matrix = _arg1.concat();
            } else {
                this.reset();
            };
        };
    }
    public function reset():void{
        this.matrix = IDENTITY.concat();
    }
    public function adjustSaturation(_arg1:Number):void{
        var _local2:Number;
        var _local3:Number;
        var _local4:Number;
        var _local5:Number;
        _local2 = (1 - _arg1);
        _local3 = (_local2 * LUMA_R);
        _local4 = (_local2 * LUMA_G);
        _local5 = (_local2 * LUMA_B);
        this.concat([(_local3 + _arg1), _local4, _local5, 0, 0, _local3, (_local4 + _arg1), _local5, 0, 0, _local3, _local4, (_local5 + _arg1), 0, 0, 0, 0, 0, 1, 0]);
    }
    public function adjustContrast(_arg1:Number, _arg2:Number=NaN, _arg3:Number=NaN):void{
        if (isNaN(_arg2)){
            _arg2 = _arg1;
        };
        if (isNaN(_arg3)){
            _arg3 = _arg1;
        };
        _arg1 = (_arg1 + 1);
        _arg2 = (_arg2 + 1);
        _arg3 = (_arg3 + 1);
        this.concat([_arg1, 0, 0, 0, (128 * (1 - _arg1)), 0, _arg2, 0, 0, (128 * (1 - _arg2)), 0, 0, _arg3, 0, (128 * (1 - _arg3)), 0, 0, 0, 1, 0]);
    }
    public function adjustBrightness(_arg1:Number, _arg2:Number=NaN, _arg3:Number=NaN):void{
        if (isNaN(_arg2)){
            _arg2 = _arg1;
        };
        if (isNaN(_arg3)){
            _arg3 = _arg1;
        };
        this.concat([1, 0, 0, 0, _arg1, 0, 1, 0, 0, _arg2, 0, 0, 1, 0, _arg3, 0, 0, 0, 1, 0]);
    }
    public function adjustHue(_arg1:Number):void{
        _arg1 = (_arg1 * RAD);
        var _local2:Number = Math.cos(_arg1);
        var _local3:Number = Math.sin(_arg1);
        this.concat([((LUMA_R + (_local2 * (1 - LUMA_R))) + (_local3 * -(LUMA_R))), ((LUMA_G + (_local2 * -(LUMA_G))) + (_local3 * -(LUMA_G))), ((LUMA_B + (_local2 * -(LUMA_B))) + (_local3 * (1 - LUMA_B))), 0, 0, ((LUMA_R + (_local2 * -(LUMA_R))) + (_local3 * 0.143)), ((LUMA_G + (_local2 * (1 - LUMA_G))) + (_local3 * 0.14)), ((LUMA_B + (_local2 * -(LUMA_B))) + (_local3 * -0.283)), 0, 0, ((LUMA_R + (_local2 * -(LUMA_R))) + (_local3 * -((1 - LUMA_R)))), ((LUMA_G + (_local2 * -(LUMA_G))) + (_local3 * LUMA_G)), ((LUMA_B + (_local2 * (1 - LUMA_B))) + (_local3 * LUMA_B)), 0, 0, 0, 0, 0, 1, 0]);
    }
    public function colorize(_arg1:int, _arg2:Number=1):void{
        var _local3:Number;
        var _local4:Number;
        var _local5:Number;
        var _local6:Number;
        _local3 = (((_arg1 >> 16) & 0xFF) / 0xFF);
        _local4 = (((_arg1 >> 8) & 0xFF) / 0xFF);
        _local5 = ((_arg1 & 0xFF) / 0xFF);
        _local6 = (1 - _arg2);
        this.concat([(_local6 + ((_arg2 * _local3) * LUMA_R)), ((_arg2 * _local3) * LUMA_G), ((_arg2 * _local3) * LUMA_B), 0, 0, ((_arg2 * _local4) * LUMA_R), (_local6 + ((_arg2 * _local4) * LUMA_G)), ((_arg2 * _local4) * LUMA_B), 0, 0, ((_arg2 * _local5) * LUMA_R), ((_arg2 * _local5) * LUMA_G), (_local6 + ((_arg2 * _local5) * LUMA_B)), 0, 0, 0, 0, 0, 1, 0]);
    }
    public function get filter():ColorMatrixFilter{
        return (new ColorMatrixFilter(this.matrix));
    }
    public function concat(_arg1:Array):void{
        var _local4:int;
        var _local5:int;
        var _local2:Array = [];
        var _local3:int;
        _local5 = 0;
        while (_local5 < 4) {
            _local4 = 0;
            while (_local4 < 5) {
                _local2[int((_local3 + _local4))] = (((((Number(_arg1[_local3]) * Number(this.matrix[_local4])) + (Number(_arg1[int((_local3 + 1))]) * Number(this.matrix[int((_local4 + 5))]))) + (Number(_arg1[int((_local3 + 2))]) * Number(this.matrix[int((_local4 + 10))]))) + (Number(_arg1[int((_local3 + 3))]) * Number(this.matrix[int((_local4 + 15))]))) + (((_local4 == 4)) ? Number(_arg1[int((_local3 + 4))]) : 0));
                _local4++;
            };
            _local3 = (_local3 + 5);
            _local5++;
        };
        this.matrix = _local2;
    }

}
