package wd.d3.lights {
    import away3d.materials.lightpickers.*;
    import away3d.lights.*;

    public class LightProvider {

        public static var lightPicker:StaticLightPicker;
        public static var lightPickerObjects:StaticLightPicker;
        public static var light0:PointLight;
        public static var light1:PointLight;

        public function LightProvider(){
            super();
            lightPicker = new StaticLightPicker([]);
            light0 = new PointLight();
            lightPicker.lights = [light0];
            lightPickerObjects = new StaticLightPicker([]);
            light1 = new PointLight();
            lightPickerObjects.lights = [light1];
        }
    }
}//package wd.d3.lights 
