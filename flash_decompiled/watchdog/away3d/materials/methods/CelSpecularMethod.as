package away3d.materials.methods {
    import __AS3__.vec.*;
    import away3d.core.managers.*;
    import away3d.materials.utils.*;

    public class CelSpecularMethod extends CompositeSpecularMethod {

        private var _dataReg:ShaderRegisterElement;
        private var _smoothness:Number = 0.1;
        private var _specularCutOff:Number = 0.1;

        public function CelSpecularMethod(specularCutOff:Number=0.5, baseSpecularMethod:BasicSpecularMethod=null){
            super(this.clampSpecular, baseSpecularMethod);
            this._specularCutOff = specularCutOff;
        }
        public function get smoothness():Number{
            return (this._smoothness);
        }
        public function set smoothness(value:Number):void{
            this._smoothness = value;
        }
        public function get specularCutOff():Number{
            return (this._specularCutOff);
        }
        public function set specularCutOff(value:Number):void{
            this._specularCutOff = value;
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            super.activate(vo, stage3DProxy);
            var index:int = vo.secondaryFragmentConstantsIndex;
            var data:Vector.<Number> = vo.fragmentData;
            data[index] = this._smoothness;
            data[(index + 1)] = this._specularCutOff;
        }
        override function cleanCompilationData():void{
            super.cleanCompilationData();
            this._dataReg = null;
        }
        private function clampSpecular(methodVO:MethodVO, target:ShaderRegisterElement, regCache:ShaderRegisterCache):String{
            return ((((((((((((((((((((((((((((((((("sub " + target) + ".y, ") + target) + ".w, ") + this._dataReg) + ".y\n") + "div ") + target) + ".y, ") + target) + ".y, ") + this._dataReg) + ".x\n") + "sat ") + target) + ".y, ") + target) + ".y\n") + "sge ") + target) + ".w, ") + target) + ".w, ") + this._dataReg) + ".y\n") + "mul ") + target) + ".w, ") + target) + ".w, ") + target) + ".y\n"));
        }
        override function getFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            this._dataReg = regCache.getFreeFragmentConstant();
            vo.secondaryFragmentConstantsIndex = (this._dataReg.index * 4);
            return (super.getFragmentPreLightingCode(vo, regCache));
        }

    }
}//package away3d.materials.methods 
