package wd.d3.geom.objects.networks {
    import __AS3__.vec.*;
    import away3d.containers.*;
    import wd.hud.items.*;
    import flash.geom.*;
    import wd.core.*;

    public class Network extends ObjectContainer3D {

        public static var instance:Network;

        private var sets:Vector.<NetworkSet>;
        private var current:NetworkSet;
        private var material:NetworkMaterial;
        private var manager:ObjectContainer3D;

        public function Network(manager:ObjectContainer3D, color:int=0, thickness:Number=1){
            super();
            this.manager = manager;
            instance = this;
            manager.addChild(this);
            this.material = new NetworkMaterial(color, thickness);
            this.current = new NetworkSet(thickness, this.material);
            this.sets = new Vector.<NetworkSet>();
            this.sets.push(this.current);
            addChild(this.current);
        }
        public function initAsSegments(vectors:Vector.<Tracker>, loop:Boolean=false):void{
            this.current.removeAllSegments();
            if ((((vectors == null)) || ((vectors.length < 2)))){
                return;
            };
            var i:int;
            while (i < (vectors.length - 1)) {
                this.addSegment(vectors[i], vectors[(i + 1)]);
                i++;
            };
            if (loop){
                this.addSegment(vectors[(vectors.length - 1)], vectors[0]);
            };
        }
        public function initAsTriangles(vectors:Vector.<Tracker>, indices:Vector.<int>):void{
            var v0:Vector3D;
            var v1:Vector3D;
            var v2:Vector3D;
            this.flush();
            if ((((vectors == null)) || ((vectors.length < 3)))){
                return;
            };
            var i:int;
            while (i < indices.length) {
                v0 = vectors[indices[i]];
                v1 = vectors[indices[(i + 1)]];
                v2 = vectors[indices[(i + 2)]];
                this.addSegment(v0, v1);
                this.addSegment(v1, v2);
                this.addSegment(v2, v0);
                i = (i + 3);
            };
        }
        public function flush():void{
            this.current.removeAllSegments();
        }
        public function addSegment(s:Vector3D, e:Vector3D):void{
            if ((((this.current.vertexData.length > (Constants.MAX_SUBGGEOM_BUFFER_SIZE - 28))) || ((this.current.indexData.length > (Constants.MAX_SUBGGEOM_BUFFER_SIZE - 6))))){
                trace("extra Buffer created on Network");
                this.current = new NetworkSet(this.material.thickness, this.material);
                this.sets.push(this.current);
                addChild(this.current);
            };
            this.current.addSegment(s, e);
        }
        public function reloacte(container:ObjectContainer3D):void{
            if (((!((parent == null))) && (parent.contains(this)))){
                parent.removeChild(this);
            };
            container.addChild(this);
        }
        public function set color(value:int):void{
            this.material.color = value;
        }
        public function set alpha(value:Number):void{
            this.material.alpha = value;
        }
        public function get alpha():Number{
            return (this.material.alpha);
        }
        public function set thickness(value:Number):void{
            this.material.thickness = value;
        }
        public function get thickness():Number{
            return (this.material.thickness);
        }
        public function set triangleRenderCount(value:Number):void{
            this.material.triangleRenderCount = value;
        }
        public function get triangleRenderCount():Number{
            return (this.material.triangleRenderCount);
        }
        public function get triangleRenderStart():Number{
            return (this.material.triangleRenderStart);
        }
        public function set triangleRenderStart(value:Number):void{
            this.material.triangleRenderStart = value;
        }

    }
}//package wd.d3.geom.objects.networks 
