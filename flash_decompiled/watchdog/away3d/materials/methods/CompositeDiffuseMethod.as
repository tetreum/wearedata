package away3d.materials.methods {
    import away3d.events.*;
    import away3d.textures.*;
    import away3d.materials.utils.*;
    import away3d.core.managers.*;

    public class CompositeDiffuseMethod extends BasicDiffuseMethod {

        private var _baseDiffuseMethod:BasicDiffuseMethod;

        public function CompositeDiffuseMethod(modulateMethod:Function=null, baseDiffuseMethod:BasicDiffuseMethod=null){
            super();
            this._baseDiffuseMethod = ((baseDiffuseMethod) || (new BasicDiffuseMethod()));
            this._baseDiffuseMethod._modulateMethod = modulateMethod;
            this._baseDiffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
        }
        override function initVO(vo:MethodVO):void{
            this._baseDiffuseMethod.initVO(vo);
        }
        override function initConstants(vo:MethodVO):void{
            this._baseDiffuseMethod.initConstants(vo);
        }
        override public function dispose():void{
            this._baseDiffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._baseDiffuseMethod.dispose();
        }
        override public function get alphaThreshold():Number{
            return (this._baseDiffuseMethod.alphaThreshold);
        }
        override public function set alphaThreshold(value:Number):void{
            this._baseDiffuseMethod.alphaThreshold = value;
        }
        override public function get texture():Texture2DBase{
            return (this._baseDiffuseMethod.texture);
        }
        override public function set texture(value:Texture2DBase):void{
            this._baseDiffuseMethod.texture = value;
        }
        override public function get diffuseAlpha():Number{
            return (this._baseDiffuseMethod.diffuseAlpha);
        }
        override public function get diffuseColor():uint{
            return (this._baseDiffuseMethod.diffuseColor);
        }
        override public function set diffuseColor(diffuseColor:uint):void{
            this._baseDiffuseMethod.diffuseColor = diffuseColor;
        }
        override public function set diffuseAlpha(value:Number):void{
            this._baseDiffuseMethod.diffuseAlpha = value;
        }
        override function getFragmentPreLightingCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            return (this._baseDiffuseMethod.getFragmentPreLightingCode(vo, regCache));
        }
        override function getFragmentCodePerLight(vo:MethodVO, lightIndex:int, lightDirReg:ShaderRegisterElement, lightColReg:ShaderRegisterElement, regCache:ShaderRegisterCache):String{
            var code:String = this._baseDiffuseMethod.getFragmentCodePerLight(vo, lightIndex, lightDirReg, lightColReg, regCache);
            _totalLightColorReg = this._baseDiffuseMethod._totalLightColorReg;
            return (code);
        }
        override function getFragmentCodePerProbe(vo:MethodVO, lightIndex:int, cubeMapReg:ShaderRegisterElement, weightRegister:String, regCache:ShaderRegisterCache):String{
            var code:String = this._baseDiffuseMethod.getFragmentCodePerProbe(vo, lightIndex, cubeMapReg, weightRegister, regCache);
            _totalLightColorReg = this._baseDiffuseMethod._totalLightColorReg;
            return (code);
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            this._baseDiffuseMethod.activate(vo, stage3DProxy);
        }
        override function deactivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            this._baseDiffuseMethod.deactivate(vo, stage3DProxy);
        }
        override function getVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            return (this._baseDiffuseMethod.getVertexCode(vo, regCache));
        }
        override function getFragmentPostLightingCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            return (this._baseDiffuseMethod.getFragmentPostLightingCode(vo, regCache, targetReg));
        }
        override function reset():void{
            this._baseDiffuseMethod.reset();
        }
        override function cleanCompilationData():void{
            super.cleanCompilationData();
            this._baseDiffuseMethod.cleanCompilationData();
        }
        override function set globalPosReg(value:ShaderRegisterElement):void{
            this._baseDiffuseMethod.globalPosReg = (_globalPosReg = value);
        }
        override function set UVFragmentReg(value:ShaderRegisterElement):void{
            this._baseDiffuseMethod.UVFragmentReg = (_uvFragmentReg = value);
        }
        override function set secondaryUVFragmentReg(value:ShaderRegisterElement):void{
            this._baseDiffuseMethod.secondaryUVFragmentReg = (_secondaryUVFragmentReg = value);
        }
        override function get viewDirFragmentReg():ShaderRegisterElement{
            return (_viewDirFragmentReg);
        }
        override function set viewDirFragmentReg(value:ShaderRegisterElement):void{
            this._baseDiffuseMethod.viewDirFragmentReg = (_viewDirFragmentReg = value);
        }
        override public function set viewDirVaryingReg(value:ShaderRegisterElement):void{
            _viewDirVaryingReg = (this._baseDiffuseMethod.viewDirVaryingReg = value);
        }
        override function set projectionReg(value:ShaderRegisterElement):void{
            _projectionReg = (this._baseDiffuseMethod.projectionReg = value);
        }
        override function get normalFragmentReg():ShaderRegisterElement{
            return (_normalFragmentReg);
        }
        override function set normalFragmentReg(value:ShaderRegisterElement):void{
            this._baseDiffuseMethod.normalFragmentReg = (_normalFragmentReg = value);
        }
        override function set shadowRegister(value:ShaderRegisterElement):void{
            super.shadowRegister = value;
            this._baseDiffuseMethod.shadowRegister = value;
        }
        override function set tangentVaryingReg(value:ShaderRegisterElement):void{
            super.tangentVaryingReg = value;
            this._baseDiffuseMethod.tangentVaryingReg = value;
        }
        private function onShaderInvalidated(event:ShadingMethodEvent):void{
            invalidateShaderProgram();
        }

    }
}//package away3d.materials.methods 
