package away3d.animators.nodes {
    import flash.geom.*;
    import flash.events.*;

    public interface IAnimationNode extends IEventDispatcher {

        function get looping():Boolean;
        function set looping(_arg1:Boolean):void;
        function get rootDelta():Vector3D;
        function update(_arg1:int):void;
        function reset(_arg1:int):void;

    }
}//package away3d.animators.nodes 
