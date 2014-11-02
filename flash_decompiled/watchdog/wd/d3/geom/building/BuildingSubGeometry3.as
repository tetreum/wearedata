package wd.d3.geom.building {
    import __AS3__.vec.*;
    import fr.seraf.stage3D.*;
    import flash.geom.*;

    public class BuildingSubGeometry3 {

        private static var _id:int = 0;

        private var index_offset:uint = 0;
        public var _vertices:Vector.<Number>;
        public var _indices:Vector.<uint>;
        public var _uvs:Vector.<Number>;
        public var buildings:Vector.<Building3>;
        public var id:int;
        private var v_offset:uint;
        private var _numVertices:uint;
        private var _numTriangles:uint;
        private var scale:Number = 2.3;

        public function BuildingSubGeometry3(){
            this._vertices = new Vector.<Number>();
            this._indices = new Vector.<uint>();
            this._uvs = new Vector.<Number>();
            super();
            this.id = _id++;
            this.buildings = new Vector.<Building3>();
        }
        public function get numVertices():uint{
            return (this._numVertices);
        }
        public function get numTriangles():uint{
            return (this._numTriangles);
        }
        public function purge():void{
            var b:Building3;
            var l:int = this.buildings.length;
            while (l--) {
                b = this.buildings[l];
                b.dispose();
                b = null;
            };
            this.buildings.length = 0;
            this._vertices.length = 0;
            this._indices.length = 0;
            this._uvs.length = 0;
            this._vertices = null;
            this._indices = null;
            this._uvs = null;
        }
        public function mergeMesh(mesh:Stage3DData, center:Point, decalX:Number, decalY:Number, decalZ:Number):void{
            var ind:uint;
            var l:int;
            var i:int;
            var uv:Number;
            this.v_offset = (this._vertices.length / 3);
            for each (ind in mesh.indices) {
                this._indices.push((ind + this.v_offset));
            };
            l = mesh.vertices.length;
            i = 0;
            while (i < l) {
                var _temp1 = i;
                i = (i + 1);
                this._vertices.push((((mesh.vertices[_temp1] * this.scale) + center.x) + decalX));
                var _temp2 = i;
                i = (i + 1);
                this._vertices.push(((mesh.vertices[_temp2] * this.scale) + decalY));
                this._vertices.push((((mesh.vertices[i] * this.scale) + center.y) + decalZ));
                i++;
            };
            for each (uv in mesh.uvs) {
                this._uvs.push(uv);
            };
            this._numVertices = (this._vertices.length / 3);
            this._numTriangles = (this._indices.length / 3);
        }
        public function mergeBuilding(building:Building3):void{
            var ind:uint;
            var v:Number;
            var uv:Number;
            this.v_offset = (this._vertices.length / 3);
            for each (ind in building.indices) {
                this._indices.push((ind + this.v_offset));
            };
            for each (v in building.vertices) {
                this._vertices.push(v);
            };
            for each (uv in building.uvs) {
                this._uvs.push(uv);
            };
            this._numVertices = (this._vertices.length / 3);
            this._numTriangles = (this._indices.length / 3);
            this.buildings.push(building);
        }
        public function initTemporaryBuffers():void{
        }
        public function commitTemporaryBuffers():void{
        }

    }
}//package wd.d3.geom.building 
