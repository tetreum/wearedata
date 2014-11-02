package aze.motion.specials {
    import flash.display.*;
    import flash.filters.*;
    import aze.motion.*;

    public class PropertyFilter extends EazeSpecial {

        public static var fixedProp:Object = {
            quality:true,
            color:true
        };

        private var properties:Array;
        private var fvalue:BitmapFilter;
        private var start:Object;
        private var delta:Object;
        private var fColor:Object;
        private var startColor:Object;
        private var deltaColor:Object;
        private var removeWhenComplete:Boolean;
        private var isNewFilter:Boolean;
        private var filterClass:Class;

        public function PropertyFilter(_arg1:Object, _arg2, _arg3, _arg4:EazeSpecial){
            var _local7:String;
            var _local8:*;
            super(_arg1, _arg2, _arg3, _arg4);
            this.filterClass = this.resolveFilterClass(_arg2);
            var _local5:DisplayObject = DisplayObject(_arg1);
            var _local6:BitmapFilter = PropertyFilter.getCurrentFilter(this.filterClass, _local5, false);
            if (!_local6){
                this.isNewFilter = true;
                _local6 = new this.filterClass();
            };
            this.properties = [];
            this.fvalue = _local6.clone();
            for (_local7 in _arg3) {
                _local8 = _arg3[_local7];
                if (_local7 == "remove"){
                    this.removeWhenComplete = _local8;
                } else {
                    if ((((_local7 == "color")) && (!(this.isNewFilter)))){
                        this.fColor = {
                            r:((_local8 >> 16) & 0xFF),
                            g:((_local8 >> 8) & 0xFF),
                            b:(_local8 & 0xFF)
                        };
                    };
                    this.fvalue[_local7] = _local8;
                    this.properties.push(_local7);
                };
            };
        }
        public static function register():void{
            EazeTween.specialProperties["blurFilter"] = PropertyFilter;
            EazeTween.specialProperties["glowFilter"] = PropertyFilter;
            EazeTween.specialProperties["dropShadowFilter"] = PropertyFilter;
            EazeTween.specialProperties[BlurFilter] = PropertyFilter;
            EazeTween.specialProperties[GlowFilter] = PropertyFilter;
            EazeTween.specialProperties[DropShadowFilter] = PropertyFilter;
        }
        public static function getCurrentFilter(_arg1:Class, _arg2:DisplayObject, _arg3:Boolean):BitmapFilter{
            var _local4:int;
            var _local5:Array;
            var _local6:BitmapFilter;
            if (_arg2.filters){
                _local5 = _arg2.filters;
                _local4 = 0;
                while (_local4 < _local5.length) {
                    if ((_local5[_local4] is _arg1)){
                        if (_arg3){
                            _local6 = _local5.splice(_local4, 1)[0];
                            _arg2.filters = _local5;
                            return (_local6);
                        };
                        return (_local5[_local4]);
                    };
                    _local4++;
                };
            };
            return (null);
        }
        public static function addFilter(_arg1:DisplayObject, _arg2:BitmapFilter):void{
            var _local3:Array = ((_arg1.filters) || ([]));
            _local3.push(_arg2);
            _arg1.filters = _local3;
        }

        private function resolveFilterClass(_arg1):Class{
            if ((_arg1 is Class)){
                return (_arg1);
            };
            switch (_arg1){
                case "blurFilter":
                    return (BlurFilter);
                case "glowFilter":
                    return (GlowFilter);
                case "dropShadowFilter":
                    return (DropShadowFilter);
            };
            return (BlurFilter);
        }
        override public function init(_arg1:Boolean):void{
            var _local4:BitmapFilter;
            var _local5:BitmapFilter;
            var _local6:Object;
            var _local7:Object;
            var _local8:*;
            var _local10:String;
            var _local2:DisplayObject = DisplayObject(target);
            var _local3:BitmapFilter = PropertyFilter.getCurrentFilter(this.filterClass, _local2, true);
            if (!_local3){
                _local3 = new this.filterClass();
            };
            if (this.fColor){
                _local8 = _local3["color"];
                _local6 = {
                    r:((_local8 >> 16) & 0xFF),
                    g:((_local8 >> 8) & 0xFF),
                    b:(_local8 & 0xFF)
                };
            };
            if (_arg1){
                _local4 = this.fvalue;
                _local5 = _local3;
                this.startColor = this.fColor;
                _local7 = _local6;
            } else {
                _local4 = _local3;
                _local5 = this.fvalue;
                this.startColor = _local6;
                _local7 = this.fColor;
            };
            this.start = {};
            this.delta = {};
            var _local9:int;
            for (;_local9 < this.properties.length;_local9++) {
                _local10 = this.properties[_local9];
                _local8 = this.fvalue[_local10];
                if ((_local8 is Boolean)){
                    _local3[_local10] = _local8;
                    this.properties[_local9] = null;
                } else {
                    if (this.isNewFilter){
                        if ((_local10 in fixedProp)){
                            _local3[_local10] = _local8;
                            this.properties[_local9] = null;
                            continue;
                        };
                        _local3[_local10] = 0;
                    } else {
                        if ((((_local10 == "color")) && (this.fColor))){
                            this.deltaColor = {
                                r:(_local7.r - this.startColor.r),
                                g:(_local7.g - this.startColor.g),
                                b:(_local7.b - this.startColor.b)
                            };
                            this.properties[_local9] = null;
                            continue;
                        };
                    };
                    this.start[_local10] = _local4[_local10];
                    this.delta[_local10] = (_local5[_local10] - this.start[_local10]);
                };
            };
            this.fvalue = null;
            this.fColor = null;
            PropertyFilter.addFilter(_local2, _local4);
        }
        override public function update(_arg1:Number, _arg2:Boolean):void{
            var _local6:String;
            var _local3:DisplayObject = DisplayObject(target);
            var _local4:BitmapFilter = PropertyFilter.getCurrentFilter(this.filterClass, _local3, true);
            if (((this.removeWhenComplete) && (_arg2))){
                _local3.filters = _local3.filters;
                return;
            };
            if (!_local4){
                _local4 = new this.filterClass();
            };
            var _local5:int;
            while (_local5 < this.properties.length) {
                _local6 = this.properties[_local5];
                if (_local6){
                    _local4[_local6] = (this.start[_local6] + (_arg1 * this.delta[_local6]));
                };
                _local5++;
            };
            if (this.startColor){
                _local4["color"] = ((((this.startColor.r + (_arg1 * this.deltaColor.r)) << 16) | ((this.startColor.g + (_arg1 * this.deltaColor.g)) << 8)) | (this.startColor.b + (_arg1 * this.deltaColor.b)));
            };
            PropertyFilter.addFilter(_local3, _local4);
        }
        override public function dispose():void{
            this.filterClass = null;
            this.start = (this.delta = null);
            this.startColor = (this.deltaColor = null);
            this.fvalue = null;
            this.fColor = null;
            this.properties = null;
            super.dispose();
        }

    }
}//package aze.motion.specials 
