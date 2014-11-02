package wd.landing.effect {
    import flash.geom.*;
    import flash.display.*;
    import flash.filters.*;
    import flash.events.*;

    public class getDisplacementMap extends EventDispatcher {

        private static var _oI:getDisplacementMap;

        private var _bmd:BitmapData;
        private var _point:Point;
        private var _r:BitmapData;
        private var _g:BitmapData;
        private var _b:BitmapData;

        public function getDisplacementMap(access:PrivateConstructorAccess){
            this._point = new Point();
            super();
        }
        public static function getInstance():getDisplacementMap{
            if (!(_oI)){
                _oI = new getDisplacementMap(new PrivateConstructorAccess());
            };
            return (_oI);
        }

        public function GetDisplacementMap(bmpDt:BitmapData):DisplacementMapFilter{
            var mapBitmap:BitmapData = bmpDt;
            var mapPoint:Point = new Point(0, 0);
            var channels:uint = BitmapDataChannel.RED;
            var componentX:uint = channels;
            var componentY:uint = channels;
            var scaleX:Number = 5;
            var scaleY:Number = 1;
            var mode:String = DisplacementMapFilterMode.COLOR;
            var color:uint;
            var alpha:Number = 0;
            return (new DisplacementMapFilter(mapBitmap, mapPoint, componentX, componentY, scaleX, scaleY, mode, color, alpha));
        }
        public function randRange(min:int, max:int):int{
            var randomNum:int = (Math.floor((Math.random() * ((max - min) + 1))) + min);
            return (randomNum);
        }
        public function createRGB(dObj:DisplayObject):Array{
            this._bmd = new BitmapData(dObj.width, dObj.height, true, 0);
            this._bmd.draw(dObj);
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
