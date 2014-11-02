package wd.landing {
    import flash.events.*;
    import flash.display.*;
    import wd.landing.star.*;
    import flash.geom.*;
    import flash.utils.*;
    import __AS3__.vec.*;

    public class Stars extends Sprite {

        public static const ROUND:String = "round";
        public static const SQUARRE:String = "squarre";
        public static const TOTAL_STARS:int = 18;

        private var translation3D:Vector3D;
        private var rotation3D:Vector3D;
        private var scale3D:Vector3D;
        private var transform3D:Matrix3D;
        private var tabStar:Vector.<StarItem>;
        private var aStar:StarItem;
        private var tmp_vector3d:Vector3D;
        private var star1:StarItem;
        private var star2:StarItem;
        private var i:Number;
        private var j:Number;
        private var StarsContainer:Sprite;
        private var canvasDistanceMax:Number;
        private var _timeDistort:Timer;
        private var radius:Number;
        private var tabBt:Array;

        public function Stars(){
            var _local3:StarItem;
            this.translation3D = new Vector3D(0, 0, 0);
            this.rotation3D = new Vector3D(185, 0, 10);
            this.scale3D = new Vector3D(1, 1, 1);
            this.transform3D = new Matrix3D();
            this.tabBt = [];
            super();
            this.radius = MainLanding.RADIUS;
            this.canvasDistanceMax = this._distance(MainLanding.WIDTH, MainLanding.HEIGHT);
            this.StarsContainer = new Sprite();
            addChild(this.StarsContainer);
            var _local1:PerspectiveProjection = new PerspectiveProjection();
            _local1.projectionCenter = new Point(0, 0);
            transform.perspectiveProjection = _local1;
            this.tabStar = new Vector.<StarItem>();
            this.i = 0;
            while (this.i < TOTAL_STARS) {
                _local3 = new StarItem();
                this.spherify(((Math.random() * Math.PI) * 2), ((Math.PI / 4) + (Math.random() * ((2 * Math.PI) / 4))), ((this.radius * 1.2) + (Math.random() * this.radius)), _local3);
                this.tabStar.push(_local3);
                this.StarsContainer.addChild(_local3);
                this.i++;
            };
            this.scale3D.x = (this.scale3D.y = (this.scale3D.z = 1));
            this.translation3D.x = 0;
            this.translation3D.y = 0;
            this.translation3D.z = 0;
            addEventListener(Event.ENTER_FRAME, this.oef);
            var _local2:Timer = new Timer(2000, 0);
            _local2.addEventListener(TimerEvent.TIMER, this.startDistortEffect);
            _local2.start();
        }
        private function resetEffect(_arg1:TimerEvent):void{
            this.i = 0;
            while (this.i < this.tabStar.length) {
                StarItem(this.tabStar[this.i]).resetDistort();
                this.i++;
            };
        }
        private function startDistortEffect(_arg1:TimerEvent):void{
            this._timeDistort = new Timer(100, 10);
            this._timeDistort.addEventListener(TimerEvent.TIMER, this.distortEffect);
            this._timeDistort.addEventListener(TimerEvent.TIMER_COMPLETE, this.resetEffect);
            this._timeDistort.start();
        }
        private function distortEffect(_arg1:TimerEvent):void{
            this.i = 0;
            while (this.i < this.tabStar.length) {
                if ((-1 + (Math.random() * 2)) > 0){
                    StarItem(this.tabStar[this.i]).distortIt();
                };
                this.i++;
            };
        }
        private function spherify(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:StarItem):void{
            _arg4.vector3d = new Vector3D(((Math.cos(_arg1) * Math.sin(_arg2)) * _arg3), (Math.cos(_arg2) * _arg3), ((Math.sin(_arg1) * Math.sin(_arg2)) * _arg3));
        }
        private function oef(_arg1:Event):void{
            var _local2:Number;
            var _local3:Number;
            this.rotation3D.y = (this.rotation3D.y - (MainLanding.SPEED_Y * 0.5));
            this.transform3D.identity();
            this.transform3D.appendScale(this.scale3D.x, this.scale3D.y, this.scale3D.z);
            this.transform3D.appendRotation(this.rotation3D.x, Vector3D.X_AXIS);
            this.transform3D.appendRotation(this.rotation3D.y, Vector3D.Y_AXIS);
            this.transform3D.appendRotation(this.rotation3D.z, Vector3D.Z_AXIS);
            this.transform3D.appendTranslation(this.translation3D.x, this.translation3D.y, this.translation3D.z);
            this.i = 0;
            while (this.i < this.tabStar.length) {
                this.aStar = StarItem(this.tabStar[this.i]);
                this.tmp_vector3d = this.transform3D.transformVector(this.aStar.vector3d);
                if (((this.aStar.isOver) && ((this.aStar.typeStar == StarItem.BUTTON_STAR)))){
                    StarButton(this.aStar).ptPosition.x = this.tmp_vector3d.x;
                    StarButton(this.aStar).ptPosition.y = this.tmp_vector3d.y;
                } else {
                    this.aStar.x = this.tmp_vector3d.x;
                    this.aStar.y = this.tmp_vector3d.y;
                    this.aStar.radiusRatio = this._getRadiusRatio(this.aStar.x, this.aStar.y);
                };
                this.i++;
            };
            graphics.clear();
            this.i = 0;
            while (this.i < this.tabStar.length) {
                this.star1 = this.tabStar[this.i];
                if (this.star1.radiusRatio < 1){
                    this.j = 0;
                    while (this.j < this.tabStar.length) {
                        this.star2 = this.tabStar[this.j];
                        if ((((this.star2.radiusRatio < 1)) && (!((this.i == this.j))))){
                            _local2 = Math.pow((1 - (this._distance((this.star1.x - this.star2.x), (this.star1.y - this.star2.y)) / this.canvasDistanceMax)), 8);
                            if (_local2 > 0.1){
                                _local3 = ((-(Math.random()) * 0.3) + (_local2 * 0.8));
                                graphics.lineStyle(0.5, 52475, _local3);
                                graphics.moveTo(this.star1.x, this.star1.y);
                                graphics.lineTo((this.star2.x + this.star2.realSize), (this.star2.y + this.star2.realSize));
                                _local3 = ((-(Math.random()) * 0.2) + (_local2 * 0.5));
                                graphics.lineStyle(0.5, 0xFF3600, _local3);
                                graphics.moveTo((this.star1.x + this.star1.realSize), (this.star1.y + this.star1.realSize));
                                graphics.lineTo(this.star2.x, this.star2.y);
                            };
                        };
                        this.j++;
                    };
                };
                this.i++;
            };
        }
        private function _distance(_arg1:Number, _arg2:Number):Number{
            return (Math.sqrt(((_arg1 * _arg1) + (_arg2 * _arg2))));
        }
        private function _getRadiusRatio(_arg1:Number, _arg2:Number):Number{
            var _local3:Number = Math.atan2(_arg1, _arg2);
            var _local4:Number = this._distance(_arg1, _arg2);
            var _local5:Number = Math.atan((MainLanding.WIDTH / MainLanding.HEIGHT));
            if ((((Math.abs(_local3) < _local5)) || ((Math.abs(_local3) > (Math.PI - _local5))))){
                return (Math.abs(((_local4 / (MainLanding.HEIGHT >> 1)) * Math.cos(_local3))));
            };
            return (Math.abs(((_local4 / (MainLanding.WIDTH >> 1)) * Math.sin(_local3))));
        }
        public function createButton(_arg1:XMLList, _arg2:String):void{
            var _local4:StarButton;
            var _local3:int;
            while (_local3 < _arg1.button.length()) {
                _local4 = new StarButton(_arg1.button[_local3].name, (_arg2 + _arg1.button[_local3].@url), _arg1.@target, _arg1.button[_local3].tag);
                _local4.addEventListener(StarButton.ON_OVER, this.onOverCity);
                _local4.addEventListener(StarButton.ON_OUT, this.onOutCity);
                this.spherify(_arg1.button[_local3].@x, _arg1.button[_local3].@y, ((this.radius * 1) + Number(_arg1.button[_local3].@z)), StarItem(_local4));
                this.tabStar.push(_local4);
                this.tabBt.push(_local4);
                this.StarsContainer.addChild(_local4);
                _local3++;
            };
        }
        private function onOutCity(_arg1:Event):void{
            var _local2:int;
            while (_local2 < this.tabBt.length) {
                StarButton(this.tabBt[_local2]).setNormal();
                _local2++;
            };
        }
        private function onOverCity(_arg1:Event):void{
            var _local2:int;
            while (_local2 < this.tabBt.length) {
                if (StarButton(this.tabBt[_local2]) != StarButton(_arg1.currentTarget)){
                    StarButton(this.tabBt[_local2]).setOut();
                } else {
                    StarButton(this.tabBt[_local2]).setOver();
                };
                _local2++;
            };
        }

    }
}//package wd.landing 
