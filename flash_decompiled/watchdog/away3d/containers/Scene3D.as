package away3d.containers {
    import __AS3__.vec.*;
    import away3d.core.partition.*;
    import away3d.core.traverse.*;
    import away3d.entities.*;
    import flash.events.*;

    public class Scene3D extends EventDispatcher {

        private var _sceneGraphRoot:ObjectContainer3D;
        private var _partitions:Vector.<Partition3D>;

        public function Scene3D(){
            super();
            this._partitions = new Vector.<Partition3D>();
            this._sceneGraphRoot = new ObjectContainer3D();
            this._sceneGraphRoot.scene = this;
            this._sceneGraphRoot._isRoot = true;
            this._sceneGraphRoot.partition = new Partition3D(new NodeBase());
        }
        public function traversePartitions(traverser:PartitionTraverser):void{
            var i:uint;
            var len:uint = this._partitions.length;
            traverser.scene = this;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                this._partitions[_temp1].traverse(traverser);
            };
        }
        public function get partition():Partition3D{
            return (this._sceneGraphRoot.partition);
        }
        public function set partition(value:Partition3D):void{
            this._sceneGraphRoot.partition = value;
        }
        public function contains(child:ObjectContainer3D):Boolean{
            return (this._sceneGraphRoot.contains(child));
        }
        public function addChild(child:ObjectContainer3D):ObjectContainer3D{
            return (this._sceneGraphRoot.addChild(child));
        }
        public function removeChild(child:ObjectContainer3D):void{
            this._sceneGraphRoot.removeChild(child);
        }
        public function getChildAt(index:uint):ObjectContainer3D{
            return (this._sceneGraphRoot.getChildAt(index));
        }
        public function get numChildren():uint{
            return (this._sceneGraphRoot.numChildren);
        }
        function registerEntity(entity:Entity):void{
            var partition:Partition3D = entity.implicitPartition;
            this.addPartitionUnique(partition);
            partition.markForUpdate(entity);
        }
        function unregisterEntity(entity:Entity):void{
            entity.implicitPartition.removeEntity(entity);
        }
        function invalidateEntityBounds(entity:Entity):void{
            entity.implicitPartition.markForUpdate(entity);
        }
        function registerPartition(entity:Entity):void{
            this.addPartitionUnique(entity.implicitPartition);
        }
        function unregisterPartition(entity:Entity):void{
            entity.implicitPartition.removeEntity(entity);
        }
        protected function addPartitionUnique(partition:Partition3D):void{
            if (this._partitions.indexOf(partition) == -1){
                this._partitions.push(partition);
            };
        }

    }
}//package away3d.containers 
