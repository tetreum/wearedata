package away3d.animators.data {
    import away3d.library.assets.*;
    import __AS3__.vec.*;

    public class SkeletonPose extends NamedAssetBase implements IAsset {

        public var jointPoses:Vector.<JointPose>;

        public function SkeletonPose(){
            super();
            this.jointPoses = new Vector.<JointPose>();
        }
        public function get numJointPoses():uint{
            return (this.jointPoses.length);
        }
        public function get assetType():String{
            return (AssetType.SKELETON_POSE);
        }
        public function jointPoseFromName(jointName:String):JointPose{
            var jointPoseIndex:int = this.jointPoseIndexFromName(jointName);
            if (jointPoseIndex != -1){
                return (this.jointPoses[jointPoseIndex]);
            };
            return (null);
        }
        public function jointPoseIndexFromName(jointName:String):int{
            var jointPoseIndex:int;
            var jointPose:JointPose;
            for each (jointPose in this.jointPoses) {
                if (jointPose.name == jointName){
                    return (jointPoseIndex);
                };
                jointPoseIndex++;
            };
            return (-1);
        }
        public function clone():SkeletonPose{
            var cloneJointPose:JointPose;
            var thisJointPose:JointPose;
            var clone:SkeletonPose = new SkeletonPose();
            var numJointPoses:uint = this.jointPoses.length;
            var i:uint;
            while (i < numJointPoses) {
                cloneJointPose = new JointPose();
                thisJointPose = this.jointPoses[i];
                cloneJointPose.name = thisJointPose.name;
                cloneJointPose.copyFrom(thisJointPose);
                clone.jointPoses[i] = cloneJointPose;
                i++;
            };
            return (clone);
        }
        public function dispose():void{
            this.jointPoses.length = 0;
        }

    }
}//package away3d.animators.data 
