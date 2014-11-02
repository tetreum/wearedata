package away3d.materials.utils {
    import flash.geom.*;
    import flash.display.*;
    import flash.display3D.textures.*;

    public class MipmapGenerator {

        private static var _matrix:Matrix = new Matrix();
        private static var _rect:Rectangle = new Rectangle();

        public static function generateMipMaps(source:BitmapData, target:TextureBase, mipmap:BitmapData=null, alpha:Boolean=false, side:int=-1):void{
            var i:uint;
            var w:uint = source.width;
            var h:uint = source.height;
            var regen:Boolean = !((mipmap == null));
            mipmap = ((mipmap) || (new BitmapData(w, h, alpha)));
            _rect.width = w;
            _rect.height = h;
            while ((((w >= 1)) || ((h >= 1)))) {
                if (alpha){
                    mipmap.fillRect(_rect, 0);
                };
                _matrix.a = (_rect.width / source.width);
                _matrix.d = (_rect.height / source.height);
                mipmap.draw(source, _matrix, null, null, null, true);
                if ((target is Texture)){
                    var _temp1 = i;
                    i = (i + 1);
                    Texture(target).uploadFromBitmapData(mipmap, _temp1);
                } else {
                    var _temp2 = i;
                    i = (i + 1);
                    CubeTexture(target).uploadFromBitmapData(mipmap, side, _temp2);
                };
                w = (w >> 1);
                h = (h >> 1);
                _rect.width = (((w > 1)) ? w : 1);
                _rect.height = (((h > 1)) ? h : 1);
            };
            if (!(regen)){
                mipmap.dispose();
            };
        }

    }
}//package away3d.materials.utils 
