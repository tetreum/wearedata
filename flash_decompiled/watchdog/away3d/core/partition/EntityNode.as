package away3d.core.partition {
    import away3d.entities.*;
    import away3d.core.traverse.*;
    import away3d.cameras.*;

    public class EntityNode extends NodeBase {

        private var _entity:Entity;
        var _updateQueueNext:EntityNode;

        public function EntityNode(entity:Entity){
            super();
            this._entity = entity;
            _numEntities = 1;
        }
        public function get entity():Entity{
            return (this._entity);
        }
        override public function acceptTraverser(traverser:PartitionTraverser):void{
            traverser.applyEntity(this._entity);
        }
        public function removeFromParent():void{
            if (_parent){
                _parent.removeNode(this);
            };
            _parent = null;
        }
        override public function isInFrustum(camera:Camera3D):Boolean{
            if (this._entity.isVisible == false){
                return (false);
            };
            this._entity.pushModelViewProjection(camera);
            return (true);
        }

    }
}//package away3d.core.partition 
