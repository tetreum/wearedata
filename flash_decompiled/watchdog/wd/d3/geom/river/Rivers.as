package wd.d3.geom.river {
    import away3d.entities.*;
    import away3d.core.base.*;
    import wd.d3.material.*;
    import flash.net.*;
    import wd.core.*;
    import wd.http.*;
    import flash.geom.*;
    import __AS3__.vec.*;
    import wd.utils.*;
    import wd.d3.geom.objects.networks.*;
    import away3d.containers.*;

    public class Rivers extends ObjectContainer3D {

        private var net:Network;
        private var responder:Responder;
        private var param:ServiceConstants;
        private var connection:NetConnection;
        private var mesh:Mesh;

        public function Rivers(){
            super();
            this.mesh = new Mesh(new Geometry(), MaterialProvider.river);
            addChild(this.mesh);
            this.responder = new Responder(this.onComplete, this.onCancel);
            this.connection = new NetConnection();
            this.connection.connect(Config.GATEWAY);
            this.init();
        }
        override public function dispose():void{
            this.clearCurrentGeom();
        }
        private function clearCurrentGeom():void{
            var subGeom:SubGeometry;
            var numSubGeoms:uint = this.mesh.geometry.subGeometries.length;
            while (numSubGeoms--) {
                subGeom = this.mesh.geometry.subGeometries[numSubGeoms];
                this.mesh.geometry.removeSubGeometry(subGeom);
                subGeom.dispose();
                subGeom = null;
            };
        }
        public function init():void{
            this.param = Service.initServiceConstants();
            this.connection.call(Service.METHOD_RIVERS, this.responder, this.param);
        }
        private function onComplete(result):void{
            var k:*;
            var sg:SubGeometry;
            var m:*;
            var p:Point;
            var v0:Vector3D;
            var v1:Vector3D;
            var i:int;
            var vertices:Array;
            var indices:Array;
            var voffset:Number = 0;
            var vs:Vector.<Number> = new Vector.<Number>();
            var inds:Vector.<uint> = new Vector.<uint>();
            for (k in result) {
                for (m in result[k]) {
                    if (m == "vertex"){
                        vertices = result[k][m];
                    };
                    if (m == "index"){
                        indices = result[k][m];
                    };
                };
                if ((((((((indices == null)) || ((vertices == null)))) || ((indices.length == 0)))) || ((vertices.length == 0)))){
                } else {
                    p = Locator.REMAP(vertices[0], vertices[2]);
                    v0 = new Vector3D(p.x, 0, p.y);
                    v1 = new Vector3D();
                    i = 0;
                    while (i < vertices.length) {
                        p = Locator.REMAP(vertices[i], vertices[(i + 2)]);
                        vs.push(p.x, 0, p.y);
                        i = (i + 3);
                    };
                    i = 0;
                    while (i < indices.length) {
                        inds.push((indices[i] + voffset));
                        i++;
                    };
                    voffset = (vs.length / 3);
                };
            };
            sg = new SubGeometry();
            sg.updateVertexData(vs);
            sg.updateIndexData(inds);
            this.mesh.geometry.addSubGeometry(sg);
        }
        private function onCancel(fault:Object):void{
        }

    }
}//package wd.d3.geom.river 
