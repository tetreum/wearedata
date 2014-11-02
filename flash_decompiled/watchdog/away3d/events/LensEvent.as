package away3d.events {
    import away3d.cameras.lenses.*;
    import flash.events.*;

    public class LensEvent extends Event {

        public static const MATRIX_CHANGED:String = "matrixChanged";

        private var _lens:LensBase;

        public function LensEvent(type:String, lens:LensBase, bubbles:Boolean=false, cancelable:Boolean=false){
            super(type, bubbles, cancelable);
            this._lens = lens;
        }
        public function get lens():LensBase{
            return (this._lens);
        }
        override public function clone():Event{
            return (new LensEvent(type, this._lens, bubbles, cancelable));
        }

    }
}//package away3d.events 
