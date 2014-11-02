package wd.landing.effect {
    import flash.display.*;
    import flash.geom.*;

    public class CopyToBmp {

        public static function mcToBmp(mc:DisplayObject, _w:Number=NaN, _h:Number=NaN):Bitmap{
            if (!(_w)){
                _w = mc.width;
            };
            if (!(_h)){
                _h = mc.height;
            };
            var BmpDt:BitmapData = new BitmapData(_w, _h, true, 0);
            BmpDt.draw(mc, null, null, null, null, true);
            var Bmp:Bitmap = new Bitmap(BmpDt, "auto", true);
            Bmp.smoothing = true;
            return (Bmp);
        }
        public static function partOfmcToBmp(mc:DisplayObject, rectPart:Rectangle):Bitmap{
            var spriteContainer:Sprite = new Sprite();
            var copyBmp:Bitmap = mcToBmp(mc);
            copyBmp.x = -(rectPart.x);
            copyBmp.y = -(rectPart.y);
            spriteContainer.addChild(copyBmp);
            return (mcToBmp(spriteContainer, rectPart.width, rectPart.height));
        }

    }
}//package wd.landing.effect 
