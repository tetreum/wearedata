package wd.d3.geom.segments {
    import away3d.materials.*;

    public class WireSegmentMaterialBuilding extends MaterialBase {

        private var _screenPass:WireSegmentPassbuilding2;

        public function WireSegmentMaterialBuilding(color:int, thickness:Number=1.25, sint:Boolean=false):void{
            super();
            bothSides = false;
            addPass((this._screenPass = new WireSegmentPassbuilding2(color, thickness, sint)));
            this._screenPass.material = this;
        }
    }
}//package wd.d3.geom.segments 
