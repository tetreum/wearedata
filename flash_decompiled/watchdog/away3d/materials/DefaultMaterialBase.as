package away3d.materials {
    import away3d.materials.passes.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import flash.geom.*;
    import away3d.materials.methods.*;
    import away3d.textures.*;
    import flash.display3D.*;

    public class DefaultMaterialBase extends MaterialBase {

        protected var _screenPass:DefaultScreenPass;
        private var _alphaBlending:Boolean;

        public function DefaultMaterialBase(){
            super();
            addPass((this._screenPass = new DefaultScreenPass(this)));
        }
        public function get alphaThreshold():Number{
            return (this._screenPass.diffuseMethod.alphaThreshold);
        }
        public function set alphaThreshold(value:Number):void{
            this._screenPass.diffuseMethod.alphaThreshold = value;
            _depthPass.alphaThreshold = value;
            _distancePass.alphaThreshold = value;
        }
        override function activateForDepth(stage3DProxy:Stage3DProxy, camera:Camera3D, distanceBased:Boolean=false, textureRatioX:Number=1, textureRatioY:Number=1):void{
            if (distanceBased){
                _distancePass.alphaMask = this._screenPass.diffuseMethod.texture;
            } else {
                _depthPass.alphaMask = this._screenPass.diffuseMethod.texture;
            };
            super.activateForDepth(stage3DProxy, camera, distanceBased, textureRatioX, textureRatioY);
        }
        public function get specularLightSources():uint{
            return (this._screenPass.specularLightSources);
        }
        public function set specularLightSources(value:uint):void{
            this._screenPass.specularLightSources = value;
        }
        public function get diffuseLightSources():uint{
            return (this._screenPass.diffuseLightSources);
        }
        public function set diffuseLightSources(value:uint):void{
            this._screenPass.diffuseLightSources = value;
        }
        public function get colorTransform():ColorTransform{
            return (this._screenPass.colorTransform);
        }
        public function set colorTransform(value:ColorTransform):void{
            this._screenPass.colorTransform = value;
        }
        override public function get requiresBlending():Boolean{
            return (((((super.requiresBlending) || (this._alphaBlending))) || (((this._screenPass.colorTransform) && ((this._screenPass.colorTransform.alphaMultiplier < 1))))));
        }
        public function get ambientMethod():BasicAmbientMethod{
            return (this._screenPass.ambientMethod);
        }
        public function set ambientMethod(value:BasicAmbientMethod):void{
            this._screenPass.ambientMethod = value;
        }
        public function get shadowMethod():ShadowMapMethodBase{
            return (this._screenPass.shadowMethod);
        }
        public function set shadowMethod(value:ShadowMapMethodBase):void{
            this._screenPass.shadowMethod = value;
        }
        public function get diffuseMethod():BasicDiffuseMethod{
            return (this._screenPass.diffuseMethod);
        }
        public function set diffuseMethod(value:BasicDiffuseMethod):void{
            this._screenPass.diffuseMethod = value;
        }
        public function get normalMethod():BasicNormalMethod{
            return (this._screenPass.normalMethod);
        }
        public function set normalMethod(value:BasicNormalMethod):void{
            this._screenPass.normalMethod = value;
        }
        public function get specularMethod():BasicSpecularMethod{
            return (this._screenPass.specularMethod);
        }
        public function set specularMethod(value:BasicSpecularMethod):void{
            this._screenPass.specularMethod = value;
        }
        public function addMethod(method:EffectMethodBase):void{
            this._screenPass.addMethod(method);
        }
        public function get numMethods():int{
            return (this._screenPass.numMethods);
        }
        public function hasMethod(method:EffectMethodBase):Boolean{
            return (this._screenPass.hasMethod(method));
        }
        public function getMethodAt(index:int):EffectMethodBase{
            return (this._screenPass.getMethodAt(index));
        }
        public function addMethodAt(method:EffectMethodBase, index:int):void{
            this._screenPass.addMethodAt(method, index);
        }
        public function removeMethod(method:EffectMethodBase):void{
            this._screenPass.removeMethod(method);
        }
        override public function set mipmap(value:Boolean):void{
            if (_mipmap == value){
                return;
            };
            super.mipmap = value;
        }
        public function get normalMap():Texture2DBase{
            return (this._screenPass.normalMap);
        }
        public function set normalMap(value:Texture2DBase):void{
            this._screenPass.normalMap = value;
        }
        public function get specularMap():Texture2DBase{
            return (this._screenPass.specularMethod.texture);
        }
        public function set specularMap(value:Texture2DBase):void{
            if (this._screenPass.specularMethod){
                this._screenPass.specularMethod.texture = value;
            } else {
                throw (new Error("No specular method was set to assign the specularGlossMap to"));
            };
        }
        public function get gloss():Number{
            return (((this._screenPass.specularMethod) ? this._screenPass.specularMethod.gloss : 0));
        }
        public function set gloss(value:Number):void{
            if (this._screenPass.specularMethod){
                this._screenPass.specularMethod.gloss = value;
            };
        }
        public function get ambient():Number{
            return (this._screenPass.ambientMethod.ambient);
        }
        public function set ambient(value:Number):void{
            this._screenPass.ambientMethod.ambient = value;
        }
        public function get specular():Number{
            return (((this._screenPass.specularMethod) ? this._screenPass.specularMethod.specular : 0));
        }
        public function set specular(value:Number):void{
            if (this._screenPass.specularMethod){
                this._screenPass.specularMethod.specular = value;
            };
        }
        public function get ambientColor():uint{
            return (this._screenPass.ambientMethod.ambientColor);
        }
        public function set ambientColor(value:uint):void{
            this._screenPass.ambientMethod.ambientColor = value;
        }
        public function get specularColor():uint{
            return (this._screenPass.specularMethod.specularColor);
        }
        public function set specularColor(value:uint):void{
            this._screenPass.specularMethod.specularColor = value;
        }
        public function get alphaBlending():Boolean{
            return (this._alphaBlending);
        }
        public function set alphaBlending(value:Boolean):void{
            this._alphaBlending = value;
        }
        override function updateMaterial(context:Context3D):void{
            var len:uint;
            var i:uint;
            if (this._screenPass._passesDirty){
                clearPasses();
                if (this._screenPass._passes){
                    len = this._screenPass._passes.length;
                    i = 0;
                    while (i < len) {
                        addPass(this._screenPass._passes[i]);
                        i++;
                    };
                };
                addPass(this._screenPass);
                this._screenPass._passesDirty = false;
            };
        }

    }
}//package away3d.materials 
