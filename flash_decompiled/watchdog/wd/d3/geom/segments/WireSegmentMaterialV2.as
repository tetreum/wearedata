package wd.d3.geom.segments {
    import away3d.materials.*;

    public class WireSegmentMaterialV2 extends MaterialBase {

        private var _screenPass:WireSegmentPassV2;

        public function WireSegmentMaterialV2(color:int, thickness:Number=1.25):void{
            super();
            bothSides = false;
            addPass((this._screenPass = new WireSegmentPassV2(color, thickness)));
            this._screenPass.material = this;
        }
    }
}//package wd.d3.geom.segments 
