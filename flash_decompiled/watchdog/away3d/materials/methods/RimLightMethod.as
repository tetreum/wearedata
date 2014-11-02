package away3d.materials.methods {
    import __AS3__.vec.*;
    import away3d.core.managers.*;
    import away3d.materials.utils.*;

    public class RimLightMethod extends EffectMethodBase {

        public static const ADD:String = "add";
        public static const MULTIPLY:String = "multiply";
        public static const MIX:String = "mix";

        private var _color:uint;
        private var _blend:String;
        private var _colorR:Number;
        private var _colorG:Number;
        private var _colorB:Number;
        private var _strength:Number;
        private var _power:Number;

        public function RimLightMethod(color:uint=0xFFFFFF, strength:Number=0.4, power:Number=2, blend:String="mix"){
            super();
            this._blend = blend;
            this._strength = strength;
            this._power = power;
            this.color = color;
        }
        override function initConstants(vo:MethodVO):void{
            vo.fragmentData[(vo.fragmentConstantsIndex + 3)] = 1;
        }
        override function initVO(vo:MethodVO):void{
            vo.needsNormals = true;
            vo.needsView = true;
        }
        public function get color():uint{
            return (this._color);
        }
        public function set color(value:uint):void{
            this._color = value;
            this._colorR = (((value >> 16) & 0xFF) / 0xFF);
            this._colorG = (((value >> 8) & 0xFF) / 0xFF);
            this._colorB = ((value & 0xFF) / 0xFF);
        }
        public function get strength():Number{
            return (this._strength);
        }
        public function set strength(value:Number):void{
            this._strength = value;
        }
        public function get power():Number{
            return (this._power);
        }
        public function set power(value:Number):void{
            this._power = value;
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            var index:int = vo.fragmentConstantsIndex;
            var data:Vector.<Number> = vo.fragmentData;
            data[index] = this._colorR;
            data[(index + 1)] = this._colorG;
            data[(index + 2)] = this._colorB;
            data[(index + 4)] = this._strength;
            data[(index + 5)] = this._power;
        }
        override function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            var dataRegister:ShaderRegisterElement = regCache.getFreeFragmentConstant();
            var dataRegister2:ShaderRegisterElement = regCache.getFreeFragmentConstant();
            var temp:ShaderRegisterElement = regCache.getFreeFragmentVectorTemp();
            var code:String = "";
            vo.fragmentConstantsIndex = (dataRegister.index * 4);
            code = (code + ((((((((((((((((((((((((((((((((((((((((((((((((((((("dp3 " + temp) + ".x, ") + _viewDirFragmentReg) + ".xyz, ") + _normalFragmentReg) + ".xyz\t\n") + "sat ") + temp) + ".x, ") + temp) + ".x\t\t\t\t\t\t\t\t\t\t\t\t\t\t\n") + "sub ") + temp) + ".x, ") + dataRegister) + ".w, ") + temp) + ".x\t\t\t\t\t\t\t\t\n") + "pow ") + temp) + ".x, ") + temp) + ".x, ") + dataRegister2) + ".y\t\t\t\t\t\t\t\n") + "mul ") + temp) + ".x, ") + temp) + ".x, ") + dataRegister2) + ".x\t\t\t\t\t\t\t\n") + "sub ") + temp) + ".x, ") + dataRegister) + ".w, ") + temp) + ".x\t\t\t\t\t\t\t\t\n") + "mul ") + targetReg) + ".xyz, ") + targetReg) + ".xyz, ") + temp) + ".x\t\t\t\t\t\t\n") + "sub ") + temp) + ".w, ") + dataRegister) + ".w, ") + temp) + ".x\t\t\t\t\t\t\t\t\n"));
            if (this._blend == ADD){
                code = (code + ((((((((((((("mul " + temp) + ".xyz, ") + temp) + ".w, ") + dataRegister) + ".xyz\t\t\t\t\t\t\t\n") + "add ") + targetReg) + ".xyz, ") + targetReg) + ".xyz, ") + temp) + ".xyz\t\t\t\t\t\t\n"));
            } else {
                if (this._blend == MULTIPLY){
                    code = (code + ((((((((((((("mul " + temp) + ".xyz, ") + temp) + ".w, ") + dataRegister) + ".xyz\t\t\t\t\t\t\t\n") + "mul ") + targetReg) + ".xyz, ") + targetReg) + ".xyz, ") + temp) + ".xyz\t\t\t\t\t\t\n"));
                } else {
                    code = (code + (((((((((((((((((((("sub " + temp) + ".xyz, ") + dataRegister) + ".xyz, ") + targetReg) + ".xyz\t\t\t\t\n") + "mul ") + temp) + ".xyz, ") + temp) + ".xyz, ") + temp) + ".w\t\t\t\t\t\t\t\t\n") + "add ") + targetReg) + ".xyz, ") + targetReg) + ".xyz, ") + temp) + ".xyz\t\t\t\t\t\n"));
                };
            };
            return (code);
        }

    }
}//package away3d.materials.methods 
