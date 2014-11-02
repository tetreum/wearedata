package wd.d3.geom.building {
    import flash.geom.*;
    import __AS3__.vec.*;
    import wd.core.*;
    import wd.utils.*;
    import wd.data.*;

    public class Building3 extends Vector3D {

        private static var staticSortingArea:SortArea;
        private static var node:ListNodeVec3D;
        private static var b:Building3;
        private static var mesh:BuildingMesh3;

        public var id:uint;
        public var vertices:Vector.<Number>;
        public var indices:Vector.<uint>;
        public var indices2:Vector.<uint>;
        public var uvs:Vector.<Number>;
        public var height:Number;
        public var lon:Number;
        public var lat:Number;
        public var center:Point;
        private var pts:Point;

        public function Building3(id:uint, vertices:Vector.<Number>, indices:Vector.<uint>, _height:Number=NaN, _lon:Number=NaN, _lat:Number=NaN, valid:Boolean=false){
            this.pts = new Point();
            this.id = id;
            this.vertices = vertices;
            this.indices = indices;
            this.indices2 = new Vector.<uint>();
            this.height = ((isNaN(this.height)) ? (Config.MIN_BUILDING_HEIGHT + (Math.random() * (Config.MAX_BUILDING_HEIGHT - Config.MIN_BUILDING_HEIGHT))) : this.height);
            this.lon = ((isNaN(_lon)) ? 0 : _lon);
            this.lat = ((isNaN(_lat)) ? 0 : _lat);
            this.center = Locator.REMAP(this.lon, this.lat, this.center);
            super(this.center.x, this.center.y, this.center.y);
            if (!(valid)){
                indices = Vector.<uint>([]);
            };
            BuildingMesh3.commitBuilding(this);
        }
        public static function staticInit(_mesh:BuildingMesh3):void{
            mesh = _mesh;
        }

        private function reduceVertice(pos:Point):void{
            this.pts.x = (pos.x - this.center.x);
            this.pts.y = (pos.y - this.center.y);
            this.pts.normalize(0.2);
            pos.x = (pos.x - this.pts.x);
            pos.y = (pos.y - this.pts.y);
        }
        public function init():void{
            var i:int;
            var i0:uint;
            var i1:uint;
            var i2:uint;
            var i3:uint;
            var h:Number;
            var p:Vector3D = new Vector3D();
            var v0:Vector3D = new Vector3D();
            var v1:Vector3D = new Vector3D();
            var sides:uint = (this.vertices.length / 3);
            var uv:int;
            this.uvs = new Vector.<Number>();
            var pos:Point = new Point();
            i = 0;
            while (i < this.vertices.length) {
                Locator.REMAP(this.vertices[i], this.vertices[(i + 2)], pos);
                this.reduceVertice(pos);
                p.x = (this.vertices[i] = pos.x);
                p.y = (this.vertices[(i + 1)] = this.height);
                p.z = (this.vertices[(i + 2)] = pos.y);
                v0.x = (v1.x = p.x);
                v0.y = this.height;
                v1.y = 0;
                v0.z = (v1.z = p.z);
                this.uvs.push(0, 0);
                if (Math.random() > 0.1){
                    v0.x = (v1.x = (v0.x + ((Math.random() - 0.5) * Config.BUILDING_DEBRIS_OFFSET)));
                    v0.y = ((Math.random() * this.height) * 0.75);
                    v0.z = (v1.z = (v0.z + ((Math.random() - 0.5) * Config.BUILDING_DEBRIS_OFFSET)));
                    v1.y = (v0.y + 0.25);
                    BuildingMesh3.getInstance().debris.addSegment(this, v0, v1);
                };
                i = (i + 3);
            };
            i = 0;
            while (i < this.vertices.length) {
                h = (0.25 + ((Math.random() * this.height) * 0.75));
                v1.x = this.vertices[i];
                v1.y = h;
                v1.z = this.vertices[(i + 2)];
                if (i > 0){
                    BuildingMesh3.getInstance().roofs.addSegment(this, p, v1);
                };
                p.x = this.vertices[((i + 3) % this.vertices.length)];
                p.y = h;
                p.z = this.vertices[(((i + 2) + 3) % this.vertices.length)];
                BuildingMesh3.getInstance().roofs.addSegment(this, v1, p);
                i = (i + 3);
            };
            var len:uint = this.vertices.length;
            i = 0;
            while (i < len) {
                this.vertices.push(this.vertices[i], 0, this.vertices[(i + 2)]);
                this.uvs.push(0, 1);
                i = (i + 3);
            };
            i = 0;
            while (i < sides) {
                i0 = i;
                i1 = ((i + 1) % sides);
                i2 = (sides + i);
                i3 = (sides + ((i + 1) % sides));
                this.indices.push(i0, i2, i1);
                this.indices.push(i2, i3, i1);
                this.indices2.push(i0, i1, i2);
                this.indices2.push(i2, i1, i3);
                i++;
            };
        }
        public function dispose():void{
            BuildingMesh3.removeBuilding(this.id);
            this.vertices.length = 0;
            this.vertices = null;
            this.indices.length = 0;
            this.indices = null;
            this.uvs.length = 0;
            this.uvs = null;
        }

    }
}//package wd.d3.geom.building 
