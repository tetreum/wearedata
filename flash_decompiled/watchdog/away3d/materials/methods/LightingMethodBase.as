package away3d.materials.methods {
    import away3d.materials.utils.*;

    public class LightingMethodBase extends ShadingMethodBase {

        var _modulateMethod:Function;

        public function LightingMethodBase(){
            super();
        }
        function getFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            return ("");
        }
        function getFragmentCodePerLight(vo:MethodVO, lightIndex:int, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String{
            return ("");
        }
        function getFragmentCodePerProbe(vo:MethodVO, lightIndex:int, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String{
            return ("");
        }
        function getFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            return ("");
        }

    }
}//package away3d.materials.methods 
