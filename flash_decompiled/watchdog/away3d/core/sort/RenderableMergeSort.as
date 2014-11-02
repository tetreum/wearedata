package away3d.core.sort {
    import away3d.core.traverse.*;
    import away3d.core.data.*;

    public class RenderableMergeSort extends EntitySorterBase {

        public function RenderableMergeSort(){
            super();
        }
        override public function sort(collector:EntityCollector):void{
            collector.opaqueRenderableHead = this.mergeSortByMaterial(collector.opaqueRenderableHead);
            collector.blendedRenderableHead = this.mergeSortByDepth(collector.blendedRenderableHead);
        }
        private function mergeSortByDepth(head:RenderableListItem):RenderableListItem{
            var headB:RenderableListItem;
            var fast:RenderableListItem;
            var slow:RenderableListItem;
            var result:RenderableListItem;
            var curr:RenderableListItem;
            var l:RenderableListItem;
            if (((!(head)) || (!(head.next)))){
                return (head);
            };
            slow = head;
            fast = head.next;
            while (fast) {
                fast = fast.next;
                if (fast){
                    slow = slow.next;
                    fast = fast.next;
                };
            };
            headB = slow.next;
            slow.next = null;
            head = this.mergeSortByDepth(head);
            headB = this.mergeSortByDepth(headB);
            if (!(head)){
                return (headB);
            };
            if (!(headB)){
                return (head);
            };
            while (((head) && (headB))) {
                if (head.zIndex < headB.zIndex){
                    l = head;
                    head = head.next;
                } else {
                    l = headB;
                    headB = headB.next;
                };
                if (!(result)){
                    result = l;
                } else {
                    curr.next = l;
                };
                curr = l;
            };
            if (head){
                curr.next = head;
            } else {
                if (headB){
                    curr.next = headB;
                };
            };
            return (result);
        }
        private function mergeSortByMaterial(head:RenderableListItem):RenderableListItem{
            var headB:RenderableListItem;
            var fast:RenderableListItem;
            var slow:RenderableListItem;
            var result:RenderableListItem;
            var curr:RenderableListItem;
            var l:RenderableListItem;
            var cmp:int;
            var aid:uint;
            var bid:uint;
            var ma:uint;
            var mb:uint;
            if (((!(head)) || (!(head.next)))){
                return (head);
            };
            slow = head;
            fast = head.next;
            while (fast) {
                fast = fast.next;
                if (fast){
                    slow = slow.next;
                    fast = fast.next;
                };
            };
            headB = slow.next;
            slow.next = null;
            head = this.mergeSortByMaterial(head);
            headB = this.mergeSortByMaterial(headB);
            if (!(head)){
                return (headB);
            };
            if (!(headB)){
                return (head);
            };
            while (((head) && (headB))) {
                aid = head.renderOrderId;
                bid = headB.renderOrderId;
                if (aid == bid){
                    ma = head.materialId;
                    mb = headB.materialId;
                    if (ma == mb){
                        if (head.zIndex < headB.zIndex){
                            cmp = 1;
                        } else {
                            cmp = -1;
                        };
                    } else {
                        if (ma > mb){
                            cmp = 1;
                        } else {
                            cmp = -1;
                        };
                    };
                } else {
                    if (aid > bid){
                        cmp = 1;
                    } else {
                        cmp = -1;
                    };
                };
                if (cmp < 0){
                    l = head;
                    head = head.next;
                } else {
                    l = headB;
                    headB = headB.next;
                };
                if (!(result)){
                    result = l;
                    curr = l;
                } else {
                    curr.next = l;
                    curr = l;
                };
            };
            if (head){
                curr.next = head;
            } else {
                if (headB){
                    curr.next = headB;
                };
            };
            return (result);
        }

    }
}//package away3d.core.sort 
