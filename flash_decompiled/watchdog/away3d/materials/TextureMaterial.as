package away3d.materials {
    import away3d.textures.*;
    import flash.geom.*;

    public class TextureMaterial extends DefaultMaterialBase {

        public function TextureMaterial(texture:Texture2DBase=null, smooth:Boolean=true, repeat:Boolean=false, mipmap:Boolean=true){
            super();
            this.texture = texture;
            this.smooth = smooth;
            this.repeat = repeat;
            this.mipmap = mipmap;
        }
        public function get animateUVs():Boolean{
            return (_screenPass.animateUVs);
        }
        public function set animateUVs(value:Boolean):void{
            _screenPass.animateUVs = value;
        }
        public function get alpha():Number{
            return (((_screenPass.colorTransform) ? _screenPass.colorTransform.alphaMultiplier : 1));
        }
        public function set alpha(value:Number):void{
            if (value > 1){
                value = 1;
            } else {
                if (value < 0){
                    value = 0;
                };
            };
            colorTransform = ((colorTransform) || (new ColorTransform()));
            colorTransform.alphaMultiplier = value;
        }
        public function get texture():Texture2DBase{
            return (_screenPass.diffuseMethod.texture);
        }
        public function set texture(value:Texture2DBase):void{
            _screenPass.diffuseMethod.texture = value;
        }
        public function get ambientTexture():Texture2DBase{
            return (_screenPass.ambientMethod.texture);
        }
        public function set ambientTexture(value:Texture2DBase):void{
            _screenPass.diffuseMethod._useDiffuseTexture = true;
            _screenPass.ambientMethod.texture = value;
        }

    }
}//package away3d.materials 
