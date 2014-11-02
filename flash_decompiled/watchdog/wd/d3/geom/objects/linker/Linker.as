package wd.d3.geom.objects.linker {
    import flash.geom.*;
    import __AS3__.vec.*;
    import wd.d3.geom.objects.networks.*;
    import wd.d3.*;
    import away3d.containers.*;

    public class Linker extends ObjectContainer3D {

        private static var instance:Linker;

        private var bounds:Vector.<Bind>;
        private var net:NetworkSet;

        public function Linker(sim:Simulation){
            super();
            this.bounds = new Vector.<Bind>();
            this.net = new NetworkSet(2, new NetworkMaterial(0xFF0000, 0.5));
            addChild(this.net);
            instance = this;
        }
        public static function addLink(p:Point, v:Vector3D):void{
            instance.bounds.push(new Bind(p, v));
        }
        public static function removeLink(p:Point=null, v:Vector3D=null):void{
            var b:Bind;
            for each (b in instance.bounds) {
                if (b.vector.equals(v)){
                    instance.bounds.splice(instance.bounds.indexOf(b), 1);
                    b = null;
                    return;
                };
            };
            instance.reset();
        }

        public function reset():void{
            var b:Bind;
            for each (b in this.bounds) {
                b.reset(this.net);
            };
        }
        public function update():void{
            var b:Bind;
            this.net.removeAllSegments();
            for each (b in this.bounds) {
                b.reset(this.net);
            };
            this.net.thickness = (0.1 + Math.random());
            this.net.alpha = (0.1 + Math.random());
        }

    }
}//package wd.d3.geom.objects.linker 
