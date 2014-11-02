﻿package away3d.textures {
    import away3d.tools.utils.*;
    import flash.display.*;
    import away3d.materials.utils.*;
    import flash.display3D.textures.*;
    import flash.display3D.*;

    public class RenderTexture extends Texture2DBase {

        public function RenderTexture(width:Number, height:Number){
            super();
            setSize(width, height);
        }
        public function set width(value:int):void{
            if (value == _width){
                return;
            };
            if (!(TextureUtils.isDimensionValid(value))){
                throw (new Error("Invalid size: Width and height must be power of 2 and cannot exceed 2048"));
            };
            invalidateContent();
            setSize(value, _height);
        }
        public function set height(value:int):void{
            if (value == _height){
                return;
            };
            if (!(TextureUtils.isDimensionValid(value))){
                throw (new Error("Invalid size: Width and height must be power of 2 and cannot exceed 2048"));
            };
            invalidateContent();
            setSize(_width, value);
        }
        override protected function uploadContent(texture:TextureBase):void{
            var bmp:BitmapData = new BitmapData(width, height, false);
            MipmapGenerator.generateMipMaps(bmp, texture);
            bmp.dispose();
        }
        override protected function createTexture(context:Context3D):TextureBase{
            return (context.createTexture(width, height, Context3DTextureFormat.BGRA, true));
        }

    }
}//package away3d.textures 