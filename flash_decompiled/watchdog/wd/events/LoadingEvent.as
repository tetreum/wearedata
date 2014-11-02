package wd.events {
    import flash.events.*;

    public class LoadingEvent extends Event {

        public static const CITY_COMPLETE:String = "cityComplete";
        public static const CONFIG_COMPLETE:String = "configComplete";
        public static const CSS_COMPLETE:String = "cssComplete";

        public function LoadingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
        }
        override public function clone():Event{
            return (new LoadingEvent(type, bubbles, cancelable));
        }
        override public function toString():String{
            return (formatToString("LoadingEvent", "type", "bubbles", "cancelable", "eventPhase"));
        }

    }
}//package wd.events 
