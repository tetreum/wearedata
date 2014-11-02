package io {
    import flash.utils.*;
    import io.utils.*;

    public class IO {

        protected static var sockets:Dictionary = new Dictionary();
        public static var transport:String = "xhr-polling";
        public static var protocol:String = "1";

        public static function connect(host:String, user_options:Options=null):SocketNamespace{
            var uri:URI;
            var prop:String;
            var socket:Socket;
            var options:Options = new Options();
            uri = URI.buildURI(host);
            options.host = uri.host;
            options.secure = (uri.protocol == "https");
            options.port = ((parseInt(uri.port)) || (((options.secure) ? 443 : 80)));
            options.query = uri.query;
            for (prop in user_options) {
                options[prop] = user_options[prop];
            };
            socket = IO.sockets[host];
            if (!(IO.sockets[host])){
                socket = new Socket(options);
                IO.sockets[host] = socket;
            };
            socket = ((socket) || (IO.sockets[host]));
            return (socket.of((((uri.path.length > 1)) ? uri.path : "")));
        }

    }
}//package io 
