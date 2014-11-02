package wd.d3.geom.objects.linker {
    import flash.geom.*;
    import wd.d3.*;
    import wd.d3.geom.objects.networks.*;

    public class Bind {

        public var point:Point;
        public var vector:Vector3D;

        public function Bind(point:Point, vector:Vector3D){
            super();
            this.vector = vector;
            this.point = point;
        }
        public function reset(net:NetworkSet):void{
            var v:Vector3D = Simulation.instance.view.unproject(this.point.x, this.point.y);
            net.addSegment(v, this.vector);
        }

    }
}//package wd.d3.geom.objects.linker 
