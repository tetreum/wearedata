package com.facebook.graph.net {
    import com.facebook.graph.data.*;
    import flash.net.*;
    import com.facebook.graph.core.*;
    import com.json2.*;
    import flash.utils.*;
    import com.facebook.graph.utils.*;
    import flash.display.*;
    import com.adobe.images.*;

    public class FacebookBatchRequest extends AbstractFacebookRequest {

        protected var _params:Object;
        protected var _relativeURL:String;
        protected var _fileData:Object;
        protected var _accessToken:String;
        protected var _batch:Batch;

        public function FacebookBatchRequest(batch:Batch, completeCallback:Function=null){
            super();
            this._batch = batch;
            _callback = completeCallback;
        }
        public function call(accessToken:String):void{
            var request:BatchItem;
            var fileData:Object;
            var params:Object;
            var urlVars:String;
            var requestVars:URLVariables;
            this._accessToken = accessToken;
            urlRequest = new URLRequest(FacebookURLDefaults.GRAPH_URL);
            urlRequest.method = URLRequestMethod.POST;
            var formatted:Array = [];
            var files:Array = [];
            var hasFiles:Boolean;
            var requests:Array = this._batch.requests;
            var l:uint = requests.length;
            var i:uint;
            while (i < l) {
                request = requests[i];
                fileData = this.extractFileData(request.params);
                params = {
                    method:request.requestMethod,
                    relative_url:request.relativeURL
                };
                if (request.params){
                    if (request.params["contentType"] != undefined){
                        params.contentType = request.params["contentType"];
                    };
                    urlVars = this.objectToURLVariables(request.params).toString();
                    if ((((request.requestMethod == URLRequestMethod.GET)) || ((request.requestMethod.toUpperCase() == "DELETE")))){
                        params.relative_url = (params.relative_url + ("?" + urlVars));
                    } else {
                        params.body = urlVars;
                    };
                };
                formatted.push(params);
                if (fileData){
                    files.push(fileData);
                    params.attached_files = (((request.params.fileName == null)) ? ("file" + i) : request.params.fileName);
                    hasFiles = true;
                } else {
                    files.push(null);
                };
                i++;
            };
            if (!(hasFiles)){
                requestVars = new URLVariables();
                requestVars.access_token = accessToken;
                requestVars.batch = JSON2.encode(formatted);
                urlRequest.data = requestVars;
                loadURLLoader();
            } else {
                this.sendPostRequest(formatted, files);
            };
        }
        protected function sendPostRequest(requests:Array, files:Array):void{
            var values:Object;
            var fileData:Object;
            var ba:ByteArray;
            var post:PostRequest = new PostRequest();
            post.writePostData("access_token", this._accessToken);
            post.writePostData("batch", JSON2.encode(requests));
            var l:uint = requests.length;
            var i:uint;
            while (i < l) {
                values = requests[i];
                fileData = files[i];
                if (fileData){
                    if ((fileData is Bitmap)){
                        fileData = (fileData as Bitmap).bitmapData;
                    };
                    if ((fileData is ByteArray)){
                        post.writeFileData(values.attached_files, (fileData as ByteArray), values.contentType);
                    } else {
                        if ((fileData is BitmapData)){
                            ba = PNGEncoder.encode((fileData as BitmapData));
                            post.writeFileData(values.attached_files, ba, "image/png");
                        };
                    };
                };
                i++;
            };
            post.close();
            urlRequest.contentType = ("multipart/form-data; boundary=" + post.boundary);
            urlRequest.data = post.getPostData();
            loadURLLoader();
        }
        override protected function handleDataReady():void{
            var body:Object;
            var results:Array = (_data as Array);
            var l:uint = results.length;
            var i:uint;
            while (i < l) {
                body = JSON2.decode(_data[i].body);
                _data[i].body = body;
                if ((this._batch.requests[i] as BatchItem).callback != null){
                    (this._batch.requests[i] as BatchItem).callback(_data[i]);
                };
                i++;
            };
        }

    }
}//package com.facebook.graph.net 
