package aze.motion.easing {

    public final class Back {

        public static var easeIn:Function = easeInWith();
        public static var easeOut:Function = easeOutWith();
        public static var easeInOut:Function = easeInOutWith();

        public static function easeInWith(s:Number=1.70158):Function{
            var s:Number = s;
            return (function (k:Number):Number{
                return (((k * k) * (((s + 1) * k) - s)));
            });
        }
        public static function easeOutWith(s:Number=1.70158):Function{
            var s:Number = s;
            return (function (k:Number):Number{
                k = (k - 1);
                return ((((k * k) * (((s + 1) * k) + s)) + 1));
            });
        }
        public static function easeInOutWith(s:Number=1.70158):Function{
            var s:Number = s;
            s = (s * 1.525);
            return (function (k:Number):Number{
                k = (k * 2);
                if (k < 1){
                    return ((0.5 * ((k * k) * (((s + 1) * k) - s))));
                };
                k = (k - 2);
                return ((0.5 * (((k * k) * (((s + 1) * k) + s)) + 2)));
            });
        }

    }
}//package aze.motion.easing 
