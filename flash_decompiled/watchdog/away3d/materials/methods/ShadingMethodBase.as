package away3d.materials.methods {
    import __AS3__.vec.*;
    import away3d.materials.passes.*;
    import away3d.materials.utils.*;
    import away3d.core.managers.*;
    import away3d.core.base.*;
    import away3d.cameras.*;
    import away3d.events.*;
    import flash.events.*;

    public class ShadingMethodBase extends EventDispatcher {

        protected var _viewDirVaryingReg:ShaderRegisterElement;
        protected var _viewDirFragmentReg:ShaderRegisterElement;
        protected var _normalFragmentReg:ShaderRegisterElement;
        protected var _uvFragmentReg:ShaderRegisterElement;
        protected var _secondaryUVFragmentReg:ShaderRegisterElement;
        protected var _tangentVaryingReg:ShaderRegisterElement;
        protected var _globalPosReg:ShaderRegisterElement;
        protected var _projectionReg:ShaderRegisterElement;
        protected var _passes:Vector.<MaterialPassBase>;

        public function ShadingMethodBase(){
            super();
        }
        function initVO(vo:MethodVO):void{
        }
        function initConstants(vo:MethodVO):void{
        }
        public function get passes():Vector.<MaterialPassBase>{
            return (this._passes);
        }
        public function dispose():void{
        }
        function createMethodVO():MethodVO{
            return (new MethodVO());
        }
        function reset():void{
            this.cleanCompilationData();
        }
        function cleanCompilationData():void{
            this._viewDirVaryingReg = null;
            this._viewDirFragmentReg = null;
            this._normalFragmentReg = null;
            this._uvFragmentReg = null;
            this._globalPosReg = null;
            this._projectionReg = null;
        }
        function get globalPosReg():ShaderRegisterElement{
            return (this._globalPosReg);
        }
        function set globalPosReg(value:ShaderRegisterElement):void{
            this._globalPosReg = value;
        }
        function get projectionReg():ShaderRegisterElement{
            return (this._projectionReg);
        }
        function set projectionReg(value:ShaderRegisterElement):void{
            this._projectionReg = value;
        }
        function get UVFragmentReg():ShaderRegisterElement{
            return (this._uvFragmentReg);
        }
        function set UVFragmentReg(value:ShaderRegisterElement):void{
            this._uvFragmentReg = value;
        }
        function get secondaryUVFragmentReg():ShaderRegisterElement{
            return (this._secondaryUVFragmentReg);
        }
        function set secondaryUVFragmentReg(value:ShaderRegisterElement):void{
            this._secondaryUVFragmentReg = value;
        }
        function get viewDirFragmentReg():ShaderRegisterElement{
            return (this._viewDirFragmentReg);
        }
        function set viewDirFragmentReg(value:ShaderRegisterElement):void{
            this._viewDirFragmentReg = value;
        }
        public function get viewDirVaryingReg():ShaderRegisterElement{
            return (this._viewDirVaryingReg);
        }
        public function set viewDirVaryingReg(value:ShaderRegisterElement):void{
            this._viewDirVaryingReg = value;
        }
        function get normalFragmentReg():ShaderRegisterElement{
            return (this._normalFragmentReg);
        }
        function set normalFragmentReg(value:ShaderRegisterElement):void{
            this._normalFragmentReg = value;
        }
        function getVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            return ("");
        }
        function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
        }
        function setRenderState(vo:MethodVO, renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void{
        }
        function deactivate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
        }
        protected function getTexSampleCode(vo:MethodVO, targetReg:ShaderRegisterElement, inputReg:ShaderRegisterElement, uvReg:ShaderRegisterElement=null, forceWrap:String=null):String{
            var filter:String;
            var wrap:String = ((forceWrap) || (((vo.repeatTextures) ? "wrap" : "clamp")));
            if (vo.useSmoothTextures){
                filter = ((vo.useMipmapping) ? "linear,miplinear" : "linear");
            } else {
                filter = ((vo.useMipmapping) ? "nearest,mipnearest" : "nearest");
            };
            uvReg = ((uvReg) || (this._uvFragmentReg));
            return ((((((((((("tex " + targetReg.toString()) + ", ") + uvReg.toString()) + ", ") + inputReg.toString()) + " <2d,") + filter) + ",") + wrap) + ">\n"));
        }
        protected function invalidateShaderProgram():void{
            dispatchEvent(new ShadingMethodEvent(ShadingMethodEvent.SHADER_INVALIDATED));
        }
        public function copyFrom(method:ShadingMethodBase):void{
        }
        function get tangentVaryingReg():ShaderRegisterElement{
            return (this._tangentVaryingReg);
        }
        function set tangentVaryingReg(value:ShaderRegisterElement):void{
            this._tangentVaryingReg = value;
        }

    }
}//package away3d.materials.methods 
