package wd.d3.material {
    import away3d.textures.*;
    import away3d.materials.*;

    public class MonumentMaterial extends MaterialBase {

        private var _screenPass:MonumentPass;

        public function MonumentMaterial(tex:BitmapTexture){
            super();
            bothSides = false;
            addPass((this._screenPass = new MonumentPass(tex)));
            this._screenPass.material = this;
        }
    }
}//package wd.d3.material 
