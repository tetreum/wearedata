package com.facebook.graph.data {

    public class BatchItem {

        public var relativeURL:String;
        public var callback:Function;
        public var params;
        public var requestMethod:String;

        public function BatchItem(relativeURL:String, callback:Function=null, params=null, requestMethod:String="GET"){
            super();
            this.relativeURL = relativeURL;
            this.callback = callback;
            this.params = params;
            this.requestMethod = requestMethod;
        }
    }
}//package com.facebook.graph.data 
