package away3d.textures {
    import flash.display3D.*;
    import flash.display3D.textures.*;

    public class Texture2DBase extends TextureProxyBase {

        public function Texture2DBase(){
            super();
        }
        override protected function createTexture(context:Context3D):TextureBase{
            return (context.createTexture(_width, _height, Context3DTextureFormat.BGRA, false));
        }

    }
}//package away3d.textures 
