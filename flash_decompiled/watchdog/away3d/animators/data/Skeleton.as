package away3d.animators.data {
    import away3d.library.assets.*;
    import __AS3__.vec.*;

    public class Skeleton extends NamedAssetBase implements IAsset {

        public var joints:Vector.<SkeletonJoint>;

        public function Skeleton(){
            super();
            this.joints = new Vector.<SkeletonJoint>();
        }
        public function get numJoints():uint{
            return (this.joints.length);
        }
        public function jointFromName(jointName:String):SkeletonJoint{
            var jointIndex:int = this.jointIndexFromName(jointName);
            if (jointIndex != -1){
                return (this.joints[jointIndex]);
            };
            return (null);
        }
        public function jointIndexFromName(jointName:String):int{
            var jointIndex:int;
            var joint:SkeletonJoint;
            for each (joint in this.joints) {
                if (joint.name == jointName){
                    return (jointIndex);
                };
                jointIndex++;
            };
            return (-1);
        }
        public function dispose():void{
            this.joints.length = 0;
        }
        public function get assetType():String{
            return (AssetType.SKELETON);
        }

    }
}//package away3d.animators.data 
