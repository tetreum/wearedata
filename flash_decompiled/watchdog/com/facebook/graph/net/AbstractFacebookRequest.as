package com.facebook.graph.net {
    import flash.net.*;
    import flash.display.*;
    import flash.utils.*;
    import flash.events.*;
    import com.json2.*;
    import com.facebook.graph.utils.*;
    import com.adobe.images.*;

    public class AbstractFacebookRequest {

        protected var urlLoader:URLLoader;
        protected var urlRequest:URLRequest;
        protected var _rawResult:String;
        protected var _data:Object;
        protected var _success:Boolean;
        protected var _url:String;
        protected var _requestMethod:String;
        protected var _callback:Function;

        public function AbstractFacebookRequest():void{
            super();
        }
        public function get rawResult():String{
            return (this._rawResult);
        }
        public function get success():Boolean{
            return (this._success);
        }
        public function get data():Object{
            return (this._data);
        }
        public function callURL(callback:Function, url:String="", locale:String=null):void{
            var data:URLVariables;
            this._callback = callback;
            this.urlRequest = new URLRequest(((url.length) ? url : this._url));
            if (locale){
                data = new URLVariables();
                data.locale = locale;
                this.urlRequest.data = data;
            };
            this.loadURLLoader();
        }
        public function set successCallback(value:Function):void{
            this._callback = value;
        }
        protected function isValueFile(value:Object):Boolean{
            return ((((((((value is FileReference)) || ((value is Bitmap)))) || ((value is BitmapData)))) || ((value is ByteArray))));
        }
        protected function objectToURLVariables(values:Object):URLVariables{
            var n:String;
            var urlVars:URLVariables = new URLVariables();
            if (values == null){
                return (urlVars);
            };
            for (n in values) {
                urlVars[n] = values[n];
            };
            return (urlVars);
        }
        public function close():void{
            if (this.urlLoader != null){
                this.urlLoader.removeEventListener(Event.COMPLETE, this.handleURLLoaderComplete);
                this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.handleURLLoaderIOError);
                this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleURLLoaderSecurityError);
                try {
                    this.urlLoader.close();
                } catch(e) {
                };
                this.urlLoader = null;
            };
        }
        protected function loadURLLoader():void{
            this.urlLoader = new URLLoader();
            this.urlLoader.addEventListener(Event.COMPLETE, this.handleURLLoaderComplete, false, 0, false);
            this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.handleURLLoaderIOError, false, 0, true);
            this.urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleURLLoaderSecurityError, false, 0, true);
            this.urlLoader.load(this.urlRequest);
        }
        protected function handleURLLoaderComplete(event:Event):void{
            this.handleDataLoad(this.urlLoader.data);
        }
        protected function handleDataLoad(result:Object, dispatchCompleteEvent:Boolean=true):void{
            var result:* = result;
            var dispatchCompleteEvent:Boolean = dispatchCompleteEvent;
            this._rawResult = (result as String);
            this._success = true;
            try {
                this._data = JSON2.decode(this._rawResult);
            } catch(e) {
                _data = _rawResult;
                _success = false;
            };
            this.handleDataReady();
            if (dispatchCompleteEvent){
                this.dispatchComplete();
            };
        }
        protected function handleDataReady():void{
        }
        protected function dispatchComplete():void{
            if (this._callback != null){
                this._callback(this);
            };
            this.close();
        }
        protected function handleURLLoaderIOError(event:IOErrorEvent):void{
            var event:* = event;
            this._success = false;
            this._rawResult = (event.target as URLLoader).data;
            if (this._rawResult != ""){
                try {
                    this._data = JSON2.decode(this._rawResult);
                } catch(e) {
                    _data = {
                        type:"Exception",
                        message:_rawResult
                    };
                };
            } else {
                this._data = event;
            };
            this.dispatchComplete();
        }
        protected function handleURLLoaderSecurityError(event:SecurityErrorEvent):void{
            var event:* = event;
            this._success = false;
            this._rawResult = (event.target as URLLoader).data;
            try {
                this._data = JSON2.decode((event.target as URLLoader).data);
            } catch(e) {
                _data = event;
            };
            this.dispatchComplete();
        }
        protected function extractFileData(values:Object):Object{
            var fileData:Object;
            var n:String;
            if (values == null){
                return (null);
            };
            if (this.isValueFile(values)){
                fileData = values;
            } else {
                if (values != null){
                    for (n in values) {
                        if (this.isValueFile(values[n])){
                            fileData = values[n];
                            delete values[n];
                            break;
                        };
                    };
                };
            };
            return (fileData);
        }
        protected function createUploadFileRequest(fileData:Object, values:Object=null):PostRequest{
            var n:String;
            var ba:ByteArray;
            var post:PostRequest = new PostRequest();
            if (values){
                for (n in values) {
                    post.writePostData(n, values[n]);
                };
            };
            if ((fileData is Bitmap)){
                fileData = (fileData as Bitmap).bitmapData;
            };
            if ((fileData is ByteArray)){
                post.writeFileData(values.fileName, (fileData as ByteArray), values.contentType);
            } else {
                if ((fileData is BitmapData)){
                    ba = PNGEncoder.encode((fileData as BitmapData));
                    post.writeFileData(values.fileName, ba, "image/png");
                };
            };
            post.close();
            this.urlRequest.contentType = ("multipart/form-data; boundary=" + post.boundary);
            return (post);
        }
        public function toString():String{
            return ((this.urlRequest.url + (((this.urlRequest.data == null)) ? "" : ("?" + unescape(this.urlRequest.data.toString())))));
        }

    }
}//package com.facebook.graph.net 
