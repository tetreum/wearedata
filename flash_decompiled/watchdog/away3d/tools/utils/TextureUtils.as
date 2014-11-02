package away3d.tools.utils {
    import flash.display.*;

    public class TextureUtils {

        private static const MAX_SIZE:uint = 0x0800;

        public static function isBitmapDataValid(bitmapData:BitmapData):Boolean{
            if (bitmapData == null){
                return (true);
            };
            return (((isDimensionValid(bitmapData.width)) && (isDimensionValid(bitmapData.height))));
        }
        public static function isDimensionValid(d:uint):Boolean{
            return ((((((d >= 1)) && ((d <= MAX_SIZE)))) && (isPowerOfTwo(d))));
        }
        public static function isPowerOfTwo(value:int):Boolean{
            return (((value) ? ((value & -(value)) == value) : false));
        }
        public static function getBestPowerOf2(value:uint):Number{
            var p:uint = 1;
            while (p < value) {
                p = (p << 1);
            };
            if (p > MAX_SIZE){
                p = MAX_SIZE;
            };
            return (p);
        }

    }
}//package away3d.tools.utils 
