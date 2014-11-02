package io.request {
    import flash.net.*;
    import flash.events.*;

    public class PostRequest extends HTTPRequest {

        protected var _data:String;

        public function PostRequest(d:IPostRequestDelegate){
            super(d);
            request.method = URLRequestMethod.POST;
            request.contentType = "text/plain;charset=UTF-8";
        }
        public function set data(d:String):void{
            this._data = d;
        }
        protected function get delegate():IPostRequestDelegate{
            return ((_delegate as IPostRequestDelegate));
        }
        override public function start():void{
            request.data = this._data;
            super.start();
            trace(("[post request] sending: " + this._data));
        }
        override protected function onError(event:IOErrorEvent):void{
            this.delegate.postRequestOnError();
        }
        override protected function onComplete(event:Event):void{
            this.delegate.postRequestOnSuccess();
            trace("[post request] sent");
        }

    }
}//package io.request 
