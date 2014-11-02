package wd.d3.geom.building {
    import wd.d3.geom.segments.*;
    import wd.utils.*;
    import __AS3__.vec.*;
    import flash.geom.*;

    public class Building {

        public static var wire:Wire = new Wire(0, 0x707070);
        public static var debris:Debris = new Debris(0xCCCCCC, 0xCCCCCC, 1);
        public static var roofs:Roofs = new Roofs(0x303030, 0x404040, 0.5);

        public var id:uint;
        public var index_offset:uint;
        public var vertices:Vector.<Number>;
        public var indices:Vector.<uint>;
        public var height:Number;
        public var lon:Number;
        public var lat:Number;
        public var uvs:Vector.<Number>;
        public var center:Point;
        public var sug_geometry:BuildingSubGeometry;

        public function Building(id:uint, vertices:Vector.<Number>, indices:Vector.<uint>, _height:Number=NaN, _lon:Number=NaN, _lat:Number=NaN, valid:Boolean=false){
            super();
            this.reset(id, vertices, indices, _height, _lon, _lat, valid);
            this.lon = ((isNaN(_lon)) ? 0 : _lon);
            this.lat = ((isNaN(_lat)) ? 0 : _lat);
            this.center = Locator.REMAP(this.lon, this.lat, this.center);
        }
        public function reset(id:uint, vertices:Vector.<Number>, indices:Vector.<uint>, _height:Number=NaN, _lon:Number=NaN, _lat:Number=NaN, valid:Boolean=false):void{
            this.id = id;
            this.vertices = vertices;
            this.indices = indices;
            if (!(valid)){
                indices = Vector.<uint>([]);
            };
            this.height = ((isNaN(this.height)) ? (0.15 + (Math.random() * 0.75)) : this.height);
        }
        public function init(sg:BuildingSubGeometry):void{
            var i:int;
            var i0:uint;
            var i1:uint;
            var i2:uint;
            var i3:uint;
            var h:Number;
            this.sug_geometry = sg;
            this.uvs = new Vector.<Number>();
            var p:Vector3D = new Vector3D();
            var v0:Vector3D = new Vector3D();
            var v1:Vector3D = new Vector3D();
            var sides:uint = (this.vertices.length / 3);
            var uv:int;
            var pos:Point = new Point();
            i = 0;
            while (i < this.vertices.length) {
                Locator.REMAP(this.vertices[i], this.vertices[(i + 2)], pos);
                p.x = (this.vertices[i] = pos.x);
                p.y = (this.vertices[(i + 1)] = this.height);
                p.z = (this.vertices[(i + 2)] = pos.y);
                v0.x = (v1.x = p.x);
                v0.y = 0;
                v1.y = this.height;
                v0.z = (v1.z = p.z);
                this.uvs.push(0, 0.25);
                i = (i + 3);
            };
            i = 0;
            while (i < this.vertices.length) {
                h = (0.25 + ((Math.random() * this.height) * 0.75));
                v1.x = this.vertices[i];
                v1.y = h;
                v1.z = this.vertices[(i + 2)];
                if (i > 0){
                    roofs.addSegment(p, v1);
                };
                p.x = this.vertices[((i + 3) % this.vertices.length)];
                p.y = h;
                p.z = this.vertices[(((i + 2) + 3) % this.vertices.length)];
                roofs.addSegment(v1, p);
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
                i++;
            };
        }

    }
}//package wd.d3.geom.building 
