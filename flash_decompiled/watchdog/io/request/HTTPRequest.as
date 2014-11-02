package io.request {
    import flash.net.*;
    import flash.events.*;

    public class HTTPRequest {

        protected var _delegate:IHTTPRequestDelegate;
        protected var request:URLRequest;
        protected var stream:URLStream;

        public function HTTPRequest(d:IHTTPRequestDelegate){
            this.request = new URLRequest();
            this.stream = new URLStream();
            super();
            this._delegate = d;
            this.stream.addEventListener(IOErrorEvent.IO_ERROR, this.onError, false, 0, true);
            this.stream.addEventListener(Event.COMPLETE, this.onComplete, false, 0, true);
        }
        public function start():void{
            this.request.url = this._delegate.getURLFor(this);
            this.stream.load(this.request);
        }
        public function stop():void{
            if (this.stream.connected){
                this.stream.close();
            };
        }
        protected function onError(event:IOErrorEvent):void{
        }
        protected function onComplete(event:Event):void{
        }

    }
}//package io.request 
