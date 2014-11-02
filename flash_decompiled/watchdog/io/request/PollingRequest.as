package io.request {
    import flash.net.*;
    import flash.events.*;

    public class PollingRequest extends HTTPRequest {

        public function PollingRequest(delegate:IPollingRequestDelegate){
            super(delegate);
            request.method = URLRequestMethod.GET;
        }
        protected function get delegate():IPollingRequestDelegate{
            return ((_delegate as IPollingRequestDelegate));
        }
        override public function start():void{
            super.start();
            trace(("[polling request] opening: " + request.url));
        }
        override protected function onError(event:IOErrorEvent):void{
            this.delegate.pollingRequestOnError();
        }
        override protected function onComplete(event:Event):void{
            if (stream.bytesAvailable){
                this.delegate.pollingRequestOnData(stream.readUTFBytes(stream.bytesAvailable));
            };
        }

    }
}//package io.request 
