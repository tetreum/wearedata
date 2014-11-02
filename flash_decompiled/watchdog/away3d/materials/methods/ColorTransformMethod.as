package away3d.materials.methods {
    import flash.geom.*;
    import away3d.materials.utils.*;
    import __AS3__.vec.*;
    import away3d.core.managers.*;

    public class ColorTransformMethod extends EffectMethodBase {

        private var _colorTransform:ColorTransform;

        public function ColorTransformMethod(){
            super();
        }
        public function get colorTransform():ColorTransform{
            return (this._colorTransform);
        }
        public function set colorTransform(value:ColorTransform):void{
            this._colorTransform = value;
        }
        override function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            var colorOffsReg:ShaderRegisterElement;
            var code:String = "";
            var colorMultReg:ShaderRegisterElement = regCache.getFreeFragmentConstant();
            colorOffsReg = regCache.getFreeFragmentConstant();
            vo.fragmentConstantsIndex = (colorMultReg.index * 4);
            code = (code + ((((((((((((("mul " + targetReg) + ", ") + targetReg.toString()) + ", ") + colorMultReg) + "\n") + "add ") + targetReg) + ", ") + targetReg.toString()) + ", ") + colorOffsReg) + "\n"));
            return (code);
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            var inv:Number = (1 / 0xFF);
            var index:int = vo.fragmentConstantsIndex;
            var data:Vector.<Number> = vo.fragmentData;
            data[index] = this._colorTransform.redMultiplier;
            data[(index + 1)] = this._colorTransform.greenMultiplier;
            data[(index + 2)] = this._colorTransform.blueMultiplier;
            data[(index + 3)] = this._colorTransform.alphaMultiplier;
            data[(index + 4)] = (this._colorTransform.redOffset * inv);
            data[(index + 5)] = (this._colorTransform.greenOffset * inv);
            data[(index + 6)] = (this._colorTransform.blueOffset * inv);
            data[(index + 7)] = (this._colorTransform.alphaOffset * inv);
        }

    }
}//package away3d.materials.methods 
