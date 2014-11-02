package away3d.core.partition {
    import away3d.core.traverse.*;
    import away3d.entities.*;

    public class Partition3D {

        private var _rootNode:NodeBase;
        private var _updatesMade:Boolean;
        private var _updateQueue:EntityNode;

        public function Partition3D(rootNode:NodeBase){
            super();
            this._rootNode = ((rootNode) || (new NullNode()));
        }
        public function get showDebugBounds():Boolean{
            return (this._rootNode.showDebugBounds);
        }
        public function set showDebugBounds(value:Boolean):void{
        }
        public function traverse(traverser:PartitionTraverser):void{
            if (((((this._updatesMade) && ((traverser is EntityCollector)))) && (!((traverser is ShadowCasterCollector))))){
                this.updateEntities();
            };
            this._rootNode.acceptTraverser(traverser);
        }
        function markForUpdate(entity:Entity):void{
            var node:EntityNode = entity.getEntityPartitionNode();
            var t:EntityNode = this._updateQueue;
            while (t) {
                if (node == t){
                    return;
                };
                t = t._updateQueueNext;
            };
            node._updateQueueNext = this._updateQueue;
            this._updateQueue = node;
            this._updatesMade = true;
        }
        function removeEntity(entity:Entity):void{
            var t:EntityNode;
            var node:EntityNode = entity.getEntityPartitionNode();
            node.removeFromParent();
            if (node == this._updateQueue){
                this._updateQueue = node._updateQueueNext;
            } else {
                t = this._updateQueue;
                while (((t) && (!((t._updateQueueNext == node))))) {
                    t = t._updateQueueNext;
                };
                if (t){
                    t._updateQueueNext = node._updateQueueNext;
                };
            };
            node._updateQueueNext = null;
            if (!(this._updateQueue)){
                this._updatesMade = false;
            };
        }
        private function updateEntities():void{
            var targetNode:NodeBase;
            var t:EntityNode;
            var node:EntityNode = this._updateQueue;
            this._updateQueue = null;
            this._updatesMade = false;
            do  {
                targetNode = this._rootNode.findPartitionForEntity(node.entity);
                if (node.parent != targetNode){
                    if (node){
                        node.removeFromParent();
                    };
                    targetNode.addNode(node);
                };
                t = node._updateQueueNext;
                node._updateQueueNext = null;
                node.entity.internalUpdate();
                node = t;
            } while (node);
        }

    }
}//package away3d.core.partition 
