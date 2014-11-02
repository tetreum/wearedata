package away3d.debug {
    import away3d.core.base.*;
    import __AS3__.vec.*;
    import flash.geom.*;
    import away3d.materials.*;
    import away3d.tools.commands.*;
    import away3d.extrusions.*;
    import away3d.entities.*;
    import away3d.debug.data.*;

    public class Trident extends Mesh {

        public function Trident(length:Number=1000, showLetters:Boolean=true):void{
            super(new Geometry(), null);
            this.buildTrident(Math.abs(((length)==0) ? 10 : length), showLetters);
        }
        private function buildTrident(length:Number, showLetters:Boolean):void{
            var scaleH:Number;
            var scaleW:Number;
            var scl1:Number;
            var scl2:Number;
            var scl3:Number;
            var scl4:Number;
            var cross:Number;
            var base:Number = (length * 0.9);
            var rad:Number = 2.4;
            var offset:Number = (length * 0.025);
            var vectors:Vector.<Vector.<Vector3D>> = new Vector.<Vector.<Vector3D>>();
            var colors:Vector.<uint> = Vector.<uint>([0xFF0000, 0xFF00, 0xFF]);
            var matX:ColorMaterial = new ColorMaterial(0xFF0000);
            var matY:ColorMaterial = new ColorMaterial(0xFF00);
            var matZ:ColorMaterial = new ColorMaterial(0xFF);
            var matOrigin:ColorMaterial = new ColorMaterial(0xCCCCCC);
            var merge:Merge = new Merge(true, true);
            var profileX:Vector.<Vector3D> = new Vector.<Vector3D>();
            profileX[0] = new Vector3D(length, 0, 0);
            profileX[1] = new Vector3D(base, 0, offset);
            profileX[2] = new Vector3D(base, 0, -(rad));
            vectors[0] = Vector.<Vector3D>([new Vector3D(0, 0, 0), new Vector3D(base, 0, 0)]);
            var arrowX:LatheExtrude = new LatheExtrude(matX, profileX, LatheExtrude.X_AXIS, 1, 10);
            var profileY:Vector.<Vector3D> = new Vector.<Vector3D>();
            profileY[0] = new Vector3D(0, length, 0);
            profileY[1] = new Vector3D(offset, base, 0);
            profileY[2] = new Vector3D(-(rad), base, 0);
            vectors[1] = Vector.<Vector3D>([new Vector3D(0, 0, 0), new Vector3D(0, base, 0)]);
            var arrowY:LatheExtrude = new LatheExtrude(matY, profileY, LatheExtrude.Y_AXIS, 1, 10);
            var profileZ:Vector.<Vector3D> = new Vector.<Vector3D>();
            vectors[2] = Vector.<Vector3D>([new Vector3D(0, 0, 0), new Vector3D(0, 0, base)]);
            profileZ[0] = new Vector3D(0, rad, base);
            profileZ[1] = new Vector3D(0, offset, base);
            profileZ[2] = new Vector3D(0, 0, length);
            var arrowZ:LatheExtrude = new LatheExtrude(matZ, profileZ, LatheExtrude.Z_AXIS, 1, 10);
            var profileO:Vector.<Vector3D> = new Vector.<Vector3D>();
            profileO[0] = new Vector3D(0, rad, 0);
            profileO[1] = new Vector3D(-((rad * 0.7)), (rad * 0.7), 0);
            profileO[2] = new Vector3D(-(rad), 0, 0);
            profileO[3] = new Vector3D(-((rad * 0.7)), -((rad * 0.7)), 0);
            profileO[4] = new Vector3D(0, -(rad), 0);
            var origin:LatheExtrude = new LatheExtrude(matOrigin, profileO, LatheExtrude.Y_AXIS, 1, 10);
            merge.applyToMeshes(this, Vector.<Mesh>([arrowX, arrowY, arrowZ, origin]));
            if (showLetters){
                scaleH = (length / 10);
                scaleW = (length / 20);
                scl1 = (scaleW * 1.5);
                scl2 = (scaleH * 3);
                scl3 = (scaleH * 2);
                scl4 = (scaleH * 3.4);
                cross = ((length + scl3) + ((((length + scl4) - (length + scl3)) / 3) * 2));
                vectors[3] = Vector.<Vector3D>([new Vector3D((length + scl2), scl1, 0), new Vector3D((length + scl3), -(scl1), 0), new Vector3D((length + scl3), scl1, 0), new Vector3D((length + scl2), -(scl1), 0)]);
                vectors[4] = Vector.<Vector3D>([new Vector3D((-(scaleW) * 1.2), (length + scl4), 0), new Vector3D(0, cross, 0), new Vector3D((scaleW * 1.2), (length + scl4), 0), new Vector3D(0, cross, 0), new Vector3D(0, cross, 0), new Vector3D(0, (length + scl3), 0)]);
                vectors[5] = Vector.<Vector3D>([new Vector3D(0, scl1, (length + scl2)), new Vector3D(0, scl1, (length + scl3)), new Vector3D(0, -(scl1), (length + scl2)), new Vector3D(0, -(scl1), (length + scl3)), new Vector3D(0, -(scl1), (length + scl3)), new Vector3D(0, scl1, (length + scl2))]);
                colors.push(0xFF0000, 0xFF00, 0xFF);
            };
            this.addChild(new TridentLines(vectors, colors));
        }

    }
}//package away3d.debug 
