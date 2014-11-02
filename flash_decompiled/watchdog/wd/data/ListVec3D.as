package wd.data {
    import flash.geom.*;

    public class ListVec3D {

        public var head:ListNodeVec3D;
        public var tail:ListNodeVec3D;

        public function ListVec3D(){
            super();
            this.head = null;
            this.tail = null;
        }
        public function insert(v:Vector3D):ListNodeVec3D{
            var node:ListNodeVec3D = new ListNodeVec3D(v);
            if (this.head){
                this.tail.insertAfter(node);
                this.tail = this.tail.next;
            } else {
                this.head = (this.tail = node);
            };
            return (node);
        }
        public function remove(node:ListNodeVec3D):Boolean{
            if (node == this.head){
                this.head = this.head.next;
            } else {
                if (node == this.tail){
                    this.tail = this.tail.prev;
                };
            };
            if (node.prev){
                node.prev.next = node.next;
            };
            if (node.next){
                node.next.prev = node.prev;
            };
            node.next = (node.prev = null);
            if (this.head == null){
                this.tail = null;
            };
            return (true);
        }

    }
}//package wd.data 
