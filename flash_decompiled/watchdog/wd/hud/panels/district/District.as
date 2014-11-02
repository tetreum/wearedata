package wd.hud.panels.district {
    import __AS3__.vec.*;
    import flash.geom.*;
    import biga.utils.*;

    public class District {

        public var id:int;
        public var name:String;
        public var vertices:Vector.<Point>;

        public function District(id:int, name:String, vertexList:String){
            super();
            this.id = id;
            this.name = name;
            this.vertices = Vector.<Point>([]);
            var tmp:Vector.<Number> = Vector.<Number>(vertexList.split(","));
            var i:int;
            while (i < tmp.length) {
                this.vertices.push(new Point(tmp[(i + 1)], tmp[i]));
                i = (i + 2);
            };
        }
        public function contains(longitude:Number, latitude:Number):Boolean{
            return (PolygonUtils.contains(longitude, latitude, this.vertices));
        }

    }
}//package wd.hud.panels.district 
