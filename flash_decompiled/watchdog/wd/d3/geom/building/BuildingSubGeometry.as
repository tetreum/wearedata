package wd.d3.geom.building {
    import __AS3__.vec.*;
    import flash.geom.*;
    import away3d.core.base.*;

    public class BuildingSubGeometry extends SubGeometry {

        private var index_offset:uint;
        public var count:int = 0;
        public var buildings:Vector.<Building>;
        public var i_offsets:Vector.<int>;
        public var v_offsets:Vector.<int>;
        public var uv_offsets:Vector.<int>;
        public var tmp_vertices:Vector.<Number>;
        public var tmp_indices:Vector.<uint>;
        public var tmp_uvs:Vector.<Number>;
        public var centers:Vector.<Point>;

        public function BuildingSubGeometry(){
            super();
            this.buildings = new Vector.<Building>();
            this.v_offsets = new Vector.<int>();
            this.i_offsets = new Vector.<int>();
            this.uv_offsets = new Vector.<int>();
            this.centers = new Vector.<Point>();
        }
        public function mergeBuilding(building:Building):void{
            var ind:uint;
            var v:Number;
            var uv:Number;
            building.init(this);
            var v_offset:int;
            var i_offset:int;
            v_offset = (this.tmp_vertices.length / 3);
            building.index_offset = (this.tmp_indices.length - this.index_offset);
            for each (ind in building.indices) {
                this.tmp_indices.push((ind + v_offset));
            };
            for each (v in building.vertices) {
                this.tmp_vertices.push(v);
            };
            for each (uv in building.uvs) {
                this.tmp_uvs.push(uv);
            };
            this.buildings.push(building);
            this.centers.push(building.center);
            this.count++;
        }
        public function initTemporaryBuffers():void{
            this.tmp_vertices = ((vertexData) ? vertexData : Vector.<Number>([0, 0, 0]));
            this.tmp_indices = ((indexData) ? indexData : new Vector.<uint>());
            this.index_offset = this.tmp_indices.length;
            this.tmp_uvs = ((UVData) ? UVData : Vector.<Number>([0, 0]));
        }
        public function commitTemporaryBuffers():void{
            updateVertexData(this.tmp_vertices);
            updateIndexData(this.tmp_indices);
            updateUVData(this.tmp_uvs);
        }
        public function remove(b:Building):void{
            var start:uint = b.index_offset;
            var end:uint = (b.index_offset + b.indices.length);
            var i:int = start;
            while (i < end) {
                this.tmp_indices[i] = 0;
                i++;
            };
            this.count--;
        }

    }
}//package wd.d3.geom.building 
