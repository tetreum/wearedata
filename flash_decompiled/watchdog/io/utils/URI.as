package io.utils {

    public class URI {

        protected static var re:RegExp = /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;
        protected static var parts:Array = ["source", "protocol", "authority", "userInfo", "user", "password", "host", "port", "relative", "path", "directory", "file", "query", "anchor"];

        public var source:String;
        public var protocol:String;
        public var authority:String;
        public var userInfo:String;
        public var user:String;
        public var password:String;
        public var host:String;
        public var port:String;
        public var relative:String;
        public var path:String;
        public var directory:String;
        public var file:String;
        public var query:String;
        public var anchor:String;

        public static function buildURI(str:String=""):URI{
            var m:Object = str.match(re);
            var uri:URI = new (URI)();
            var i:uint = 14;
            while (i--) {
                uri[parts[i]] = ((m[i]) || (""));
            };
            return (uri);
        }

    }
}//package io.utils 
