package io {
    import io.request.*;
    import io.utils.*;
    import io.packet.*;
    import __AS3__.vec.*;
    import avmplus.*;
    import flash.utils.*;
    import io.event.*;

    public class Transport extends EventEmitter implements IPollingRequestDelegate, IPostRequestDelegate {

        protected var socket:Socket;
        protected var pollingRequest:PollingRequest;
        protected var postRequest:PostRequest;
        protected var session_id:String = null;
        protected var closeTimer:Timer;
        protected var opened:Boolean = false;
        protected var closed:Boolean = false;

        public function Transport(socket:Socket){
            super();
            this.socket = socket;
            this.pollingRequest = new PollingRequest(this);
            this.postRequest = new PostRequest(this);
        }
        public function init(sid:String, heartbeat:Number, close:Number):void{
            trace((((("[transport] session: " + sid) + "\n\tclosetimeout: ") + close.toString()) + " (ms)"));
            this.session_id = sid;
            this.closeTimer = IOUtils.createTimer(close, this.onDisconnect);
            this.onOpen();
        }
        public function getURLFor(req:HTTPRequest):String{
            return (IOUtils.getSessionRequestURL(this.socket.options, this.session_id));
        }
        public function disconnect():void{
            this.onDisconnect(Socket.BOOTED);
        }
        protected function get():void{
            if (!(this.opened)){
                return;
            };
            this.pollingRequest.start();
        }
        public function pollingRequestOnData(data:String):void{
            this.onData(data);
            this.get();
        }
        public function pollingRequestOnError():void{
            this.onClose();
        }
        public function packet(packet:Packet):void{
            this.post(PacketFactory.encodePacket(packet));
        }
        public function payload(payload:Vector.<Packet>):void{
            this.post(PacketFactory.encodePayload(payload));
        }
        protected function post(data:String):void{
            this.socket.setBuffer(true);
            this.postRequest.data = data;
            this.postRequest.start();
        }
        public function postRequestOnSuccess():void{
            this.socket.setBuffer(false);
        }
        public function postRequestOnError():void{
            this.onClose();
        }
        protected function onOpen():void{
            trace("[transport] onOpen");
            this.socket.setBuffer(false);
            this.opened = true;
            emit(Socket.OPEN);
            this.get();
            this.closeTimer.reset();
            this.closeTimer.start();
        }
        protected function onClose():void{
            trace("[transport] onClose");
            this.opened = false;
            emit(Socket.CLOSE);
            this.pollingRequest.stop();
        }
        protected function onDisconnect(reason:String):void{
            trace(("[transport] onDisconnect: " + reason));
            if (((this.closed) && (this.opened))){
                this.onClose();
            };
            this.closeTimer.reset();
            emit(Socket.DISCONNECT, reason);
        }
        protected function onData(data:String):void{
            var msgs:Vector.<Packet>;
            var i:uint;
            var l:uint;
            trace(("[transport] onData: " + data));
            this.closeTimer.reset();
            if (((((this.socket.connected) || (this.socket.connecting))) || (this.socket.reconnecting))){
                this.closeTimer.start();
            };
            if (data !== ""){
                msgs = PacketFactory.decodePayload(data);
                if (((msgs) && (msgs.length))){
                    i = 0;
                    l = msgs.length;
                    while (i < l) {
                        this.onPacket(msgs[i]);
                        i++;
                    };
                };
            };
        }
        protected function onPacket(packet:Packet):void{
            trace(("[transport] onPacket: " + getQualifiedClassName(packet)));
            if (packet.type == HeartbeatPacket.TYPE){
                this.post(PacketFactory.encodePacket(new HeartbeatPacket()));
                return;
            };
            emit(Socket.PACKET, packet);
        }

    }
}//package io 
