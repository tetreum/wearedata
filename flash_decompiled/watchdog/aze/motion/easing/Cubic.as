package aze.motion.easing {

    public final class Cubic {

        public static function easeIn(k:Number):Number{
            return (((k * k) * k));
        }
        public static function easeOut(k:Number):Number{
            --k;
            return ((((k * k) * k) + 1));
        }
        public static function easeInOut(k:Number):Number{
            k = (k * 2);
            if (k < 1){
                return ((((0.5 * k) * k) * k));
            };
            k = (k - 2);
            return ((0.5 * (((k * k) * k) + 2)));
        }

    }
}//package aze.motion.easing 
