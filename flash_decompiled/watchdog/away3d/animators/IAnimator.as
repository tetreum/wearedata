package away3d.animators {
    import away3d.animators.transitions.*;
    import away3d.core.managers.*;
    import away3d.core.base.*;
    import away3d.materials.passes.*;
    import away3d.entities.*;

    public interface IAnimator {

        function get animationSet():IAnimationSet;
        function get activeState():IAnimationState;
        function get autoUpdate():Boolean;
        function set autoUpdate(_arg1:Boolean):void;
        function get time():int;
        function set time(_arg1:int):void;
        function get playbackSpeed():Number;
        function set playbackSpeed(_arg1:Number):void;
        function play(_arg1:String, _arg2:StateTransitionBase=null):void;
        function start():void;
        function stop():void;
        function update(_arg1:int):void;
        function setRenderState(_arg1:Stage3DProxy, _arg2:IRenderable, _arg3:int, _arg4:int):void;
        function testGPUCompatibility(_arg1:MaterialPassBase):void;
        function addOwner(_arg1:Mesh):void;
        function removeOwner(_arg1:Mesh):void;

    }
}//package away3d.animators 
