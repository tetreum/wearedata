package away3d.materials.methods {
    import __AS3__.vec.*;
    import away3d.materials.utils.*;
    import away3d.core.managers.*;

    public class CelDiffuseMethod extends CompositeDiffuseMethod {

        private var _levels:uint;
        private var _dataReg:ShaderRegisterElement;
        private var _smoothness:Number = 0.1;

        public function CelDiffuseMethod(levels:uint=3, baseDiffuseMethod:BasicDiffuseMethod=null){
            super(this.clampDiffuse, baseDiffuseMethod);
            this._levels = levels;
        }
        override function initConstants(vo:MethodVO):void{
            var data:Vector.<Number> = vo.fragmentData;
            var index:int = vo.secondaryFragmentConstantsIndex;
            super.initConstants(vo);
            data[(index + 1)] = 1;
            data[(index + 2)] = 0;
        }
        public function get levels():uint{
            return (this._levels);
        }
        public function set levels(value:uint):void{
            this._levels = value;
        }
        public function get smoothness():Number{
            return (this._smoothness);
        }
        public function set smoothness(value:Number):void{
            this._smoothness = value;
        }
        override function cleanCompilationData():void{
            super.cleanCompilationData();
            this._dataReg = null;
        }
        override function getFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            this._dataReg = regCache.getFreeFragmentConstant();
            vo.secondaryFragmentConstantsIndex = (this._dataReg.index * 4);
            return (super.getFragmentPreLightingCode(vo, regCache));
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            super.activate(vo, stage3DProxy);
            var data:Vector.<Number> = vo.fragmentData;
            var index:int = vo.secondaryFragmentConstantsIndex;
            data[index] = this._levels;
            data[(index + 3)] = this._smoothness;
        }
        private function clampDiffuse(vo:MethodVO, t:ShaderRegisterElement, regCache:ShaderRegisterCache):String{
            return ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((("mul " + t) + ".w, ") + t) + ".w, ") + this._dataReg) + ".x\n") + "frc ") + t) + ".z, ") + t) + ".w\n") + "sub ") + t) + ".y, ") + t) + ".w, ") + t) + ".z\n") + "mov ") + t) + ".x, ") + this._dataReg) + ".x\n") + "sub ") + t) + ".x, ") + t) + ".x, ") + this._dataReg) + ".y\n") + "rcp ") + t) + ".x,") + t) + ".x\n") + "mul ") + t) + ".w, ") + t) + ".y, ") + t) + ".x\n") + "sub ") + t) + ".y, ") + t) + ".w, ") + t) + ".x\n") + "div ") + t) + ".z, ") + t) + ".z, ") + this._dataReg) + ".w\n") + "sat ") + t) + ".z, ") + t) + ".z\n") + "mul ") + t) + ".w, ") + t) + ".w, ") + t) + ".z\n") + "sub ") + t) + ".z, ") + this._dataReg) + ".y, ") + t) + ".z\n") + "mul ") + t) + ".y, ") + t) + ".y, ") + t) + ".z\n") + "add ") + t) + ".w, ") + t) + ".w, ") + t) + ".y\n") + "sat ") + t) + ".w, ") + t) + ".w\n"));
        }

    }
}//package away3d.materials.methods 
