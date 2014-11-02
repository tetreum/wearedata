package wd.data {
    import wd.hud.items.*;

    public class ListNodeTracker {

        public var next:ListNodeTracker;
        public var prev:ListNodeTracker;
        public var data:Tracker;
        public var pos:uint;
        public var time:int = 0;

        public function ListNodeTracker(obj:Tracker){
            super();
            this.data = obj;
            this.next = null;
            this.prev = null;
        }
        public function insertAfter(node:ListNodeTracker):void{
            node.next = this.next;
            node.prev = this;
            if (this.next){
                this.next.prev = node;
            };
            this.next = node;
        }

    }
}//package wd.data 
