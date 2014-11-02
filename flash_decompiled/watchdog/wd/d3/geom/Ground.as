package wd.d3.geom {
    import away3d.core.base.*;
    import wd.utils.*;
    import away3d.primitives.*;
    import flash.geom.*;
    import away3d.entities.*;
    import wd.d3.material.*;
    import away3d.containers.*;

    public class Ground extends ObjectContainer3D {

        public function Ground(groundCells:int=3){
            var j:int;
            var sg:SubGeometry;
            super();
            var ww:Number = Locator.WORLD_RECT.width;
            var wh:Number = Locator.WORLD_RECT.height;
            var w:Number = (ww / groundCells);
            var h:Number = (wh / groundCells);
            var plane:SubGeometry = new PlaneGeometry(w, h, 1, 1).subGeometries[0];
            var geom:Geometry = new Geometry();
            var m:Matrix3D = new Matrix3D();
            var i:int;
            while (i < groundCells) {
                j = 0;
                while (j < groundCells) {
                    sg = plane.clone();
                    m.identity();
                    m.appendTranslation(((ww * 0.5) - (i * w)), 0, ((wh * 0.5) - (h * j)));
                    sg.applyTransformation(m);
                    geom.addSubGeometry(sg);
                    j++;
                };
                i++;
            };
            var s:Number = 10000;
            var grid:Mesh = new Mesh(geom, MaterialProvider.ground);
            grid.geometry.scaleUV(s, s);
            addChild(grid);
        }
    }
}//package wd.d3.geom 
