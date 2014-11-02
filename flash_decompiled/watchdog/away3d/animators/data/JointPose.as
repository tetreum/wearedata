package away3d.animators.data {
    import flash.geom.*;
    import away3d.core.math.*;

    public class JointPose {

        public var name:String;
        public var orientation:Quaternion;
        public var translation:Vector3D;

        public function JointPose(){
            this.orientation = new Quaternion();
            this.translation = new Vector3D();
            super();
        }
        public function toMatrix3D(target:Matrix3D=null):Matrix3D{
            target = ((target) || (new Matrix3D()));
            this.orientation.toMatrix3D(target);
            target.appendTranslation(this.translation.x, this.translation.y, this.translation.z);
            return (target);
        }
        public function copyFrom(pose:JointPose):void{
            var or:Quaternion = pose.orientation;
            var tr:Vector3D = pose.translation;
            this.orientation.x = or.x;
            this.orientation.y = or.y;
            this.orientation.z = or.z;
            this.orientation.w = or.w;
            this.translation.x = tr.x;
            this.translation.y = tr.y;
            this.translation.z = tr.z;
        }

    }
}//package away3d.animators.data 
