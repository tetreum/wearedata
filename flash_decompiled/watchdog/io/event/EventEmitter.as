package io.event {
    import flash.utils.*;
    import flash.events.*;

    public class EventEmitter extends EventDispatcher {

        protected var callbacks:Dictionary;

        public function EventEmitter(){
            this.callbacks = new Dictionary();
            super();
        }
        public function on(type:String, cb:Function):void{
            var type:* = type;
            var cb:* = cb;
            if (!(this.callbacks[cb])){
                this.callbacks[cb] = function (e:EmitterEvent):void{
                    cb.apply(null, e.arguments);
                };
            };
            addEventListener(type, this.callbacks[cb], false, 0, true);
        }
        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
            super.removeEventListener(type, ((this.callbacks[listener]) || (listener)), useCapture);
        }
        public function once(type:String, cb:Function):void{
            var self:* = null;
            var event_remover:* = null;
            var type:* = type;
            var cb:* = cb;
            event_remover = function ():void{
                cb();
                self.removeEventListener(type, event_remover);
            };
            self = this;
            this.on(type, event_remover);
        }
        public function emit(name:String, ... _args):void{
            dispatchEvent(new EmitterEvent(name, _args));
        }

    }
}//package io.event 
