package away3d.animators.nodes {
    import away3d.animators.data.*;
    import flash.geom.*;
    import __AS3__.vec.*;

    public class SkeletonBinaryLERPNode extends AnimationNodeBase implements ISkeletonAnimationNode {

        private var _blendWeight:Number = 0;
        private var _skeletonPose:SkeletonPose;
        private var _skeletonPoseDirty:Boolean = true;
        public var inputA:ISkeletonAnimationNode;
        public var inputB:ISkeletonAnimationNode;

        public function SkeletonBinaryLERPNode(){
            this._skeletonPose = new SkeletonPose();
            super();
        }
        override public function reset(time:int):void{
            super.reset(time);
            this.inputA.reset(time);
            this.inputB.reset(time);
        }
        public function getSkeletonPose(skeleton:Skeleton):SkeletonPose{
            if (this._skeletonPoseDirty){
                this.updateSkeletonPose(skeleton);
            };
            return (this._skeletonPose);
        }
        public function get blendWeight():Number{
            return (this._blendWeight);
        }
        public function set blendWeight(value:Number):void{
            this._blendWeight = value;
            _rootDeltaDirty = true;
            this._skeletonPoseDirty = true;
        }
        protected function updateSkeletonPose(skeleton:Skeleton):void{
            var endPose:JointPose;
            var pose1:JointPose;
            var pose2:JointPose;
            var p1:Vector3D;
            var p2:Vector3D;
            var tr:Vector3D;
            this._skeletonPoseDirty = false;
            var endPoses:Vector.<JointPose> = this._skeletonPose.jointPoses;
            var poses1:Vector.<JointPose> = this.inputA.getSkeletonPose(skeleton).jointPoses;
            var poses2:Vector.<JointPose> = this.inputB.getSkeletonPose(skeleton).jointPoses;
            var numJoints:uint = skeleton.numJoints;
            if (endPoses.length != numJoints){
                endPoses.length = numJoints;
            };
            var i:uint;
            while (i < numJoints) {
                endPose = (endPoses[i] = ((endPoses[i]) || (new JointPose())));
                pose1 = poses1[i];
                pose2 = poses2[i];
                p1 = pose1.translation;
                p2 = pose2.translation;
                endPose.orientation.lerp(pose1.orientation, pose2.orientation, this._blendWeight);
                tr = endPose.translation;
                tr.x = (p1.x + (this._blendWeight * (p2.x - p1.x)));
                tr.y = (p1.y + (this._blendWeight * (p2.y - p1.y)));
                tr.z = (p1.z + (this._blendWeight * (p2.z - p1.z)));
                i++;
            };
        }
        override protected function updateTime(time:int):void{
            super.updateTime(time);
            this.inputA.update(time);
            this.inputB.update(time);
            this._skeletonPoseDirty = true;
        }
        override protected function updateRootDelta():void{
            _rootDeltaDirty = false;
            var deltA:Vector3D = this.inputA.rootDelta;
            var deltB:Vector3D = this.inputB.rootDelta;
            _rootDelta.x = (deltA.x + (this._blendWeight * (deltB.x - deltA.x)));
            _rootDelta.y = (deltA.y + (this._blendWeight * (deltB.y - deltA.y)));
            _rootDelta.z = (deltA.z + (this._blendWeight * (deltB.z - deltA.z)));
        }

    }
}//package away3d.animators.nodes 
