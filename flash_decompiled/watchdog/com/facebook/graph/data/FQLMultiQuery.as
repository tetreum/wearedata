package com.facebook.graph.data {
    import com.json2.*;

    public class FQLMultiQuery {

        public var queries:Object;

        public function FQLMultiQuery(){
            super();
            this.queries = {};
        }
        public function add(query:String, name:String, values:Object=null):void{
            var n:String;
            if (this.queries.hasOwnProperty(name)){
                throw (new Error("Query name already exists, there cannot be duplicate names"));
            };
            for (n in values) {
                query = query.replace(new RegExp((("\\{" + n) + "\\}"), "g"), values[n]);
            };
            this.queries[name] = query;
        }
        public function toString():String{
            return (JSON2.encode(this.queries));
        }

    }
}//package com.facebook.graph.data 
