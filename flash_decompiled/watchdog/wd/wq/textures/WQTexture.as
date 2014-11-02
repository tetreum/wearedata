package wd.wq.textures {
    import flash.display3D.textures.*;
    import flash.display.*;
    import wd.wq.core.*;
    import flash.display3D.*;

    public class WQTexture {

        private var mRepeat:Boolean;

        public function WQTexture(){
            super();
            this.mRepeat = false;
        }
        static function uploadBitmapData(nativeTexture:Texture, data:BitmapData, generateMipmaps:Boolean):void{
            nativeTexture.uploadFromBitmapData(data);
        }
        public static function fromColor(width:int, height:int, color:uint=0xFFFFFFFF, optimizeForRenderToTexture:Boolean=false):WQConcreteTexture{
            var bitmapData:BitmapData = new BitmapData(width, height, true, color);
            var texture:WQConcreteTexture = fromBitmapData(bitmapData, false, optimizeForRenderToTexture);
            bitmapData.dispose();
            return (texture);
        }
        public static function getNextPowerOfTwo(number:int):int{
            var result:int;
            if ((((number > 0)) && (((number & (number - 1)) == 0)))){
                return (number);
            };
            result = 1;
            while (result < number) {
                result = (result << 1);
            };
            return (result);
        }
        public static function fromBitmapData(data:BitmapData, generateMipMaps:Boolean=false, optimizeForRenderToTexture:Boolean=false, scale:Number=1):WQConcreteTexture{
            var origWidth:int = data.width;
            var origHeight:int = data.height;
            var legalWidth:int = getNextPowerOfTwo(origWidth);
            var legalHeight:int = getNextPowerOfTwo(origHeight);
            var context:Context3D = WatchQuads.context;
            var nativeTexture:Texture = context.createTexture(legalWidth, legalHeight, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
            uploadBitmapData(nativeTexture, data, generateMipMaps);
            var concreteTexture:WQConcreteTexture = new WQConcreteTexture(nativeTexture, origWidth, origHeight, legalWidth, legalHeight);
            return (concreteTexture);
        }

        public function get repeat():Boolean{
            return (this.mRepeat);
        }
        public function set repeat(value:Boolean):void{
            this.mRepeat = value;
        }
        public function get width():Number{
            return (0);
        }
        public function get height():Number{
            return (0);
        }
        public function get nativeWidth():Number{
            return (0);
        }
        public function get nativeHeight():Number{
            return (0);
        }
        public function get scale():Number{
            return (1);
        }
        public function get base():TextureBase{
            return (null);
        }
        public function get format():String{
            return (Context3DTextureFormat.BGRA);
        }
        public function get mipMapping():Boolean{
            return (false);
        }
        public function get premultipliedAlpha():Boolean{
            return (false);
        }

    }
}//package wd.wq.textures 
