package wd.d3.geom.segments {
    import away3d.materials.*;

    public class WireSegmentMaterial extends MaterialBase {

        private var _screenPass:WireSegmentPass;

        public function WireSegmentMaterial(thickness:Number=1.25, useCustomData:Boolean=false):void{
            super();
            bothSides = false;
            addPass((this._screenPass = new WireSegmentPass(thickness, useCustomData, true)));
            this._screenPass.material = this;
        }
    }
}//package wd.d3.geom.segments 
