package away3d.core.partition {
    import __AS3__.vec.*;
    import away3d.cameras.*;
    import away3d.entities.*;
    import away3d.core.traverse.*;
    import away3d.primitives.*;

    public class NodeBase {

        protected var _parent:NodeBase;
        protected var _childNodes:Vector.<NodeBase>;
        protected var _numChildNodes:uint;
        private var _debugPrimitive:WireframePrimitiveBase;
        var _numEntities:int;

        public function NodeBase(){
            super();
            this._childNodes = new Vector.<NodeBase>();
        }
        public function get showDebugBounds():Boolean{
            return (!((this._debugPrimitive == null)));
        }
        public function set showDebugBounds(value:Boolean):void{
            if (Boolean(this._debugPrimitive) == value){
                return;
            };
            if (value){
                this._debugPrimitive = this.createDebugBounds();
            } else {
                this._debugPrimitive.dispose();
                this._debugPrimitive = null;
            };
            var i:uint;
            while (i < this._numChildNodes) {
                this._childNodes[i].showDebugBounds = value;
                i++;
            };
        }
        public function get parent():NodeBase{
            return (this._parent);
        }
        public function addNode(node:NodeBase):void{
            node._parent = this;
            this._numEntities = (this._numEntities + node._numEntities);
            var _local3 = this._numChildNodes++;
            this._childNodes[_local3] = node;
            node.showDebugBounds = this.showDebugBounds;
            var numEntities:int = node._numEntities;
            node = this;
            do  {
                node._numEntities = (node._numEntities + numEntities);
                node = node._parent;
            } while (node);
        }
        public function removeNode(node:NodeBase):void{
            var index:uint = this._childNodes.indexOf(node);
            this._childNodes[index] = this._childNodes[--this._numChildNodes];
            this._childNodes.pop();
            var numEntities:int = node._numEntities;
            node = this;
            do  {
                node._numEntities = (node._numEntities - numEntities);
                node = node._parent;
            } while (node);
        }
        public function isInFrustum(camera:Camera3D):Boolean{
            camera = null;
            return (true);
        }
        public function findPartitionForEntity(entity:Entity):NodeBase{
            entity = null;
            return (this);
        }
        public function acceptTraverser(traverser:PartitionTraverser):void{
            var i:uint;
            if (this._numEntities == 0){
                return;
            };
            if (traverser.enterNode(this)){
                while (i < this._numChildNodes) {
                    var _temp1 = i;
                    i = (i + 1);
                    this._childNodes[_temp1].acceptTraverser(traverser);
                };
                if (this._debugPrimitive){
                    traverser.applyRenderable(this._debugPrimitive);
                };
            };
            traverser.leaveNode(this);
        }
        protected function createDebugBounds():WireframePrimitiveBase{
            return (null);
        }

    }
}//package away3d.core.partition 
