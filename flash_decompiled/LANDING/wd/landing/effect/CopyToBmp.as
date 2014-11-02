package wd.landing.effect {
    import flash.display.*;
    import flash.geom.*;

    public class CopyToBmp {

        public static function mcToBmp(_arg1:DisplayObject, _arg2:Number=NaN, _arg3:Number=NaN):Bitmap{
            if (!_arg2){
                _arg2 = _arg1.width;
            };
            if (!_arg3){
                _arg3 = _arg1.height;
            };
            var _local4:BitmapData = new BitmapData(_arg2, _arg3, true, 0);
            _local4.draw(_arg1, null, null, null, null, true);
            var _local5:Bitmap = new Bitmap(_local4, "auto", true);
            _local5.smoothing = true;
            return (_local5);
        }
        public static function partOfmcToBmp(_arg1:DisplayObject, _arg2:Rectangle):Bitmap{
            var _local3:Sprite = new Sprite();
            var _local4:Bitmap = mcToBmp(_arg1);
            _local4.x = -(_arg2.x);
            _local4.y = -(_arg2.y);
            _local3.addChild(_local4);
            return (mcToBmp(_local3, _arg2.width, _arg2.height));
        }

    }
}//package wd.landing.effect 
