package com.facebook.graph {
    import flash.net.*;
    import com.facebook.graph.core.*;
    import com.facebook.graph.net.*;
    import com.facebook.graph.data.*;
    import com.facebook.graph.utils.*;
    import flash.utils.*;
    import flash.external.*;
    import com.json2.*;

    public class Facebook extends AbstractFacebook {

        protected static var _instance:Facebook;
        protected static var _canInit:Boolean = false;

        protected var jsCallbacks:Object;
        protected var openUICalls:Dictionary;
        protected var jsBridge:FacebookJSBridge;
        protected var applicationId:String;
        protected var _initCallback:Function;
        protected var _loginCallback:Function;
        protected var _logoutCallback:Function;

        public function Facebook(){
            super();
            if (_canInit == false){
                throw (new Error("Facebook is an singleton and cannot be instantiated."));
            };
            this.jsBridge = new FacebookJSBridge();
            this.jsCallbacks = {};
            this.openUICalls = new Dictionary();
        }
        public static function init(applicationId:String, callback:Function=null, options:Object=null, accessToken:String=null):void{
            getInstance().init(applicationId, callback, options, accessToken);
        }
        public static function set locale(value:String):void{
            getInstance().locale = value;
        }
        public static function login(callback:Function, options:Object=null):void{
            getInstance().login(callback, options);
        }
        public static function mobileLogin(redirectUri:String, display:String="touch", extendedPermissions:Array=null):void{
            var data:URLVariables = new URLVariables();
            data.client_id = getInstance().applicationId;
            data.redirect_uri = redirectUri;
            data.display = display;
            if (extendedPermissions != null){
                data.scope = extendedPermissions.join(",");
            };
            var req:URLRequest = new URLRequest(FacebookURLDefaults.AUTH_URL);
            req.method = URLRequestMethod.GET;
            req.data = data;
            navigateToURL(req, "_self");
        }
        public static function mobileLogout(redirectUri:String):void{
            getInstance().authResponse = null;
            var data:URLVariables = new URLVariables();
            data.confirm = 1;
            data.next = redirectUri;
            var req:URLRequest = new URLRequest("http://m.facebook.com/logout.php");
            req.method = URLRequestMethod.GET;
            req.data = data;
            navigateToURL(req, "_self");
        }
        public static function logout(callback:Function):void{
            getInstance().logout(callback);
        }
        public static function ui(method:String, data:Object, callback:Function=null, display:String=null):void{
            getInstance().ui(method, data, callback, display);
        }
        public static function api(method:String, callback:Function=null, params=null, requestMethod:String="GET"):void{
            getInstance().api(method, callback, params, requestMethod);
        }
        public static function getRawResult(data:Object):Object{
            return (getInstance().getRawResult(data));
        }
        public static function hasNext(data:Object):Boolean{
            var result:Object = getInstance().getRawResult(data);
            if (!(result.paging)){
                return (false);
            };
            return (!((result.paging.next == null)));
        }
        public static function hasPrevious(data:Object):Boolean{
            var result:Object = getInstance().getRawResult(data);
            if (!(result.paging)){
                return (false);
            };
            return (!((result.paging.previous == null)));
        }
        public static function nextPage(data:Object, callback:Function):FacebookRequest{
            return (getInstance().nextPage(data, callback));
        }
        public static function previousPage(data:Object, callback:Function):FacebookRequest{
            return (getInstance().previousPage(data, callback));
        }
        public static function postData(method:String, callback:Function=null, params:Object=null):void{
            api(method, callback, params, URLRequestMethod.POST);
        }
        public static function uploadVideo(method:String, callback:Function=null, params=null):void{
            getInstance().uploadVideo(method, callback, params);
        }
        public static function fqlQuery(query:String, callback:Function=null, values:Object=null):void{
            getInstance().fqlQuery(query, callback, values);
        }
        public static function fqlMultiQuery(queries:FQLMultiQuery, callback:Function=null, parser:IResultParser=null):void{
            getInstance().fqlMultiQuery(queries, callback, parser);
        }
        public static function batchRequest(batch:Batch, callback:Function=null):void{
            getInstance().batchRequest(batch, callback);
        }
        public static function callRestAPI(methodName:String, callback:Function, values=null, requestMethod:String="GET"):void{
            getInstance().callRestAPI(methodName, callback, values, requestMethod);
        }
        public static function getImageUrl(id:String, type:String=null):String{
            return (getInstance().getImageUrl(id, type));
        }
        public static function deleteObject(method:String, callback:Function=null):void{
            getInstance().deleteObject(method, callback);
        }
        public static function addJSEventListener(event:String, listener:Function):void{
            getInstance().addJSEventListener(event, listener);
        }
        public static function removeJSEventListener(event:String, listener:Function):void{
            getInstance().removeJSEventListener(event, listener);
        }
        public static function hasJSEventListener(event:String, listener:Function):Boolean{
            return (getInstance().hasJSEventListener(event, listener));
        }
        public static function setCanvasAutoResize(autoSize:Boolean=true, interval:uint=100):void{
            getInstance().setCanvasAutoResize(autoSize, interval);
        }
        public static function setCanvasSize(width:Number, height:Number):void{
            getInstance().setCanvasSize(width, height);
        }
        public static function callJS(methodName:String, params:Object):void{
            getInstance().callJS(methodName, params);
        }
        public static function getAuthResponse():FacebookAuthResponse{
            return (getInstance().getAuthResponse());
        }
        public static function getLoginStatus():void{
            getInstance().getLoginStatus();
        }
        protected static function getInstance():Facebook{
            if (_instance == null){
                _canInit = true;
                _instance = new (Facebook)();
                _canInit = false;
            };
            return (_instance);
        }

        protected function init(applicationId:String, callback:Function=null, options:Object=null, accessToken:String=null):void{
            ExternalInterface.addCallback("handleJsEvent", this.handleJSEvent);
            ExternalInterface.addCallback("authResponseChange", this.handleAuthResponseChange);
            ExternalInterface.addCallback("logout", this.handleLogout);
            ExternalInterface.addCallback("uiResponse", this.handleUI);
            this._initCallback = callback;
            this.applicationId = applicationId;
            this.oauth2 = true;
            if (options == null){
                options = {};
            };
            options.appId = applicationId;
            options.oauth = true;
            ExternalInterface.call("FBAS.init", JSON2.encode(options));
            if (accessToken != null){
                authResponse = new FacebookAuthResponse();
                authResponse.accessToken = accessToken;
            };
            if (options.status !== false){
                this.getLoginStatus();
            } else {
                if (this._initCallback != null){
                    this._initCallback(authResponse, null);
                    this._initCallback = null;
                };
            };
        }
        protected function getLoginStatus():void{
            ExternalInterface.call("FBAS.getLoginStatus");
        }
        protected function callJS(methodName:String, params:Object):void{
            ExternalInterface.call(methodName, params);
        }
        protected function setCanvasSize(width:Number, height:Number):void{
            ExternalInterface.call("FBAS.setCanvasSize", width, height);
        }
        protected function setCanvasAutoResize(autoSize:Boolean=true, interval:uint=100):void{
            ExternalInterface.call("FBAS.setCanvasAutoResize", autoSize, interval);
        }
        protected function login(callback:Function, options:Object=null):void{
            this._loginCallback = callback;
            ExternalInterface.call("FBAS.login", JSON2.encode(options));
        }
        protected function logout(callback:Function):void{
            this._logoutCallback = callback;
            ExternalInterface.call("FBAS.logout");
        }
        protected function getAuthResponse():FacebookAuthResponse{
            var authResponseObj:* = null;
            var result:* = ExternalInterface.call("FBAS.getAuthResponse");
            try {
                authResponseObj = JSON2.decode(result);
            } catch(e) {
                return (null);
            };
            var a:* = new FacebookAuthResponse();
            a.fromJSON(authResponseObj);
            this.authResponse = a;
            return (authResponse);
        }
        protected function ui(method:String, data:Object, callback:Function=null, display:String=null):void{
            data.method = method;
            if (callback != null){
                this.openUICalls[method] = callback;
            };
            if (display){
                data.display = display;
            };
            ExternalInterface.call("FBAS.ui", JSON2.encode(data));
        }
        protected function addJSEventListener(event:String, listener:Function):void{
            if (this.jsCallbacks[event] == null){
                this.jsCallbacks[event] = new Dictionary();
                ExternalInterface.call("FBAS.addEventListener", event);
            };
            this.jsCallbacks[event][listener] = null;
        }
        protected function removeJSEventListener(event:String, listener:Function):void{
            if (this.jsCallbacks[event] == null){
                return;
            };
            delete this.jsCallbacks[event][listener];
        }
        protected function hasJSEventListener(event:String, listener:Function):Boolean{
            if ((((this.jsCallbacks[event] == null)) || (!((this.jsCallbacks[event][listener] === null))))){
                return (false);
            };
            return (true);
        }
        protected function handleUI(result:String, method:String):void{
            var decodedResult:Object = ((result) ? JSON2.decode(result) : null);
            var uiCallback:Function = this.openUICalls[method];
            if (uiCallback === null){
                delete this.openUICalls[method];
            } else {
                uiCallback(decodedResult);
                delete this.openUICalls[method];
            };
        }
        protected function handleLogout():void{
            authResponse = null;
            if (this._logoutCallback != null){
                this._logoutCallback(true);
                this._logoutCallback = null;
            };
        }
        protected function handleJSEvent(event:String, result:String=null):void{
            var decodedResult:Object;
            var func:Object;
            if (this.jsCallbacks[event] != null){
                try {
                    decodedResult = JSON2.decode(result);
                } catch(e:JSONParseError) {
                };
                for (func in this.jsCallbacks[event]) {
                    (func as Function)(decodedResult);
                    delete this.jsCallbacks[event][func];
                };
            };
        }
        protected function handleAuthResponseChange(result:String):void{
            var resultObj:* = null;
            var result:* = result;
            var success:* = true;
            if (result != null){
                try {
                    resultObj = JSON2.decode(result);
                } catch(e:JSONParseError) {
                    success = false;
                };
            } else {
                success = false;
            };
            if (success){
                if (authResponse == null){
                    authResponse = new FacebookAuthResponse();
                    authResponse.fromJSON(resultObj);
                } else {
                    authResponse.fromJSON(resultObj);
                };
            };
            if (this._initCallback != null){
                this._initCallback(authResponse, null);
                this._initCallback = null;
            };
            if (this._loginCallback != null){
                this._loginCallback(authResponse, null);
                this._loginCallback = null;
            };
        }

    }
}//package com.facebook.graph 
