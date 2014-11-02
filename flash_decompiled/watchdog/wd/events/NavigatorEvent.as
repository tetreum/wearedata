package wd.events {
    import flash.events.*;

    public class NavigatorEvent extends Event {

        public static const LOCATION_CHANGE:String = "locationChange";
        public static const LOADING_START:String = "loadingStart";
        public static const LOADING_STOP:String = "loadingStop";
        public static const LOADING_PROGRESS:String = "loadingProgress";
        public static const TARGET_REACHED:String = "targetReached";
        public static const SET_START_LOCATION:String = "setStartLocation";
        public static const INTRO_VISIBLE:String = "introVisible";
        public static const INTRO_HIDDEN:String = "introHidden";
        public static const INTRO_SHOW:String = "introShow";
        public static const INTRO_HIDE:String = "introHide";
        public static const ZOOM_CHANGE:String = "ZOOM_CHANGE";
        public static const DO_WAVE:String = "doWave";

        public var data;

        public function NavigatorEvent(type:String, data=null, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
            this.data = data;
        }
        override public function clone():Event{
            return (new NavigatorEvent(type, this.data, bubbles, cancelable));
        }
        override public function toString():String{
            return (formatToString("NavigatorEvent", "type", "data", "bubbles", "cancelable", "eventPhase"));
        }

    }
}//package wd.events 
