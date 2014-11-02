package away3d.events {
    import away3d.library.assets.*;
    import flash.events.*;

    public class AssetEvent extends Event {

        public static const ASSET_COMPLETE:String = "assetComplete";
        public static const ENTITY_COMPLETE:String = "entityComplete";
        public static const MESH_COMPLETE:String = "meshComplete";
        public static const GEOMETRY_COMPLETE:String = "geometryComplete";
        public static const SKELETON_COMPLETE:String = "skeletonComplete";
        public static const SKELETON_POSE_COMPLETE:String = "skeletonPoseComplete";
        public static const CONTAINER_COMPLETE:String = "containerComplete";
        public static const TEXTURE_COMPLETE:String = "textureComplete";
        public static const MATERIAL_COMPLETE:String = "materialComplete";
        public static const ANIMATION_SET_COMPLETE:String = "animationSetComplete";
        public static const ANIMATION_STATE_COMPLETE:String = "animationStateComplete";
        public static const ANIMATION_NODE_COMPLETE:String = "animationNodeComplete";
        public static const STATE_TRANSITION_COMPLETE:String = "stateTransitionComplete";
        public static const ASSET_RENAME:String = "assetRename";
        public static const ASSET_CONFLICT_RESOLVED:String = "assetConflictResolved";

        private var _asset:IAsset;
        private var _prevName:String;

        public function AssetEvent(type:String, asset:IAsset=null, prevName:String=null){
            super(type);
            this._asset = asset;
            this._prevName = ((prevName) || (((this._asset) ? this._asset.name : null)));
        }
        public function get asset():IAsset{
            return (this._asset);
        }
        public function get assetPrevName():String{
            return (this._prevName);
        }
        override public function clone():Event{
            return (new AssetEvent(type, this.asset, this.assetPrevName));
        }

    }
}//package away3d.events 
