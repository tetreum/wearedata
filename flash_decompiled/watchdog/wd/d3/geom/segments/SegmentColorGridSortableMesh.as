package wd.d3.geom.segments {
    import __AS3__.vec.*;
    import flash.geom.*;
    import away3d.core.base.*;
    import wd.d3.*;
    import wd.utils.*;
    import wd.core.*;
    import away3d.entities.*;

    public class SegmentColorGridSortableMesh extends Mesh {

        private const LIMIT:uint = 196605;

        public var VERTEX_BUFFER_LENGTH:int = 11;
        protected var ceilSize:int;
        protected var w:uint;
        protected var h:uint;
        protected var offX:Number = 0;
        protected var offY:Number = 0;
        protected var gridLength:uint;
        protected var m:Number;
        private var pos:uint;
        private var adjX:uint;
        protected var grid:Vector.<Vector.<SegmentColorGridSortableSubGeometry>>;
        private var geom:Vector.<SegmentColorGridSortableSubGeometry>;
        private var geomAdd:Vector.<SegmentColorGridSortableSubGeometry>;
        private var current:SegmentColorGridSortableSubGeometry;
        private var currentAdd:SegmentColorGridSortableSubGeometry;

        public function SegmentColorGridSortableMesh(thickness:Number=1){
            super(new Geometry(), new WireSegmentMaterial(thickness, true));
        }
        public function init(ceilSize:int, _b:Rectangle):void{
            this.ceilSize = ceilSize;
            this.w = (Math.ceil((_b.width / ceilSize)) + 1);
            this.h = (Math.ceil((_b.height / ceilSize)) + 1);
            this.gridLength = (this.w * this.h);
            this.offX = -(_b.x);
            this.offY = -(_b.y);
            this.m = (1 / ceilSize);
            this.grid = new Vector.<Vector.<SegmentColorGridSortableSubGeometry>>(this.gridLength, true);
            var i:uint;
            while (i < this.gridLength) {
                this.geom = new Vector.<SegmentColorGridSortableSubGeometry>();
                this.current = new SegmentColorGridSortableSubGeometry();
                this.geom.push(this.current);
                this.grid[i] = this.geom;
                i++;
            };
        }
        override public function dispose():void{
            var l2:int;
            var segSubGeom:SegmentColorGridSortableSubGeometry;
            this.clearCurrentGeom();
            var l:int = this.gridLength;
            while (l--) {
                this.geom = this.grid[l];
                l2 = this.geom.length;
                while (l2--) {
                    segSubGeom = this.geom[l2];
                    segSubGeom.dispose();
                    segSubGeom = null;
                    this.geom.splice(l2, 1);
                };
                this.grid.splice(l, 1);
            };
            this.grid = null;
        }
        public function sortSegment(scene:Simulation, radius:uint):void{
            var numSubGeoms:uint;
            var subGeom:SubGeometry;
            var y:uint;
            this.clearCurrentGeom();
            var itemX:uint = (((scene.cameraTargetPos.x + this.offX) / this.ceilSize) | 0);
            var itemY:uint = (((scene.cameraTargetPos.z + this.offY) / this.ceilSize) | 0);
            var minX:int = (itemX - radius);
            if (minX < 0){
                minX = 0;
            };
            var minY:int = (itemY - radius);
            if (minY < 0){
                minY = 0;
            };
            var maxX:uint = (itemX + radius);
            if (maxX > this.w){
                maxX = this.w;
            };
            var maxY:uint = (itemY + radius);
            if (maxY > this.h){
                maxY = this.h;
            };
            var x:uint = minX;
            while (x <= maxX) {
                this.adjX = (x * this.h);
                y = minY;
                while (y <= maxY) {
                    if ((this.adjX + y) < this.gridLength){
                        this.geom = this.grid[(this.adjX + y)];
                        numSubGeoms = this.geom.length;
                        while (numSubGeoms--) {
                            if (this.geom[numSubGeoms]._vertices.length > 40){
                                subGeom = new SubGeometry();
                                subGeom.initCustomBuffer((this.geom[numSubGeoms]._vertices.length / this.VERTEX_BUFFER_LENGTH), this.VERTEX_BUFFER_LENGTH);
                                subGeom.updateCustomData(this.geom[numSubGeoms]._vertices);
                                subGeom.updateIndexData(this.geom[numSubGeoms]._indices);
                                geometry.addSubGeometry(subGeom);
                            };
                        };
                    };
                    y++;
                };
                x++;
            };
        }
        private function clearCurrentGeom():void{
            var subGeom:SubGeometry;
            var numSubGeoms:uint = geometry.subGeometries.length;
            while (numSubGeoms--) {
                subGeom = geometry.subGeometries[numSubGeoms];
                geometry.removeSubGeometry(subGeom);
                subGeom.dispose();
                subGeom = null;
            };
        }
        public function addSegment(s:Vector3D, e:Vector3D, color:int, thickness:Number):void{
            Stats.totalPolygoneCount = (Stats.totalPolygoneCount + 2);
            var itemX:uint = (((s.x + this.offX) / this.ceilSize) | 0);
            var itemY:uint = (((s.z + this.offY) / this.ceilSize) | 0);
            this.pos = ((itemX * this.h) + itemY);
            if (this.pos < this.gridLength){
                this.geomAdd = this.grid[this.pos];
                this.currentAdd = this.geomAdd[(this.geomAdd.length - 1)];
            } else {
                return;
            };
            if ((((((this.currentAdd._vertices.length / this.VERTEX_BUFFER_LENGTH) + this.VERTEX_BUFFER_LENGTH) > Constants.MAX_SUBGGEOM_BUFFER_SIZE)) || ((((this.currentAdd._indices.length / 3) + 2) > Constants.MAX_SUBGGEOM_BUFFER_SIZE)))){
                trace("new segment color buffer");
                this.currentAdd = new SegmentColorGridSortableSubGeometry();
                this.geomAdd.push(this.currentAdd);
            };
            this.currentAdd.mergeSegment(s, e, color, thickness);
        }

    }
}//package wd.d3.geom.segments 
