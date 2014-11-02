package wd.d3.geom.monuments {
    import flash.geom.*;
    import wd.d3.geom.objects.networks.*;
    import __AS3__.vec.*;
    import wd.utils.*;
    import away3d.containers.*;

    public class BerlinWall extends ObjectContainer3D {

        private var mat:NetworkMaterial;
        private var net:NetworkSet;

        public function BerlinWall(){
            var p:Point;
            super();
            var coords:Array = [52.558685, 13.3987970000001, 52.554741, 13.398636, 52.551567, 13.399871, 52.542053, 13.404409, 52.53804, 13.395843, 52.537392, 13.3935759999999, 52.535915, 13.391156, 52.534813, 13.389595, 52.53381, 13.388544, 52.532616, 13.3884399999999, 52.532299, 13.3888480000001, 52.533321, 13.386254, 52.53495, 13.3836200000001, 52.535767, 13.38229, 52.536255, 13.381044, 52.539921, 13.379306, 52.532875, 13.3698910000001, 52.53162, 13.371074, 52.521568, 13.377514, 52.521015, 13.377755, 52.507137, 13.382614, 52.502914, 13.384316, 52.502556, 13.38477, 52.503269, 13.420935, 52.505016, 13.422194, 52.508289, 13.434562, 52.507011, 13.4364410000001, 52.505241, 13.439118, 52.504108, 13.4420259999999, 52.502697, 13.446175];
            this.net = new NetworkSet(0.5, (this.mat = new NetworkMaterial(0xFFFFFF, 0.5)));
            var vecs:Vector.<Vector3D> = new Vector.<Vector3D>();
            var i:int;
            while (i < coords.length) {
                p = Locator.REMAP(coords[(i + 1)], coords[i]);
                vecs.push(new Vector3D(p.x, 0, p.y));
                i = (i + 2);
            };
            var j:int;
            while (j < (vecs.length - 1)) {
                this.net.addSegment(vecs[j], vecs[(j + 1)]);
                vecs[j].x = (vecs[j].x + 5);
                vecs[(j + 1)].x = (vecs[(j + 1)].x + 5);
                this.net.addSegment(vecs[j], vecs[(j + 1)]);
                vecs[j].x = (vecs[j].x + 5);
                vecs[(j + 1)].x = (vecs[(j + 1)].x + 5);
                this.net.addSegment(vecs[j], vecs[(j + 1)]);
                vecs[j].x = (vecs[j].x + 5);
                vecs[(j + 1)].x = (vecs[(j + 1)].x + 5);
                this.net.addSegment(vecs[j], vecs[(j + 1)]);
                vecs[j].x = (vecs[j].x + 5);
                vecs[(j + 1)].x = (vecs[(j + 1)].x + 5);
                this.net.addSegment(vecs[j], vecs[(j + 1)]);
                vecs[j].x = (vecs[j].x - 20);
                vecs[(j + 1)].x = (vecs[(j + 1)].x - 20);
                j++;
            };
            addChild(this.net);
        }
    }
}//package wd.d3.geom.monuments 
