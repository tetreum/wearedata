package wd.d3.geom.building {
    import flash.utils.*;
    import flash.display.*;
    import __AS3__.vec.*;
    import wd.d3.geom.segments.*;
    import flash.geom.*;
    import wd.core.*;
    import wd.d3.material.*;
    import wd.events.*;
    import wd.d3.*;
    import wd.hud.items.*;
    import away3d.core.base.*;
    import wd.utils.*;
    import away3d.entities.*;

    public class BuildingMesh3 extends Mesh {

        private static var instance:BuildingMesh3;
        private static var buildings:Dictionary = new Dictionary(true);

        public var roofs:SegmentGridSortableMesh;
        public var debris:SegmentGridSortableMesh;
        protected var ceilSize:int;
        protected var w:uint;
        protected var h:uint;
        protected var offX:Number = 0;
        protected var offY:Number = 0;
        protected var gridLength:uint;
        protected var m:Number;
        private var pos:uint;
        private var adjX:uint;
        protected var grid:Vector.<BuildingGridCase>;
        private var gridCase:BuildingGridCase;
        private var gridCaseAdd:BuildingGridCase;
        private var current:BuildingSubGeometry3;
        private var currentAdd:BuildingSubGeometry3;
        public var radius:uint;
        public var gridMinX:int;
        public var gridMaxX:int;
        public var gridMinY:int;
        public var gridMaxY:int;
        public var debugGrid:BitmapData;
        public var debug:Boolean = false;
        private var purgeCount:int = 0;
        private var purgeEnabled:Boolean = true;
        private var purgeTime:int = 75;
        private var lastSearchX:uint = 0;
        private var lastSearchY:uint = 0;
        private var dirty:Boolean = true;
        private var buildingWaitingForBuild:Vector.<Building3>;
        private var b:Building3;
        private var time:int;
        private var TIME_AVAILABLE_FOR_BUILD:int = 10;

        public function BuildingMesh3(){
            this.buildingWaitingForBuild = new Vector.<Building3>();
            BuildingMesh3.instance = this;
            Simulation.instance.controller.addEventListener(NavigatorEvent.DO_WAVE, this.doWave);
            Simulation.instance.itemObjects.addEventListener(NavigatorEvent.DO_WAVE, this.doWave);
            super(new Geometry(), MaterialProvider.building_blockHQ);
        }
        public static function removeBuilding(id:uint):void{
            delete buildings[id];
        }
        public static function commitBuilding(building:Building3):void{
            buildings[building.id] = true;
            instance.addBuilding(building);
        }
        public static function buildingExist(id:uint):Boolean{
            return (!((buildings[id] == null)));
        }
        public static function getInstance():BuildingMesh3{
            return (instance);
        }

        override public function dispose():void{
            this.clearCurrentGeom();
            var l:int = (this.gridLength - 1);
            while (l--) {
                this.gridCase = this.grid[l];
                this.purgeGrid(l);
            };
            l = (this.gridLength - 1);
            while (l--) {
                this.gridCase = this.grid[l];
                this.grid.splice(l, 1);
                this.gridCase.dispose();
            };
            this.grid = null;
            this.roofs.dispose();
            this.debris.dispose();
        }
        public function init(ceilSize:int, _b:Rectangle):void{
            this.ceilSize = ceilSize;
            this.w = (Math.ceil((_b.width / ceilSize)) + 1);
            this.h = (Math.ceil((_b.height / ceilSize)) + 1);
            this.gridLength = (this.w * this.h);
            if (this.debug){
                this.debugGrid = new BitmapData((this.h * 5), (this.w * 5), true, 872415231);
            };
            this.offX = -(_b.x);
            this.offY = -(_b.y);
            this.m = (1 / ceilSize);
            this.grid = new Vector.<BuildingGridCase>(this.gridLength, true);
            var i:uint;
            while (i < this.gridLength) {
                this.gridCase = new BuildingGridCase((i % this.h), int((i / this.h)), i);
                this.current = new BuildingSubGeometry3();
                this.gridCase.push(this.current);
                this.grid[i] = this.gridCase;
                i++;
            };
            if (this.roofs == null){
                this.roofs = new SegmentGridSortableMesh(0x606060, 0.5);
            };
            this.roofs.init(ceilSize, _b);
            if (this.debris == null){
                this.debris = new SegmentGridSortableMesh(0xFFFFFF, 2, true);
            };
            this.debris.init(ceilSize, _b);
        }
        public function doHide(e:NavigatorEvent):void{
            if (AppState.isHQ){
                (material as BuildingMaterial).doHide();
            };
        }
        public function doWave(e:NavigatorEvent):void{
            var t:Point;
            if (AppState.isHQ){
                t = new Point(Simulation.instance.cameraTargetPos.x, Simulation.instance.cameraTargetPos.z);
                if (((!((e.data == null))) && ((e.data is Tracker)))){
                    t.x = (e.data as Tracker).x;
                    t.y = (e.data as Tracker).z;
                };
                (material as BuildingMaterial).doWave(t.x, t.y);
            };
        }
        public function setLQ():void{
            material = MaterialProvider.building_blockLQ;
        }
        public function setHQ():void{
            material = MaterialProvider.building_blockHQ;
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
        public function sortBuilding(scene:Simulation, _radius:uint=2):void{
            var numSubGeoms:uint;
            var subGeom:SubGeometry;
            var y:uint;
            this.radius = _radius;
            var itemX:uint = (((scene.cameraTargetPos.x + this.offX) / this.ceilSize) | 0);
            var itemY:uint = (((scene.cameraTargetPos.z + this.offY) / this.ceilSize) | 0);
            if (itemY > this.h){
                itemY = this.h;
            };
            if (itemX > this.w){
                itemX = this.w;
            };
            if (itemY < 0){
                itemY = 0;
            };
            if (itemX < 0){
                itemX = 0;
            };
            this.purgeCount++;
            if (this.purgeCount > this.purgeTime){
                this.purgeCount = 0;
                this.purgeGrid(itemX, itemY);
            } else {
                this.buildBuilding(20);
            };
            if ((((((this.lastSearchX == itemX)) && ((this.lastSearchY == itemY)))) && (!(this.dirty)))){
                return;
            };
            this.dirty = false;
            this.lastSearchX = uint(itemX);
            this.lastSearchY = uint(itemY);
            this.clearCurrentGeom();
            this.gridMinX = (itemX - this.radius);
            if (this.gridMinX < 0){
                this.gridMinX = 0;
            };
            this.gridMinY = (itemY - this.radius);
            if (this.gridMinY < 0){
                this.gridMinY = 0;
            };
            this.gridMaxX = (itemX + this.radius);
            if (this.gridMaxX > this.w){
                this.gridMaxX = this.w;
            };
            this.gridMaxY = (itemY + this.radius);
            if (this.gridMaxY > this.h){
                this.gridMaxY = this.h;
            };
            this.roofs.clearSegment();
            this.debris.clearSegment();
            var x:uint = this.gridMinX;
            while (x <= this.gridMaxX) {
                this.adjX = (x * this.h);
                y = this.gridMinY;
                while (y <= this.gridMaxY) {
                    if ((this.adjX + y) < this.gridLength){
                        this.gridCase = this.grid[(this.adjX + y)];
                        this.roofs.sortCaseSegment((this.adjX + y));
                        this.debris.sortCaseSegment((this.adjX + y));
                        this.gridCase.lastTimeOnScreen = getTimer();
                        numSubGeoms = this.gridCase.length;
                        while (numSubGeoms--) {
                            if (this.gridCase.geometry[numSubGeoms]._vertices.length > 2){
                                subGeom = new SubGeometry();
                                subGeom.updateVertexData(this.gridCase.geometry[numSubGeoms]._vertices);
                                subGeom.updateIndexData(this.gridCase.geometry[numSubGeoms]._indices);
                                subGeom.updateUVData(this.gridCase.geometry[numSubGeoms]._uvs);
                                geometry.addSubGeometry(subGeom);
                            };
                        };
                    };
                    y++;
                };
                x++;
            };
        }
        private function purgeGrid(itemX:uint, itemY:int=-1):void{
            var j:int;
            if (this.debug){
                this.debugGrid.lock();
                this.debugGrid.fillRect(this.debugGrid.rect, 872415231);
            };
            if (itemY != -1){
                j = ((itemX * this.h) + itemY);
                if (j >= (this.gridLength - 1)){
                    j = (this.gridLength - 1);
                };
                if (j < 0){
                    j = 0;
                };
            } else {
                j = itemX;
            };
            var gridCaseTemp:BuildingGridCase = this.grid[j];
            var time:int = getTimer();
            var i:uint;
            while (i < this.gridLength) {
                this.gridCase = this.grid[i];
                if (this.gridCase.isUsed){
                    if (this.gridCase.awayFrom(gridCaseTemp.x, gridCaseTemp.y)){
                        if (this.gridCase.isOld(time)){
                            if (this.debug){
                                this.debugGrid.fillRect(new Rectangle((this.gridCase.x * 5), (this.gridCase.y * 5), 4, 4), 0xFF000000);
                            };
                            if (this.purgeEnabled){
                                this.gridCase.purge();
                                this.roofs.purge(this.gridCase.index);
                                this.debris.purge(this.gridCase.index);
                                Tracker.purge(this.gridCase.index);
                            };
                        } else {
                            if (this.debug){
                                this.debugGrid.fillRect(new Rectangle((this.gridCase.x * 5), (this.gridCase.y * 5), 4, 4), 0xFF00FFFF);
                            };
                        };
                    } else {
                        if (this.debug){
                            this.debugGrid.fillRect(new Rectangle((this.gridCase.x * 5), (this.gridCase.y * 5), 4, 4), 0xFFFFFFFF);
                        };
                    };
                } else {
                    if (this.debug){
                        this.debugGrid.fillRect(new Rectangle((this.gridCase.x * 5), (this.gridCase.y * 5), 4, 4), 1157627903);
                    };
                };
                i++;
            };
            if (this.debug){
                this.debugGrid.fillRect(new Rectangle(((gridCaseTemp.x * 5) + 1), ((gridCaseTemp.y * 5) + 1), 2, 2), 0xFFFF0000);
            };
            if (this.debug){
                this.debugGrid.unlock();
            };
        }
        private function addBuilding(b:Building3):void{
            this.buildingWaitingForBuild.push(b);
        }
        private function buildBuilding(count:uint):void{
            var _x:uint;
            var _y:uint;
            this.time = getTimer();
            var l:int = this.buildingWaitingForBuild.length;
            if (l == 0){
                return;
            };
            if (l < count){
                count = l;
            };
            while (count--) {
                if ((getTimer() - this.time) > this.TIME_AVAILABLE_FOR_BUILD){
                    return;
                };
                this.b = this.buildingWaitingForBuild.shift();
                this.b.init();
                Stats.totalPolygoneCount = (Stats.totalPolygoneCount + (this.b.indices.length / 3));
                _x = (((this.b.x + this.offX) / this.ceilSize) | 0);
                _y = (((this.b.z + this.offY) / this.ceilSize) | 0);
                if (_y > this.h){
                    _y = this.h;
                };
                if (_x > this.w){
                    _x = this.w;
                };
                this.pos = ((_x * this.h) + _y);
                if (this.pos <= this.gridLength){
                    this.gridCaseAdd = this.grid[this.pos];
                    this.currentAdd = this.gridCaseAdd.geometry[(this.gridCaseAdd.length - 1)];
                } else {
                    return;
                };
                if ((((this.currentAdd.numVertices >= (Constants.MAX_SUBGGEOM_BUFFER_SIZE - (this.b.vertices.length / 3)))) || ((this.currentAdd.numTriangles >= (Constants.MAX_SUBGGEOM_BUFFER_SIZE - (this.b.indices.length / 3)))))){
                    trace("new building buffer");
                    this.currentAdd = new BuildingSubGeometry3();
                    this.gridCaseAdd.push(this.currentAdd);
                };
                this.gridCaseAdd.lastTimeOnScreen = getTimer();
                this.currentAdd.mergeBuilding(this.b);
                this.dirty = true;
            };
        }

    }
}//package wd.d3.geom.building 
