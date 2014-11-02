package wd.d3.geom.parcs {
    import __AS3__.vec.*;
    import wd.utils.*;
    import wd.core.*;
    import away3d.entities.*;
    import away3d.core.base.*;
    import wd.d3.material.*;
    import flash.net.*;
    import flash.geom.*;
    import wd.http.*;
    import away3d.containers.*;

    public class Parcs extends ObjectContainer3D {

        private static var instance:Parcs;

        private var responder:Responder;
        private var param:ServiceConstants;
        private var connection:NetConnection;
        private var mesh:Mesh;
        private var currentAdd:SubGeometry;
        private var voffset:Number = 0;
        private var vs:Vector.<Number>;
        private var inds:Vector.<uint>;
        private var ids:Vector.<uint>;

        public function Parcs(){
            this.vs = new Vector.<Number>();
            this.inds = new Vector.<uint>();
            this.ids = new Vector.<uint>();
            super();
            new CSVLoader((("assets/csv/parcs/" + Config.CITY.toLowerCase()) + ".csv"));
            this.mesh = new Mesh(new Geometry(), MaterialProvider.parc);
            addChild(this.mesh);
            this.currentAdd = new SubGeometry();
            this.responder = new Responder(this.onComplete, this.onCancel);
            this.connection = new NetConnection();
            this.connection.connect(Config.GATEWAY);
            instance = this;
        }
        public static function call(flush:Boolean):void{
            instance.getParcs(flush);
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
            this.currentAdd = new SubGeometry();
            this.vs = new Vector.<Number>();
            this.inds = new Vector.<uint>();
            this.ids = new Vector.<uint>();
            this.voffset = 0;
        }
        public function reset():void{
        }
        private function onComplete(res:Object):void{
            var k:*;
            var m:*;
            var p:Point;
            var v0:Vector3D;
            var v1:Vector3D;
            var i:int;
            var vertices:Array;
            var indices:Array;
            var result:Array = res["parcs"];
            var id:int;
            for (k in result) {
                for (m in result[k]) {
                    if (m == "id"){
                        id = parseInt(result[k][m]);
                    };
                    if (m == "vertex"){
                        vertices = result[k][m];
                    };
                    if (m == "index"){
                        indices = result[k][m];
                    };
                };
                if (this.ids.indexOf(id) != -1){
                } else {
                    this.ids.push(id);
                    if ((((((((indices == null)) || ((vertices == null)))) || ((indices.length == 0)))) || ((vertices.length == 0)))){
                    } else {
                        p = Locator.REMAP(vertices[0], vertices[2]);
                        v0 = new Vector3D(p.x, 0, p.y);
                        v1 = new Vector3D();
                        if ((((this.vs.length >= (Constants.MAX_SUBGGEOM_BUFFER_SIZE - (vertices.length / 3)))) || ((this.inds.length >= (Constants.MAX_SUBGGEOM_BUFFER_SIZE - (indices.length / 3)))))){
                            this.currentAdd.updateVertexData(this.vs);
                            this.currentAdd.updateIndexData(this.inds);
                            this.currentAdd = new SubGeometry();
                            this.vs = new Vector.<Number>();
                            this.inds = new Vector.<uint>();
                            this.voffset = 0;
                        };
                        i = 0;
                        while (i < vertices.length) {
                            p = Locator.REMAP(parseFloat(vertices[i]), parseFloat(vertices[(i + 2)]));
                            this.vs.push(p.x, 0, p.y);
                            i = (i + 3);
                        };
                        i = 0;
                        while (i < indices.length) {
                            this.inds.push((indices[i] + this.voffset));
                            i++;
                        };
                        this.voffset = (this.vs.length / 3);
                    };
                };
            };
            this.currentAdd.updateVertexData(this.vs);
            this.currentAdd.updateIndexData(this.inds);
            if (this.mesh.geometry != this.currentAdd.parentGeometry){
                this.mesh.geometry.addSubGeometry(this.currentAdd);
            };
            if (res["next_page"] != null){
                this.param[ServiceConstants.PAGE] = res["next_page"];
                this.getParcs(false);
            };
        }
        private function onCancel(fault:Object):void{
        }
        private function getParcs(flush:Boolean=false):void{
            if (flush){
                this.param = Service.initServiceConstants();
                this.param["radius"] = (Config.SETTINGS_BUILDING_RADIUS * 2);
                this.param["current_page"] = 0;
                this.param["item_per_page"] = Config.SETTINGS_BUILDING_PAGINATION;
            };
            try {
                this.connection.call(Service.METHOD_PARCS, this.responder, this.param);
            } catch(err:Error) {
            };
        }

    }
}//package wd.d3.geom.parcs 
