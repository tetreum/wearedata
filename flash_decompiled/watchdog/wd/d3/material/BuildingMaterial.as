package wd.d3.material {
    import away3d.textures.*;
    import away3d.materials.*;

    public class BuildingMaterial extends MaterialBase {

        private var _screenPass:BuildingPass2;

        public function BuildingMaterial(tex:BitmapTexture){
            super();
            bothSides = false;
            addPass((this._screenPass = new BuildingPass2(tex)));
            this._screenPass.material = this;
        }
        public function doHide():void{
            this._screenPass.doHide();
        }
        public function doWave(_x:Number, _y:Number):void{
            this._screenPass.doWave(_x, _y);
        }

    }
}//package wd.d3.material 
