package away3d.debug.data {
    import __AS3__.vec.*;
    import flash.geom.*;
    import away3d.primitives.*;
    import away3d.entities.*;

    public class TridentLines extends SegmentSet {

        public function TridentLines(vectors:Vector.<Vector.<Vector3D>>, colors:Vector.<uint>):void{
            super();
            this.build(vectors, colors);
        }
        private function build(vectors:Vector.<Vector.<Vector3D>>, colors:Vector.<uint>):void{
            var letter:Vector.<Vector3D>;
            var v0:Vector3D;
            var v1:Vector3D;
            var color:uint;
            var j:uint;
            var i:uint;
            while (i < vectors.length) {
                color = colors[i];
                letter = vectors[i];
                j = 0;
                while (j < letter.length) {
                    v0 = letter[j];
                    v1 = letter[(j + 1)];
                    addSegment(new LineSegment(v0, v1, color, color, 1));
                    j = (j + 2);
                };
                i++;
            };
        }

    }
}//package away3d.debug.data 
