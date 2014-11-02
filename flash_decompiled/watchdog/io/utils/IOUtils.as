package io.utils {
    import flash.utils.*;
    import flash.events.*;
    import io.*;

    public class IOUtils {

        public static function createTimer(timeout:uint, cb:Function):Timer{
            var timer:Timer = new Timer(timeout);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, cb, false, 0, true);
            timer.start();
            return (timer);
        }
        public static function getRequestURL(options:Options):String{
            return ([(("http" + ((options.secure) ? "s" : "")) + ":/"), ((options.host + ":") + options.port), options.resource, IO.protocol, ("?t=" + new Date().time)].join("/"));
        }
        public static function getSessionRequestURL(options:Options, session:String):String{
            return ([(("http" + ((options.secure) ? "s" : "")) + ":/"), ((options.host + ":") + options.port), options.resource, IO.protocol, "xhr-polling", session, ("?t=" + new Date().time)].join("/"));
        }

    }
}//package io.utils 
