package aze.motion.easing {

    public final class Expo {

        public static function easeIn(k:Number):Number{
            return ((((k == 0)) ? 0 : Math.pow(2, (10 * (k - 1)))));
        }
        public static function easeOut(k:Number):Number{
            return ((((k == 1)) ? 1 : (-(Math.pow(2, (-10 * k))) + 1)));
        }
        public static function easeInOut(k:Number):Number{
            if (k == 0){
                return (0);
            };
            if (k == 1){
                return (1);
            };
            k = (k * 2);
            if (k < 1){
                return ((0.5 * Math.pow(2, (10 * (k - 1)))));
            };
            return ((0.5 * (-(Math.pow(2, (-10 * (k - 1)))) + 2)));
        }

    }
}//package aze.motion.easing 
