package away3d.animators {
    import __AS3__.vec.*;
    import away3d.materials.passes.*;
    import away3d.core.managers.*;

    public interface IAnimationSet {

        function get states():Vector.<IAnimationState>;
        function hasState(_arg1:String):Boolean;
        function getState(_arg1:String):IAnimationState;
        function addState(_arg1:String, _arg2:IAnimationState):void;
        function get usesCPU():Boolean;
        function resetGPUCompatibility():void;
        function getAGALVertexCode(_arg1:MaterialPassBase, _arg2:Array, _arg3:Array):String;
        function activate(_arg1:Stage3DProxy, _arg2:MaterialPassBase):void;
        function deactivate(_arg1:Stage3DProxy, _arg2:MaterialPassBase):void;

    }
}//package away3d.animators 
