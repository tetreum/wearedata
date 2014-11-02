package away3d.materials.methods {
    import away3d.textures.*;
    import away3d.materials.utils.*;
    import flash.display3D.*;
    import __AS3__.vec.*;
    import away3d.core.managers.*;

    public class BasicSpecularMethod extends LightingMethodBase {

        protected var _useTexture:Boolean;
        protected var _totalLightColorReg:ShaderRegisterElement;
        protected var _specularTextureRegister:ShaderRegisterElement;
        protected var _specularTexData:ShaderRegisterElement;
        protected var _specularDataRegister:ShaderRegisterElement;
        private var _texture:Texture2DBase;
        private var _gloss:int = 50;
        private var _specular:Number = 1;
        private var _specularColor:uint = 0xFFFFFF;
        var _specularR:Number = 1;
        var _specularG:Number = 1;
        var _specularB:Number = 1;
        private var _shadowRegister:ShaderRegisterElement;
        private var _shadingModel:String;

        public function BasicSpecularMethod(){
            super();
            this._shadingModel = SpecularShadingModel.BLINN_PHONG;
        }
        override function initVO(vo:MethodVO):void{
            vo.needsUV = this._useTexture;
            vo.needsNormals = (vo.numLights > 0);
            vo.needsView = (vo.numLights > 0);
        }
        public function get gloss():Number{
            return (this._gloss);
        }
        public function set gloss(value:Number):void{
            this._gloss = value;
        }
        public function get specular():Number{
            return (this._specular);
        }
        public function set specular(value:Number):void{
            if (value == this._specular){
                return;
            };
            this._specular = value;
            this.updateSpecular();
        }
        public function get shadingModel():String{
            return (this._shadingModel);
        }
        public function set shadingModel(value:String):void{
            if (value == this._shadingModel){
                return;
            };
            this._shadingModel = value;
            invalidateShaderProgram();
        }
        public function get specularColor():uint{
            return (this._specularColor);
        }
        public function set specularColor(value:uint):void{
            if (this._specularColor == value){
                return;
            };
            if ((((this._specularColor == 0)) || ((value == 0)))){
                invalidateShaderProgram();
            };
            this._specularColor = value;
            this.updateSpecular();
        }
        public function get texture():Texture2DBase{
            return (this._texture);
        }
        public function set texture(value:Texture2DBase):void{
            if (((!(value)) || (!(this._useTexture)))){
                invalidateShaderProgram();
            };
            this._useTexture = Boolean(value);
            this._texture = value;
        }
        override public function copyFrom(method:ShadingMethodBase):void{
            var spec:BasicSpecularMethod = BasicSpecularMethod(method);
            this.texture = spec.texture;
            this.specular = spec.specular;
            this.specularColor = spec.specularColor;
            this.gloss = spec.gloss;
        }
        override function cleanCompilationData():void{
            super.cleanCompilationData();
            this._shadowRegister = null;
            this._totalLightColorReg = null;
            this._specularTextureRegister = null;
            this._specularTexData = null;
            this._specularDataRegister = null;
        }
        override function getFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            var code:String = "";
            if (vo.numLights > 0){
                this._specularDataRegister = regCache.getFreeFragmentConstant();
                vo.fragmentConstantsIndex = (this._specularDataRegister.index * 4);
                if (this._useTexture){
                    this._specularTexData = regCache.getFreeFragmentVectorTemp();
                    regCache.addFragmentTempUsages(this._specularTexData, 1);
                    this._specularTextureRegister = regCache.getFreeTextureReg();
                    vo.texturesIndex = this._specularTextureRegister.index;
                    code = getTexSampleCode(vo, this._specularTexData, this._specularTextureRegister);
                } else {
                    this._specularTextureRegister = null;
                };
                this._totalLightColorReg = regCache.getFreeFragmentVectorTemp();
                regCache.addFragmentTempUsages(this._totalLightColorReg, 1);
            };
            return (code);
        }
        override function getFragmentCodePerLight(vo:MethodVO, lightIndex:int, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String{
            var t:ShaderRegisterElement;
            var code:String = "";
            if (lightIndex > 0){
                t = regCache.getFreeFragmentVectorTemp();
                regCache.addFragmentTempUsages(t, 1);
            } else {
                t = this._totalLightColorReg;
            };
            switch (this._shadingModel){
                case SpecularShadingModel.BLINN_PHONG:
                    code = (code + ((((((((((((((((((((((("add " + t) + ".xyz, ") + lightDirReg) + ".xyz, ") + _viewDirFragmentReg) + ".xyz\n") + "nrm ") + t) + ".xyz, ") + t) + ".xyz\n") + "dp3 ") + t) + ".w, ") + _normalFragmentReg) + ".xyz, ") + t) + ".xyz\n") + "sat ") + t) + ".w, ") + t) + ".w\n"));
                    break;
                case SpecularShadingModel.PHONG:
                    code = (code + (((((((((((((((((((((((((((((((((((((((((((((((((((((((((("dp3 " + t) + ".w, ") + lightDirReg) + ".xyz, ") + _normalFragmentReg) + ".xyz\n") + "add ") + t) + ".w, ") + t) + ".w, ") + t) + ".w\n") + "mul ") + t) + ".xyz, ") + _normalFragmentReg) + ".xyz, ") + t) + ".w\n") + "sub ") + t) + ".xyz, ") + t) + ".xyz, ") + lightDirReg) + ".xyz\n") + "add") + t) + ".w, ") + t) + ".w, ") + _normalFragmentReg) + ".w\n") + "sat ") + t) + ".w, ") + t) + ".w\n") + "mul ") + t) + ".xyz, ") + t) + ".xyz, ") + t) + ".w\n") + "dp3 ") + t) + ".w, ") + t) + ".xyz, ") + _viewDirFragmentReg) + ".xyz\n") + "sat ") + t) + ".w, ") + t) + ".w\n"));
                    break;
            };
            if (this._useTexture){
                code = (code + ((((((((((((("mul " + this._specularTexData) + ".w, ") + this._specularTexData) + ".y, ") + this._specularDataRegister) + ".w\n") + "pow ") + t) + ".w, ") + t) + ".w, ") + this._specularTexData) + ".w\n"));
            } else {
                code = (code + (((((("pow " + t) + ".w, ") + t) + ".w, ") + this._specularDataRegister) + ".w\n"));
            };
            code = (code + (((((("mul " + t) + ".w, ") + t) + ".w, ") + lightDirReg) + ".w\n"));
            if (_modulateMethod != null){
                code = (code + _modulateMethod(vo, t, regCache));
            };
            code = (code + (((((("mul " + t) + ".xyz, ") + lightColReg) + ".xyz, ") + t) + ".w\n"));
            if (lightIndex > 0){
                code = (code + (((((("add " + this._totalLightColorReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz, ") + t) + ".xyz\n"));
                regCache.removeFragmentTempUsage(t);
            };
            return (code);
        }
        override function getFragmentCodePerProbe(vo:MethodVO, lightIndex:int, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String{
            var t:ShaderRegisterElement;
            var code:String = "";
            if (lightIndex > 0){
                t = regCache.getFreeFragmentVectorTemp();
                regCache.addFragmentTempUsages(t, 1);
            } else {
                t = this._totalLightColorReg;
            };
            code = (code + ((((((((((((("tex " + t) + ", ") + _viewDirFragmentReg) + ", ") + cubeMapReg) + " <cube,linear,miplinear>\n") + "mul ") + t) + ", ") + t) + ", ") + weightRegister) + "\n"));
            if (lightIndex > 0){
                code = (code + (((((("add " + this._totalLightColorReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz, ") + t) + ".xyz\n"));
                regCache.removeFragmentTempUsage(t);
            };
            return (code);
        }
        override function getFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            var code:String = "";
            if (vo.numLights == 0){
                return (code);
            };
            if (this._shadowRegister){
                code = (code + (((((("mul " + this._totalLightColorReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz, ") + this._shadowRegister) + ".w\n"));
            };
            if (this._useTexture){
                code = (code + (((((("mul " + this._totalLightColorReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz, ") + this._specularTexData) + ".x\n"));
                regCache.removeFragmentTempUsage(this._specularTexData);
            };
            code = (code + ((((((((((((("mul " + this._totalLightColorReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz, ") + this._specularDataRegister) + ".xyz\n") + "add ") + targetReg) + ".xyz, ") + targetReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz\n"));
            regCache.removeFragmentTempUsage(this._totalLightColorReg);
            return (code);
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            var context:Context3D = stage3DProxy._context3D;
            if (vo.numLights == 0){
                return;
            };
            if (this._useTexture){
                stage3DProxy.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));
            };
            var index:int = vo.fragmentConstantsIndex;
            var data:Vector.<Number> = vo.fragmentData;
            data[index] = this._specularR;
            data[(index + 1)] = this._specularG;
            data[(index + 2)] = this._specularB;
            data[(index + 3)] = this._gloss;
        }
        private function updateSpecular():void{
            this._specularR = ((((this._specularColor >> 16) & 0xFF) / 0xFF) * this._specular);
            this._specularG = ((((this._specularColor >> 8) & 0xFF) / 0xFF) * this._specular);
            this._specularB = (((this._specularColor & 0xFF) / 0xFF) * this._specular);
        }
        function set shadowRegister(shadowReg:ShaderRegisterElement):void{
            this._shadowRegister = shadowReg;
        }

    }
}//package away3d.materials.methods 
