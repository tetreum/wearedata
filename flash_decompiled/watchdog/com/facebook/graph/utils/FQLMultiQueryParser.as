package com.facebook.graph.utils {

    public class FQLMultiQueryParser implements IResultParser {

        public function FQLMultiQueryParser(){
            super();
        }
        public function parse(data:Object):Object{
            var n:String;
            var o:Object = {};
            for (n in data) {
                o[data[n].name] = data[n].fql_result_set;
            };
            return (o);
        }

    }
}//package com.facebook.graph.utils 
