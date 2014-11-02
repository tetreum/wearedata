package com.facebook.graph.data {
    import com.facebook.graph.core.*;

    public class Batch {

        protected var _requests:Array;

        public function Batch(){
            super();
            this._requests = [];
        }
        public function get requests():Array{
            return (this._requests);
        }
        public function add(relativeURL:String, callback:Function=null, params=null, requestMethod:String="GET"):void{
            if (this._requests.length == FacebookLimits.BATCH_REQUESTS){
                throw (new Error((("Facebook limits you to " + FacebookLimits.BATCH_REQUESTS) + " requests in a single batch.")));
            };
            this._requests.push(new BatchItem(relativeURL, callback, params, requestMethod));
        }

    }
}//package com.facebook.graph.data 
