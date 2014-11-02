package wd.hud.panels.live {
    import wd.core.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;
    import io.*;

    public class SocketInterface {

        private static var hostName:String;
        private static var options:Options;
        private static var socket:SocketNamespace;
        private static var timerRetry:Timer;
        private static var connected:Boolean = false;
        private static var logged:Boolean = false;
        public static var messageFifo:Array;
        private static var loginData:Object;
        private static var initied:Boolean = false;
        public static var bridge:EventDispatcher;

        public function SocketInterface(){
            super();
        }
        public static function init():void{
            if (!(initied)){
                hostName = Config.LIVE_WEBSOCKETSERVER_URL;
                bridge = new EventDispatcher();
                messageFifo = new Array();
                Security.allowDomain(hostName);
                Security.loadPolicyFile(hostName);
                timerRetry = new Timer(1000, 1);
                timerRetry.addEventListener(TimerEvent.TIMER, timerRetryHandler);
                timerRetry.start();
                initied = true;
            };
        }
        private static function timerRetryHandler(e:TimerEvent):void{
            if (connected){
                timerRetry.stop();
            } else {
                trace((("[socket] Server connect try n° " + timerRetry.currentCount) + "..."));
                socket = IO.connect(hostName, options);
                socket.on("connected", onConnected);
                socket.on("error", onError);
                socket.on("custom_error", onError);
                timerRetry = new Timer(7000);
                timerRetry.addEventListener(TimerEvent.TIMER, timerRetryHandler);
                timerRetry.start();
            };
        }
        private static function onConnected(data:Object):void{
            trace("[socket] Server connected");
            connected = true;
            socket.on("loggedIn", onLoggedIn);
            socket.on("loggedOut", onLoggedOut);
            socket.on("receiveAction", onReceiveMessage);
            socket.on("messageSubmited", onMessageSubmited);
            if (loginData){
                socket.emit("login", loginData);
            };
        }
        private static function onLoggedIn(data:Object):void{
            trace("[socket] Logged In ");
            logged = true;
        }
        private static function onLoggedOut(data:Object):void{
            logged = false;
        }
        private static function onMessageSubmited(data:Object):void{
        }
        public static function onError(data:Object):void{
            if (!(data)){
                trace("[Error] Cannot connect to the WebSocket server");
            } else {
                if (data.error > 0){
                    trace(("[Error]" + data.message));
                };
            };
        }
        private static function onReceiveMessage(data:Object):void{
            trace(("[Action]" + data.fbId));
            messageFifo.push(data);
            bridge.dispatchEvent(new Event("NEW_MESSAGE"));
        }
        public static function sendData(lat:Number, long:Number, action:String):void{
            if (((connected) && (logged))){
                socket.emit("action", {
                    long_lat:[long, lat],
                    action:action
                });
            };
        }
        public static function login(fb_id:String, first_name:String, last_name:String, age:String, job:String, country:String, city:String):void{
            loginData = {
                fb_id:fb_id,
                first_name:first_name,
                last_name:last_name,
                age:age,
                job:job,
                country:country,
                server:city.toLowerCase()
            };
            if (connected){
                socket.emit("login", loginData);
            };
        }

    }
}//package wd.hud.panels.live 
