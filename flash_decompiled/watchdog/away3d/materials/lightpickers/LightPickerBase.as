package away3d.materials.lightpickers {
    import __AS3__.vec.*;
    import away3d.lights.*;
    import away3d.core.traverse.*;
    import away3d.core.base.*;
    import flash.geom.*;
    import flash.events.*;

    public class LightPickerBase extends EventDispatcher {

        protected var _numPointLights:uint;
        protected var _numDirectionalLights:uint;
        protected var _numLightProbes:uint;
        protected var _allPickedLights:Vector.<LightBase>;
        protected var _pointLights:Vector.<PointLight>;
        protected var _directionalLights:Vector.<DirectionalLight>;
        protected var _lightProbes:Vector.<LightProbe>;
        protected var _lightProbeWeights:Vector.<Number>;
        public var name:String;

        public function get numDirectionalLights():uint{
            return (this._numDirectionalLights);
        }
        public function get numPointLights():uint{
            return (this._numPointLights);
        }
        public function get numLightProbes():uint{
            return (this._numLightProbes);
        }
        public function get pointLights():Vector.<PointLight>{
            return (this._pointLights);
        }
        public function get directionalLights():Vector.<DirectionalLight>{
            return (this._directionalLights);
        }
        public function get lightProbes():Vector.<LightProbe>{
            return (this._lightProbes);
        }
        public function get lightProbeWeights():Vector.<Number>{
            return (this._lightProbeWeights);
        }
        public function get allPickedLights():Vector.<LightBase>{
            return (this._allPickedLights);
        }
        public function collectLights(renderable:IRenderable, entityCollector:EntityCollector):void{
            this.updateProbeWeights(renderable);
        }
        private function updateProbeWeights(renderable:IRenderable):void{
            var lightPos:Vector3D;
            var dx:Number;
            var dy:Number;
            var dz:Number;
            var w:Number;
            var i:int;
            var objectPos:Vector3D = renderable.sourceEntity.scenePosition;
            var rx:Number = objectPos.x;
            var ry:Number = objectPos.y;
            var rz:Number = objectPos.z;
            var total:Number = 0;
            i = 0;
            while (i < this._numLightProbes) {
                lightPos = this._lightProbes[i].scenePosition;
                dx = (rx - lightPos.x);
                dy = (ry - lightPos.y);
                dz = (rz - lightPos.z);
                w = (((dx * dx) + (dy * dy)) + (dz * dz));
                w = (((w > 1E-5)) ? (1 / w) : 50000000);
                this._lightProbeWeights[i] = w;
                total = (total + w);
                i++;
            };
            total = (1 / total);
            i = 0;
            while (i < this._numLightProbes) {
                this._lightProbeWeights[i] = (this._lightProbeWeights[i] * total);
                i++;
            };
        }

    }
}//package away3d.materials.lightpickers 
