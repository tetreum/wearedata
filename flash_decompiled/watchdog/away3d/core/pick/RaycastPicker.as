package away3d.core.pick {
    import __AS3__.vec.*;
    import away3d.entities.*;
    import flash.geom.*;
    import away3d.bounds.*;
    import away3d.core.traverse.*;
    import away3d.core.data.*;
    import away3d.containers.*;

    public class RaycastPicker implements IPicker {

        private var _findClosestCollision:Boolean;
        protected var _entities:Vector.<Entity>;
        protected var _numEntities:uint;
        protected var _hasCollisions:Boolean;

        public function RaycastPicker(findClosestCollision:Boolean){
            super();
            this._findClosestCollision = findClosestCollision;
            this._entities = new Vector.<Entity>();
        }
        public function getViewCollision(x:Number, y:Number, view:View3D):PickingCollisionVO{
            var entity:Entity;
            var i:uint;
            var localRayPosition:Vector3D;
            var localRayDirection:Vector3D;
            var rayEntryDistance:Number;
            var pickingCollisionVO:PickingCollisionVO;
            var bestCollisionVO:PickingCollisionVO;
            var invSceneTransform:Matrix3D;
            var bounds:BoundingVolumeBase;
            var collector:EntityCollector = view.entityCollector;
            if (collector.numMouseEnableds == 0){
                return (null);
            };
            var rayPosition:Vector3D = view.unproject(x, y, 0);
            var rayDirection:Vector3D = view.unproject(x, y, 1);
            rayDirection = rayDirection.subtract(rayPosition);
            this._hasCollisions = false;
            this._numEntities = 0;
            var node:EntityListItem = collector.entityHead;
            while (node) {
                entity = node.entity;
                if (((((entity.visible) && (entity._ancestorsAllowMouseEnabled))) && (entity.mouseEnabled))){
                    pickingCollisionVO = entity.pickingCollisionVO;
                    invSceneTransform = entity.inverseSceneTransform;
                    bounds = entity.bounds;
                    localRayPosition = invSceneTransform.transformVector(rayPosition);
                    localRayDirection = invSceneTransform.deltaTransformVector(rayDirection);
                    rayEntryDistance = bounds.rayIntersection(localRayPosition, localRayDirection, (pickingCollisionVO.localNormal = ((pickingCollisionVO.localNormal) || (new Vector3D()))));
                    if (rayEntryDistance >= 0){
                        this._hasCollisions = true;
                        pickingCollisionVO.rayEntryDistance = rayEntryDistance;
                        pickingCollisionVO.localRayPosition = localRayPosition;
                        pickingCollisionVO.localRayDirection = localRayDirection;
                        pickingCollisionVO.rayOriginIsInsideBounds = (rayEntryDistance == 0);
                        var _local18 = this._numEntities++;
                        this._entities[_local18] = entity;
                    };
                };
                node = node.next;
            };
            this._entities.length = this._numEntities;
            this._entities = this._entities.sort(this.sortOnNearT);
            if (!(this._hasCollisions)){
                return (null);
            };
            var shortestCollisionDistance:Number = Number.MAX_VALUE;
            i = 0;
            while (i < this._numEntities) {
                entity = this._entities[i];
                pickingCollisionVO = entity._pickingCollisionVO;
                if (entity.pickingCollider){
                    if ((((((bestCollisionVO == null)) || ((pickingCollisionVO.rayEntryDistance < bestCollisionVO.rayEntryDistance)))) && (entity.collidesBefore(shortestCollisionDistance, this._findClosestCollision)))){
                        shortestCollisionDistance = pickingCollisionVO.rayEntryDistance;
                        bestCollisionVO = pickingCollisionVO;
                        if (!(this._findClosestCollision)){
                            this.updateLocalPosition(pickingCollisionVO);
                            return (pickingCollisionVO);
                        };
                    };
                } else {
                    if ((((bestCollisionVO == null)) || ((pickingCollisionVO.rayEntryDistance < bestCollisionVO.rayEntryDistance)))){
                        this.updateLocalPosition(pickingCollisionVO);
                        return (pickingCollisionVO);
                    };
                };
                i++;
            };
            return (bestCollisionVO);
        }
        private function updateLocalPosition(pickingCollisionVO:PickingCollisionVO):void{
            var collisionPos:Vector3D = (pickingCollisionVO.localPosition = ((pickingCollisionVO.localPosition) || (new Vector3D())));
            var rayDir:Vector3D = pickingCollisionVO.localRayDirection;
            var rayPos:Vector3D = pickingCollisionVO.localRayPosition;
            var t:Number = pickingCollisionVO.rayEntryDistance;
            collisionPos.x = (rayPos.x + (t * rayDir.x));
            collisionPos.y = (rayPos.y + (t * rayDir.y));
            collisionPos.z = (rayPos.z + (t * rayDir.z));
        }
        public function getSceneCollision(position:Vector3D, direction:Vector3D, scene:Scene3D):PickingCollisionVO{
            return (null);
        }
        private function sortOnNearT(entity1:Entity, entity2:Entity):Number{
            return ((((entity1.pickingCollisionVO.rayEntryDistance > entity2.pickingCollisionVO.rayEntryDistance)) ? 1 : -1));
        }

    }
}//package away3d.core.pick 
