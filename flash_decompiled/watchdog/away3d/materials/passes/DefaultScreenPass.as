package away3d.materials.passes {
    import __AS3__.vec.*;
    import away3d.materials.*;
    import away3d.materials.methods.*;
    import away3d.events.*;
    import flash.geom.*;
    import away3d.textures.*;
    import flash.display3D.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import away3d.core.base.*;
    import away3d.materials.lightpickers.*;
    import away3d.materials.utils.*;
    import away3d.lights.*;

    public class DefaultScreenPass extends MaterialPassBase {

        private var _specularLightSources:uint = 1;
        private var _diffuseLightSources:uint = 3;
        private var _combinedLightSources:uint;
        private var _colorTransformMethod:ColorTransformMethod;
        private var _colorTransformMethodVO:MethodVO;
        private var _normalMethod:BasicNormalMethod;
        private var _normalMethodVO:MethodVO;
        private var _ambientMethod:BasicAmbientMethod;
        private var _ambientMethodVO:MethodVO;
        private var _shadowMethod:ShadowMapMethodBase;
        private var _shadowMethodVO:MethodVO;
        private var _diffuseMethod:BasicDiffuseMethod;
        private var _diffuseMethodVO:MethodVO;
        private var _specularMethod:BasicSpecularMethod;
        private var _specularMethodVO:MethodVO;
        private var _methods:Vector.<MethodSet>;
        private var _registerCache:ShaderRegisterCache;
        private var _vertexCode:String;
        private var _fragmentCode:String;
        private var _projectionDependencies:uint;
        private var _normalDependencies:uint;
        private var _viewDirDependencies:uint;
        private var _uvDependencies:uint;
        private var _secondaryUVDependencies:uint;
        private var _globalPosDependencies:uint;
        protected var _uvBufferIndex:int;
        protected var _secondaryUVBufferIndex:int;
        protected var _normalBufferIndex:int;
        protected var _tangentBufferIndex:int;
        protected var _sceneMatrixIndex:int;
        protected var _sceneNormalMatrixIndex:int;
        protected var _lightDataIndex:int;
        protected var _cameraPositionIndex:int;
        protected var _uvTransformIndex:int;
        private var _projectionFragmentReg:ShaderRegisterElement;
        private var _normalFragmentReg:ShaderRegisterElement;
        private var _viewDirFragmentReg:ShaderRegisterElement;
        private var _lightInputIndices:Vector.<uint>;
        private var _lightProbeDiffuseIndices:Vector.<uint>;
        private var _lightProbeSpecularIndices:Vector.<uint>;
        private var _normalVarying:ShaderRegisterElement;
        private var _tangentVarying:ShaderRegisterElement;
        private var _bitangentVarying:ShaderRegisterElement;
        private var _uvVaryingReg:ShaderRegisterElement;
        private var _secondaryUVVaryingReg:ShaderRegisterElement;
        private var _viewDirVaryingReg:ShaderRegisterElement;
        private var _shadedTargetReg:ShaderRegisterElement;
        private var _globalPositionVertexReg:ShaderRegisterElement;
        private var _globalPositionVaryingReg:ShaderRegisterElement;
        private var _localPositionRegister:ShaderRegisterElement;
        private var _positionMatrixRegs:Vector.<ShaderRegisterElement>;
        private var _normalInput:ShaderRegisterElement;
        private var _tangentInput:ShaderRegisterElement;
        private var _animatedNormalReg:ShaderRegisterElement;
        private var _animatedTangentReg:ShaderRegisterElement;
        private var _commonsReg:ShaderRegisterElement;
        private var _commonsDataIndex:int;
        private var _vertexConstantIndex:uint;
        private var _vertexConstantData:Vector.<Number>;
        private var _fragmentConstantData:Vector.<Number>;
        var _passes:Vector.<MaterialPassBase>;
        var _passesDirty:Boolean;
        private var _animateUVs:Boolean;
        private var _numLights:int;
        private var _lightDataLength:int;
        private var _pointLightRegisters:Vector.<ShaderRegisterElement>;
        private var _dirLightRegisters:Vector.<ShaderRegisterElement>;
        private var _diffuseLightIndex:int;
        private var _specularLightIndex:int;
        private var _probeWeightsIndex:int;
        private var _numProbeRegisters:uint;
        private var _usingSpecularMethod:Boolean;
        private var _usesGlobalPosFragment:Boolean = true;
        private var _tangentDependencies:int;
        private var _ambientLightR:Number;
        private var _ambientLightG:Number;
        private var _ambientLightB:Number;
        private var _projectedTargetRegister:String;

        public function DefaultScreenPass(material:MaterialBase){
            this._vertexConstantData = new Vector.<Number>();
            this._fragmentConstantData = new Vector.<Number>();
            super();
            _material = material;
            this.init();
        }
        private function init():void{
            this._methods = new Vector.<MethodSet>();
            this._normalMethod = new BasicNormalMethod();
            this._ambientMethod = new BasicAmbientMethod();
            this._diffuseMethod = new BasicDiffuseMethod();
            this._specularMethod = new BasicSpecularMethod();
            this._normalMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._diffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._specularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._ambientMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._normalMethodVO = this._normalMethod.createMethodVO();
            this._ambientMethodVO = this._ambientMethod.createMethodVO();
            this._diffuseMethodVO = this._diffuseMethod.createMethodVO();
            this._specularMethodVO = this._specularMethod.createMethodVO();
        }
        public function get animateUVs():Boolean{
            return (this._animateUVs);
        }
        public function set animateUVs(value:Boolean):void{
            this._animateUVs = value;
            if (((((value) && (!(this._animateUVs)))) || (((!(value)) && (this._animateUVs))))){
                this.invalidateShaderProgram();
            };
        }
        override public function set mipmap(value:Boolean):void{
            if (_mipmap == value){
                return;
            };
            super.mipmap = value;
        }
        public function get specularLightSources():uint{
            return (this._specularLightSources);
        }
        public function set specularLightSources(value:uint):void{
            this._specularLightSources = value;
        }
        public function get diffuseLightSources():uint{
            return (this._diffuseLightSources);
        }
        public function set diffuseLightSources(value:uint):void{
            this._diffuseLightSources = value;
        }
        public function get colorTransform():ColorTransform{
            return (((this._colorTransformMethod) ? this._colorTransformMethod.colorTransform : null));
        }
        public function set colorTransform(value:ColorTransform):void{
            if (value){
                this.colorTransformMethod = ((this.colorTransformMethod) || (new ColorTransformMethod()));
                this._colorTransformMethod.colorTransform = value;
            } else {
                if (!(value)){
                    if (this._colorTransformMethod){
                        this.colorTransformMethod = null;
                    };
                    this.colorTransformMethod = (this._colorTransformMethod = null);
                };
            };
        }
        override public function dispose():void{
            super.dispose();
            this._normalMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._normalMethod.dispose();
            this._diffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._diffuseMethod.dispose();
            if (this._shadowMethod){
                this._diffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
                this._shadowMethod.dispose();
            };
            this._ambientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._ambientMethod.dispose();
            if (this._specularMethod){
                this._ambientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
                this._specularMethod.dispose();
            };
            if (this._colorTransformMethod){
                this._colorTransformMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
                this._colorTransformMethod.dispose();
            };
            var i:int;
            while (i < this._methods.length) {
                this._methods[i].method.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
                this._methods[i].method.dispose();
                i++;
            };
            this._methods = null;
        }
        public function addMethod(method:EffectMethodBase):void{
            this._methods.push(new MethodSet(method));
            method.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this.invalidateShaderProgram();
        }
        public function hasMethod(method:EffectMethodBase):Boolean{
            return (!((this.getMethodSetForMethod(method) == null)));
        }
        public function addMethodAt(method:EffectMethodBase, index:int):void{
            this._methods.splice(index, 0, new MethodSet(method));
            method.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this.invalidateShaderProgram();
        }
        public function getMethodAt(index:int):EffectMethodBase{
            return (EffectMethodBase(this._methods[index].method));
        }
        public function get numMethods():int{
            return (this._methods.length);
        }
        public function removeMethod(method:EffectMethodBase):void{
            var index:int;
            var methodSet:MethodSet = this.getMethodSetForMethod(method);
            if (methodSet != null){
                index = this._methods.indexOf(methodSet);
                this._methods.splice(index, 1);
                method.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
                this.invalidateShaderProgram();
            };
        }
        public function get normalMap():Texture2DBase{
            return (this._normalMethod.normalMap);
        }
        public function set normalMap(value:Texture2DBase):void{
            this._normalMethod.normalMap = value;
        }
        public function get normalMethod():BasicNormalMethod{
            return (this._normalMethod);
        }
        public function set normalMethod(value:BasicNormalMethod):void{
            this._normalMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            value.copyFrom(this._normalMethod);
            this._normalMethod = value;
            this._normalMethodVO = this._normalMethod.createMethodVO();
            this._normalMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this.invalidateShaderProgram();
        }
        public function get ambientMethod():BasicAmbientMethod{
            return (this._ambientMethod);
        }
        public function set ambientMethod(value:BasicAmbientMethod):void{
            this._ambientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            value.copyFrom(this._ambientMethod);
            this._ambientMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this._ambientMethod = value;
            this._ambientMethodVO = this._ambientMethod.createMethodVO();
            this.invalidateShaderProgram();
        }
        public function get shadowMethod():ShadowMapMethodBase{
            return (this._shadowMethod);
        }
        public function set shadowMethod(value:ShadowMapMethodBase):void{
            if (this._shadowMethod){
                this._shadowMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            };
            this._shadowMethod = value;
            if (this._shadowMethod){
                this._shadowMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
                this._shadowMethodVO = this._shadowMethod.createMethodVO();
            } else {
                this._shadowMethodVO = null;
            };
            this.invalidateShaderProgram();
        }
        public function get diffuseMethod():BasicDiffuseMethod{
            return (this._diffuseMethod);
        }
        public function set diffuseMethod(value:BasicDiffuseMethod):void{
            this._diffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            value.copyFrom(this._diffuseMethod);
            this._diffuseMethod = value;
            this._diffuseMethodVO = this._diffuseMethod.createMethodVO();
            this._diffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            this.invalidateShaderProgram();
        }
        public function get specularMethod():BasicSpecularMethod{
            return (this._specularMethod);
        }
        public function set specularMethod(value:BasicSpecularMethod):void{
            if (this._specularMethod){
                this._specularMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
                if (value){
                    value.copyFrom(this._specularMethod);
                };
            };
            this._specularMethod = value;
            if (this._specularMethod){
                this._specularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
                this._specularMethodVO = this._specularMethod.createMethodVO();
            } else {
                this._specularMethodVO = null;
            };
            this.invalidateShaderProgram();
        }
        function get colorTransformMethod():ColorTransformMethod{
            return (this._colorTransformMethod);
        }
        function set colorTransformMethod(value:ColorTransformMethod):void{
            if (this._colorTransformMethod == value){
                return;
            };
            if (this._colorTransformMethod){
                this._colorTransformMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
            };
            if (((!(this._colorTransformMethod)) || (!(value)))){
                this.invalidateShaderProgram();
            };
            this._colorTransformMethod = value;
            if (this._colorTransformMethod){
                this._colorTransformMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED, this.onShaderInvalidated);
                this._colorTransformMethodVO = this._colorTransformMethod.createMethodVO();
            } else {
                this._colorTransformMethodVO = null;
            };
        }
        override function set numPointLights(value:uint):void{
            super.numPointLights = value;
            this.invalidateShaderProgram();
        }
        override function set numDirectionalLights(value:uint):void{
            super.numDirectionalLights = value;
            this.invalidateShaderProgram();
        }
        override function set numLightProbes(value:uint):void{
            super.numLightProbes = value;
            this.invalidateShaderProgram();
        }
        override function getVertexCode(code:String):String{
            var normal:String = (((_animationTargetRegisters.length > 1)) ? _animationTargetRegisters[1] : null);
            var projectionVertexCode:String = this.getProjectionCode(_animationTargetRegisters[0], this._projectedTargetRegister, normal);
            this._vertexCode = ((code + projectionVertexCode) + this._vertexCode);
            return (this._vertexCode);
        }
        private function getProjectionCode(positionRegister:String, projectionRegister:String, normalRegister:String):String{
            var code:String = "";
            var pos:String = positionRegister;
            if (projectionRegister){
                code = (code + (((((((("m44 " + projectionRegister) + ", ") + pos) + ", vc0\t\t\n") + "mov vt7, ") + projectionRegister) + "\n") + "mul op, vt7, vc4\n"));
            } else {
                code = (code + ((("m44 vt7, " + pos) + ", vc0\t\t\n") + "mul op, vt7, vc4\n"));
            };
            return (code);
        }
        override function getFragmentCode():String{
            return (this._fragmentCode);
        }
        override function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, textureRatioX:Number, textureRatioY:Number):void{
            var set:MethodSet;
            var pos:Vector3D;
            var context:Context3D = stage3DProxy._context3D;
            var len:uint = this._methods.length;
            super.activate(stage3DProxy, camera, textureRatioX, textureRatioY);
            if ((((this._normalDependencies > 0)) && (this._normalMethod.hasOutput))){
                this._normalMethod.activate(this._normalMethodVO, stage3DProxy);
            };
            this._ambientMethod.activate(this._ambientMethodVO, stage3DProxy);
            if (this._shadowMethod){
                this._shadowMethod.activate(this._shadowMethodVO, stage3DProxy);
            };
            this._diffuseMethod.activate(this._diffuseMethodVO, stage3DProxy);
            if (this._usingSpecularMethod){
                this._specularMethod.activate(this._specularMethodVO, stage3DProxy);
            };
            if (this._colorTransformMethod){
                this._colorTransformMethod.activate(this._colorTransformMethodVO, stage3DProxy);
            };
            var i:int;
            while (i < len) {
                set = this._methods[i];
                set.method.activate(set.data, stage3DProxy);
                i++;
            };
            if (this._cameraPositionIndex >= 0){
                pos = camera.scenePosition;
                this._vertexConstantData[this._cameraPositionIndex] = pos.x;
                this._vertexConstantData[(this._cameraPositionIndex + 1)] = pos.y;
                this._vertexConstantData[(this._cameraPositionIndex + 2)] = pos.z;
            };
        }
        override function deactivate(stage3DProxy:Stage3DProxy):void{
            var set:MethodSet;
            super.deactivate(stage3DProxy);
            var len:uint = this._methods.length;
            if ((((this._normalDependencies > 0)) && (this._normalMethod.hasOutput))){
                this._normalMethod.deactivate(this._normalMethodVO, stage3DProxy);
            };
            this._ambientMethod.deactivate(this._ambientMethodVO, stage3DProxy);
            if (this._shadowMethod){
                this._shadowMethod.deactivate(this._shadowMethodVO, stage3DProxy);
            };
            this._diffuseMethod.deactivate(this._diffuseMethodVO, stage3DProxy);
            if (this._usingSpecularMethod){
                this._specularMethod.deactivate(this._specularMethodVO, stage3DProxy);
            };
            if (this._colorTransformMethod){
                this._colorTransformMethod.deactivate(this._colorTransformMethodVO, stage3DProxy);
            };
            var i:uint;
            while (i < len) {
                set = this._methods[i];
                set.method.deactivate(set.data, stage3DProxy);
                i++;
            };
        }
        override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, lightPicker:LightPickerBase):void{
            var i:uint;
            var uvTransform:Matrix;
            var set:MethodSet;
            var context:Context3D = stage3DProxy._context3D;
            if (this._uvBufferIndex >= 0){
                stage3DProxy.setSimpleVertexBuffer(this._uvBufferIndex, renderable.getUVBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_2, renderable.UVBufferOffset);
            };
            if (this._secondaryUVBufferIndex >= 0){
                stage3DProxy.setSimpleVertexBuffer(this._secondaryUVBufferIndex, renderable.getSecondaryUVBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_2, renderable.secondaryUVBufferOffset);
            };
            if (this._normalBufferIndex >= 0){
                stage3DProxy.setSimpleVertexBuffer(this._normalBufferIndex, renderable.getVertexNormalBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, renderable.normalBufferOffset);
            };
            if (this._tangentBufferIndex >= 0){
                stage3DProxy.setSimpleVertexBuffer(this._tangentBufferIndex, renderable.getVertexTangentBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, renderable.tangentBufferOffset);
            };
            if (this._animateUVs){
                uvTransform = renderable.uvTransform;
                if (uvTransform){
                    this._vertexConstantData[this._uvTransformIndex] = uvTransform.a;
                    this._vertexConstantData[(this._uvTransformIndex + 1)] = uvTransform.b;
                    this._vertexConstantData[(this._uvTransformIndex + 3)] = uvTransform.tx;
                    this._vertexConstantData[(this._uvTransformIndex + 4)] = uvTransform.c;
                    this._vertexConstantData[(this._uvTransformIndex + 5)] = uvTransform.d;
                    this._vertexConstantData[(this._uvTransformIndex + 7)] = uvTransform.ty;
                } else {
                    trace("Warning: animateUVs is set to true with an IRenderable without a uvTransform. Identity matrix assumed.");
                    this._vertexConstantData[this._uvTransformIndex] = 1;
                    this._vertexConstantData[(this._uvTransformIndex + 1)] = 0;
                    this._vertexConstantData[(this._uvTransformIndex + 3)] = 0;
                    this._vertexConstantData[(this._uvTransformIndex + 4)] = 0;
                    this._vertexConstantData[(this._uvTransformIndex + 5)] = 1;
                    this._vertexConstantData[(this._uvTransformIndex + 7)] = 0;
                };
            };
            if ((((this._numLights > 0)) && ((this._combinedLightSources & LightSources.LIGHTS)))){
                this.updateLights(lightPicker.directionalLights, lightPicker.pointLights, stage3DProxy);
            };
            if ((((_numLightProbes > 0)) && ((this._combinedLightSources & LightSources.PROBES)))){
                this.updateProbes(lightPicker.lightProbes, lightPicker.lightProbeWeights, stage3DProxy);
            };
            if (this._sceneMatrixIndex >= 0){
                renderable.sceneTransform.copyRawDataTo(this._vertexConstantData, this._sceneMatrixIndex, true);
            };
            if (this._sceneNormalMatrixIndex >= 0){
                renderable.inverseSceneTransform.copyRawDataTo(this._vertexConstantData, this._sceneNormalMatrixIndex, false);
            };
            if ((((this._normalDependencies > 0)) && (this._normalMethod.hasOutput))){
                this._normalMethod.setRenderState(this._normalMethodVO, renderable, stage3DProxy, camera);
            };
            this._ambientMethod.setRenderState(this._ambientMethodVO, renderable, stage3DProxy, camera);
            this._ambientMethod._lightAmbientR = this._ambientLightR;
            this._ambientMethod._lightAmbientG = this._ambientLightG;
            this._ambientMethod._lightAmbientB = this._ambientLightB;
            if (this._shadowMethod){
                this._shadowMethod.setRenderState(this._shadowMethodVO, renderable, stage3DProxy, camera);
            };
            this._diffuseMethod.setRenderState(this._diffuseMethodVO, renderable, stage3DProxy, camera);
            if (this._usingSpecularMethod){
                this._specularMethod.setRenderState(this._specularMethodVO, renderable, stage3DProxy, camera);
            };
            if (this._colorTransformMethod){
                this._colorTransformMethod.setRenderState(this._colorTransformMethodVO, renderable, stage3DProxy, camera);
            };
            var len:uint = this._methods.length;
            i = 0;
            while (i < len) {
                set = this._methods[i];
                set.method.setRenderState(set.data, renderable, stage3DProxy, camera);
                i++;
            };
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, this._vertexConstantIndex, this._vertexConstantData, (_numUsedVertexConstants - this._vertexConstantIndex));
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._fragmentConstantData, _numUsedFragmentConstants);
            super.render(renderable, stage3DProxy, camera, lightPicker);
        }
        override function invalidateShaderProgram(updateMaterial:Boolean=true):void{
            super.invalidateShaderProgram(updateMaterial);
            this._passesDirty = true;
            this._passes = new Vector.<MaterialPassBase>();
            if (this._normalMethod.hasOutput){
                this.addPasses(this._normalMethod.passes);
            };
            this.addPasses(this._ambientMethod.passes);
            if (this._shadowMethod){
                this.addPasses(this._shadowMethod.passes);
            };
            this.addPasses(this._diffuseMethod.passes);
            if (this._specularMethod){
                this.addPasses(this._specularMethod.passes);
            };
            if (this._colorTransformMethod){
                this.addPasses(this._colorTransformMethod.passes);
            };
            var i:uint;
            while (i < this._methods.length) {
                this.addPasses(this._methods[i].method.passes);
                i++;
            };
        }
        override function updateProgram(stage3DProxy:Stage3DProxy):void{
            this.reset();
            super.updateProgram(stage3DProxy);
        }
        private function reset():void{
            this._numLights = (_numPointLights + _numDirectionalLights);
            this._numProbeRegisters = Math.ceil((_numLightProbes / 4));
            if (this._specularMethod){
                this._combinedLightSources = (this._specularLightSources | this._diffuseLightSources);
            } else {
                this._combinedLightSources = this._diffuseLightSources;
            };
            this._usingSpecularMethod = ((this._specularMethod) && ((((((this._numLights > 0)) && ((this._specularLightSources & LightSources.LIGHTS)))) || ((((_numLightProbes > 0)) && ((this._specularLightSources & LightSources.PROBES)))))));
            this._uvTransformIndex = -1;
            this._cameraPositionIndex = -1;
            this._commonsDataIndex = -1;
            this._uvBufferIndex = -1;
            this._secondaryUVBufferIndex = -1;
            this._normalBufferIndex = -1;
            this._tangentBufferIndex = -1;
            this._lightDataIndex = -1;
            this._sceneMatrixIndex = -1;
            this._sceneNormalMatrixIndex = -1;
            this._probeWeightsIndex = -1;
            this._pointLightRegisters = new Vector.<ShaderRegisterElement>((_numPointLights * 3), true);
            this._dirLightRegisters = new Vector.<ShaderRegisterElement>((_numDirectionalLights * 3), true);
            this._lightDataLength = (this._numLights * 3);
            this._registerCache = new ShaderRegisterCache();
            this._vertexConstantIndex = (this._registerCache.vertexConstantOffset = 5);
            this._registerCache.vertexAttributesOffset = 1;
            this._registerCache.reset();
            this._lightInputIndices = new Vector.<uint>(this._numLights, true);
            this._commonsReg = null;
            _numUsedVertexConstants = 0;
            _numUsedStreams = 1;
            _animatableAttributes = ["va0"];
            _animationTargetRegisters = ["vt0"];
            this._vertexCode = "";
            this._fragmentCode = "";
            this._projectedTargetRegister = null;
            this._localPositionRegister = this._registerCache.getFreeVertexVectorTemp();
            this._registerCache.addVertexTempUsages(this._localPositionRegister, 1);
            this.compile();
            _numUsedVertexConstants = this._registerCache.numUsedVertexConstants;
            _numUsedFragmentConstants = this._registerCache.numUsedFragmentConstants;
            _numUsedStreams = this._registerCache.numUsedStreams;
            _numUsedTextures = this._registerCache.numUsedTextures;
            this._vertexConstantData.length = ((_numUsedVertexConstants - this._vertexConstantIndex) * 4);
            this._fragmentConstantData.length = (_numUsedFragmentConstants * 4);
            this.initCommonsData();
            if (this._uvTransformIndex >= 0){
                this.initUVTransformData();
            };
            if (this._cameraPositionIndex >= 0){
                this._vertexConstantData[(this._cameraPositionIndex + 3)] = 1;
            };
            this.updateMethodConstants();
            this.cleanUp();
        }
        private function updateMethodConstants():void{
            if (this._normalMethod){
                this._normalMethod.initConstants(this._normalMethodVO);
            };
            if (this._diffuseMethod){
                this._diffuseMethod.initConstants(this._diffuseMethodVO);
            };
            if (this._ambientMethod){
                this._ambientMethod.initConstants(this._ambientMethodVO);
            };
            if (this._specularMethod){
                this._specularMethod.initConstants(this._specularMethodVO);
            };
            if (this._shadowMethod){
                this._shadowMethod.initConstants(this._shadowMethodVO);
            };
            if (this._colorTransformMethod){
                this._colorTransformMethod.initConstants(this._colorTransformMethodVO);
            };
            var len:uint = this._methods.length;
            var i:uint;
            while (i < len) {
                this._methods[i].method.initConstants(this._methods[i].data);
                i++;
            };
        }
        private function initUVTransformData():void{
            this._vertexConstantData[this._uvTransformIndex] = 1;
            this._vertexConstantData[(this._uvTransformIndex + 1)] = 0;
            this._vertexConstantData[(this._uvTransformIndex + 2)] = 0;
            this._vertexConstantData[(this._uvTransformIndex + 3)] = 0;
            this._vertexConstantData[(this._uvTransformIndex + 4)] = 0;
            this._vertexConstantData[(this._uvTransformIndex + 5)] = 1;
            this._vertexConstantData[(this._uvTransformIndex + 6)] = 0;
            this._vertexConstantData[(this._uvTransformIndex + 7)] = 0;
        }
        private function initCommonsData():void{
            this._fragmentConstantData[this._commonsDataIndex] = 0.5;
            this._fragmentConstantData[(this._commonsDataIndex + 1)] = 0;
            this._fragmentConstantData[(this._commonsDataIndex + 2)] = 1E-5;
            this._fragmentConstantData[(this._commonsDataIndex + 3)] = 1;
        }
        private function cleanUp():void{
            this.nullifyCompilationData();
            this.cleanUpMethods();
        }
        private function nullifyCompilationData():void{
            this._pointLightRegisters = null;
            this._dirLightRegisters = null;
            this._projectionFragmentReg = null;
            this._viewDirFragmentReg = null;
            this._normalVarying = null;
            this._tangentVarying = null;
            this._bitangentVarying = null;
            this._uvVaryingReg = null;
            this._secondaryUVVaryingReg = null;
            this._viewDirVaryingReg = null;
            this._shadedTargetReg = null;
            this._globalPositionVertexReg = null;
            this._globalPositionVaryingReg = null;
            this._localPositionRegister = null;
            this._positionMatrixRegs = null;
            this._normalInput = null;
            this._tangentInput = null;
            this._animatedNormalReg = null;
            this._animatedTangentReg = null;
            this._commonsReg = null;
            this._registerCache.dispose();
            this._registerCache = null;
        }
        private function cleanUpMethods():void{
            if (this._normalMethod){
                this._normalMethod.cleanCompilationData();
            };
            if (this._diffuseMethod){
                this._diffuseMethod.cleanCompilationData();
            };
            if (this._ambientMethod){
                this._ambientMethod.cleanCompilationData();
            };
            if (this._specularMethod){
                this._specularMethod.cleanCompilationData();
            };
            if (this._shadowMethod){
                this._shadowMethod.cleanCompilationData();
            };
            if (this._colorTransformMethod){
                this._colorTransformMethod.cleanCompilationData();
            };
            var len:uint = this._methods.length;
            var i:uint;
            while (i < len) {
                this._methods[i].method.cleanCompilationData();
                i++;
            };
        }
        private function compile():void{
            this.createCommons();
            this.calculateDependencies();
            if (this._projectionDependencies > 0){
                this.compileProjCode();
            };
            if (this._uvDependencies > 0){
                this.compileUVCode();
            };
            if (this._secondaryUVDependencies > 0){
                this.compileSecondaryUVCode();
            };
            if (this._globalPosDependencies > 0){
                this.compileGlobalPositionCode();
            };
            this.updateMethodRegisters(this._normalMethod);
            if (this._normalDependencies > 0){
                this._animatedNormalReg = this._registerCache.getFreeVertexVectorTemp();
                this._registerCache.addVertexTempUsages(this._animatedNormalReg, 1);
                if (this._normalDependencies > 0){
                    this.compileNormalCode();
                };
            };
            if (this._viewDirDependencies > 0){
                this.compileViewDirCode();
            };
            this.updateMethodRegisters(this._diffuseMethod);
            if (this._shadowMethod){
                this.updateMethodRegisters(this._shadowMethod);
            };
            this.updateMethodRegisters(this._ambientMethod);
            if (this._specularMethod){
                this.updateMethodRegisters(this._specularMethod);
            };
            if (this._colorTransformMethod){
                this.updateMethodRegisters(this._colorTransformMethod);
            };
            var i:uint;
            while (i < this._methods.length) {
                this.updateMethodRegisters(this._methods[i].method);
                i++;
            };
            this._shadedTargetReg = this._registerCache.getFreeFragmentVectorTemp();
            this._registerCache.addFragmentTempUsages(this._shadedTargetReg, 1);
            this.compileLightingCode();
            this.compileMethods();
            this._fragmentCode = (this._fragmentCode + (((("mov " + this._registerCache.fragmentOutputRegister) + ", ") + this._shadedTargetReg) + "\n"));
            this._registerCache.removeFragmentTempUsage(this._shadedTargetReg);
        }
        private function compileProjCode():void{
            this._projectionFragmentReg = this._registerCache.getFreeVarying();
            this._projectedTargetRegister = this._registerCache.getFreeVertexVectorTemp().toString();
            this._vertexCode = (this._vertexCode + (((("mov " + this._projectionFragmentReg) + ", ") + this._projectedTargetRegister) + "\n"));
        }
        private function updateMethodRegisters(method:ShadingMethodBase):void{
            method.globalPosReg = this._globalPositionVaryingReg;
            method.normalFragmentReg = this._normalFragmentReg;
            method.projectionReg = this._projectionFragmentReg;
            method.UVFragmentReg = this._uvVaryingReg;
            method.tangentVaryingReg = this._tangentVarying;
            method.secondaryUVFragmentReg = this._secondaryUVVaryingReg;
            method.viewDirFragmentReg = this._viewDirFragmentReg;
            method.viewDirVaryingReg = this._viewDirVaryingReg;
        }
        private function addPasses(passes:Vector.<MaterialPassBase>):void{
            if (!(passes)){
                return;
            };
            var len:uint = passes.length;
            var i:uint;
            while (i < len) {
                passes[i].material = material;
                this._passes.push(passes[i]);
                i++;
            };
        }
        private function calculateDependencies():void{
            var len:uint;
            this._normalDependencies = 0;
            this._viewDirDependencies = 0;
            this._uvDependencies = 0;
            this._secondaryUVDependencies = 0;
            this._globalPosDependencies = 0;
            this.setupAndCountMethodDependencies(this._diffuseMethod, this._diffuseMethodVO);
            if (this._shadowMethod){
                this.setupAndCountMethodDependencies(this._shadowMethod, this._shadowMethodVO);
            };
            this.setupAndCountMethodDependencies(this._ambientMethod, this._ambientMethodVO);
            if (this._usingSpecularMethod){
                this.setupAndCountMethodDependencies(this._specularMethod, this._specularMethodVO);
            };
            if (this._colorTransformMethod){
                this.setupAndCountMethodDependencies(this._colorTransformMethod, this._colorTransformMethodVO);
            };
            len = this._methods.length;
            var i:uint;
            while (i < len) {
                this.setupAndCountMethodDependencies(this._methods[i].method, this._methods[i].data);
                i++;
            };
            if ((((this._normalDependencies > 0)) && (this._normalMethod.hasOutput))){
                this.setupAndCountMethodDependencies(this._normalMethod, this._normalMethodVO);
            };
            if (this._viewDirDependencies > 0){
                this._globalPosDependencies++;
            };
            if ((((_numPointLights > 0)) && ((this._combinedLightSources & LightSources.LIGHTS)))){
                this._globalPosDependencies++;
                this._usesGlobalPosFragment = true;
            };
        }
        private function setupAndCountMethodDependencies(method:ShadingMethodBase, methodVO:MethodVO):void{
            this.setupMethod(method, methodVO);
            this.countDependencies(methodVO);
        }
        private function countDependencies(methodVO:MethodVO):void{
            if (methodVO.needsProjection){
                this._projectionDependencies++;
            };
            if (methodVO.needsGlobalPos){
                this._globalPosDependencies++;
                this._usesGlobalPosFragment = true;
            };
            if (methodVO.needsNormals){
                this._normalDependencies++;
            };
            if (methodVO.needsTangents){
                this._tangentDependencies++;
            };
            if (methodVO.needsView){
                this._viewDirDependencies++;
            };
            if (methodVO.needsUV){
                this._uvDependencies++;
            };
            if (methodVO.needsSecondaryUV){
                this._secondaryUVDependencies++;
            };
        }
        private function setupMethod(method:ShadingMethodBase, methodVO:MethodVO):void{
            method.reset();
            methodVO.reset();
            methodVO.vertexData = this._vertexConstantData;
            methodVO.fragmentData = this._fragmentConstantData;
            methodVO.vertexConstantsOffset = this._vertexConstantIndex;
            methodVO.useSmoothTextures = _smooth;
            methodVO.repeatTextures = _repeat;
            methodVO.useMipmapping = _mipmap;
            methodVO.numLights = (this._numLights + _numLightProbes);
            method.initVO(methodVO);
        }
        private function compileGlobalPositionCode():void{
            this._globalPositionVertexReg = this._registerCache.getFreeVertexVectorTemp();
            this._registerCache.addVertexTempUsages(this._globalPositionVertexReg, this._globalPosDependencies);
            this._positionMatrixRegs = new Vector.<ShaderRegisterElement>();
            this._positionMatrixRegs[0] = this._registerCache.getFreeVertexConstant();
            this._positionMatrixRegs[1] = this._registerCache.getFreeVertexConstant();
            this._positionMatrixRegs[2] = this._registerCache.getFreeVertexConstant();
            this._registerCache.getFreeVertexConstant();
            this._sceneMatrixIndex = ((this._positionMatrixRegs[0].index - this._vertexConstantIndex) * 4);
            this._vertexCode = (this._vertexCode + ((((((((((("m44 " + this._globalPositionVertexReg) + ".xyz, ") + this._localPositionRegister.toString()) + ", ") + this._positionMatrixRegs[0].toString()) + "\n") + "mov ") + this._globalPositionVertexReg) + ".w, ") + this._localPositionRegister) + ".w     \n"));
            if (this._usesGlobalPosFragment){
                this._globalPositionVaryingReg = this._registerCache.getFreeVarying();
                this._vertexCode = (this._vertexCode + (((("mov " + this._globalPositionVaryingReg) + ", ") + this._globalPositionVertexReg) + "\n"));
            };
        }
        private function compileUVCode():void{
            var uvTransform1:ShaderRegisterElement;
            var uvTransform2:ShaderRegisterElement;
            var uvAttributeReg:ShaderRegisterElement = this._registerCache.getFreeVertexAttribute();
            this._uvVaryingReg = this._registerCache.getFreeVarying();
            this._uvBufferIndex = uvAttributeReg.index;
            if (this._animateUVs){
                uvTransform1 = this._registerCache.getFreeVertexConstant();
                uvTransform2 = this._registerCache.getFreeVertexConstant();
                this._uvTransformIndex = ((uvTransform1.index - this._vertexConstantIndex) * 4);
                this._vertexCode = (this._vertexCode + (((((((((((((((((("dp4 " + this._uvVaryingReg) + ".x, ") + uvAttributeReg) + ", ") + uvTransform1) + "\n") + "dp4 ") + this._uvVaryingReg) + ".y, ") + uvAttributeReg) + ", ") + uvTransform2) + "\n") + "mov ") + this._uvVaryingReg) + ".zw, ") + uvAttributeReg) + ".zw \n"));
            } else {
                this._vertexCode = (this._vertexCode + (((("mov " + this._uvVaryingReg) + ", ") + uvAttributeReg) + "\n"));
            };
        }
        private function compileSecondaryUVCode():void{
            var uvAttributeReg:ShaderRegisterElement = this._registerCache.getFreeVertexAttribute();
            this._secondaryUVVaryingReg = this._registerCache.getFreeVarying();
            this._secondaryUVBufferIndex = uvAttributeReg.index;
            this._vertexCode = (this._vertexCode + (((("mov " + this._secondaryUVVaryingReg) + ", ") + uvAttributeReg) + "\n"));
        }
        private function compileNormalCode():void{
            var normalMatrix:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>(3, true);
            this._normalFragmentReg = this._registerCache.getFreeFragmentVectorTemp();
            this._registerCache.addFragmentTempUsages(this._normalFragmentReg, this._normalDependencies);
            if (((this._normalMethod.hasOutput) && (!(this._normalMethod.tangentSpace)))){
                this._vertexCode = (this._vertexCode + this._normalMethod.getVertexCode(this._normalMethodVO, this._registerCache));
                this._fragmentCode = (this._fragmentCode + this._normalMethod.getFragmentCode(this._normalMethodVO, this._registerCache, this._normalFragmentReg));
                return;
            };
            this._normalInput = this._registerCache.getFreeVertexAttribute();
            this._normalBufferIndex = this._normalInput.index;
            this._normalVarying = this._registerCache.getFreeVarying();
            _animatableAttributes.push(this._normalInput.toString());
            _animationTargetRegisters.push(this._animatedNormalReg.toString());
            normalMatrix[0] = this._registerCache.getFreeVertexConstant();
            normalMatrix[1] = this._registerCache.getFreeVertexConstant();
            normalMatrix[2] = this._registerCache.getFreeVertexConstant();
            this._registerCache.getFreeVertexConstant();
            this._sceneNormalMatrixIndex = ((normalMatrix[0].index - this._vertexConstantIndex) * 4);
            if (this._normalMethod.hasOutput){
                this.compileTangentVertexCode(normalMatrix);
                this.compileTangentNormalMapFragmentCode();
            } else {
                this._vertexCode = (this._vertexCode + ((((((((((("m33 " + this._normalVarying) + ".xyz, ") + this._animatedNormalReg) + ".xyz, ") + normalMatrix[0]) + "\n") + "mov ") + this._normalVarying) + ".w, ") + this._animatedNormalReg) + ".w\t\n"));
                this._fragmentCode = (this._fragmentCode + ((((((((("nrm " + this._normalFragmentReg) + ".xyz, ") + this._normalVarying) + ".xyz\t\n") + "mov ") + this._normalFragmentReg) + ".w, ") + this._normalVarying) + ".w\t\t\n"));
                if (this._tangentDependencies > 0){
                    this._tangentInput = this._registerCache.getFreeVertexAttribute();
                    this._tangentBufferIndex = this._tangentInput.index;
                    this._tangentVarying = this._registerCache.getFreeVarying();
                    this._vertexCode = (this._vertexCode + (((("mov " + this._tangentVarying) + ", ") + this._tangentInput) + "\n"));
                };
            };
            this._registerCache.removeVertexTempUsage(this._animatedNormalReg);
        }
        private function compileTangentVertexCode(matrix:Vector.<ShaderRegisterElement>):void{
            var normalTemp:ShaderRegisterElement;
            var tanTemp:ShaderRegisterElement;
            var bitanTemp1:ShaderRegisterElement;
            var bitanTemp2:ShaderRegisterElement;
            this._tangentVarying = this._registerCache.getFreeVarying();
            this._bitangentVarying = this._registerCache.getFreeVarying();
            this._tangentInput = this._registerCache.getFreeVertexAttribute();
            this._tangentBufferIndex = this._tangentInput.index;
            this._animatedTangentReg = this._registerCache.getFreeVertexVectorTemp();
            this._registerCache.addVertexTempUsages(this._animatedTangentReg, 1);
            _animatableAttributes.push(this._tangentInput.toString());
            _animationTargetRegisters.push(this._animatedTangentReg.toString());
            normalTemp = this._registerCache.getFreeVertexVectorTemp();
            this._registerCache.addVertexTempUsages(normalTemp, 1);
            this._vertexCode = (this._vertexCode + ((((((((((("m33 " + normalTemp) + ".xyz, ") + this._animatedNormalReg) + ".xyz, ") + matrix[0].toString()) + "\n") + "nrm ") + normalTemp) + ".xyz, ") + normalTemp) + ".xyz\t\n"));
            tanTemp = this._registerCache.getFreeVertexVectorTemp();
            this._registerCache.addVertexTempUsages(tanTemp, 1);
            this._vertexCode = (this._vertexCode + ((((((((((("m33 " + tanTemp) + ".xyz, ") + this._animatedTangentReg) + ".xyz, ") + matrix[0].toString()) + "\n") + "nrm ") + tanTemp) + ".xyz, ") + tanTemp) + ".xyz\t\n"));
            bitanTemp1 = this._registerCache.getFreeVertexVectorTemp();
            this._registerCache.addVertexTempUsages(bitanTemp1, 1);
            bitanTemp2 = this._registerCache.getFreeVertexVectorTemp();
            this._vertexCode = (this._vertexCode + (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((("mul " + bitanTemp1) + ".xyz, ") + normalTemp) + ".yzx, ") + tanTemp) + ".zxy\t\n") + "mul ") + bitanTemp2) + ".xyz, ") + normalTemp) + ".zxy, ") + tanTemp) + ".yzx\t\n") + "sub ") + bitanTemp2) + ".xyz, ") + bitanTemp1) + ".xyz, ") + bitanTemp2) + ".xyz\t\n") + "mov ") + this._tangentVarying) + ".x, ") + tanTemp) + ".x\t\n") + "mov ") + this._tangentVarying) + ".y, ") + bitanTemp2) + ".x\t\n") + "mov ") + this._tangentVarying) + ".z, ") + normalTemp) + ".x\t\n") + "mov ") + this._tangentVarying) + ".w, ") + this._normalInput) + ".w\t\n") + "mov ") + this._bitangentVarying) + ".x, ") + tanTemp) + ".y\t\n") + "mov ") + this._bitangentVarying) + ".y, ") + bitanTemp2) + ".y\t\n") + "mov ") + this._bitangentVarying) + ".z, ") + normalTemp) + ".y\t\n") + "mov ") + this._bitangentVarying) + ".w, ") + this._normalInput) + ".w\t\n") + "mov ") + this._normalVarying) + ".x, ") + tanTemp) + ".z\t\n") + "mov ") + this._normalVarying) + ".y, ") + bitanTemp2) + ".z\t\n") + "mov ") + this._normalVarying) + ".z, ") + normalTemp) + ".z\t\n") + "mov ") + this._normalVarying) + ".w, ") + this._normalInput) + ".w\t\n"));
            this._registerCache.removeVertexTempUsage(normalTemp);
            this._registerCache.removeVertexTempUsage(tanTemp);
            this._registerCache.removeVertexTempUsage(bitanTemp1);
            this._registerCache.removeVertexTempUsage(this._animatedTangentReg);
        }
        private function compileTangentNormalMapFragmentCode():void{
            var t:ShaderRegisterElement;
            var b:ShaderRegisterElement;
            var n:ShaderRegisterElement;
            t = this._registerCache.getFreeFragmentVectorTemp();
            this._registerCache.addFragmentTempUsages(t, 1);
            b = this._registerCache.getFreeFragmentVectorTemp();
            this._registerCache.addFragmentTempUsages(b, 1);
            n = this._registerCache.getFreeFragmentVectorTemp();
            this._registerCache.addFragmentTempUsages(n, 1);
            this._fragmentCode = (this._fragmentCode + ((((((((((((((((((("nrm " + t) + ".xyz, ") + this._tangentVarying) + ".xyz\t\n") + "mov ") + t) + ".w, ") + this._tangentVarying) + ".w\t\n") + "nrm ") + b) + ".xyz, ") + this._bitangentVarying) + ".xyz\t\n") + "nrm ") + n) + ".xyz, ") + this._normalVarying) + ".xyz\t\n"));
            var temp:ShaderRegisterElement = this._registerCache.getFreeFragmentVectorTemp();
            this._registerCache.addFragmentTempUsages(temp, 1);
            this._fragmentCode = (this._fragmentCode + ((((((((((((((((((((((((this._normalMethod.getFragmentCode(this._normalMethodVO, this._registerCache, temp) + "sub ") + temp) + ".xyz, ") + temp) + ".xyz, ") + this._commonsReg) + ".xxx\t\n") + "nrm ") + temp) + ".xyz, ") + temp) + ".xyz\t\t\t\t\t\t\t\n") + "m33 ") + this._normalFragmentReg) + ".xyz, ") + temp) + ".xyz, ") + t) + "\t\n") + "mov ") + this._normalFragmentReg) + ".w,   ") + this._normalVarying) + ".w\t\t\t\n"));
            this._registerCache.removeFragmentTempUsage(temp);
            if (this._normalMethodVO.needsView){
                this._registerCache.removeFragmentTempUsage(this._viewDirFragmentReg);
            };
            if (this._normalMethodVO.needsGlobalPos){
                this._registerCache.removeVertexTempUsage(this._globalPositionVertexReg);
            };
            this._registerCache.removeFragmentTempUsage(b);
            this._registerCache.removeFragmentTempUsage(t);
            this._registerCache.removeFragmentTempUsage(n);
        }
        private function createCommons():void{
            this._commonsReg = this._registerCache.getFreeFragmentConstant();
            this._commonsDataIndex = (this._commonsReg.index * 4);
        }
        private function compileViewDirCode():void{
            var cameraPositionReg:ShaderRegisterElement = this._registerCache.getFreeVertexConstant();
            this._viewDirVaryingReg = this._registerCache.getFreeVarying();
            this._viewDirFragmentReg = this._registerCache.getFreeFragmentVectorTemp();
            this._registerCache.addFragmentTempUsages(this._viewDirFragmentReg, this._viewDirDependencies);
            this._cameraPositionIndex = ((cameraPositionReg.index - this._vertexConstantIndex) * 4);
            this._vertexCode = (this._vertexCode + (((((("sub " + this._viewDirVaryingReg) + ", ") + cameraPositionReg) + ", ") + this._globalPositionVertexReg) + "\n"));
            this._fragmentCode = (this._fragmentCode + ((((((((("nrm " + this._viewDirFragmentReg) + ".xyz, ") + this._viewDirVaryingReg) + ".xyz\t\t\n") + "mov ") + this._viewDirFragmentReg) + ".w,   ") + this._viewDirVaryingReg) + ".w \t\t\n"));
            this._registerCache.removeVertexTempUsage(this._globalPositionVertexReg);
        }
        private function compileLightingCode():void{
            var shadowReg:ShaderRegisterElement;
            this.initLightRegisters();
            this._vertexCode = (this._vertexCode + this._diffuseMethod.getVertexCode(this._diffuseMethodVO, this._registerCache));
            this._fragmentCode = (this._fragmentCode + this._diffuseMethod.getFragmentPreLightingCode(this._diffuseMethodVO, this._registerCache));
            if (this._usingSpecularMethod){
                this._vertexCode = (this._vertexCode + this._specularMethod.getVertexCode(this._specularMethodVO, this._registerCache));
                this._fragmentCode = (this._fragmentCode + this._specularMethod.getFragmentPreLightingCode(this._specularMethodVO, this._registerCache));
            };
            this._diffuseLightIndex = 0;
            this._specularLightIndex = 0;
            if ((((this._numLights > 0)) && ((this._combinedLightSources & LightSources.LIGHTS)))){
                this.compileDirectionalLightCode();
                this.compilePointLightCode();
            };
            if ((((_numLightProbes > 0)) && ((this._combinedLightSources & LightSources.PROBES)))){
                this.compileLightProbeCode();
            };
            this._vertexCode = (this._vertexCode + this._ambientMethod.getVertexCode(this._ambientMethodVO, this._registerCache));
            this._fragmentCode = (this._fragmentCode + this._ambientMethod.getFragmentCode(this._ambientMethodVO, this._registerCache, this._shadedTargetReg));
            if (this._ambientMethodVO.needsNormals){
                this._registerCache.removeFragmentTempUsage(this._normalFragmentReg);
            };
            if (this._ambientMethodVO.needsView){
                this._registerCache.removeFragmentTempUsage(this._viewDirFragmentReg);
            };
            if (this._shadowMethod){
                this._vertexCode = (this._vertexCode + this._shadowMethod.getVertexCode(this._shadowMethodVO, this._registerCache));
                if (this._normalDependencies == 0){
                    shadowReg = this._registerCache.getFreeFragmentVectorTemp();
                    this._registerCache.addFragmentTempUsages(shadowReg, 1);
                } else {
                    shadowReg = this._normalFragmentReg;
                };
                this._diffuseMethod.shadowRegister = shadowReg;
                this._fragmentCode = (this._fragmentCode + this._shadowMethod.getFragmentCode(this._shadowMethodVO, this._registerCache, shadowReg));
            };
            this._fragmentCode = (this._fragmentCode + this._diffuseMethod.getFragmentPostLightingCode(this._diffuseMethodVO, this._registerCache, this._shadedTargetReg));
            if (_alphaPremultiplied){
                this._fragmentCode = (this._fragmentCode + ((((((((((((("add " + this._shadedTargetReg) + ".w, ") + this._shadedTargetReg) + ".w, ") + this._commonsReg) + ".z\n") + "div ") + this._shadedTargetReg) + ".xyz, ") + this._shadedTargetReg) + ".xyz, ") + this._shadedTargetReg) + ".w\n"));
            };
            if (this._diffuseMethodVO.needsNormals){
                this._registerCache.removeFragmentTempUsage(this._normalFragmentReg);
            };
            if (this._diffuseMethodVO.needsView){
                this._registerCache.removeFragmentTempUsage(this._viewDirFragmentReg);
            };
            if (this._usingSpecularMethod){
                this._specularMethod.shadowRegister = shadowReg;
                this._fragmentCode = (this._fragmentCode + this._specularMethod.getFragmentPostLightingCode(this._specularMethodVO, this._registerCache, this._shadedTargetReg));
                if (this._specularMethodVO.needsNormals){
                    this._registerCache.removeFragmentTempUsage(this._normalFragmentReg);
                };
                if (this._specularMethodVO.needsView){
                    this._registerCache.removeFragmentTempUsage(this._viewDirFragmentReg);
                };
            };
        }
        private function initLightRegisters():void{
            var i:uint;
            var len:uint;
            len = this._dirLightRegisters.length;
            i = 0;
            while (i < len) {
                this._dirLightRegisters[i] = this._registerCache.getFreeFragmentConstant();
                if (this._lightDataIndex == -1){
                    this._lightDataIndex = (this._dirLightRegisters[i].index * 4);
                };
                i++;
            };
            len = this._pointLightRegisters.length;
            i = 0;
            while (i < len) {
                this._pointLightRegisters[i] = this._registerCache.getFreeFragmentConstant();
                if (this._lightDataIndex == -1){
                    this._lightDataIndex = (this._pointLightRegisters[i].index * 4);
                };
                i++;
            };
        }
        private function compileDirectionalLightCode():void{
            var diffuseColorReg:ShaderRegisterElement;
            var specularColorReg:ShaderRegisterElement;
            var lightDirReg:ShaderRegisterElement;
            var regIndex:int;
            var addSpec:Boolean = ((this._usingSpecularMethod) && (!(((this._specularLightSources & LightSources.LIGHTS) == 0))));
            var addDiff:Boolean = !(((this._diffuseLightSources & LightSources.LIGHTS) == 0));
            if (!(((addSpec) || (addDiff)))){
                return;
            };
            var i:uint;
            while (i < _numDirectionalLights) {
                var _temp1 = regIndex;
                regIndex = (regIndex + 1);
                lightDirReg = this._dirLightRegisters[_temp1];
                var _temp2 = regIndex;
                regIndex = (regIndex + 1);
                diffuseColorReg = this._dirLightRegisters[_temp2];
                var _temp3 = regIndex;
                regIndex = (regIndex + 1);
                specularColorReg = this._dirLightRegisters[_temp3];
                if (addDiff){
                    this._fragmentCode = (this._fragmentCode + this._diffuseMethod.getFragmentCodePerLight(this._diffuseMethodVO, this._diffuseLightIndex, lightDirReg, diffuseColorReg, this._registerCache));
                    this._diffuseLightIndex++;
                };
                if (addSpec){
                    this._fragmentCode = (this._fragmentCode + this._specularMethod.getFragmentCodePerLight(this._specularMethodVO, this._specularLightIndex, lightDirReg, specularColorReg, this._registerCache));
                    this._specularLightIndex++;
                };
                i++;
            };
        }
        private function compilePointLightCode():void{
            var diffuseColorReg:ShaderRegisterElement;
            var specularColorReg:ShaderRegisterElement;
            var lightPosReg:ShaderRegisterElement;
            var lightDirReg:ShaderRegisterElement;
            var regIndex:int;
            var addSpec:Boolean = ((this._usingSpecularMethod) && (!(((this._specularLightSources & LightSources.LIGHTS) == 0))));
            var addDiff:Boolean = !(((this._diffuseLightSources & LightSources.LIGHTS) == 0));
            if (!(((addSpec) || (addDiff)))){
                return;
            };
            var i:uint;
            while (i < _numPointLights) {
                var _temp1 = regIndex;
                regIndex = (regIndex + 1);
                lightPosReg = this._pointLightRegisters[_temp1];
                var _temp2 = regIndex;
                regIndex = (regIndex + 1);
                diffuseColorReg = this._pointLightRegisters[_temp2];
                var _temp3 = regIndex;
                regIndex = (regIndex + 1);
                specularColorReg = this._pointLightRegisters[_temp3];
                lightDirReg = this._registerCache.getFreeFragmentVectorTemp();
                this._registerCache.addFragmentTempUsages(lightDirReg, 1);
                this._fragmentCode = (this._fragmentCode + ((((((((((((((((((((((((((((((((((((((((((((((((("sub " + lightDirReg) + ", ") + lightPosReg) + ", ") + this._globalPositionVaryingReg) + "\n") + "dp3 ") + lightDirReg) + ".w, ") + lightDirReg) + ".xyz, ") + lightDirReg) + ".xyz\n") + "sqt ") + lightDirReg) + ".w, ") + lightDirReg) + ".w\n") + "sub ") + lightDirReg) + ".w, ") + lightDirReg) + ".w, ") + diffuseColorReg) + ".w\n") + "mul ") + lightDirReg) + ".w, ") + lightDirReg) + ".w, ") + specularColorReg) + ".w\n") + "sat ") + lightDirReg) + ".w, ") + lightDirReg) + ".w\n") + "sub ") + lightDirReg) + ".w, ") + lightPosReg) + ".w, ") + lightDirReg) + ".w\n") + "nrm ") + lightDirReg) + ".xyz, ") + lightDirReg) + ".xyz\t\n"));
                if (this._lightDataIndex == -1){
                    this._lightDataIndex = (lightPosReg.index * 4);
                };
                if (addDiff){
                    this._fragmentCode = (this._fragmentCode + this._diffuseMethod.getFragmentCodePerLight(this._diffuseMethodVO, this._diffuseLightIndex, lightDirReg, diffuseColorReg, this._registerCache));
                    this._diffuseLightIndex++;
                };
                if (addSpec){
                    this._fragmentCode = (this._fragmentCode + this._specularMethod.getFragmentCodePerLight(this._specularMethodVO, this._specularLightIndex, lightDirReg, specularColorReg, this._registerCache));
                    this._specularLightIndex++;
                };
                this._registerCache.removeFragmentTempUsage(lightDirReg);
                i++;
            };
        }
        private function compileLightProbeCode():void{
            var weightReg:String;
            var i:uint;
            var texReg:ShaderRegisterElement;
            var weightComponents:Array = [".x", ".y", ".z", ".w"];
            var weightRegisters:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>();
            var addSpec:Boolean = ((this._usingSpecularMethod) && (!(((this._specularLightSources & LightSources.PROBES) == 0))));
            var addDiff:Boolean = !(((this._diffuseLightSources & LightSources.PROBES) == 0));
            if (!(((addSpec) || (addDiff)))){
                return;
            };
            if (addDiff){
                this._lightProbeDiffuseIndices = new Vector.<uint>();
            };
            if (addSpec){
                this._lightProbeSpecularIndices = new Vector.<uint>();
            };
            i = 0;
            while (i < this._numProbeRegisters) {
                weightRegisters[i] = this._registerCache.getFreeFragmentConstant();
                if (i == 0){
                    this._probeWeightsIndex = (weightRegisters[i].index * 4);
                };
                i++;
            };
            i = 0;
            while (i < _numLightProbes) {
                weightReg = (weightRegisters[Math.floor((i / 4))].toString() + weightComponents[(i % 4)]);
                if (addDiff){
                    texReg = this._registerCache.getFreeTextureReg();
                    this._lightProbeDiffuseIndices[i] = texReg.index;
                    this._fragmentCode = (this._fragmentCode + this._diffuseMethod.getFragmentCodePerProbe(this._diffuseMethodVO, this._diffuseLightIndex, texReg, weightReg, this._registerCache));
                    this._diffuseLightIndex++;
                };
                if (addSpec){
                    texReg = this._registerCache.getFreeTextureReg();
                    this._lightProbeSpecularIndices[i] = texReg.index;
                    this._fragmentCode = (this._fragmentCode + this._specularMethod.getFragmentCodePerProbe(this._specularMethodVO, this._specularLightIndex, texReg, weightReg, this._registerCache));
                    this._specularLightIndex++;
                };
                i++;
            };
        }
        private function compileMethods():void{
            var method:EffectMethodBase;
            var data:MethodVO;
            var numMethods:uint = this._methods.length;
            var i:uint;
            while (i < numMethods) {
                method = this._methods[i].method;
                data = this._methods[i].data;
                this._vertexCode = (this._vertexCode + method.getVertexCode(data, this._registerCache));
                if (data.needsGlobalPos){
                    this._registerCache.removeVertexTempUsage(this._globalPositionVertexReg);
                };
                this._fragmentCode = (this._fragmentCode + method.getFragmentCode(data, this._registerCache, this._shadedTargetReg));
                if (data.needsNormals){
                    this._registerCache.removeFragmentTempUsage(this._normalFragmentReg);
                };
                if (data.needsView){
                    this._registerCache.removeFragmentTempUsage(this._viewDirFragmentReg);
                };
                i++;
            };
            if (this._colorTransformMethod){
                this._vertexCode = (this._vertexCode + this._colorTransformMethod.getVertexCode(this._colorTransformMethodVO, this._registerCache));
                this._fragmentCode = (this._fragmentCode + this._colorTransformMethod.getFragmentCode(this._colorTransformMethodVO, this._registerCache, this._shadedTargetReg));
            };
        }
        private function updateLights(directionalLights:Vector.<DirectionalLight>, pointLights:Vector.<PointLight>, stage3DProxy:Stage3DProxy):void{
            var dirLight:DirectionalLight;
            var pointLight:PointLight;
            var i:uint;
            var k:uint;
            var len:int;
            var dirPos:Vector3D;
            this._ambientLightR = (this._ambientLightG = (this._ambientLightB = 0));
            len = directionalLights.length;
            k = this._lightDataIndex;
            i = 0;
            while (i < len) {
                dirLight = directionalLights[i];
                dirPos = dirLight.sceneDirection;
                this._ambientLightR = (this._ambientLightR + dirLight._ambientR);
                this._ambientLightG = (this._ambientLightG + dirLight._ambientG);
                this._ambientLightB = (this._ambientLightB + dirLight._ambientB);
                var _temp1 = k;
                k = (k + 1);
                var _local10 = _temp1;
                this._fragmentConstantData[_local10] = -(dirPos.x);
                var _temp2 = k;
                k = (k + 1);
                var _local11 = _temp2;
                this._fragmentConstantData[_local11] = -(dirPos.y);
                var _temp3 = k;
                k = (k + 1);
                var _local12 = _temp3;
                this._fragmentConstantData[_local12] = -(dirPos.z);
                var _temp4 = k;
                k = (k + 1);
                var _local13 = _temp4;
                this._fragmentConstantData[_local13] = 1;
                var _temp5 = k;
                k = (k + 1);
                var _local14 = _temp5;
                this._fragmentConstantData[_local14] = dirLight._diffuseR;
                var _temp6 = k;
                k = (k + 1);
                var _local15 = _temp6;
                this._fragmentConstantData[_local15] = dirLight._diffuseG;
                var _temp7 = k;
                k = (k + 1);
                var _local16 = _temp7;
                this._fragmentConstantData[_local16] = dirLight._diffuseB;
                var _temp8 = k;
                k = (k + 1);
                var _local17 = _temp8;
                this._fragmentConstantData[_local17] = 1;
                var _temp9 = k;
                k = (k + 1);
                var _local18 = _temp9;
                this._fragmentConstantData[_local18] = dirLight._specularR;
                var _temp10 = k;
                k = (k + 1);
                var _local19 = _temp10;
                this._fragmentConstantData[_local19] = dirLight._specularG;
                var _temp11 = k;
                k = (k + 1);
                var _local20 = _temp11;
                this._fragmentConstantData[_local20] = dirLight._specularB;
                var _temp12 = k;
                k = (k + 1);
                var _local21 = _temp12;
                this._fragmentConstantData[_local21] = 1;
                i++;
            };
            if (_numDirectionalLights > len){
                i = (k + ((_numDirectionalLights - len) * 12));
                while (k < i) {
                    var _temp13 = k;
                    k = (k + 1);
                    _local10 = _temp13;
                    this._fragmentConstantData[_local10] = 0;
                };
            };
            len = pointLights.length;
            i = 0;
            while (i < len) {
                pointLight = pointLights[i];
                dirPos = pointLight.scenePosition;
                this._ambientLightR = (this._ambientLightR + pointLight._ambientR);
                this._ambientLightG = (this._ambientLightG + pointLight._ambientG);
                this._ambientLightB = (this._ambientLightB + pointLight._ambientB);
                var _temp14 = k;
                k = (k + 1);
                _local10 = _temp14;
                this._fragmentConstantData[_local10] = dirPos.x;
                var _temp15 = k;
                k = (k + 1);
                _local11 = _temp15;
                this._fragmentConstantData[_local11] = dirPos.y;
                var _temp16 = k;
                k = (k + 1);
                _local12 = _temp16;
                this._fragmentConstantData[_local12] = dirPos.z;
                var _temp17 = k;
                k = (k + 1);
                _local13 = _temp17;
                this._fragmentConstantData[_local13] = 1;
                var _temp18 = k;
                k = (k + 1);
                _local14 = _temp18;
                this._fragmentConstantData[_local14] = pointLight._diffuseR;
                var _temp19 = k;
                k = (k + 1);
                _local15 = _temp19;
                this._fragmentConstantData[_local15] = pointLight._diffuseG;
                var _temp20 = k;
                k = (k + 1);
                _local16 = _temp20;
                this._fragmentConstantData[_local16] = pointLight._diffuseB;
                var _temp21 = k;
                k = (k + 1);
                _local17 = _temp21;
                this._fragmentConstantData[_local17] = pointLight._radius;
                var _temp22 = k;
                k = (k + 1);
                _local18 = _temp22;
                this._fragmentConstantData[_local18] = pointLight._specularR;
                var _temp23 = k;
                k = (k + 1);
                _local19 = _temp23;
                this._fragmentConstantData[_local19] = pointLight._specularG;
                var _temp24 = k;
                k = (k + 1);
                _local20 = _temp24;
                this._fragmentConstantData[_local20] = pointLight._specularB;
                var _temp25 = k;
                k = (k + 1);
                _local21 = _temp25;
                this._fragmentConstantData[_local21] = pointLight._fallOffFactor;
                i++;
            };
            if (_numPointLights > len){
                i = (k + ((len - _numPointLights) * 12));
                while (k < i) {
                    this._fragmentConstantData[k] = 0;
                    k++;
                };
            };
        }
        private function updateProbes(lightProbes:Vector.<LightProbe>, weights:Vector.<Number>, stage3DProxy:Stage3DProxy):void{
            var probe:LightProbe;
            var len:int = lightProbes.length;
            var addDiff:Boolean = ((this._diffuseMethod) && (!(((this._diffuseLightSources & LightSources.PROBES) == 0))));
            var addSpec:Boolean = ((this._specularMethod) && (!(((this._specularLightSources & LightSources.PROBES) == 0))));
            if (!(((addDiff) || (addSpec)))){
                return;
            };
            var i:uint;
            while (i < len) {
                probe = lightProbes[i];
                if (addDiff){
                    stage3DProxy.setTextureAt(this._lightProbeDiffuseIndices[i], probe.diffuseMap.getTextureForStage3D(stage3DProxy));
                };
                if (addSpec){
                    stage3DProxy.setTextureAt(this._lightProbeSpecularIndices[i], probe.specularMap.getTextureForStage3D(stage3DProxy));
                };
                i++;
            };
            this._fragmentConstantData[this._probeWeightsIndex] = weights[0];
            this._fragmentConstantData[(this._probeWeightsIndex + 1)] = weights[1];
            this._fragmentConstantData[(this._probeWeightsIndex + 2)] = weights[2];
            this._fragmentConstantData[(this._probeWeightsIndex + 3)] = weights[3];
        }
        private function getMethodSetForMethod(method:EffectMethodBase):MethodSet{
            var len:int = this._methods.length;
            var i:int;
            while (i < len) {
                if (this._methods[i].method == method){
                    return (this._methods[i]);
                };
                i++;
            };
            return (null);
        }
        private function onShaderInvalidated(event:ShadingMethodEvent):void{
            this.invalidateShaderProgram();
        }

    }
}//package away3d.materials.passes 

import away3d.materials.methods.*;

class MethodSet {

    public var method:EffectMethodBase;
    public var data:MethodVO;

    public function MethodSet(method:EffectMethodBase){
        super();
        this.method = method;
        this.data = method.createMethodVO();
    }
}
