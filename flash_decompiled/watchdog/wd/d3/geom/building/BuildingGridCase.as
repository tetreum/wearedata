package wd.d3.geom.building {
    import __AS3__.vec.*;

    public class BuildingGridCase {

        public var geometry:Vector.<BuildingSubGeometry3>;
        public var y:int;
        public var x:int;
        private var caseDistance:int = 8;
        public var lastTimeOnScreen:int = 0;
        private var timeBeforePurge:int = 10000;
        public var index:int;

        public function BuildingGridCase(_x:int, _y:int, i:int){
            super();
            this.x = _x;
            this.y = _y;
            this.index = i;
            this.geometry = new Vector.<BuildingSubGeometry3>();
        }
        public function isOld(time:int):Boolean{
            return ((time > (this.lastTimeOnScreen + this.timeBeforePurge)));
        }
        public function get isUsed():Boolean{
            return ((this.geometry[0]._indices.length > 0));
        }
        public function get length():int{
            return (this.geometry.length);
        }
        public function push(sub:BuildingSubGeometry3):void{
            this.geometry.push(sub);
        }
        public function awayFrom(itemX:uint, itemY:uint):Boolean{
            if (itemX > (this.x + this.caseDistance)){
                return (true);
            };
            if (itemX < (this.x - this.caseDistance)){
                return (true);
            };
            if (itemY > (this.y + this.caseDistance)){
                return (true);
            };
            if (itemY < (this.y - this.caseDistance)){
                return (true);
            };
            return (false);
        }
        public function purge():void{
            var sub:BuildingSubGeometry3;
            var numSubGeoms:int = this.geometry.length;
            while (numSubGeoms--) {
                sub = this.geometry[numSubGeoms];
                this.geometry.splice(numSubGeoms, 1);
                sub.purge();
                sub = null;
            };
            this.geometry.push(new BuildingSubGeometry3());
        }
        public function dispose():void{
            this.geometry[0].purge();
            this.geometry[0] = null;
            this.geometry.length = 0;
            this.geometry = null;
        }

    }
}//package wd.d3.geom.building 
