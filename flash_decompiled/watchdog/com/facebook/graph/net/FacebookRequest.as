package com.facebook.graph.net {
    import flash.net.*;
    import flash.events.*;

    public class FacebookRequest extends AbstractFacebookRequest {

        protected var fileReference:FileReference;

        public function FacebookRequest():void{
            super();
        }
        public function call(url:String, requestMethod:String="GET", callback:Function=null, values=null):void{
            _url = url;
            _requestMethod = requestMethod;
            _callback = callback;
            var requestUrl:String = url;
            urlRequest = new URLRequest(requestUrl);
            urlRequest.method = _requestMethod;
            if (values == null){
                loadURLLoader();
                return;
            };
            var fileData:Object = extractFileData(values);
            if (fileData == null){
                urlRequest.data = objectToURLVariables(values);
                loadURLLoader();
                return;
            };
            if ((fileData is FileReference)){
                urlRequest.data = objectToURLVariables(values);
                urlRequest.method = URLRequestMethod.POST;
                this.fileReference = (fileData as FileReference);
                this.fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, this.handleFileReferenceData, false, 0, true);
                this.fileReference.addEventListener(IOErrorEvent.IO_ERROR, this.handelFileReferenceError, false, 0, false);
                this.fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handelFileReferenceError, false, 0, false);
                this.fileReference.upload(urlRequest);
                return;
            };
            urlRequest.data = createUploadFileRequest(fileData, values).getPostData();
            urlRequest.method = URLRequestMethod.POST;
            loadURLLoader();
        }
        override public function close():void{
            super.close();
            if (this.fileReference != null){
                this.fileReference.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, this.handleFileReferenceData);
                this.fileReference.removeEventListener(IOErrorEvent.IO_ERROR, this.handelFileReferenceError);
                this.fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handelFileReferenceError);
                try {
                    this.fileReference.cancel();
                } catch(e) {
                };
                this.fileReference = null;
            };
        }
        protected function handleFileReferenceData(event:DataEvent):void{
            handleDataLoad(event.data);
        }
        protected function handelFileReferenceError(event:ErrorEvent):void{
            _success = false;
            _data = event;
            dispatchComplete();
        }

    }
}//package com.facebook.graph.net 
