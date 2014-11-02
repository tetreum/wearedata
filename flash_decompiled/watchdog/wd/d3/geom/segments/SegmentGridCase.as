package wd.d3.geom.segments {
    import __AS3__.vec.*;

    public class SegmentGridCase {

        public var geometry:Vector.<SegmentGridSortableSubGeometry>;
        public var y:int;
        public var x:int;

        public function SegmentGridCase(_x:int, _y:int){
            super();
            this.x = _x;
            this.y = _y;
            this.geometry = new Vector.<SegmentGridSortableSubGeometry>();
        }
        public function push(sub:SegmentGridSortableSubGeometry):void{
            this.geometry.push(sub);
        }
        public function get isUsed():Boolean{
            return ((this.geometry[0]._indices.length > 0));
        }
        public function dispose():void{
            this.geometry[0].purge();
            this.geometry[0] = null;
            this.geometry.length = 0;
            this.geometry = null;
        }

    }
}//package wd.d3.geom.segments 
