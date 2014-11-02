package away3d.textures {
    import away3d.tools.utils.*;
    import flash.display.*;
    import away3d.materials.utils.*;
    import flash.display3D.textures.*;
    import flash.display3D.*;

    public class RenderCubeTexture extends CubeTextureBase {

        public function RenderCubeTexture(size:Number){
            super();
            setSize(size, size);
        }
        public function set size(value:int):void{
            if (value == _width){
                return;
            };
            if (!(TextureUtils.isDimensionValid(value))){
                throw (new Error("Invalid size: Width and height must be power of 2 and cannot exceed 2048"));
            };
            invalidateContent();
            setSize(value, value);
        }
        override protected function uploadContent(texture:TextureBase):void{
            var bmd:BitmapData = new BitmapData(_width, _height, false, 0);
            var i:int;
            while (i < 6) {
                MipmapGenerator.generateMipMaps(bmd, texture, null, false, i);
                i++;
            };
            bmd.dispose();
        }
        override protected function createTexture(context:Context3D):TextureBase{
            return (context.createCubeTexture(_width, Context3DTextureFormat.BGRA, true));
        }

    }
}//package away3d.textures 
