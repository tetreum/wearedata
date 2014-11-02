package away3d.animators {
    import away3d.animators.nodes.*;

    public interface IAnimationState {

        function get looping():Boolean;
        function set looping(_arg1:Boolean):void;
        function get rootNode():IAnimationNode;
        function get stateName():String;
        function reset(_arg1:int):void;
        function addOwner(_arg1:IAnimationSet, _arg2:String):void;

    }
}//package away3d.animators 
