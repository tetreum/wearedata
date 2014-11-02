package wd.d3.material {
    import away3d.materials.*;
    import away3d.materials.methods.*;
    import away3d.textures.*;
    import wd.core.*;
    import wd.d3.control.*;
    import flash.display.*;
    import wd.d3.lights.*;

    public class MaterialProvider {

        public static var FOG:FogMethod;
        public static var CEL_DIFFUSE:CelDiffuseMethod;
        public static var CEL_SPECULAR:CelSpecularMethod;
        public static var RIM_LIGHT:RimLightMethod;
        public static var white:ColorMaterial;
        public static var black:ColorMaterial;
        public static var yellow:ColorMaterial;
        public static var red:ColorMaterial;
        public static var blue:ColorMaterial;
        public static var uv:TextureMaterial;
        public static var ground:TextureMaterial;
        public static var particle:TextureMaterial;
        public static var BLUE_FOG:FogMethod;
        public static var ANTI_FOG:FogMethod;
        public static var vignette:TextureMaterial;
        public static var cyclo:TextureMaterial;
        public static var river:ColorMaterial;
        public static var parc:ColorMaterial;
        private static var _building_block:BuildingMaterial;
        private static var _building_blocklq:TextureMaterial;
        private static var _monuments:MonumentMaterial;

        public function MaterialProvider(){
            var m:ColorMaterial;
            super();
            new TextureProvider();
            FOG = new FogMethod(0, 1500, Constants.BG_COLOR);
            ANTI_FOG = new FogMethod(3000, 1000, Constants.BG_COLOR);
            BLUE_FOG = new FogMethod(CameraController.MAX_HEIGHT, CameraController.MIN_HEIGHT, Constants.BLUE_COLOR_RGB);
            CEL_DIFFUSE = new CelDiffuseMethod(3);
            CEL_SPECULAR = new CelSpecularMethod(1);
            RIM_LIGHT = new RimLightMethod(Constants.BLUE_COLOR_RGB, 0.75, 4, BlendMode.ADD);
            red = new ColorMaterial(0xFF0000);
            red.bothSides = true;
            white = new ColorMaterial(0xFFFFFF);
            black = new ColorMaterial(0);
            yellow = new ColorMaterial(0xFFCC00);
            yellow.alpha = 0.5;
            yellow.bothSides = true;
            blue = new ColorMaterial(1056972, 1);
            blue.alpha = 0.2;
            blue.bothSides = true;
            var mats:Array = [black, white, yellow, blue, red];
            for each (m in mats) {
                m.addMethod(FOG);
            };
            ground = new TextureMaterial(TextureProvider.ground, false, true);
            ground.specularColor = 0;
            ground.ambientColor = 0;
            ground.specular = 0.85;
            ground.gloss = 1;
            ground.bothSides = true;
            ground.smooth = true;
            ground.lightPicker = LightProvider.lightPicker;
            particle = new TextureMaterial(TextureProvider.particle, true);
            particle.alphaPremultiplied = true;
            particle.blendMode = BlendMode.ADD;
            vignette = new TextureMaterial(TextureProvider.vignette, true, false);
            vignette.alphaPremultiplied = true;
            vignette.alphaBlending = true;
            vignette.blendMode = BlendMode.MULTIPLY;
            cyclo = new TextureMaterial(TextureProvider.cyclo);
            cyclo.alpha = 0.5;
            cyclo.bothSides = true;
            river = new ColorMaterial(1252144, 1);
            river.bothSides = true;
            parc = new ColorMaterial(929570, 1);
            parc.bothSides = true;
        }
        public static function get network_material():MaterialBase{
            var mat:TextureMaterial;
            mat = new TextureMaterial(TextureProvider.network, true, true);
            mat.alpha = 0.8;
            mat.bothSides = true;
            mat.addMethod(new OutlineMethod(0xFFFFFF, 1));
            mat.animateUVs = true;
            return (mat);
        }
        public static function get monuments():MonumentMaterial{
            if (_monuments != null){
                return (_monuments);
            };
            var tex:BitmapTexture = TextureProvider.monument;
            var mat:MonumentMaterial = new MonumentMaterial(tex);
            return ((_monuments = mat));
        }
        public static function get building_blockHQ():BuildingMaterial{
            if (_building_block != null){
                return (_building_block);
            };
            var tex:BitmapTexture = TextureProvider.building_block;
            var mat:BuildingMaterial = new BuildingMaterial(tex);
            return ((_building_block = mat));
        }
        public static function get building_blockLQ():TextureMaterial{
            if (_building_blocklq != null){
                return (_building_blocklq);
            };
            var tex:BitmapTexture = TextureProvider.building_block;
            var mat:TextureMaterial = new TextureMaterial(tex);
            mat.alpha = 0.8;
            mat.smooth = true;
            mat.bothSides = false;
            return ((_building_blocklq = mat));
        }
        public static function get building_side():MaterialBase{
            var mat:TextureMaterial = new TextureMaterial(TextureProvider.building_side, true, true);
            mat.alphaPremultiplied = true;
            mat.alpha = 0.9;
            mat.smooth = true;
            mat.bothSides = true;
            mat.addMethod(FOG);
            return (mat);
        }

    }
}//package wd.d3.material 
