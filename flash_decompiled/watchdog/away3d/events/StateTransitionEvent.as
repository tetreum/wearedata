package away3d.events {
    import flash.events.*;

    public class StateTransitionEvent extends Event {

        public static const TRANSITION_COMPLETE:String = "transitionComplete";

        public function StateTransitionEvent(type:String){
            super(type);
        }
        override public function clone():Event{
            return (new StateTransitionEvent(type));
        }

    }
}//package away3d.events 
