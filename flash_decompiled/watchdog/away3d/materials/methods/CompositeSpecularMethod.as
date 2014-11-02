package away3d.materials.methods {
    import away3d.events.*;
    import __AS3__.vec.*;
    import away3d.materials.passes.*;
    import away3d.textures.*;
    import away3d.core.managers.*;
    import away3d.materials.utils.*;

    public class CompositeSpecularMethod extends BasicSpecularMethod {

        private var _baseSpecularMethod:BasicSpecularMethod;

        public function CompositeSpecularMethod(modulateMethod:Function, baseSpecularMethod:BasicSpecularMethod=null){
            super();
            this._baseSpecularMethod = ((baseSpecularMethod) || (new BasicSpecularMethod()));
            this._baseSpecularMethod._modulateMethod = modulateMethod;
            this._baseSpecularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
        }
        override function initVO(vo:MethodVO):void{
            this._baseSpecularMethod.initVO(vo);
        }
        override function initConstants(vo:MethodVO):void{
            this._baseSpecularMethod.initConstants(vo);
        }
        override public function get gloss():Number{
            return (this._baseSpecularMethod.gloss);
        }
        override public function set gloss(value:Number):void{
            this._baseSpecularMethod.gloss = value;
        }
        override public function get specular():Number{
            return (this._baseSpecularMethod.specular);
        }
        override public function set specular(value:Number):void{
            this._baseSpecularMethod.specular = value;
        }
        override public function get shadingModel():String{
            return (this._baseSpecularMethod.shadingModel);
        }
        override public function set shadingModel(value:String):void{
            this._baseSpecularMethod.shadingModel = value;
        }
        override public function get passes():Vector.<MaterialPassBase>{
            return (this._baseSpecularMethod.passes);
        }
        override public function dispose():void{
            this._baseSpecularMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._baseSpecularMethod.dispose();
        }
        override public function get texture():Texture2DBase{
            return (this._baseSpecularMethod.texture);
        }
        override public function set texture(value:Texture2DBase):void{
            this._baseSpecularMethod.texture = value;
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            this._baseSpecularMethod.activate(vo, stage3DProxy);
        }
        override function deactivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            this._baseSpecularMethod.deactivate(vo, stage3DProxy);
        }
        override function get normalFragmentReg():ShaderRegisterElement{
            return (this._baseSpecularMethod.normalFragmentReg);
        }
        override function set normalFragmentReg(value:ShaderRegisterElement):void{
            _normalFragmentReg = (this._baseSpecularMethod.normalFragmentReg = value);
        }
        override function set globalPosReg(value:ShaderRegisterElement):void{
            this._baseSpecularMethod.globalPosReg = (_globalPosReg = value);
        }
        override function set UVFragmentReg(value:ShaderRegisterElement):void{
            this._baseSpecularMethod.UVFragmentReg = value;
        }
        override function set secondaryUVFragmentReg(value:ShaderRegisterElement):void{
            this._baseSpecularMethod.secondaryUVFragmentReg = (_secondaryUVFragmentReg = value);
        }
        override function set viewDirFragmentReg(value:ShaderRegisterElement):void{
            _viewDirFragmentReg = (this._baseSpecularMethod.viewDirFragmentReg = value);
        }
        override function set projectionReg(value:ShaderRegisterElement):void{
            _projectionReg = (this._baseSpecularMethod.projectionReg = value);
        }
        override public function set viewDirVaryingReg(value:ShaderRegisterElement):void{
            _viewDirVaryingReg = (this._baseSpecularMethod.viewDirVaryingReg = value);
        }
        override function getVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            return (this._baseSpecularMethod.getVertexCode(vo, regCache));
        }
        override function getFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            return (this._baseSpecularMethod.getFragmentPreLightingCode(vo, regCache));
        }
        override function getFragmentCodePerLight(vo:MethodVO, lightIndex:int, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String{
            return (this._baseSpecularMethod.getFragmentCodePerLight(vo, lightIndex, lightDirReg, lightColReg, regCache));
        }
        override function getFragmentCodePerProbe(vo:MethodVO, lightIndex:int, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String{
            return (this._baseSpecularMethod.getFragmentCodePerProbe(vo, lightIndex, cubeMapReg, weightRegister, regCache));
        }
        override function getFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            return (this._baseSpecularMethod.getFragmentPostLightingCode(vo, regCache, targetReg));
        }
        override function reset():void{
            this._baseSpecularMethod.reset();
        }
        override function cleanCompilationData():void{
            super.cleanCompilationData();
            this._baseSpecularMethod.cleanCompilationData();
        }
        override function set shadowRegister(value:ShaderRegisterElement):void{
            super.shadowRegister = value;
            this._baseSpecularMethod.shadowRegister = value;
        }
        override function set tangentVaryingReg(value:ShaderRegisterElement):void{
            super.tangentVaryingReg = value;
            this._baseSpecularMethod.tangentVaryingReg = value;
        }
        private function onShaderInvalidated(event:ShadingMethodEvent):void{
            invalidateShaderProgram();
        }

    }
}//package away3d.materials.methods 
