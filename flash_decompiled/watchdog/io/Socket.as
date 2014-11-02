package io {
    import flash.utils.*;
    import __AS3__.vec.*;
    import io.packet.*;
    import io.utils.*;
    import flash.net.*;
    import flash.events.*;
    import io.event.*;

    public class Socket extends EventEmitter {

        public static const CONNECT:String = "connect";
        public static const CONNECTING:String = "connecting";
        public static const CONNECT_FAILED:String = "connect_failed";
        public static const RECONNECT:String = "reconnect";
        public static const RECONNECTING:String = "reconnecting";
        public static const RECONNECT_FAILED:String = "reconnect_failed";
        public static const OPEN:String = "open";
        public static const CLOSE:String = "close";
        public static const DISCONNECT:String = "disconnect";
        public static const ERROR:String = "error";
        public static const PACKET:String = "packet";
        public static const BOOTED:String = "booted";

        public var options:Options;
        protected var _connected:Boolean = false;
        protected var _open:Boolean = false;
        protected var _connecting:Boolean = false;
        protected var _reconnecting:Boolean = false;
        protected var transport:Transport = null;
        protected var connectTimeoutTimer:Timer = null;
        protected var namespaces:Dictionary;
        protected var buffer:Vector.<Packet>;
        protected var doBuffer:Boolean = false;
        protected var reconnectionAttempts:uint = 0;
        protected var reconnectionTimer:Timer = null;
        protected var reconnectionDelay:uint = 0;

        public function Socket(options:Options){
            this.options = new Options();
            this.namespaces = new Dictionary();
            this.buffer = new Vector.<Packet>();
            super();
            this.transport = new Transport(this);
            this.transport.on(PACKET, this.onPacket);
            this.transport.on(CLOSE, this.onClose);
            this.transport.on(OPEN, this.onOpen);
            this.transport.on(DISCONNECT, this.onDisconnect);
            if (options){
                this.options = options;
            };
            if (options.auto_connect){
                this.connect();
            };
        }
        public function get connected():Boolean{
            return (this._connected);
        }
        public function get open():Boolean{
            return (this._open);
        }
        public function get connecting():Boolean{
            return (this._connecting);
        }
        public function get reconnecting():Boolean{
            return (this._reconnecting);
        }
        public function of(name:String):SocketNamespace{
            var connect:ConnectPacket;
            if (!(this.namespaces[name])){
                this.namespaces[name] = new SocketNamespace(this, name);
                if (name != ""){
                    connect = new ConnectPacket();
                    connect.endpoint = name;
                    this.packet(connect);
                };
            };
            return (this.namespaces[name]);
        }
        public function connect():void{
            if (((this.connecting) || (this.connected))){
                return;
            };
            this.doHandshake();
        }
        public function disconnect():void{
            if (this.connected){
                if (this.open){
                    this.packet(new DisconnectPacket());
                };
                this.onDisconnect(BOOTED);
            };
        }
        public function packet(data:Packet):void{
            if (((this.connected) && (!(this.doBuffer)))){
                this.transport.packet(data);
            } else {
                this.buffer.push(data);
            };
        }
        protected function publish(... _args):void{
            var i:String;
            emit.apply(this, _args);
            for (i in this.namespaces) {
                emit.apply(this.of(i), _args);
            };
        }
        protected function getRequest():URLRequest{
            var url:String = IOUtils.getRequestURL(this.options);
            var xhr:URLRequest = new URLRequest(url);
            return (xhr);
        }
        protected function doHandshake():void{
            var loader:* = null;
            var xhr:* = this.getRequest();
            loader = new URLStream();
            loader.addEventListener(IOErrorEvent.IO_ERROR, function (event:IOErrorEvent):void{
                onError(loader.readUTFBytes(loader.bytesAvailable));
            }, false, 0, true);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function (event:HTTPStatusEvent):void{
                var data:String = ((loader.bytesAvailable) ? loader.readUTFBytes(loader.bytesAvailable) : "");
                if (event.status == 200){
                    onHandshake.apply(this, data.split(":"));
                } else {
                    ((!(reconnecting)) && (onError(data)));
                };
            }, false, 0, true);
            loader.load(xhr);
        }
        protected function onHandshake(sid:String, heartbeat:Number, close:Number, transports:String):void{
            var sid:* = sid;
            var heartbeat:* = heartbeat;
            var close:* = close;
            var transports:* = transports;
            if (transports.split(",").indexOf("xhr-polling") == -1){
                return (this.publish(CONNECT_FAILED));
            };
            this.transport.init(sid, (heartbeat * 1000), (close * 1000));
            this._connecting = true;
            this.publish(CONNECTING);
            if (this.options.connect_timeout){
                IOUtils.createTimer(this.options.connect_timeout, function ():void{
                    if (!(connected)){
                        _connecting = false;
                    };
                });
            };
        }
        protected function reconnect():void{
            var i:String;
            if (((this.reconnecting) && (this.connected))){
                for (i in this.namespaces) {
                    if (i != ""){
                        this.namespaces[i].packet(new ConnectPacket());
                    };
                };
                this.publish(RECONNECT, "xhr-polling", this.reconnectionAttempts);
                return (this.reset_reconnect());
            };
            if (((this.reconnecting) && ((this.reconnectionAttempts < this.options.max_reconnection_attempts)))){
                this.reset_reconnect();
                return (this.publish(RECONNECT_FAILED));
            };
            if (((this.reconnecting) && (this.connecting))){
                this.reconnectionTimer = IOUtils.createTimer(1000, this.reconnect);
                return;
            };
            if (this.reconnecting){
                if (this.reconnectionDelay < this.options.reconnection_limit){
                    this.reconnectionDelay = (this.reconnectionDelay * 2);
                };
            } else {
                on(CONNECT_FAILED, this.reconnect);
                on(CONNECT, this.reconnect);
            };
            this._reconnecting = true;
            this.reconnectionTimer = IOUtils.createTimer(this.reconnectionDelay, this.reconnect);
            this.connect();
            this.publish(RECONNECTING);
        }
        protected function reset_reconnect():void{
            this.reconnectionTimer.stop();
            this._reconnecting = false;
            this.reconnectionAttempts = 0;
            removeEventListener(CONNECT_FAILED, this.reconnect);
            removeEventListener(CONNECT, this.reconnect);
        }
        public function setBuffer(b:Boolean):void{
            this.doBuffer = b;
            if (((((!(this.doBuffer)) && (this.connected))) && (this.buffer.length))){
                this.transport.payload(this.buffer);
                this.buffer = new Vector.<Packet>();
            };
        }
        protected function onOpen():void{
            this._open = true;
        }
        protected function onClose():void{
            this._open = false;
        }
        protected function onConnect():void{
            if (!(this.connected)){
                this._connected = true;
                this._connecting = false;
                this.setBuffer(false);
                this.emit(CONNECT);
            };
        }
        public function onDisconnect(reason:String):void{
            var wasConnected:Boolean = this.connected;
            this._connected = false;
            this._connecting = false;
            this._open = false;
            if (wasConnected){
                this.transport.disconnect();
                this.publish(DISCONNECT);
                if (((((!((BOOTED == reason))) && (this.options.reconnect))) && (!(this.reconnecting)))){
                    this.reconnect();
                };
            };
        }
        protected function onPacket(packet:Packet):void{
            if ((((packet.type == ConnectPacket.TYPE)) && ((packet.endpoint == "")))){
                this.onConnect();
            };
            emit(Socket.PACKET, packet);
        }
        public function onError(err:Object):void{
            if ((((((((((err is ErrorPacket)) && (err.advice))) && (this.options.reconnect))) && ((err.advice == RECONNECT)))) && (this.connected))){
                this.disconnect();
                this.reconnect();
            };
            this.publish(ERROR, (((err is ErrorPacket)) ? err.reason : err));
        }

    }
}//package io 
