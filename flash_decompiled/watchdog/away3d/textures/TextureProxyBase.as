package away3d.textures {
    import __AS3__.vec.*;
    import flash.display3D.textures.*;
    import flash.display3D.*;
    import away3d.library.assets.*;
    import away3d.core.managers.*;
    import away3d.errors.*;

    public class TextureProxyBase extends NamedAssetBase implements IAsset {

        protected var _textures:Vector.<TextureBase>;
        protected var _dirty:Vector.<Context3D>;
        protected var _width:int;
        protected var _height:int;

        public function TextureProxyBase(){
            super();
            this._textures = new Vector.<TextureBase>(8);
            this._dirty = new Vector.<Context3D>(8);
        }
        public function get assetType():String{
            return (AssetType.TEXTURE);
        }
        public function get width():int{
            return (this._width);
        }
        public function get height():int{
            return (this._height);
        }
        public function getTextureForStage3D(stage3DProxy:Stage3DProxy):TextureBase{
            var contextIndex:int = stage3DProxy._stage3DIndex;
            var tex:TextureBase = this._textures[contextIndex];
            var context:Context3D = stage3DProxy._context3D;
            if (((!(tex)) || (!((this._dirty[contextIndex] == context))))){
                tex = this.createTexture(context);
                this._textures[contextIndex] = tex;
                this._dirty[contextIndex] = context;
                this.uploadContent(tex);
            };
            return (tex);
        }
        protected function uploadContent(texture:TextureBase):void{
            throw (new AbstractMethodError());
        }
        protected function setSize(width:int, height:int):void{
            if (((!((this._width == width))) || (!((this._height == height))))){
                this.invalidateSize();
            };
            this._width = width;
            this._height = height;
        }
        public function invalidateContent():void{
            var i:int;
            while (i < 8) {
                this._dirty[i] = null;
                i++;
            };
        }
        protected function invalidateSize():void{
            var tex:TextureBase;
            var i:int;
            while (i < 8) {
                tex = this._textures[i];
                if (tex){
                    tex.dispose();
                    this._textures[i] = null;
                    this._dirty[i] = null;
                };
                i++;
            };
        }
        protected function createTexture(context:Context3D):TextureBase{
            throw (new AbstractMethodError());
        }
        public function dispose():void{
            var i:int;
            while (i < 8) {
                if (this._textures[i]){
                    this._textures[i].dispose();
                };
                i++;
            };
        }

    }
}//package away3d.textures 
