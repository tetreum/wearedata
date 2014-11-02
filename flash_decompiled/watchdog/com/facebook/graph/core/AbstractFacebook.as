package com.facebook.graph.core {
    import flash.utils.*;
    import com.facebook.graph.net.*;
    import com.facebook.graph.utils.*;
    import com.facebook.graph.data.*;
    import flash.net.*;

    public class AbstractFacebook {

        protected var session:FacebookSession;
        protected var authResponse:FacebookAuthResponse;
        protected var oauth2:Boolean;
        protected var openRequests:Dictionary;
        protected var resultHash:Dictionary;
        protected var locale:String;
        protected var parserHash:Dictionary;

        public function AbstractFacebook():void{
            super();
            this.openRequests = new Dictionary();
            this.resultHash = new Dictionary(true);
            this.parserHash = new Dictionary();
        }
        protected function get accessToken():String{
            if (((((this.oauth2) && (!((this.authResponse == null))))) || (!((this.session == null))))){
                return (((this.oauth2) ? this.authResponse.accessToken : this.session.accessToken));
            };
            return (null);
        }
        protected function api(method:String, callback:Function=null, params=null, requestMethod:String="GET"):void{
            method = ((method.indexOf("/"))!=0) ? ("/" + method) : method;
            if (this.accessToken){
                if (params == null){
                    params = {};
                };
                if (params.access_token == null){
                    params.access_token = this.accessToken;
                };
            };
            var req:FacebookRequest = new FacebookRequest();
            if (this.locale){
                params.locale = this.locale;
            };
            this.openRequests[req] = callback;
            req.call((FacebookURLDefaults.GRAPH_URL + method), requestMethod, this.handleRequestLoad, params);
        }
        protected function uploadVideo(method:String, callback:Function=null, params=null):void{
            method = ((method.indexOf("/"))!=0) ? ("/" + method) : method;
            if (this.accessToken){
                if (params == null){
                    params = {};
                };
                if (params.access_token == null){
                    params.access_token = this.accessToken;
                };
            };
            var req:FacebookRequest = new FacebookRequest();
            if (this.locale){
                params.locale = this.locale;
            };
            this.openRequests[req] = callback;
            req.call((FacebookURLDefaults.VIDEO_URL + method), "POST", this.handleRequestLoad, params);
        }
        protected function pagingCall(url:String, callback:Function):FacebookRequest{
            var req:FacebookRequest = new FacebookRequest();
            this.openRequests[req] = callback;
            req.callURL(this.handleRequestLoad, url, this.locale);
            return (req);
        }
        protected function getRawResult(data:Object):Object{
            return (this.resultHash[data]);
        }
        protected function nextPage(data:Object, callback:Function=null):FacebookRequest{
            var req:FacebookRequest;
            var rawObj:Object = this.getRawResult(data);
            if (((((rawObj) && (rawObj.paging))) && (rawObj.paging.next))){
                req = this.pagingCall(rawObj.paging.next, callback);
            } else {
                if (callback != null){
                    callback(null, "no page");
                };
            };
            return (req);
        }
        protected function previousPage(data:Object, callback:Function=null):FacebookRequest{
            var req:FacebookRequest;
            var rawObj:Object = this.getRawResult(data);
            if (((((rawObj) && (rawObj.paging))) && (rawObj.paging.previous))){
                req = this.pagingCall(rawObj.paging.previous, callback);
            } else {
                if (callback != null){
                    callback(null, "no page");
                };
            };
            return (req);
        }
        protected function handleRequestLoad(target:FacebookRequest):void{
            var data:Object;
            var p:IResultParser;
            var resultCallback:Function = this.openRequests[target];
            if (resultCallback === null){
                delete this.openRequests[target];
            };
            if (target.success){
                data = ((("data" in target.data)) ? target.data.data : target.data);
                this.resultHash[data] = target.data;
                if (data.hasOwnProperty("error_code")){
                    resultCallback(null, data);
                } else {
                    if ((this.parserHash[target] is IResultParser)){
                        p = (this.parserHash[target] as IResultParser);
                        data = p.parse(data);
                        this.parserHash[target] = null;
                        delete this.parserHash[target];
                    };
                    resultCallback(data, null);
                };
            } else {
                resultCallback(null, target.data);
            };
            delete this.openRequests[target];
        }
        protected function callRestAPI(methodName:String, callback:Function=null, values=null, requestMethod:String="GET"):void{
            var p:IResultParser;
            if (values == null){
                values = {};
            };
            values.format = "json";
            if (this.accessToken){
                values.access_token = this.accessToken;
            };
            if (this.locale){
                values.locale = this.locale;
            };
            var req:FacebookRequest = new FacebookRequest();
            this.openRequests[req] = callback;
            if ((this.parserHash[values["queries"]] is IResultParser)){
                p = (this.parserHash[values["queries"]] as IResultParser);
                this.parserHash[values["queries"]] = null;
                delete this.parserHash[values["queries"]];
                this.parserHash[req] = p;
            };
            req.call(((FacebookURLDefaults.API_URL + "/method/") + methodName), requestMethod, this.handleRequestLoad, values);
        }
        protected function fqlQuery(query:String, callback:Function=null, values:Object=null):void{
            var n:String;
            for (n in values) {
                query = query.replace(new RegExp((("\\{" + n) + "\\}"), "g"), values[n]);
            };
            this.callRestAPI("fql.query", callback, {query:query});
        }
        protected function fqlMultiQuery(queries:FQLMultiQuery, callback:Function=null, parser:IResultParser=null):void{
            this.parserHash[queries.toString()] = ((!((parser == null))) ? parser : new FQLMultiQueryParser());
            this.callRestAPI("fql.multiquery", callback, {queries:queries.toString()});
        }
        protected function batchRequest(batch:Batch, callback:Function=null):void{
            var request:FacebookBatchRequest;
            if (this.accessToken){
                request = new FacebookBatchRequest(batch, callback);
                this.resultHash[request] = true;
                request.call(this.accessToken);
            };
        }
        protected function deleteObject(method:String, callback:Function=null):void{
            var params:Object = {method:"delete"};
            this.api(method, callback, params, URLRequestMethod.POST);
        }
        protected function getImageUrl(id:String, type:String=null):String{
            return (((((FacebookURLDefaults.GRAPH_URL + "/") + id) + "/picture") + ((!((type == null))) ? ("?type=" + type) : "")));
        }

    }
}//package com.facebook.graph.core 
