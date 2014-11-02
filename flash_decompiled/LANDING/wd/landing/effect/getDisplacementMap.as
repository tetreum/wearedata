package wd.landing.effect {
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.filters.*;

    public class getDisplacementMap extends EventDispatcher {

        private static var _oI:getDisplacementMap;

        private var _bmd:BitmapData;
        private var _point:Point;
        private var _r:BitmapData;
        private var _g:BitmapData;
        private var _b:BitmapData;

        public function getDisplacementMap(_arg1:PrivateConstructorAccess){
            this._point = new Point();
            super();
        }
        public static function getInstance():getDisplacementMap{
            if (!_oI){
                _oI = new getDisplacementMap(new PrivateConstructorAccess());
            };
            return (_oI);
        }

        public function GetDisplacementMap(_arg1:BitmapData):DisplacementMapFilter{
            var _local2:BitmapData = _arg1;
            var _local3:Point = new Point(0, 0);
            var _local4:uint = BitmapDataChannel.RED;
            var _local5:uint = _local4;
            var _local6:uint = _local4;
            var _local7:Number = 5;
            var _local8:Number = 1;
            var _local9:String = DisplacementMapFilterMode.COLOR;
            var _local10:uint;
            var _local11:Number = 0;
            return (new DisplacementMapFilter(_local2, _local3, _local5, _local6, _local7, _local8, _local9, _local10, _local11));
        }
        public function randRange(_arg1:int, _arg2:int):int{
            var _local3:int = (Math.floor((Math.random() * ((_arg2 - _arg1) + 1))) + _arg1);
            return (_local3);
        }
        public function createRGB(_arg1:DisplayObject):Array{
            this._bmd = new BitmapData(_arg1.width, _arg1.height, true, 0);
            this._bmd.draw(_arg1);
            this._r = new BitmapData(this._bmd.width, this._bmd.height, true, 0xFF000000);
            this._g = new BitmapData(this._bmd.width, this._bmd.height, true, 0xFF000000);
            this._b = new BitmapData(this._bmd.width, this._bmd.height, true, 0xFF000000);
            this._r.copyChannel(this._bmd, this._bmd.rect, this._point, BitmapDataChannel.RED, BitmapDataChannel.RED);
            this._r.copyChannel(this._bmd, this._bmd.rect, this._point, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
            this._g.copyChannel(this._bmd, this._bmd.rect, this._point, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
            this._g.copyChannel(this._bmd, this._bmd.rect, this._point, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
            this._b.copyChannel(this._bmd, this._bmd.rect, this._point, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
            this._b.copyChannel(this._bmd, this._bmd.rect, this._point, BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
            return ([this._r, this._g, this._b]);
        }

    }
}//package wd.landing.effect 

class PrivateConstructorAccess {

    public function PrivateConstructorAccess(){
    }
}
