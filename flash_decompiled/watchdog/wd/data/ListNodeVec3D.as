package wd.data {
    import flash.geom.*;

    public class ListNodeVec3D {

        public var next:ListNodeVec3D;
        public var prev:ListNodeVec3D;
        public var data:Vector3D;
        public var pos:uint;
        public var time:int = 0;

        public function ListNodeVec3D(obj:Vector3D){
            super();
            this.data = obj;
            this.next = null;
            this.prev = null;
        }
        public function insertAfter(node:ListNodeVec3D):void{
            node.next = this.next;
            node.prev = this;
            if (this.next){
                this.next.prev = node;
            };
            this.next = node;
        }

    }
}//package wd.data 
