package wd.d3.control {
    import away3d.entities.*;
    import wd.core.*;
    import away3d.primitives.*;
    import wd.d3.material.*;
    import wd.utils.*;
    import flash.geom.*;
    import biga.shapes2d.*;
    import away3d.containers.*;

    public class Location extends ObjectContainer3D {

        private const FRICTION:Number = 0.5;

        public var SPEED:Number = 1.2E-5;
        private var angleStep:Number = 0.0261799387799149;
        public var position2D:Point;
        public var velocity:Number = 0;
        public var angle:Number = 0;
        public var dest_velocity:Number = 0;
        public var dest_angle:Number = 0;
        public var mesh:ObjectContainer3D;

        public function Location(){
            var m:Mesh;
            super();
            if (Config.DEBUG_SIMULATION){
                m = new Mesh(new SphereGeometry(10), MaterialProvider.yellow);
                addChild(m);
                m.y = 0.01;
                m = new Mesh(new CylinderGeometry(100, 100, 1, 64, 1, false, false), MaterialProvider.yellow);
                addChild(m);
                m.y = 0.5;
            };
            this.dest_angle = (Math.PI * 0.5);
            this.dest_velocity = 0;
            this.reset();
        }
        public function update(useKeys:Boolean=true):void{
            if (((useKeys) && (!(Config.NAVIGATION_LOCKED)))){
                if (Keys.arrows[0]){
                    this.dest_angle = (this.dest_angle + this.angleStep);
                };
                if (Keys.arrows[1]){
                    this.dest_velocity = (this.dest_velocity + this.SPEED);
                };
                if (Keys.arrows[2]){
                    this.dest_angle = (this.dest_angle - this.angleStep);
                };
                if (Keys.arrows[3]){
                    this.dest_velocity = (this.dest_velocity - this.SPEED);
                };
                this.dest_velocity = Math.max(-10, Math.min(this.dest_velocity, 10));
                this.velocity = (this.velocity + ((this.dest_velocity - this.velocity) * this.FRICTION));
                this.velocity = this.dest_velocity;
                this.angle = (this.angle + ((this.dest_angle - this.angle) * this.FRICTION));
                this.dest_velocity = (this.dest_velocity * 0.9);
            };
            var maxSpeed:Number = 10;
            if (this.velocity > (maxSpeed * this.SPEED)){
                this.velocity = (maxSpeed * this.SPEED);
            };
            if (this.velocity < (-(maxSpeed) * this.SPEED)){
                this.velocity = (-(maxSpeed) * this.SPEED);
            };
            Locator.LONGITUDE = (Locator.LONGITUDE + (Math.cos(this.angle) * this.velocity));
            Locator.LATITUDE = (Locator.LATITUDE + (Math.sin(this.angle) * this.velocity));
            Locator.REMAP(Locator.LONGITUDE, Locator.LATITUDE, this.position2D);
            x = this.position2D.x;
            z = this.position2D.y;
            this.checkbounds2();
        }
        private function checkbounds2():void{
            if (x > Locator.world_rect.right){
                x = Locator.world_rect.right;
                this.velocity = (this.velocity * -1);
                this.dest_velocity = 0;
            };
            if (x < Locator.world_rect.left){
                x = Locator.world_rect.left;
                this.velocity = (this.velocity * -1);
                this.dest_velocity = 0;
            };
            if (z > Locator.world_rect.bottom){
                z = Locator.world_rect.bottom;
                this.velocity = (this.velocity * -1);
                this.dest_velocity = 0;
            };
            if (z < Locator.world_rect.top){
                z = Locator.world_rect.top;
                this.velocity = (this.velocity * -1);
                this.dest_velocity = 0;
            };
        }
        private function closestPointOnRect(p:Point, rect:Rectangle):Point{
            var res_p:Point;
            var c:Point = new Point((rect.left + (rect.right * 0.5)), (rect.top + (rect.bottom * 0.5)));
            var e:Edge = new Edge(c, p);
            var tp0:Point = rect.topLeft.clone();
            var tp1:Point = rect.topLeft.clone();
            var tmp_edge:Edge = new Edge(tp0, tp1);
            tmp_edge.p1.x = rect.right;
            res_p = e.intersect(tmp_edge);
            if (res_p != null){
                return (res_p);
            };
            tmp_edge.p0 = rect.bottomRight;
            res_p = e.intersect(tmp_edge);
            if (res_p != null){
                return (res_p);
            };
            tmp_edge.p1.x = rect.x;
            tmp_edge.p1.y = rect.bottom;
            res_p = e.intersect(tmp_edge);
            if (res_p != null){
                return (res_p);
            };
            tmp_edge.p0 = rect.topLeft;
            res_p = e.intersect(tmp_edge);
            if (res_p != null){
                return (res_p);
            };
            return (null);
        }
        public function reset():void{
            this.position2D = Locator.REMAP(Locator.LONGITUDE, Locator.LATITUDE);
            x = this.position2D.x;
            z = this.position2D.y;
            this.angle = (Math.PI / 2);
            this.dest_angle = this.angle;
        }

    }
}//package wd.d3.control 
