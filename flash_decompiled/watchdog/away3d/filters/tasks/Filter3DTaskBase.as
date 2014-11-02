package away3d.filters.tasks {
    import flash.display3D.textures.*;
    import away3d.core.managers.*;
    import com.adobe.utils.*;
    import away3d.debug.*;
    import flash.display3D.*;
    import away3d.errors.*;
    import away3d.cameras.*;

    public class Filter3DTaskBase {

        protected var _mainInputTexture:Texture;
        protected var _scaledTextureWidth:int = -1;
        protected var _scaledTextureHeight:int = -1;
        protected var _textureWidth:int = -1;
        protected var _textureHeight:int = -1;
        private var _textureDimensionsInvalid:Boolean = true;
        private var _program3DInvalid:Boolean = true;
        private var _program3D:Program3D;
        private var _target:Texture;
        private var _requireDepthRender:Boolean;
        protected var _textureScale:int = 0;

        public function Filter3DTaskBase(requireDepthRender:Boolean=false){
            super();
            this._requireDepthRender = requireDepthRender;
        }
        public function get textureScale():int{
            return (this._textureScale);
        }
        public function set textureScale(value:int):void{
            if (this._textureScale == value){
                return;
            };
            this._textureScale = value;
            this._scaledTextureWidth = (this._textureWidth >> this._textureScale);
            this._scaledTextureHeight = (this._textureHeight >> this._textureScale);
            this._textureDimensionsInvalid = true;
        }
        public function get target():Texture{
            return (this._target);
        }
        public function set target(value:Texture):void{
            this._target = value;
        }
        public function get textureWidth():int{
            return (this._textureWidth);
        }
        public function set textureWidth(value:int):void{
            if (this._textureWidth == value){
                return;
            };
            this._textureWidth = value;
            this._scaledTextureWidth = (this._textureWidth >> this._textureScale);
            this._textureDimensionsInvalid = true;
        }
        public function get textureHeight():int{
            return (this._textureHeight);
        }
        public function set textureHeight(value:int):void{
            if (this._textureHeight == value){
                return;
            };
            this._textureHeight = value;
            this._scaledTextureHeight = (this._textureHeight >> this._textureScale);
            this._textureDimensionsInvalid = true;
        }
        public function getMainInputTexture(stage:Stage3DProxy):Texture{
            if (this._textureDimensionsInvalid){
                this.updateTextures(stage);
            };
            return (this._mainInputTexture);
        }
        public function dispose():void{
            if (this._mainInputTexture){
                this._mainInputTexture.dispose();
            };
            if (this._program3D){
                this._program3D.dispose();
            };
        }
        protected function invalidateProgram3D():void{
            this._program3DInvalid = true;
        }
        protected function updateProgram3D(stage:Stage3DProxy):void{
            if (this._program3D){
                this._program3D.dispose();
            };
            this._program3D = stage.context3D.createProgram();
            this._program3D.upload(new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX, this.getVertexCode(), Debug.active), new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT, this.getFragmentCode(), Debug.active));
            this._program3DInvalid = false;
        }
        protected function getVertexCode():String{
            return (("mov op, va0\n" + "mov v0, va1"));
        }
        protected function getFragmentCode():String{
            throw (new AbstractMethodError());
        }
        protected function updateTextures(stage:Stage3DProxy):void{
            if (this._mainInputTexture){
                this._mainInputTexture.dispose();
            };
            this._mainInputTexture = stage.context3D.createTexture(this._scaledTextureWidth, this._scaledTextureHeight, Context3DTextureFormat.BGRA, true);
            this._textureDimensionsInvalid = false;
        }
        public function getProgram3D(stage3DProxy:Stage3DProxy):Program3D{
            if (this._program3DInvalid){
                this.updateProgram3D(stage3DProxy);
            };
            return (this._program3D);
        }
        public function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, depthTexture:Texture):void{
        }
        public function deactivate(stage3DProxy:Stage3DProxy):void{
        }
        public function get requireDepthRender():Boolean{
            return (this._requireDepthRender);
        }

    }
}//package away3d.filters.tasks 
