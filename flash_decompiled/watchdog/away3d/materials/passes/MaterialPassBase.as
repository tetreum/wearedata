package away3d.materials.passes {
    import __AS3__.vec.*;
    import flash.display3D.*;
    import away3d.materials.*;
    import away3d.animators.*;
    import away3d.core.managers.*;
    import away3d.core.base.*;
    import away3d.cameras.*;
    import away3d.materials.lightpickers.*;
    import away3d.errors.*;
    import flash.events.*;
    import away3d.debug.*;
    import flash.display3D.textures.*;
    import flash.geom.*;

    public class MaterialPassBase extends EventDispatcher {

        private static var _previousUsedStreams:Vector.<int> = Vector.<int>([0, 0, 0, 0, 0, 0, 0, 0]);
        private static var _previousUsedTexs:Vector.<int> = Vector.<int>([0, 0, 0, 0, 0, 0, 0, 0]);
        private static var _rttData:Vector.<Number>;

        protected var _material:MaterialBase;
        protected var _animationSet:IAnimationSet;
        var _program3Ds:Vector.<Program3D>;
        var _program3Dids:Vector.<int>;
        private var _context3Ds:Vector.<Context3D>;
        protected var _numUsedStreams:uint;
        protected var _numUsedTextures:uint;
        protected var _numUsedVertexConstants:uint;
        protected var _numUsedFragmentConstants:uint;
        protected var _smooth:Boolean = true;
        protected var _repeat:Boolean = false;
        protected var _mipmap:Boolean = true;
        protected var _depthCompareMode:String = "less";
        private var _bothSides:Boolean;
        protected var _numPointLights:uint;
        protected var _numDirectionalLights:uint;
        protected var _numLightProbes:uint;
        protected var _animatableAttributes:Array;
        protected var _animationTargetRegisters:Array;
        protected var _defaultCulling:String = "back";
        private var _renderToTexture:Boolean;
        private var _oldTarget:TextureBase;
        private var _oldSurface:int;
        private var _oldDepthStencil:Boolean;
        private var _oldRect:Rectangle;
        protected var _alphaPremultiplied:Boolean;

        public function MaterialPassBase(renderToTexture:Boolean=false){
            this._program3Ds = new Vector.<Program3D>(8);
            this._program3Dids = Vector.<int>([-1, -1, -1, -1, -1, -1, -1, -1]);
            this._context3Ds = new Vector.<Context3D>(8);
            this._animatableAttributes = ["va0"];
            this._animationTargetRegisters = ["vt0"];
            super();
            this._renderToTexture = renderToTexture;
            this._numUsedStreams = 1;
            this._numUsedVertexConstants = 5;
            if (!(_rttData)){
                _rttData = new <Number>[1, 1, 1, 1];
            };
        }
        public function get material():MaterialBase{
            return (this._material);
        }
        public function set material(value:MaterialBase):void{
            this._material = value;
        }
        public function get mipmap():Boolean{
            return (this._mipmap);
        }
        public function set mipmap(value:Boolean):void{
            if (this._mipmap == value){
                return;
            };
            this._mipmap = value;
            this.invalidateShaderProgram();
        }
        public function get smooth():Boolean{
            return (this._smooth);
        }
        public function set smooth(value:Boolean):void{
            if (this._smooth == value){
                return;
            };
            this._smooth = value;
            this.invalidateShaderProgram();
        }
        public function get repeat():Boolean{
            return (this._repeat);
        }
        public function set repeat(value:Boolean):void{
            if (this._repeat == value){
                return;
            };
            this._repeat = value;
            this.invalidateShaderProgram();
        }
        public function get bothSides():Boolean{
            return (this._bothSides);
        }
        public function set bothSides(value:Boolean):void{
            this._bothSides = value;
        }
        public function get depthCompareMode():String{
            return (this._depthCompareMode);
        }
        public function set depthCompareMode(value:String):void{
            this._depthCompareMode = value;
        }
        public function get animationSet():IAnimationSet{
            return (this._animationSet);
        }
        public function set animationSet(value:IAnimationSet):void{
            if (this._animationSet == value){
                return;
            };
            this._animationSet = value;
            this.invalidateShaderProgram();
        }
        public function get renderToTexture():Boolean{
            return (this._renderToTexture);
        }
        public function dispose():void{
            var i:uint;
            while (i < 8) {
                if (this._program3Ds[i]){
                    AGALProgram3DCache.getInstanceFromIndex(i).freeProgram3D(this._program3Dids[i]);
                };
                i++;
            };
        }
        public function get numUsedStreams():uint{
            return (this._numUsedStreams);
        }
        public function get numUsedVertexConstants():uint{
            return (this._numUsedVertexConstants);
        }
        function updateAnimationState(renderable:IRenderable, stage3DProxy:Stage3DProxy):void{
            renderable.animator.setRenderState(stage3DProxy, renderable, this._numUsedVertexConstants, this._numUsedStreams);
        }
        function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, lightPicker:LightPickerBase):void{
            var context:Context3D = stage3DProxy._context3D;
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, renderable.getModelViewProjectionUnsafe(), true);
            stage3DProxy.setSimpleVertexBuffer(0, renderable.getVertexBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, renderable.vertexBufferOffset);
            context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
        }
        function getVertexCode(code:String):String{
            throw (new AbstractMethodError());
        }
        function getFragmentCode():String{
            throw (new AbstractMethodError());
        }
        function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, textureRatioX:Number, textureRatioY:Number):void{
            var i:uint;
            var contextIndex:int = stage3DProxy._stage3DIndex;
            var context:Context3D = stage3DProxy._context3D;
            if (((!((this._context3Ds[contextIndex] == context))) || (!(this._program3Ds[contextIndex])))){
                this._context3Ds[contextIndex] = context;
                this.updateProgram(stage3DProxy);
                dispatchEvent(new Event(Event.CHANGE));
            };
            var prevUsed:int = _previousUsedStreams[contextIndex];
            i = this._numUsedStreams;
            while (i < prevUsed) {
                stage3DProxy.setSimpleVertexBuffer(i, null, null, 0);
                i++;
            };
            prevUsed = _previousUsedTexs[contextIndex];
            i = this._numUsedTextures;
            while (i < prevUsed) {
                stage3DProxy.setTextureAt(i, null);
                i++;
            };
            if (((this._animationSet) && (!(this._animationSet.usesCPU)))){
                this._animationSet.activate(stage3DProxy, this);
            };
            stage3DProxy.setProgram(this._program3Ds[contextIndex]);
            context.setCulling(((this._bothSides) ? Context3DTriangleFace.NONE : this._defaultCulling));
            if (this._renderToTexture){
                _rttData[0] = 1;
                _rttData[1] = 1;
                this._oldTarget = stage3DProxy.renderTarget;
                this._oldSurface = stage3DProxy.renderSurfaceSelector;
                this._oldDepthStencil = stage3DProxy.enableDepthAndStencil;
                this._oldRect = stage3DProxy.scissorRect;
            } else {
                _rttData[0] = textureRatioX;
                _rttData[1] = textureRatioY;
                stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, _rttData, 1);
            };
            context.setDepthTest(true, this._depthCompareMode);
        }
        function deactivate(stage3DProxy:Stage3DProxy):void{
            var index:uint = stage3DProxy._stage3DIndex;
            _previousUsedStreams[index] = this._numUsedStreams;
            _previousUsedTexs[index] = this._numUsedTextures;
            if (((this._animationSet) && (!(this._animationSet.usesCPU)))){
                this._animationSet.deactivate(stage3DProxy, this);
            };
            if (this._renderToTexture){
                stage3DProxy.setRenderTarget(this._oldTarget, this._oldDepthStencil, this._oldSurface);
                stage3DProxy.scissorRect = this._oldRect;
            };
            stage3DProxy._context3D.setDepthTest(true, Context3DCompareMode.LESS);
        }
        function invalidateShaderProgram(updateMaterial:Boolean=true):void{
            var i:uint;
            while (i < 8) {
                this._program3Ds[i] = null;
                i++;
            };
            if (((this._material) && (updateMaterial))){
                this._material.invalidatePasses(this);
            };
        }
        function updateProgram(stage3DProxy:Stage3DProxy):void{
            var len:uint;
            var i:uint;
            var animatorCode:String = "";
            if (((this._animationSet) && (!(this._animationSet.usesCPU)))){
                animatorCode = this._animationSet.getAGALVertexCode(this, this._animatableAttributes, this._animationTargetRegisters);
            } else {
                len = this._animatableAttributes.length;
                i = 0;
                while (i < len) {
                    animatorCode = (animatorCode + (((("mov " + this._animationTargetRegisters[i]) + ", ") + this._animatableAttributes[i]) + "\n"));
                    i++;
                };
            };
            var vertexCode:String = this.getVertexCode(animatorCode);
            var fragmentCode:String = this.getFragmentCode();
            if (Debug.active){
                trace("Compiling AGAL Code:");
                trace("--------------------");
                trace(vertexCode);
                trace("--------------------");
                trace(fragmentCode);
            };
            AGALProgram3DCache.getInstance(stage3DProxy).setProgram3D(this, vertexCode, fragmentCode);
        }
        function get numPointLights():uint{
            return (this._numPointLights);
        }
        function set numPointLights(value:uint):void{
            this._numPointLights = value;
        }
        function get numDirectionalLights():uint{
            return (this._numDirectionalLights);
        }
        function set numDirectionalLights(value:uint):void{
            this._numDirectionalLights = value;
        }
        function set numLightProbes(value:uint):void{
            this._numLightProbes = value;
        }
        public function get alphaPremultiplied():Boolean{
            return (this._alphaPremultiplied);
        }
        public function set alphaPremultiplied(value:Boolean):void{
            this._alphaPremultiplied = value;
        }

    }
}//package away3d.materials.passes 
