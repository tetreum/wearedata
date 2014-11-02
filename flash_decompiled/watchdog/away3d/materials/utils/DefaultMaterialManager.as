package away3d.materials.utils {
    import away3d.materials.*;
    import away3d.core.base.*;
    import away3d.textures.*;
    import flash.display.*;

    public class DefaultMaterialManager {

        private static var _defaultTextureBitmapData:BitmapData;
        private static var _defaultMaterial:TextureMaterial;
        private static var _defaultTexture:BitmapTexture;

        public static function getDefaultMaterial(renderable:IMaterialOwner=null):TextureMaterial{
            if (!(_defaultTexture)){
                createDefaultTexture();
            };
            if (!(_defaultMaterial)){
                createDefaultMaterial();
            };
            return (_defaultMaterial);
        }
        public static function getDefaultTexture(renderable:IMaterialOwner=null):BitmapTexture{
            if (!(_defaultTexture)){
                createDefaultTexture();
            };
            return (_defaultTexture);
        }
        private static function createDefaultTexture():void{
            var i:uint;
            var j:uint;
            _defaultTextureBitmapData = new BitmapData(8, 8, false, 0);
            i = 0;
            while (i < 8) {
                j = 0;
                while (j < 8) {
                    if (((j & 1) ^ (i & 1))){
                        _defaultTextureBitmapData.setPixel(i, j, 0xFFFFFF);
                    };
                    j++;
                };
                i++;
            };
            _defaultTexture = new BitmapTexture(_defaultTextureBitmapData);
        }
        private static function createDefaultMaterial():void{
            _defaultMaterial = new TextureMaterial(_defaultTexture);
            _defaultMaterial.mipmap = false;
            _defaultMaterial.smooth = false;
        }

    }
}//package away3d.materials.utils 
