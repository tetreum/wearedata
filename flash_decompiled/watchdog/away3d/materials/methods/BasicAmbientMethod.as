package away3d.materials.methods {
    import away3d.textures.*;
    import away3d.materials.utils.*;
    import __AS3__.vec.*;
    import away3d.core.managers.*;

    public class BasicAmbientMethod extends ShadingMethodBase {

        protected var _useTexture:Boolean;
        private var _texture:Texture2DBase;
        protected var _ambientInputRegister:ShaderRegisterElement;
        private var _ambientColor:uint = 0xFFFFFF;
        private var _ambientR:Number = 0;
        private var _ambientG:Number = 0;
        private var _ambientB:Number = 0;
        private var _ambient:Number = 1;
        var _lightAmbientR:Number = 0;
        var _lightAmbientG:Number = 0;
        var _lightAmbientB:Number = 0;

        public function BasicAmbientMethod(){
            super();
        }
        override function initVO(vo:MethodVO):void{
            vo.needsUV = this._useTexture;
        }
        override function initConstants(vo:MethodVO):void{
            vo.fragmentData[(vo.fragmentConstantsIndex + 3)] = 1;
        }
        public function get ambient():Number{
            return (this._ambient);
        }
        public function set ambient(value:Number):void{
            this._ambient = value;
        }
        public function get ambientColor():uint{
            return (this._ambientColor);
        }
        public function set ambientColor(value:uint):void{
            this._ambientColor = value;
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
            var diff:BasicAmbientMethod = BasicAmbientMethod(method);
            this.ambient = diff.ambient;
            this.ambientColor = diff.ambientColor;
        }
        override function cleanCompilationData():void{
            super.cleanCompilationData();
            this._ambientInputRegister = null;
        }
        function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            var code:String = "";
            if (this._useTexture){
                this._ambientInputRegister = regCache.getFreeTextureReg();
                vo.texturesIndex = this._ambientInputRegister.index;
                code = (code + (((((((getTexSampleCode(vo, targetReg, this._ambientInputRegister) + "div ") + targetReg) + ".xyz, ") + targetReg) + ".xyz, ") + targetReg) + ".w\n"));
            } else {
                this._ambientInputRegister = regCache.getFreeFragmentConstant();
                vo.fragmentConstantsIndex = (this._ambientInputRegister.index * 4);
                code = (code + (((("mov " + targetReg) + ", ") + this._ambientInputRegister) + "\n"));
            };
            return (code);
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            var index:int;
            var data:Vector.<Number>;
            this.updateAmbient();
            if (this._useTexture){
                stage3DProxy.setTextureAt(vo.texturesIndex, this._texture.getTextureForStage3D(stage3DProxy));
            } else {
                index = vo.fragmentConstantsIndex;
                data = vo.fragmentData;
                data[index] = this._ambientR;
                data[(index + 1)] = this._ambientG;
                data[(index + 2)] = this._ambientB;
            };
        }
        private function updateAmbient():void{
            this._ambientR = (((((this._ambientColor >> 16) & 0xFF) / 0xFF) * this._ambient) * this._lightAmbientR);
            this._ambientG = (((((this._ambientColor >> 8) & 0xFF) / 0xFF) * this._ambient) * this._lightAmbientG);
            this._ambientB = ((((this._ambientColor & 0xFF) / 0xFF) * this._ambient) * this._lightAmbientB);
        }

    }
}//package away3d.materials.methods 
