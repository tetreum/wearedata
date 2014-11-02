package away3d.materials.methods {
    import away3d.errors.*;
    import away3d.materials.utils.*;

    public class EffectMethodBase extends ShadingMethodBase {

        public function EffectMethodBase(){
            super();
        }
        function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            throw (new AbstractMethodError());
        }

    }
}//package away3d.materials.methods 
