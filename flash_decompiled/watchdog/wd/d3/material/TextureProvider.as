package wd.d3.material {
    import away3d.textures.*;
    import flash.display.*;
    import flash.geom.*;

    public class TextureProvider {

        private static var ground_bd:BitmapData;
        public static var ground:BitmapTexture;
        private static var particleSrc:Class = TextureProvider_particleSrc;
        public static var particle:BitmapTexture = new BitmapTexture(new particleSrc().bitmapData);
        private static var vignetteSrc:Class = TextureProvider_vignetteSrc;
        public static var vignette:BitmapTexture = new BitmapTexture(new vignetteSrc().bitmapData);
        private static var building_block_bd:BitmapData;
        public static var building_block:BitmapTexture;
        private static var cyclo_bd:BitmapData;
        public static var cyclo:BitmapTexture;
        private static var building_side_bd:BitmapData;
        public static var building_side:BitmapTexture;
        private static var building_roof_bd:BitmapData;
        public static var building_roof:BitmapTexture;
        private static var network_bd:BitmapData;
        public static var network:BitmapTexture;
        private static var monument_bd:BitmapData;
        public static var monument:BitmapTexture;

        public function TextureProvider(){
            super();
            var top:uint;
            var topAlpha:uint = 204;
            var bootom:uint = 170;
            var bottomAlpha:uint = 170;
            var sh:Shape = new Shape();
            var m:Matrix = new Matrix();
            m.createGradientBox(128, 128, (Math.PI / 2));
            sh.graphics.beginGradientFill(GradientType.LINEAR, [0, 0xAAAAAA, 0xAAAAAA, 0], [0.5, 0.5, 0.8, 0], [0, 128, 254, 0xFF], m);
            sh.graphics.drawRect(0, 0, 128, 128);
            building_block_bd = new BitmapData(128, 128, true, 0);
            building_block_bd.draw(sh);
            building_block = new BitmapTexture(building_block_bd);
            monument_bd = new BitmapData(16, 16, true, 1440603613);
            monument = new BitmapTexture(monument_bd);
            ground_bd = new BitmapData(32, 32, false, 0x101010);
            ground_bd.fillRect(new Rectangle(8, 8, 16, 16), 0x303030);
            ground = new BitmapTexture(ground_bd);
            cyclo_bd = new BitmapData(2, 2, true, ((((topAlpha << 24) | (bootom << 16)) | (bootom << 8)) | bootom));
            cyclo_bd.setPixel(0, 0, ((((bottomAlpha << 24) | (top << 16)) | (top << 8)) | top));
            cyclo_bd.setPixel(1, 0, ((((bottomAlpha << 24) | (top << 16)) | (top << 8)) | top));
            cyclo = new BitmapTexture(cyclo_bd);
        }
    }
}//package wd.d3.material 
