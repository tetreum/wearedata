package wd.landing {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;
    import __AS3__.vec.*;

    public class Sphere extends Sprite {

        private var translation3D:Vector3D;
        private var rotation3D:Vector3D;
        private var scale3D:Vector3D;
        private var transform3D:Matrix3D;
        private var vertices:Vector.<Number>;
        private var tmp:Vector.<Number>;
        private var uvts:Vector.<Number>;
        private var projections:Vector.<Number>;
        private var tabType:Array;

        public function Sphere(_arg1:BitmapData):void{
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            var _local11:Number;
            var _local12:Number;
            var _local13:Object;
            var _local15:int;
            this.translation3D = new Vector3D(0, 0, 0);
            this.rotation3D = new Vector3D(185, 0, 10);
            this.scale3D = new Vector3D(1, 1, 1);
            this.transform3D = new Matrix3D();
            this.tabType = [];
            super();
            var _local2:Number = MainLanding.RADIUS;
            var _local3:PerspectiveProjection = new PerspectiveProjection();
            _local3.projectionCenter = new Point(0, 0);
            transform.perspectiveProjection = _local3;
            this.vertices = new Vector.<Number>();
            this.tmp = new Vector.<Number>();
            this.projections = new Vector.<Number>();
            this.uvts = new Vector.<Number>();
            var _local4 = 4;
            var _local5:int = (36 * _local4);
            var _local6:int = (18 * _local4);
            var _local7:BitmapData = _arg1;
            var _local14:int;
            while (_local14 < _local5) {
                _local8 = ((_local7.width / _local5) * _local14);
                _local15 = 0;
                while (_local15 < _local6) {
                    _local9 = ((_local7.height / _local6) * _local15);
                    _local10 = _local7.getPixel(_local8, _local9);
                    switch (_local10){
                        case 0x5E5E5E:
                            _local11 = 0.2;
                            _local12 = 12058103;
                            break;
                        case 0xFFFFFF:
                            _local11 = 1;
                            _local12 = 14876151;
                            break;
                    };
                    if (_local10 > 0){
                        _local13 = {
                            size:_local11,
                            color:_local12
                        };
                        this.spherify((((_local14 / _local5) * Math.PI) * 2), ((_local15 / _local6) * Math.PI), _local2, _local13);
                    };
                    _local15++;
                };
                _local14++;
            };
            this.scale3D.x = (this.scale3D.y = (this.scale3D.z = 1));
            this.translation3D.x = 0;
            this.translation3D.y = 0;
            this.translation3D.z = 0;
            addEventListener(Event.ENTER_FRAME, this.oef);
        }
        public function stopEnterFrame():void{
            removeEventListener(Event.ENTER_FRAME, this.oef);
        }
        private function spherify(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Object):void{
            this.vertices.push(((Math.cos(_arg1) * Math.sin(_arg2)) * _arg3));
            this.vertices.push((Math.cos(_arg2) * _arg3));
            this.vertices.push(((Math.sin(_arg1) * Math.sin(_arg2)) * _arg3));
            this.tabType.push(_arg4);
        }
        private function oef(_arg1:Event):void{
            var _local2:Number = Math.sin((getTimer() * 0.001));
            this.rotation3D.y = (this.rotation3D.y - MainLanding.SPEED_Y);
            this.transform3D.identity();
            this.transform3D.appendScale(this.scale3D.x, this.scale3D.y, this.scale3D.z);
            this.transform3D.appendRotation(this.rotation3D.x, Vector3D.X_AXIS);
            this.transform3D.appendRotation(this.rotation3D.y, Vector3D.Y_AXIS);
            this.transform3D.appendRotation(this.rotation3D.z, Vector3D.Z_AXIS);
            this.transform3D.appendTranslation(this.translation3D.x, this.translation3D.y, this.translation3D.z);
            this.transform3D.transformVectors(this.vertices, this.tmp);
            this.transform3D.identity();
            Utils3D.projectVectors(this.transform3D, this.tmp, this.projections, this.uvts);
            graphics.clear();
            var _local3:int;
            while (_local3 < this.projections.length) {
                if (this.tmp[(((_local3 / 2) * 3) + 2)] > 0){
                    graphics.lineStyle(1, this.tabType[(_local3 >> 1)].color, (0.4 + (Math.random() * 0.6)));
                    graphics.drawCircle(this.projections[_local3], this.projections[(_local3 + 1)], this.tabType[(_local3 >> 1)].size);
                };
                _local3 = (_local3 + 2);
            };
        }

    }
}//package wd.landing 
