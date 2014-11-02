package away3d.materials {
    import away3d.materials.passes.*;

    public class SegmentMaterial extends MaterialBase {

        private var _screenPass:SegmentPass;

        public function SegmentMaterial(thickness:Number=1.25){
            super();
            bothSides = true;
            addPass((this._screenPass = new SegmentPass(thickness)));
            this._screenPass.material = this;
        }
    }
}//package away3d.materials 
