package wd.wq.textures {

    public class WQTextureSmoothing {

        public static const NONE:String = "none";
        public static const BILINEAR:String = "bilinear";
        public static const TRILINEAR:String = "trilinear";

        public function WQTextureSmoothing(){
            super();
        }
        public static function isValid(smoothing:String):Boolean{
            return ((((((smoothing == NONE)) || ((smoothing == BILINEAR)))) || ((smoothing == TRILINEAR))));
        }

    }
}//package wd.wq.textures 
