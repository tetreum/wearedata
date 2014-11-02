package away3d.materials.methods {
    import away3d.textures.*;
    import away3d.core.managers.*;
    import away3d.materials.utils.*;

    public class BasicNormalMethod extends ShadingMethodBase {

        private var _texture:Texture2DBase;
        private var _useTexture:Boolean;
        protected var _normalTextureRegister:ShaderRegisterElement;

        public function BasicNormalMethod(){
            super();
        }
        override function initVO(vo:MethodVO):void{
            vo.needsUV = Boolean(this._texture);
        }
        function get tangentSpace():Boolean{
            return (true);
        }
        function get hasOutput():Boolean{
            return (this._useTexture);
        }
        override public function copyFrom(method:ShadingMethodBase):void{
            this.normalMap = BasicNormalMethod(method).normalMap;
        }
        public function get normalMap():Texture2DBase{
            return (this._texture);
        }
        public function set normalMap(value:Texture2DBase):void{
            if (((!(value)) || (!(this._useTexture)))){
                invalidateShaderProgram();
            };
            this._useTexture = Boolean(value);
            this._texture = value;
        }
        override function cleanCompilationData():void{
            super.cleanCompilationData();
            this._normalTextureRegister = null;
        }
        override public function dispose():void{
            if (this._texture){
                this._texture = null;
            };
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            if (vo.texturesIndex >= 0){
                stage3DProxy.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));
            };
        }
        function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            this._normalTextureRegister = regCache.getFreeTextureReg();
            vo.texturesIndex = this._normalTextureRegister.index;
            return (getTexSampleCode(vo, targetReg, this._normalTextureRegister));
        }

    }
}//package away3d.materials.methods 
