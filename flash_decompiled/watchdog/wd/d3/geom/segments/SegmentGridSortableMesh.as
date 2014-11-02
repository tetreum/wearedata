package wd.d3.geom.segments {
    import __AS3__.vec.*;
    import flash.geom.*;
    import away3d.core.base.*;
    import wd.utils.*;
    import wd.core.*;
    import wd.d3.geom.building.*;
    import flash.display.*;
    import away3d.entities.*;

    public class SegmentGridSortableMesh extends Mesh {

        private const LIMIT:uint = 196605;

        public var VERTEX_BUFFER_LENGTH:int = 7;
        protected var ceilSize:int;
        protected var w:uint;
        protected var h:uint;
        protected var offX:Number = 0;
        protected var offY:Number = 0;
        protected var gridLength:uint;
        protected var m:Number;
        private var pos:uint;
        private var adjX:uint;
        protected var grid:Vector.<SegmentGridCase>;
        private var gridCase:SegmentGridCase;
        private var gridCaseAdd:SegmentGridCase;
        private var current:SegmentGridSortableSubGeometry;
        private var currentAdd:SegmentGridSortableSubGeometry;
        public var radius:uint;
        public var gridMinX:uint;
        public var gridMaxX:uint;
        public var gridMinY:uint;
        public var gridMaxY:uint;
        public var debugGrid:BitmapData;
        public var debug:Boolean = true;
        private var purgeCount:int = 0;
        private var purgeTime:int = 150;
        private var numSubGeoms:uint;
        private var subGeom:SubGeometry;

        public function SegmentGridSortableMesh(startColor:int=-1, thickness:Number=1, sint:Boolean=false){
            super(new Geometry(), new WireSegmentMaterialBuilding(startColor, thickness, sint));
        }
        override public function dispose():void{
            this.clearSegment();
            var l:int = this.gridLength;
            while (l--) {
                this.gridCase = this.grid[l];
                this.grid.splice(l, 1);
                this.gridCase.dispose();
            };
            this.grid = null;
        }
        public function purge(i:int):void{
            var sub:SegmentGridSortableSubGeometry;
            this.gridCase = this.grid[i];
            var numSubGeoms:int = this.gridCase.geometry.length;
            while (numSubGeoms--) {
                sub = this.gridCase.geometry[numSubGeoms];
                this.gridCase.geometry.splice(numSubGeoms, 1);
                sub.purge();
                sub = null;
            };
            this.current = new SegmentGridSortableSubGeometry();
            this.gridCase.push(this.current);
        }
        public function init(ceilSize:int, _b:Rectangle):void{
            this.ceilSize = ceilSize;
            this.w = (Math.ceil((_b.width / ceilSize)) + 1);
            this.h = (Math.ceil((_b.height / ceilSize)) + 1);
            this.gridLength = (this.w * this.h);
            this.offX = -(_b.x);
            this.offY = -(_b.y);
            this.m = (1 / ceilSize);
            this.grid = new Vector.<SegmentGridCase>(this.gridLength, true);
            var i:uint;
            while (i < this.gridLength) {
                this.gridCase = new SegmentGridCase((i % this.h), int((i / this.h)));
                this.current = new SegmentGridSortableSubGeometry();
                this.gridCase.push(this.current);
                this.grid[i] = this.gridCase;
                i++;
            };
        }
        public function clearSegment():void{
            var c:uint;
            this.numSubGeoms = geometry.subGeometries.length;
            while (this.numSubGeoms--) {
                this.subGeom = geometry.subGeometries[this.numSubGeoms];
                geometry.removeSubGeometry(this.subGeom);
                this.subGeom.dispose();
                this.subGeom = null;
            };
        }
        public function sortCaseSegment(c:uint):void{
            this.gridCase = this.grid[c];
            this.numSubGeoms = this.gridCase.geometry.length;
            while (this.numSubGeoms--) {
                if (this.gridCase.geometry[this.numSubGeoms]._vertices.length > 0){
                    this.subGeom = new SubGeometry();
                    this.subGeom.initCustomBuffer((this.gridCase.geometry[this.numSubGeoms]._vertices.length / this.VERTEX_BUFFER_LENGTH), this.VERTEX_BUFFER_LENGTH);
                    this.subGeom.updateCustomData(this.gridCase.geometry[this.numSubGeoms]._vertices);
                    this.subGeom.updateIndexData(this.gridCase.geometry[this.numSubGeoms]._indices);
                    geometry.addSubGeometry(this.subGeom);
                };
            };
        }
        private function updateDebugGrid():void{
            var gridCase:SegmentGridCase;
            this.debugGrid.lock();
            this.debugGrid.fillRect(this.debugGrid.rect, 872415231);
            var i:uint;
            while (i < this.gridLength) {
                gridCase = this.grid[i];
                if (gridCase.geometry[0]._indices.length > 4){
                    this.debugGrid.fillRect(new Rectangle((gridCase.x * 5), (gridCase.y * 5), 4, 4), 0xFFFFFFFF);
                } else {
                    this.debugGrid.fillRect(new Rectangle((gridCase.x * 5), (gridCase.y * 5), 4, 4), 1442840575);
                };
                i++;
            };
            this.debugGrid.unlock();
        }
        public function addSegment(b:Building3, s:Vector3D, e:Vector3D):void{
            Stats.totalPolygoneCount = (Stats.totalPolygoneCount + 2);
            var itemX:uint = (((b.x + this.offX) / this.ceilSize) | 0);
            var itemY:uint = (((b.z + this.offY) / this.ceilSize) | 0);
            this.pos = ((itemX * this.h) + itemY);
            if (this.pos <= this.gridLength){
                this.gridCaseAdd = this.grid[this.pos];
                this.currentAdd = this.gridCaseAdd.geometry[(this.gridCaseAdd.geometry.length - 1)];
            } else {
                return;
            };
            if ((((((this.currentAdd._vertices.length / this.VERTEX_BUFFER_LENGTH) + this.VERTEX_BUFFER_LENGTH) > Constants.MAX_SUBGGEOM_BUFFER_SIZE)) || ((((this.currentAdd._indices.length / 3) + 2) > Constants.MAX_SUBGGEOM_BUFFER_SIZE)))){
                trace("new segment buffer");
                this.currentAdd = new SegmentGridSortableSubGeometry();
                this.gridCaseAdd.push(this.currentAdd);
            };
            this.currentAdd.mergeSegment(s, e);
        }

    }
}//package wd.d3.geom.segments 
