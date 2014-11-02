package wd.d3.geom.rails {
    import __AS3__.vec.*;
    import flash.net.*;
    import wd.core.*;
    import flash.geom.*;
    import wd.utils.*;
    import wd.d3.geom.metro.*;
    import wd.http.*;

    public class Rails {

        private static var instance:Rails;

        private var responder:Responder;
        private var param:ServiceConstants;
        private var connection:NetConnection;
        private var vs:Vector.<Number>;
        private var inds:Vector.<uint>;
        private var ids:Vector.<uint>;

        public function Rails(){
            this.vs = new Vector.<Number>();
            this.inds = new Vector.<uint>();
            this.ids = new Vector.<uint>();
            super();
            this.responder = new Responder(this.onComplete, this.onCancel);
            this.connection = new NetConnection();
            this.connection.connect(Config.GATEWAY);
            instance = this;
        }
        public static function call(flush:Boolean):void{
            instance.getRails(flush);
        }

        public function dispose():void{
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
            var result:Array = res["rails"];
            var id:int;
            for (k in result) {
                for (m in result[k]) {
                    if (m == "id"){
                        id = parseInt(result[k][m]);
                    };
                    if (m == "vertex"){
                        vertices = result[k][m].split(",");
                    };
                };
                if (this.ids.indexOf(id) != -1){
                } else {
                    this.ids.push(id);
                    if ((((vertices == null)) || ((vertices.length == 0)))){
                    } else {
                        p = Locator.REMAP(vertices[0], vertices[2]);
                        v0 = new Vector3D();
                        v1 = new Vector3D();
                        i = 0;
                        while (i < (vertices.length - 2)) {
                            p = Locator.REMAP(parseFloat(vertices[i]), parseFloat(vertices[(i + 1)]));
                            v0.x = p.x;
                            v0.z = p.y;
                            p = Locator.REMAP(parseFloat(vertices[(i + 2)]), parseFloat(vertices[(i + 3)]));
                            v1.x = p.x;
                            v1.z = p.y;
                            Metro.addSegment(v0, v1, 0xBBBBBB, 0.5);
                            i = (i + 2);
                        };
                    };
                };
            };
            if (res["next_page"] != null){
                this.param[ServiceConstants.PAGE] = res["next_page"];
                this.getRails(false);
            };
        }
        private function onCancel(fault:Object):void{
        }
        private function getRails(flush:Boolean=false):void{
            if (flush){
                this.param = Service.initServiceConstants();
                this.param["radius"] = (Config.SETTINGS_BUILDING_RADIUS * 2);
                this.param["current_page"] = 0;
                this.param["item_per_page"] = Config.SETTINGS_BUILDING_PAGINATION;
            };
            try {
                this.connection.call(Service.METHOD_RAILS, this.responder, this.param);
            } catch(err:Error) {
            };
        }

    }
}//package wd.d3.geom.rails 
