package away3d.animators.transitions {
    import away3d.animators.nodes.*;
    import away3d.library.assets.*;
    import away3d.events.*;

    public class StateTransitionBase extends NamedAssetBase implements IAsset {

        private var _stateTransitionComplete:StateTransitionEvent;
        private var _blendWeight:Number;
        protected var _rootNode:SkeletonBinaryLERPNode;
        public var startTime:Number = 0;
        public var blendSpeed:Number = 0.5;

        public function StateTransitionBase(){
            super();
        }
        public function get rootNode():SkeletonBinaryLERPNode{
            return (this._rootNode);
        }
        public function get blendWeight():Number{
            return (this._blendWeight);
        }
        public function set blendWeight(value:Number):void{
            if (this._blendWeight == value){
                return;
            };
            this._blendWeight = value;
            this._rootNode.blendWeight = value;
        }
        public function get startNode():ISkeletonAnimationNode{
            return (this._rootNode.inputA);
        }
        public function set startNode(value:ISkeletonAnimationNode):void{
            if (this._rootNode.inputA == value){
                return;
            };
            this._rootNode.inputA = value;
        }
        public function get endNode():ISkeletonAnimationNode{
            return (this._rootNode.inputB);
        }
        public function set endNode(value:ISkeletonAnimationNode):void{
            if (this._rootNode.inputB == value){
                return;
            };
            this._rootNode.inputB = value;
        }
        public function get assetType():String{
            return (AssetType.STATE_TRANSITION);
        }
        public function update(time:Number):void{
            this._blendWeight = (this._rootNode.blendWeight = (Math.abs((time - this.startTime)) / (1000 * this.blendSpeed)));
            this._rootNode.update(time);
            if (this._blendWeight >= 1){
                this._blendWeight = 1;
                dispatchEvent(((this._stateTransitionComplete) || ((this._stateTransitionComplete = new StateTransitionEvent(StateTransitionEvent.TRANSITION_COMPLETE)))));
            };
        }
        public function dispose():void{
        }
        public function clone(object:StateTransitionBase=null):StateTransitionBase{
            var stateTransition:StateTransitionBase = ((object) || (new StateTransitionBase()));
            stateTransition.startTime = this.startTime;
            stateTransition.blendSpeed = this.blendSpeed;
            stateTransition.startNode = this.startNode;
            stateTransition.endNode = this.endNode;
            stateTransition.rootNode.blendWeight = this._rootNode.blendWeight;
            return (stateTransition);
        }

    }
}//package away3d.animators.transitions 
