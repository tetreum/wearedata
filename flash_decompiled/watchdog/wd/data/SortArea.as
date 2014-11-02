package wd.data {
    import flash.geom.*;
    import flash.utils.*;
    import __AS3__.vec.*;

    public class SortArea {

        protected var ceilSize:int;
        protected var bounds:Rectangle;
        protected var w:uint;
        protected var h:uint;
        protected var offX:Number = 0;
        protected var offY:Number = 0;
        private var length:uint;
        protected var lengths:Vector.<uint>;
        protected var m:Number;
        protected var grid:Vector.<ListVec3D>;
        protected var _items:ListVec3D;
        private var dirty:Boolean = true;
        private var lastSearchX:uint = 9999999;
        private var lastSearchY:uint = 999999;
        private var results:ListVec3D;
        private var adjX:uint;
        private var l:uint;
        private var pos:uint;
        private var item:Vector3D;
        private var needEntityAcces:Boolean;
        public var caseCount:int;
        public var nodeEntity:ListNodeVec3D;

        public function SortArea(ceilSize:int, bounds:Rectangle, needEntityAcces:Boolean=false){
            this._items = new ListVec3D();
            super();
            this.needEntityAcces = needEntityAcces;
            this.ceilSize = ceilSize;
            this.bounds = bounds;
            this.init();
        }
        public function get entitys():ListVec3D{
            return (this._items);
        }
        public function deleteEntity(sortNode:ListNodeVec3D, sortNode2:ListNodeVec3D=null):void{
            if (this.needEntityAcces){
                this._items.remove(sortNode2);
            };
            this.grid[sortNode.pos].remove(sortNode);
        }
        public function addEntity(item:Vector3D):ListNodeVec3D{
            this.pos = (((((item.x + this.offX) * this.m) | 0) * this.h) + ((item.z + this.offY) * this.m));
            if (this.pos > (this.length - 1)){
                this.pos = (this.length - 1);
            };
            if (this.pos < 0){
                this.pos = 0;
            };
            var itemNode:ListNodeVec3D = this.grid[this.pos].insert(item);
            itemNode.pos = this.pos;
            if (this.needEntityAcces){
                this.nodeEntity = this._items.insert(item);
            };
            this.dirty = true;
            return (itemNode);
        }
        public function clear():void{
            this._items = new ListVec3D();
            var i:int;
            while (i < this.length) {
                this.grid[i] = new ListVec3D();
                i++;
            };
        }
        public function update():void{
            var nodeList:ListVec3D;
            var node0:ListNodeVec3D;
            var node1:ListNodeVec3D;
            this.dirty = true;
            var t:int = getTimer();
            var i:int;
            while (i < this.length) {
                nodeList = this.grid[i];
                node0 = nodeList.head;
                while (node0) {
                    if (node0.time != t){
                        node0.time = t;
                        this.pos = (((((node0.data.x + this.offX) * this.m) | 0) * this.h) + ((node0.data.z + this.offY) * this.m));
                        if (this.pos >= this.length){
                            this.pos = 0;
                        };
                        if (this.pos < 0){
                            this.pos = 0;
                        };
                        if (this.pos != node0.pos){
                            node1 = this.grid[this.pos].insert(node0.data);
                            node1.pos = this.pos;
                            node1.time = t;
                            if (node0.next){
                                node0 = node0.next;
                                nodeList.remove(node0.prev);
                            } else {
                                nodeList.remove(node0);
                                node0 = null;
                            };
                        } else {
                            node0 = node0.next;
                        };
                    } else {
                        node0 = node0.next;
                    };
                };
                i++;
            };
        }
        public function getNeighbors(item:Vector3D, resultVector:Vector.<Vector3D>, radius:uint=1):ListVec3D{
            var node:ListNodeVec3D;
            var y:uint;
            var itemX:uint = (((item.x + this.offX) / this.ceilSize) | 0);
            var itemY:uint = (((item.z + this.offY) / this.ceilSize) | 0);
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
            if ((((((this.lastSearchX == itemX)) && ((this.lastSearchY == itemY)))) && (!(this.dirty)))){
                return (this.results);
            };
            this.dirty = false;
            this.lastSearchX = uint(itemX);
            this.lastSearchY = uint(itemY);
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
            this.results = new ListVec3D();
            var count:uint = ((resultVector) ? resultVector.length : 0);
            var x:uint = minX;
            while (x <= maxX) {
                this.adjX = (x * this.h);
                y = minY;
                while (y <= maxY) {
                    if ((this.adjX + y) < this.length){
                        node = this.grid[(this.adjX + y)].head;
                        while (node) {
                            this.results.insert(node.data);
                            node = node.next;
                        };
                    };
                    y++;
                };
                x++;
            };
            return (this.results);
        }
        protected function init():void{
            this.w = (Math.ceil((this.bounds.width / this.ceilSize)) + 1);
            this.h = (Math.ceil((this.bounds.height / this.ceilSize)) + 1);
            this.length = (this.w * this.h);
            this.caseCount = this.length;
            this.offX = -(this.bounds.x);
            this.offY = -(this.bounds.y);
            this.m = (1 / this.ceilSize);
            this._items = new ListVec3D();
            this.grid = new Vector.<ListVec3D>(this.length, true);
            var i:uint;
            while (i < this.length) {
                this.grid[i] = new ListVec3D();
                i++;
            };
        }
        public function getEntityCaseGrid(i:int):ListVec3D{
            return (this.grid[i]);
        }
        public function clearCaseGrid(i:int):void{
            this.grid[i] = new ListVec3D();
        }

    }
}//package wd.data 
