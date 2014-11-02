package away3d.materials.methods {
    import __AS3__.vec.*;
    import away3d.core.managers.*;
    import away3d.materials.utils.*;

    public class FogMethod extends EffectMethodBase {

        private var _minDistance:Number = 0;
        private var _maxDistance:Number = 1000;
        private var _fogColor:uint;
        private var _fogR:Number;
        private var _fogG:Number;
        private var _fogB:Number;

        public function FogMethod(minDistance:Number, maxDistance:Number, fogColor:uint=0x808080){
            super();
            this.minDistance = minDistance;
            this.maxDistance = maxDistance;
            this.fogColor = fogColor;
        }
        override function initVO(vo:MethodVO):void{
            vo.needsView = true;
        }
        override function initConstants(vo:MethodVO):void{
            var data:Vector.<Number> = vo.fragmentData;
            var index:int = vo.fragmentConstantsIndex;
            data[(index + 3)] = 1;
            data[(index + 6)] = 0;
            data[(index + 7)] = 0;
        }
        public function get minDistance():Number{
            return (this._minDistance);
        }
        public function set minDistance(value:Number):void{
            this._minDistance = value;
        }
        public function get maxDistance():Number{
            return (this._maxDistance);
        }
        public function set maxDistance(value:Number):void{
            this._maxDistance = value;
        }
        public function get fogColor():uint{
            return (this._fogColor);
        }
        public function set fogColor(value:uint):void{
            this._fogColor = value;
            this._fogR = (((value >> 16) & 0xFF) / 0xFF);
            this._fogG = (((value >> 8) & 0xFF) / 0xFF);
            this._fogB = ((value & 0xFF) / 0xFF);
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            var data:Vector.<Number> = vo.fragmentData;
            var index:int = vo.fragmentConstantsIndex;
            data[index] = this._fogR;
            data[(index + 1)] = this._fogG;
            data[(index + 2)] = this._fogB;
            data[(index + 4)] = this._minDistance;
            data[(index + 5)] = (1 / (this._maxDistance - this._minDistance));
        }
        override function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            var fogColor:ShaderRegisterElement = regCache.getFreeFragmentConstant();
            var fogData:ShaderRegisterElement = regCache.getFreeFragmentConstant();
            var temp:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
            var code:String = "";
            vo.fragmentConstantsIndex = (fogColor.index * 4);
            code = (code + ((((((((((((((((((((((((((((((((((((((((((((((((((("dp3 " + temp) + ".w, ") + _viewDirVaryingReg) + ".xyz\t, ") + _viewDirVaryingReg) + ".xyz\n") + "sqt ") + temp) + ".w, ") + temp) + ".w\t\t\t\t\t\t\t\t\t\t\n") + "sub ") + temp) + ".w, ") + temp) + ".w, ") + fogData) + ".x\t\t\t\t\t\n") + "mul ") + temp) + ".w, ") + temp) + ".w, ") + fogData) + ".y\t\t\t\t\t\n") + "sat ") + temp) + ".w, ") + temp) + ".w\t\t\t\t\t\t\t\t\t\t\n") + "sub ") + temp) + ".xyz, ") + fogColor) + ".xyz, ") + targetReg) + ".xyz\n") + "mul ") + temp) + ".xyz, ") + temp) + ".xyz, ") + temp) + ".w\t\t\t\t\t\n") + "add ") + targetReg) + ".xyz, ") + targetReg) + ".xyz, ") + temp) + ".xyz\n"));
            return (code);
        }

    }
}//package away3d.materials.methods 
