package away3d.materials {
    import __AS3__.vec.*;
    import away3d.core.base.*;
    import away3d.materials.passes.*;
    import away3d.library.assets.*;
    import away3d.materials.lightpickers.*;
    import flash.events.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import flash.display3D.*;
    import away3d.core.traverse.*;
    import flash.display.*;
    import away3d.animators.*;

    public class MaterialBase extends NamedAssetBase implements IAsset {

        private static var MATERIAL_ID_COUNT:uint = 0;

        public var extra:Object;
        var _classification:String;
        var _uniqueId:uint;
        var _renderOrderId:int;
        var _name:String = "material";
        private var _bothSides:Boolean;
        private var _animationSet:IAnimationSet;
        private var _owners:Vector.<IMaterialOwner>;
        private var _alphaPremultiplied:Boolean;
        private var _requiresBlending:Boolean;
        private var _blendMode:String = "normal";
        private var _srcBlend:String = "sourceAlpha";
        private var _destBlend:String = "oneMinusSourceAlpha";
        protected var _numPasses:uint;
        protected var _passes:Vector.<MaterialPassBase>;
        protected var _mipmap:Boolean = true;
        protected var _smooth:Boolean = true;
        protected var _repeat:Boolean;
        protected var _depthCompareMode:String = "less";
        protected var _depthPass:DepthMapPass;
        protected var _distancePass:DistanceMapPass;
        private var _lightPicker:LightPickerBase;
        private var _distanceBasedDepthRender:Boolean;

        public function MaterialBase(){
            super();
            this._owners = new Vector.<IMaterialOwner>();
            this._passes = new Vector.<MaterialPassBase>();
            this._depthPass = new DepthMapPass();
            this._distancePass = new DistanceMapPass();
            this.alphaPremultiplied = true;
            this._uniqueId = MATERIAL_ID_COUNT++;
        }
        public function get assetType():String{
            return (AssetType.MATERIAL);
        }
        public function get lightPicker():LightPickerBase{
            return (this._lightPicker);
        }
        public function set lightPicker(value:LightPickerBase):void{
            if (value != this._lightPicker){
                if (this._lightPicker){
                    this._lightPicker.removeEventListener(Event.CHANGE, this.onLightsChange);
                };
                this._lightPicker = value;
                if (this._lightPicker){
                    this._lightPicker.addEventListener(Event.CHANGE, this.onLightsChange);
                };
                this.invalidatePasses(null);
            };
        }
        private function onLightsChange(event:Event):void{
            var pass:MaterialPassBase;
            var i:uint;
            while (i < this._numPasses) {
                pass = this._passes[i];
                pass.numPointLights = this._lightPicker.numPointLights;
                pass.numDirectionalLights = this._lightPicker.numDirectionalLights;
                pass.numLightProbes = this._lightPicker.numLightProbes;
                i++;
            };
        }
        public function get mipmap():Boolean{
            return (this._mipmap);
        }
        public function set mipmap(value:Boolean):void{
            this._mipmap = value;
            var i:int;
            while (i < this._numPasses) {
                this._passes[i].mipmap = value;
                i++;
            };
        }
        public function get smooth():Boolean{
            return (this._smooth);
        }
        public function set smooth(value:Boolean):void{
            this._smooth = value;
            var i:int;
            while (i < this._numPasses) {
                this._passes[i].smooth = value;
                i++;
            };
        }
        public function get depthCompareMode():String{
            return (this._depthCompareMode);
        }
        public function set depthCompareMode(value:String):void{
            this._depthCompareMode = value;
        }
        public function get repeat():Boolean{
            return (this._repeat);
        }
        public function set repeat(value:Boolean):void{
            this._repeat = value;
            var i:int;
            while (i < this._numPasses) {
                this._passes[i].repeat = value;
                i++;
            };
        }
        public function dispose():void{
            var i:uint;
            i = 0;
            while (i < this._numPasses) {
                this._passes[i].dispose();
                i++;
            };
            this._depthPass.dispose();
            this._distancePass.dispose();
            if (this._lightPicker){
                this._lightPicker.removeEventListener(Event.CHANGE, this.onLightsChange);
            };
        }
        public function get bothSides():Boolean{
            return (this._bothSides);
        }
        public function set bothSides(value:Boolean):void{
            this._bothSides = value;
            var i:int;
            while (i < this._numPasses) {
                this._passes[i].bothSides = value;
                i++;
            };
            this._depthPass.bothSides = value;
            this._distancePass.bothSides = value;
        }
        public function get blendMode():String{
            return (this._blendMode);
        }
        public function set blendMode(value:String):void{
            this._blendMode = value;
            this.updateBlendFactors();
        }
        public function get alphaPremultiplied():Boolean{
            return (this._alphaPremultiplied);
        }
        public function set alphaPremultiplied(value:Boolean):void{
            this._alphaPremultiplied = value;
            var i:int;
            while (i < this._numPasses) {
                this._passes[i].alphaPremultiplied = value;
                i++;
            };
        }
        public function get requiresBlending():Boolean{
            return (this._requiresBlending);
        }
        public function get uniqueId():uint{
            return (this._uniqueId);
        }
        override public function get name():String{
            return (this._name);
        }
        override public function set name(value:String):void{
            this._name = value;
        }
        function get numPasses():uint{
            return (this._numPasses);
        }
        function activateForDepth(stage3DProxy:Stage3DProxy, camera:Camera3D, distanceBased:Boolean=false, textureRatioX:Number=1, textureRatioY:Number=1):void{
            this._distanceBasedDepthRender = distanceBased;
            if (distanceBased){
                this._distancePass.activate(stage3DProxy, camera, textureRatioX, textureRatioY);
            } else {
                this._depthPass.activate(stage3DProxy, camera, textureRatioX, textureRatioY);
            };
        }
        function deactivateForDepth(stage3DProxy:Stage3DProxy):void{
            if (this._distanceBasedDepthRender){
                this._distancePass.deactivate(stage3DProxy);
            } else {
                this._depthPass.deactivate(stage3DProxy);
            };
        }
        function renderDepth(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void{
            if (this._distanceBasedDepthRender){
                if (renderable.animator){
                    this._distancePass.updateAnimationState(renderable, stage3DProxy);
                };
                this._distancePass.render(renderable, stage3DProxy, camera, this._lightPicker);
            } else {
                if (renderable.animator){
                    this._depthPass.updateAnimationState(renderable, stage3DProxy);
                };
                this._depthPass.render(renderable, stage3DProxy, camera, this._lightPicker);
            };
        }
        function passRendersToTexture(index:uint):Boolean{
            return (this._passes[index].renderToTexture);
        }
        function activatePass(index:uint, stage3DProxy:Stage3DProxy, camera:Camera3D, textureRatioX:Number, textureRatioY:Number):void{
            var context:Context3D;
            if (index == (this._numPasses - 1)){
                context = stage3DProxy._context3D;
                if (this.requiresBlending){
                    context.setBlendFactors(this._srcBlend, this._destBlend);
                    context.setDepthTest(false, this._depthCompareMode);
                } else {
                    context.setDepthTest(true, this._depthCompareMode);
                };
            };
            this._passes[index].activate(stage3DProxy, camera, textureRatioX, textureRatioY);
        }
        function deactivatePass(index:uint, stage3DProxy:Stage3DProxy):void{
            this._passes[index].deactivate(stage3DProxy);
        }
        function renderPass(index:uint, renderable:IRenderable, stage3DProxy:Stage3DProxy, entityCollector:EntityCollector):void{
            if (this._lightPicker){
                this._lightPicker.collectLights(renderable, entityCollector);
            };
            var pass:MaterialPassBase = this._passes[index];
            if (renderable.animator){
                pass.updateAnimationState(renderable, stage3DProxy);
            };
            pass.render(renderable, stage3DProxy, entityCollector.camera, this._lightPicker);
        }
        function addOwner(owner:IMaterialOwner):void{
            var i:int;
            this._owners.push(owner);
            if (owner.animator){
                if (((this._animationSet) && (!((owner.animator.animationSet == this._animationSet))))){
                    throw (new Error("A Material instance cannot be shared across renderables with different animator libraries"));
                };
                this._animationSet = owner.animator.animationSet;
                i = 0;
                while (i < this._numPasses) {
                    this._passes[i].animationSet = this._animationSet;
                    i++;
                };
                this._depthPass.animationSet = this._animationSet;
                this._distancePass.animationSet = this._animationSet;
                this.invalidatePasses(null);
            };
        }
        function removeOwner(owner:IMaterialOwner):void{
            var i:int;
            this._owners.splice(this._owners.indexOf(owner), 1);
            if (this._owners.length == 0){
                this._animationSet = null;
                i = 0;
                while (i < this._numPasses) {
                    this._passes[i].animationSet = this._animationSet;
                    i++;
                };
                this._depthPass.animationSet = this._animationSet;
                this._distancePass.animationSet = this._animationSet;
                this.invalidatePasses(null);
            };
        }
        function get owners():Vector.<IMaterialOwner>{
            return (this._owners);
        }
        function updateMaterial(context:Context3D):void{
        }
        function deactivate(stage3DProxy:Stage3DProxy):void{
            this._passes[(this._numPasses - 1)].deactivate(stage3DProxy);
        }
        function invalidatePasses(triggerPass:MaterialPassBase):void{
            var owner:IMaterialOwner;
            this._depthPass.invalidateShaderProgram();
            this._distancePass.invalidateShaderProgram();
            if (this._animationSet){
                this._animationSet.resetGPUCompatibility();
                for each (owner in this._owners) {
                    if (owner.animator){
                        owner.animator.testGPUCompatibility(this._depthPass);
                        owner.animator.testGPUCompatibility(this._distancePass);
                    };
                };
            };
            var i:int;
            while (i < this._numPasses) {
                if (this._passes[i] != triggerPass){
                    this._passes[i].invalidateShaderProgram(false);
                };
                if (this._animationSet){
                    for each (owner in this._owners) {
                        if (owner.animator){
                            owner.animator.testGPUCompatibility(this._passes[i]);
                        };
                    };
                };
                i++;
            };
        }
        protected function clearPasses():void{
            var i:int;
            while (i < this._numPasses) {
                this._passes[i].removeEventListener(Event.CHANGE, this.onPassChange);
                i++;
            };
            this._passes.length = 0;
            this._numPasses = 0;
        }
        protected function addPass(pass:MaterialPassBase):void{
            var _local2 = this._numPasses++;
            this._passes[_local2] = pass;
            pass.animationSet = this._animationSet;
            pass.alphaPremultiplied = this._alphaPremultiplied;
            pass.mipmap = this._mipmap;
            pass.smooth = this._smooth;
            pass.repeat = this._repeat;
            pass.numPointLights = ((this._lightPicker) ? this._lightPicker.numPointLights : 0);
            pass.numDirectionalLights = ((this._lightPicker) ? this._lightPicker.numDirectionalLights : 0);
            pass.numLightProbes = ((this._lightPicker) ? this._lightPicker.numLightProbes : 0);
            pass.addEventListener(Event.CHANGE, this.onPassChange);
            this.calculateRenderId();
            this.invalidatePasses(null);
        }
        private function updateBlendFactors():void{
            switch (this._blendMode){
                case BlendMode.NORMAL:
                case BlendMode.LAYER:
                    this._srcBlend = Context3DBlendFactor.SOURCE_ALPHA;
                    this._destBlend = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
                    this._requiresBlending = false;
                    break;
                case BlendMode.MULTIPLY:
                    this._srcBlend = Context3DBlendFactor.ZERO;
                    this._destBlend = Context3DBlendFactor.SOURCE_COLOR;
                    this._requiresBlending = true;
                    break;
                case BlendMode.ADD:
                    this._srcBlend = Context3DBlendFactor.SOURCE_ALPHA;
                    this._destBlend = Context3DBlendFactor.ONE;
                    this._requiresBlending = true;
                    break;
                case BlendMode.ALPHA:
                    this._srcBlend = Context3DBlendFactor.ZERO;
                    this._destBlend = Context3DBlendFactor.SOURCE_ALPHA;
                    this._requiresBlending = true;
                    break;
                default:
                    throw (new ArgumentError("Unsupported blend mode!"));
            };
        }
        private function calculateRenderId():void{
        }
        private function onPassChange(event:Event):void{
            var ids:Vector.<int>;
            var len:int;
            var j:int;
            var mult:Number = 1;
            this._renderOrderId = 0;
            var i:int;
            while (i < this._numPasses) {
                ids = this._passes[i]._program3Dids;
                len = ids.length;
                j = 0;
                while (j < len) {
                    if (ids[j] != -1){
                        this._renderOrderId = (this._renderOrderId + (mult * ids[j]));
                        j = len;
                    };
                    j++;
                };
                mult = (mult * 1000);
                i++;
            };
        }

    }
}//package away3d.materials 
