package away3d.materials.lightpickers {
    import away3d.lights.*;
    import __AS3__.vec.*;
    import flash.events.*;

    public class StaticLightPicker extends LightPickerBase {

        private var _lights:Array;

        public function StaticLightPicker(lights:Array){
            super();
            this.lights = lights;
        }
        public function get lights():Array{
            return (this._lights);
        }
        public function set lights(value:Array):void{
            var numPointLights:uint;
            var numDirectionalLights:uint;
            var numLightProbes:uint;
            var light:LightBase;
            this._lights = value;
            _allPickedLights = Vector.<LightBase>(value);
            _pointLights = new Vector.<PointLight>();
            _directionalLights = new Vector.<DirectionalLight>();
            _lightProbes = new Vector.<LightProbe>();
            var len:uint = value.length;
            var i:uint;
            while (i < len) {
                light = value[i];
                if ((light is PointLight)){
                    var _temp1 = numPointLights;
                    numPointLights = (numPointLights + 1);
                    var _local8 = _temp1;
                    _pointLights[_local8] = PointLight(light);
                } else {
                    if ((light is DirectionalLight)){
                        var _temp2 = numDirectionalLights;
                        numDirectionalLights = (numDirectionalLights + 1);
                        _local8 = _temp2;
                        _directionalLights[_local8] = DirectionalLight(light);
                    } else {
                        if ((light is LightProbe)){
                            var _temp3 = numLightProbes;
                            numLightProbes = (numLightProbes + 1);
                            _local8 = _temp3;
                            _lightProbes[_local8] = LightProbe(light);
                        };
                    };
                };
                i++;
            };
            if ((((((_numDirectionalLights == numDirectionalLights)) && ((_numPointLights == numPointLights)))) && ((_numLightProbes == numLightProbes)))){
                return;
            };
            _numDirectionalLights = numDirectionalLights;
            _numPointLights = numPointLights;
            _numLightProbes = numLightProbes;
            _lightProbeWeights = new Vector.<Number>((Math.ceil((numLightProbes / 4)) * 4), true);
            dispatchEvent(new Event(Event.CHANGE));
        }

    }
}//package away3d.materials.lightpickers 
