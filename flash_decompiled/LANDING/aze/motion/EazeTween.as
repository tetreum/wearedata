package aze.motion {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.filters.*;
    import aze.motion.specials.*;
    import flash.utils.*;
    import aze.motion.easing.*;

    public final class EazeTween {

        public static const specialProperties:Dictionary = new Dictionary();
        private static const running:Dictionary = new Dictionary();
        private static const ticker:Shape = createTicker();

        public static var defaultEasing:Function = Quadratic.easeOut;
        public static var defaultDuration:Object = {
            slow:1,
            normal:0.4,
            fast:0.2
        };
        private static var pauseTime:Number;
        private static var head:EazeTween;
        private static var tweenCount:int = 0;

        private var prev:EazeTween;
        private var next:EazeTween;
        private var rnext:EazeTween;
        private var isDead:Boolean;
        private var target:Object;
        private var reversed:Boolean;
        private var overwrite:Boolean;
        private var autoStart:Boolean;
        private var _configured:Boolean;
        private var _started:Boolean;
        private var _inited:Boolean;
        private var duration;
        private var _duration:Number;
        private var _ease:Function;
        private var startTime:Number;
        private var endTime:Number;
        private var properties:EazeProperty;
        private var specials:EazeSpecial;
        private var autoVisible:Boolean;
        private var slowTween:Boolean;
        private var _chain:Array;
        private var _onStart:Function;
        private var _onStartArgs:Array;
        private var _onUpdate:Function;
        private var _onUpdateArgs:Array;
        private var _onComplete:Function;
        private var _onCompleteArgs:Array;

        public function EazeTween(_arg1:Object, _arg2:Boolean=true){
            if (!_arg1){
                throw (new ArgumentError("EazeTween: target can not be null"));
            };
            this.target = _arg1;
            this.autoStart = _arg2;
            this._ease = defaultEasing;
        }
        public static function killAllTweens():void{
            var _local1:Object;
            for (_local1 in running) {
                killTweensOf(_local1);
            };
        }
        public static function killTweensOf(_arg1:Object):void{
            var _local3:EazeTween;
            if (!_arg1){
                return;
            };
            var _local2:EazeTween = running[_arg1];
            while (_local2) {
                _local2.isDead = true;
                _local2.dispose();
                if (_local2.rnext){
                    _local3 = _local2;
                    _local2 = _local2.rnext;
                    _local3.rnext = null;
                } else {
                    _local2 = null;
                };
            };
            delete running[_arg1];
        }
        public static function pauseAllTweens():void{
            if (ticker.hasEventListener(Event.ENTER_FRAME)){
                pauseTime = getTimer();
                ticker.removeEventListener(Event.ENTER_FRAME, tick);
            };
        }
        public static function resumeAllTweens():void{
            var _local1:Number;
            var _local2:EazeTween;
            if (!ticker.hasEventListener(Event.ENTER_FRAME)){
                _local1 = (getTimer() - pauseTime);
                _local2 = head;
                while (_local2) {
                    _local2.startTime = (_local2.startTime + _local1);
                    _local2.endTime = (_local2.endTime + _local1);
                    _local2 = _local2.next;
                };
                ticker.addEventListener(Event.ENTER_FRAME, tick);
            };
        }
        private static function createTicker():Shape{
            var _local1:Shape = new Shape();
            _local1.addEventListener(Event.ENTER_FRAME, tick);
            return (_local1);
        }
        private static function tick(_arg1:Event):void{
            if (head){
                updateTweens(getTimer());
            };
        }
        private static function updateTweens(_arg1:int):void{
            var _local6:Boolean;
            var _local7:Number;
            var _local8:Number;
            var _local9:Object;
            var _local10:EazeProperty;
            var _local11:EazeSpecial;
            var _local12:EazeTween;
            var _local13:EazeTween;
            var _local14:CompleteData;
            var _local15:int;
            var _local2:Array = [];
            var _local3:int;
            var _local4:EazeTween = head;
            var _local5:int;
            while (_local4) {
                _local5++;
                if (_local4.isDead){
                    _local6 = true;
                } else {
                    _local6 = (_arg1 >= _local4.endTime);
                    _local7 = ((_local6) ? 1 : ((_arg1 - _local4.startTime) / _local4._duration));
                    _local8 = _local4._ease(((_local7) || (0)));
                    _local9 = _local4.target;
                    _local10 = _local4.properties;
                    while (_local10) {
                        _local9[_local10.name] = (_local10.start + (_local10.delta * _local8));
                        _local10 = _local10.next;
                    };
                    if (_local4.slowTween){
                        if (_local4.autoVisible){
                            _local9.visible = (_local9.alpha > 0.001);
                        };
                        if (_local4.specials){
                            _local11 = _local4.specials;
                            while (_local11) {
                                _local11.update(_local8, _local6);
                                _local11 = _local11.next;
                            };
                        };
                        if (_local4._onStart != null){
                            _local4._onStart.apply(null, _local4._onStartArgs);
                            _local4._onStart = null;
                            _local4._onStartArgs = null;
                        };
                        if (_local4._onUpdate != null){
                            _local4._onUpdate.apply(null, _local4._onUpdateArgs);
                        };
                    };
                };
                if (_local6){
                    if (_local4._started){
                        _local14 = new CompleteData(_local4._onComplete, _local4._onCompleteArgs, _local4._chain, (_local4.endTime - _arg1));
                        _local4._chain = null;
                        _local2.unshift(_local14);
                        _local3++;
                    };
                    _local4.isDead = true;
                    _local4.detach();
                    _local4.dispose();
                    _local12 = _local4;
                    _local13 = _local4.prev;
                    _local4 = _local12.next;
                    if (_local13){
                        _local13.next = _local4;
                        if (_local4){
                            _local4.prev = _local13;
                        };
                    } else {
                        head = _local4;
                        if (_local4){
                            _local4.prev = null;
                        };
                    };
                    _local12.prev = (_local12.next = null);
                } else {
                    _local4 = _local4.next;
                };
            };
            if (_local3){
                _local15 = 0;
                while (_local15 < _local3) {
                    _local2[_local15].execute();
                    _local15++;
                };
            };
            tweenCount = _local5;
        }

        private function configure(_arg1, _arg2:Object=null, _arg3:Boolean=false):void{
            var _local4:String;
            var _local5:*;
            this._configured = true;
            this.reversed = _arg3;
            this.duration = _arg1;
            if (_arg2){
                for (_local4 in _arg2) {
                    _local5 = _arg2[_local4];
                    if ((_local4 in specialProperties)){
                        if (_local4 == "alpha"){
                            this.autoVisible = true;
                            this.slowTween = true;
                        } else {
                            if (_local4 == "alphaVisible"){
                                _local4 = "alpha";
                                this.autoVisible = false;
                            } else {
                                if (!(_local4 in this.target)){
                                    if (_local4 == "scale"){
                                        this.configure(_arg1, {
                                            scaleX:_local5,
                                            scaleY:_local5
                                        }, _arg3);
                                        continue;
                                    };
                                    this.specials = new specialProperties[_local4](this.target, _local4, _local5, this.specials);
                                    this.slowTween = true;
                                    continue;
                                };
                            };
                        };
                    };
                    if ((((_local5 is Array)) && ((this.target[_local4] is Number)))){
                        if (("__bezier" in specialProperties)){
                            this.specials = new specialProperties["__bezier"](this.target, _local4, _local5, this.specials);
                            this.slowTween = true;
                        };
                    } else {
                        this.properties = new EazeProperty(_local4, _local5, this.properties);
                    };
                };
            };
        }
        public function start(_arg1:Boolean=true, _arg2:Number=0):void{
            if (this._started){
                return;
            };
            if (!this._inited){
                this.init();
            };
            this.overwrite = _arg1;
            this.startTime = (getTimer() + _arg2);
            this._duration = (((isNaN(this.duration)) ? this.smartDuration(String(this.duration)) : Number(this.duration)) * 1000);
            this.endTime = (this.startTime + this._duration);
            if (((this.reversed) || ((this._duration == 0)))){
                this.update(this.startTime);
            };
            if (((this.autoVisible) && ((this._duration > 0)))){
                this.target.visible = true;
            };
            this._started = true;
            this.attach(this.overwrite);
        }
        private function init():void{
            if (this._inited){
                return;
            };
            var _local1:EazeProperty = this.properties;
            while (_local1) {
                _local1.init(this.target, this.reversed);
                _local1 = _local1.next;
            };
            var _local2:EazeSpecial = this.specials;
            while (_local2) {
                _local2.init(this.reversed);
                _local2 = _local2.next;
            };
            this._inited = true;
        }
        private function smartDuration(_arg1:String):Number{
            var _local2:EazeSpecial;
            if ((_arg1 in defaultDuration)){
                return (defaultDuration[_arg1]);
            };
            if (_arg1 == "auto"){
                _local2 = this.specials;
                while (_local2) {
                    if (("getPreferredDuration" in _local2)){
                        return (_local2["getPreferredDuration"]());
                    };
                    _local2 = _local2.next;
                };
            };
            return (defaultDuration.normal);
        }
        public function easing(_arg1:Function):EazeTween{
            this._ease = ((_arg1) || (defaultEasing));
            return (this);
        }
        public function filter(_arg1, _arg2:Object, _arg3:Boolean=false):EazeTween{
            if (!_arg2){
                _arg2 = {};
            };
            if (_arg3){
                _arg2.remove = true;
            };
            this.addSpecial(_arg1, _arg1, _arg2);
            return (this);
        }
        public function tint(_arg1=null, _arg2:Number=1, _arg3:Number=NaN):EazeTween{
            if (isNaN(_arg3)){
                _arg3 = (1 - _arg2);
            };
            this.addSpecial("tint", "tint", [_arg1, _arg2, _arg3]);
            return (this);
        }
        public function colorMatrix(_arg1:Number=0, _arg2:Number=0, _arg3:Number=0, _arg4:Number=0, _arg5:uint=0xFFFFFF, _arg6:Number=0):EazeTween{
            var _local7:Boolean = ((((((((!(_arg1)) && (!(_arg2)))) && (!(_arg3)))) && (!(_arg4)))) && (!(_arg6)));
            return (this.filter(ColorMatrixFilter, {
                brightness:_arg1,
                contrast:_arg2,
                saturation:_arg3,
                hue:_arg4,
                tint:_arg5,
                colorize:_arg6
            }, _local7));
        }
        public function short(_arg1:Number, _arg2:String="rotation", _arg3:Boolean=false):EazeTween{
            this.addSpecial("__short", _arg2, [_arg1, _arg3]);
            return (this);
        }
        public function rect(_arg1:Rectangle, _arg2:String="scrollRect"):EazeTween{
            this.addSpecial("__rect", _arg2, _arg1);
            return (this);
        }
        private function addSpecial(_arg1, _arg2, _arg3:Object):void{
            if ((((_arg1 in specialProperties)) && (this.target))){
                if (((((!(this._inited)) || ((this._duration == 0)))) && (this.autoStart))){
                    EazeSpecial(new specialProperties[_arg1](this.target, _arg2, _arg3, null)).init(true);
                } else {
                    this.specials = new specialProperties[_arg1](this.target, _arg2, _arg3, this.specials);
                    if (this._started){
                        this.specials.init(this.reversed);
                    };
                    this.slowTween = true;
                };
            };
        }
        public function onStart(_arg1:Function, ... _args):EazeTween{
            this._onStart = _arg1;
            this._onStartArgs = _args;
            this.slowTween = ((((((!(this.autoVisible)) || (!((this.specials == null))))) || (!((this._onUpdate == null))))) || (!((this._onStart == null))));
            return (this);
        }
        public function onUpdate(_arg1:Function, ... _args):EazeTween{
            this._onUpdate = _arg1;
            this._onUpdateArgs = _args;
            this.slowTween = ((((((!(this.autoVisible)) || (!((this.specials == null))))) || (!((this._onUpdate == null))))) || (!((this._onStart == null))));
            return (this);
        }
        public function onComplete(_arg1:Function, ... _args):EazeTween{
            this._onComplete = _arg1;
            this._onCompleteArgs = _args;
            return (this);
        }
        public function kill(_arg1:Boolean=false):void{
            if (this.isDead){
                return;
            };
            if (_arg1){
                this._onUpdate = (this._onComplete = null);
                this.update(this.endTime);
            } else {
                this.detach();
                this.dispose();
            };
            this.isDead = true;
        }
        public function killTweens():EazeTween{
            EazeTween.killTweensOf(this.target);
            return (this);
        }
        public function updateNow():EazeTween{
            var _local1:Number;
            if (this._started){
                _local1 = Math.max(this.startTime, getTimer());
                this.update(_local1);
            } else {
                this.init();
                this.endTime = (this._duration = 1);
                this.update(0);
            };
            return (this);
        }
        private function update(_arg1:Number):void{
            var _local2:EazeTween = head;
            head = this;
            updateTweens(_arg1);
            head = _local2;
        }
        private function attach(_arg1:Boolean):void{
            var _local2:EazeTween;
            if (_arg1){
                killTweensOf(this.target);
            } else {
                _local2 = running[this.target];
            };
            if (_local2){
                this.prev = _local2;
                this.next = _local2.next;
                if (this.next){
                    this.next.prev = this;
                };
                _local2.next = this;
                this.rnext = _local2;
            } else {
                if (head){
                    head.prev = this;
                };
                this.next = head;
                head = this;
            };
            running[this.target] = this;
        }
        private function detach():void{
            var _local1:EazeTween;
            var _local2:EazeTween;
            if (((this.target) && (this._started))){
                _local1 = running[this.target];
                if (_local1 == this){
                    if (this.rnext){
                        running[this.target] = this.rnext;
                    } else {
                        delete running[this.target];
                    };
                } else {
                    if (_local1){
                        _local2 = _local1;
                        _local1 = _local1.rnext;
                        while (_local1) {
                            if (_local1 == this){
                                _local2.rnext = this.rnext;
                                break;
                            };
                            _local2 = _local1;
                            _local1 = _local1.rnext;
                        };
                    };
                };
                this.rnext = null;
            };
        }
        private function dispose():void{
            var _local1:EazeTween;
            if (this._started){
                this.target = null;
                this._onComplete = null;
                this._onCompleteArgs = null;
                if (this._chain){
                    for each (_local1 in this._chain) {
                        _local1.dispose();
                    };
                    this._chain = null;
                };
            };
            if (this.properties){
                this.properties.dispose();
                this.properties = null;
            };
            this._ease = null;
            this._onStart = null;
            this._onStartArgs = null;
            if (this.slowTween){
                if (this.specials){
                    this.specials.dispose();
                    this.specials = null;
                };
                this.autoVisible = false;
                this._onUpdate = null;
                this._onUpdateArgs = null;
            };
        }
        public function delay(_arg1, _arg2:Boolean=true):EazeTween{
            return (this.add(_arg1, null, _arg2));
        }
        public function apply(_arg1:Object=null, _arg2:Boolean=true):EazeTween{
            return (this.add(0, _arg1, _arg2));
        }
        public function play(_arg1=0, _arg2:Boolean=true):EazeTween{
            return (this.add("auto", {frame:_arg1}, _arg2).easing(Linear.easeNone));
        }
        public function to(_arg1, _arg2:Object=null, _arg3:Boolean=true):EazeTween{
            return (this.add(_arg1, _arg2, _arg3));
        }
        public function from(_arg1, _arg2:Object=null, _arg3:Boolean=true):EazeTween{
            return (this.add(_arg1, _arg2, _arg3, true));
        }
        private function add(_arg1, _arg2:Object, _arg3:Boolean, _arg4:Boolean=false):EazeTween{
            if (this.isDead){
                return (new EazeTween(this.target).add(_arg1, _arg2, _arg3, _arg4));
            };
            if (this._configured){
                return (this.chain().add(_arg1, _arg2, _arg3, _arg4));
            };
            this.configure(_arg1, _arg2, _arg4);
            if (this.autoStart){
                this.start(_arg3);
            };
            return (this);
        }
        public function chain(_arg1:Object=null):EazeTween{
            var _local2:EazeTween = new EazeTween(((_arg1) || (this.target)), false);
            if (!this._chain){
                this._chain = [];
            };
            this._chain.push(_local2);
            return (_local2);
        }
        public function get isStarted():Boolean{
            return (this._started);
        }
        public function get isFinished():Boolean{
            return (this.isDead);
        }

        specialProperties.alpha = true;
        specialProperties.alphaVisible = true;
        specialProperties.scale = true;
    }
}//package aze.motion 

final class EazeProperty {

    public var name:String;
    public var start:Number;
    public var end:Number;
    public var delta:Number;
    public var next:EazeProperty;

    public function EazeProperty(_arg1:String, _arg2:Number, _arg3:EazeProperty){
        this.name = _arg1;
        this.end = _arg2;
        this.next = _arg3;
    }
    public function init(_arg1:Object, _arg2:Boolean):void{
        if (_arg2){
            this.start = this.end;
            this.end = _arg1[this.name];
            _arg1[this.name] = this.start;
        } else {
            this.start = _arg1[this.name];
        };
        this.delta = (this.end - this.start);
    }
    public function dispose():void{
        if (this.next){
            this.next.dispose();
        };
        this.next = null;
    }

}
final class CompleteData {

    private var callback:Function;
    private var args:Array;
    private var chain:Array;
    private var diff:Number;

    public function CompleteData(_arg1:Function, _arg2:Array, _arg3:Array, _arg4:Number){
        this.callback = _arg1;
        this.args = _arg2;
        this.chain = _arg3;
        this.diff = _arg4;
    }
    public function execute():void{
        var _local1:int;
        var _local2:int;
        if (this.callback != null){
            this.callback.apply(null, this.args);
            this.callback = null;
        };
        this.args = null;
        if (this.chain){
            _local1 = this.chain.length;
            _local2 = 0;
            while (_local2 < _local1) {
                EazeTween(this.chain[_local2]).start(false, this.diff);
                _local2++;
            };
            this.chain = null;
        };
    }

}
