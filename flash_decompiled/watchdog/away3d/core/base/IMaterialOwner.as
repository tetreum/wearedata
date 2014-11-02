package away3d.core.base {
    import away3d.materials.*;
    import away3d.animators.*;

    public interface IMaterialOwner {

        function get material():MaterialBase;
        function set material(_arg1:MaterialBase):void;
        function get animator():IAnimator;

    }
}//package away3d.core.base 
