package wd.data {
    import wd.hud.items.*;

    public class ListTracker {

        public var head:ListNodeTracker;
        public var tail:ListNodeTracker;

        public function ListTracker(){
            super();
            this.head = null;
            this.tail = null;
        }
        public function insert(v:Tracker):ListNodeTracker{
            var node:ListNodeTracker = new ListNodeTracker(v);
            if (this.head){
                this.tail.insertAfter(node);
                this.tail = this.tail.next;
            } else {
                this.head = (this.tail = node);
            };
            return (node);
        }
        public function remove(node:ListNodeTracker):Boolean{
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
