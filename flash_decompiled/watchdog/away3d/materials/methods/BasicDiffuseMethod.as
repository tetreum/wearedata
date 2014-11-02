package away3d.materials.methods {
    import away3d.core.managers.*;
    import away3d.textures.*;
    import away3d.materials.utils.*;
    import __AS3__.vec.*;
    import flash.display3D.*;

    public class BasicDiffuseMethod extends LightingMethodBase {

        var _useDiffuseTexture:Boolean;
        protected var _useTexture:Boolean;
        var _totalLightColorReg:ShaderRegisterElement;
        protected var _diffuseInputRegister:ShaderRegisterElement;
        private var _texture:Texture2DBase;
        private var _diffuseColor:uint = 0xFFFFFF;
        private var _diffuseR:Number = 1;
        private var _diffuseG:Number = 1;
        private var _diffuseB:Number = 1;
        private var _diffuseA:Number = 1;
        protected var _shadowRegister:ShaderRegisterElement;
        protected var _alphaThreshold:Number = 0;

        public function BasicDiffuseMethod(){
            super();
        }
        override function initVO(vo:MethodVO):void{
            vo.needsUV = this._useTexture;
            vo.needsNormals = (vo.numLights > 0);
        }
        public function generateMip(stage3DProxy:Stage3DProxy):void{
            if (this._useTexture){
                this._texture.getTextureForStage3D(stage3DProxy);
            };
        }
        public function get diffuseAlpha():Number{
            return (this._diffuseA);
        }
        public function set diffuseAlpha(value:Number):void{
            this._diffuseA = value;
        }
        public function get diffuseColor():uint{
            return (this._diffuseColor);
        }
        public function set diffuseColor(diffuseColor:uint):void{
            this._diffuseColor = diffuseColor;
            this.updateDiffuse();
        }
        public function get texture():Texture2DBase{
            return (this._texture);
        }
        public function set texture(value:Texture2DBase):void{
            this._useTexture = Boolean(value);
            this._texture = value;
            if (((!(value)) || (!(this._useTexture)))){
                invalidateShaderProgram();
            };
        }
        public function get alphaThreshold():Number{
            return (this._alphaThreshold);
        }
        public function set alphaThreshold(value:Number):void{
            if (value < 0){
                value = 0;
            } else {
                if (value > 1){
                    value = 1;
                };
            };
            if (value == this._alphaThreshold){
                return;
            };
            if ((((value == 0)) || ((this._alphaThreshold == 0)))){
                invalidateShaderProgram();
            };
            this._alphaThreshold = value;
        }
        override public function dispose():void{
            this._texture = null;
        }
        override public function copyFrom(method:ShadingMethodBase):void{
            var diff:BasicDiffuseMethod = BasicDiffuseMethod(method);
            this.alphaThreshold = diff.alphaThreshold;
            this.texture = diff.texture;
            this.diffuseAlpha = diff.diffuseAlpha;
            this.diffuseColor = diff.diffuseColor;
        }
        override function cleanCompilationData():void{
            super.cleanCompilationData();
            this._shadowRegister = null;
            this._totalLightColorReg = null;
            this._diffuseInputRegister = null;
        }
        override function getFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            var code:String = "";
            if (vo.numLights > 0){
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
            code = (code + (((((((((((((((((("dp3 " + t) + ".x, ") + lightDirReg) + ".xyz, ") + _normalFragmentReg) + ".xyz\n") + "sat ") + t) + ".w, ") + t) + ".x\n") + "mul ") + t) + ".w, ") + t) + ".w, ") + lightDirReg) + ".w\n"));
            if (_modulateMethod != null){
                code = (code + _modulateMethod(vo, t, regCache));
            };
            code = (code + (((((("mul " + t) + ", ") + t) + ".w, ") + lightColReg) + "\n"));
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
            code = (code + ((((((((((((("tex " + t) + ", ") + _normalFragmentReg) + ", ") + cubeMapReg) + " <cube,linear,miplinear>\n") + "mul ") + t) + ", ") + t) + ", ") + weightRegister) + "\n"));
            if (lightIndex > 0){
                code = (code + (((((("add " + this._totalLightColorReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz, ") + t) + ".xyz\n"));
                regCache.removeFragmentTempUsage(t);
            };
            return (code);
        }
        override function getFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            var t:ShaderRegisterElement;
            var cutOffReg:ShaderRegisterElement;
            var code:String = "";
            if (vo.numLights > 0){
                t = regCache.getFreeFragmentVectorTemp();
                regCache.addFragmentTempUsages(t, 1);
                if (this._shadowRegister){
                    code = (code + (((((("mul " + this._totalLightColorReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz, ") + this._shadowRegister) + ".w\n"));
                };
            } else {
                t = targetReg;
            };
            if (this._useTexture){
                this._diffuseInputRegister = regCache.getFreeTextureReg();
                vo.texturesIndex = this._diffuseInputRegister.index;
                code = (code + getTexSampleCode(vo, t, this._diffuseInputRegister));
                if (this._alphaThreshold > 0){
                    cutOffReg = regCache.getFreeFragmentConstant();
                    vo.fragmentConstantsIndex = (cutOffReg.index * 4);
                    code = (code + (((((((((((((((("sub " + t) + ".w, ") + t) + ".w, ") + cutOffReg) + ".x\n") + "kil ") + t) + ".w\n") + "add ") + t) + ".w, ") + t) + ".w, ") + cutOffReg) + ".x\n"));
                };
            } else {
                this._diffuseInputRegister = regCache.getFreeFragmentConstant();
                vo.fragmentConstantsIndex = (this._diffuseInputRegister.index * 4);
                code = (code + (((("mov " + t) + ", ") + this._diffuseInputRegister) + "\n"));
            };
            if (vo.numLights == 0){
                return (code);
            };
            if (this._useDiffuseTexture){
                code = (code + (((((((((((((((((((((((((((((((("sat " + this._totalLightColorReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz\n") + "mul ") + t) + ".xyz, ") + t) + ".xyz, ") + this._totalLightColorReg) + ".xyz\n") + "mul ") + this._totalLightColorReg) + ".xyz, ") + targetReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz\n") + "sub ") + targetReg) + ".xyz, ") + targetReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz\n") + "add ") + targetReg) + ".xyz, ") + t) + ".xyz, ") + targetReg) + ".xyz\n"));
            } else {
                code = (code + ((((((((((((((((((((((("add " + targetReg) + ".xyz, ") + this._totalLightColorReg) + ".xyz, ") + targetReg) + ".xyz\n") + "sat ") + targetReg) + ".xyz, ") + targetReg) + ".xyz\n") + "mul ") + targetReg) + ".xyz, ") + t) + ".xyz, ") + targetReg) + ".xyz\n") + "mov ") + targetReg) + ".w, ") + t) + ".w\n"));
            };
            regCache.removeFragmentTempUsage(this._totalLightColorReg);
            regCache.removeFragmentTempUsage(t);
            return (code);
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            var index:int;
            var data:Vector.<Number>;
            var context:Context3D = stage3DProxy._context3D;
            if (this._useTexture){
                stage3DProxy.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));
                if (this._alphaThreshold > 0){
                    vo.fragmentData[vo.fragmentConstantsIndex] = this._alphaThreshold;
                };
            } else {
                index = vo.fragmentConstantsIndex;
                data = vo.fragmentData;
                data[index] = this._diffuseR;
                data[(index + 1)] = this._diffuseG;
                data[(index + 2)] = this._diffuseB;
                data[(index + 3)] = this._diffuseA;
            };
        }
        private function updateDiffuse():void{
            this._diffuseR = (((this._diffuseColor >> 16) & 0xFF) / 0xFF);
            this._diffuseG = (((this._diffuseColor >> 8) & 0xFF) / 0xFF);
            this._diffuseB = ((this._diffuseColor & 0xFF) / 0xFF);
        }
        function set shadowRegister(value:ShaderRegisterElement):void{
            this._shadowRegister = value;
        }

    }
}//package away3d.materials.methods 
