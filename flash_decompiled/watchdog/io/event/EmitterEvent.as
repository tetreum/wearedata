package io.event {
    import flash.events.*;

    public class EmitterEvent extends Event {

        public static const EMIT:String = "EmitterEvent";

        protected var _arguments:Array;

        public function EmitterEvent(type:String, arguments:Array, bubbles:Boolean=false, cancelable:Boolean=false){
            this._arguments = [];
            this._arguments = arguments;
            super(type, bubbles, cancelable);
        }
        public function get arguments():Array{
            return (this._arguments);
        }
        override public function clone():Event{
            return (new EmitterEvent(this.type, this.arguments));
        }
        override public function toString():String{
            return (formatToString("AlarmEvent", "type", "bubbles", "cancelable", "eventPhase", "message"));
        }

    }
}//package io.event 
