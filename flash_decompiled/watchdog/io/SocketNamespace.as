package io {
    import io.packet.*;
    import io.event.*;

    public class SocketNamespace extends EventEmitter {

        protected var socket:Socket = null;
        protected var name:String = "";
        protected var ackPackets:uint = 0;
        protected var acks:Object;

        public function SocketNamespace(socket:Socket, name:String=""){
            this.acks = {};
            super();
            this.socket = socket;
            this.socket.on(Socket.PACKET, this.onPacket);
            this.name = ((name) || (""));
            this.ackPackets = 0;
            this.acks = {};
        }
        protected function $emit(... _args):void{
            super.emit.apply(this, _args);
        }
        protected function of(name:String):SocketNamespace{
            return (this.socket.of.call(this.socket, name));
        }
        protected function packet(packet:Packet):void{
            packet.endpoint = this.name;
            this.socket.packet(packet);
        }
        public function disconnect():void{
            if (this.name == ""){
                this.socket.disconnect();
            } else {
                this.packet(new DisconnectPacket());
                this.$emit("disconnect");
            };
        }
        override public function emit(name:String, ... _args):void{
            var lastArg:* = _args[(_args.length - 1)];
            var packet:EventPacket = new EventPacket();
            packet.name = name;
            if ((lastArg is Function)){
                packet.id = ++this.ackPackets.toString();
                packet.ack = "data";
                this.acks[packet.id] = lastArg;
                _args.splice(-1, 1);
            };
            packet.args = _args;
            this.packet(packet);
        }
        protected function onPacket(packet:Packet):void{
            var self:* = null;
            var ack:* = null;
            var params:* = null;
            var ap:* = null;
            var packet:* = packet;
            ack = function (... _args):void{
                var p:AckPacket = new AckPacket(packet.id);
                p.args = _args;
                self.packet(p);
            };
            self = this;
            switch (packet.type){
                case DisconnectPacket.TYPE:
                    if (this.name == ""){
                        this.socket.onDisconnect((((packet as DisconnectPacket).reason) || ("booted")));
                    };
                    break;
                case MessagePacket.TYPE:
                case JSONPacket.TYPE:
                    params = packet.getParams();
                    if (packet.ack == "data"){
                        params.push(ack);
                    } else {
                        this.packet(new AckPacket(packet.id));
                    };
                    this.$emit.apply(this, params);
                    return;
                case AckPacket.TYPE:
                    ap = (packet as AckPacket);
                    if (this.acks[ap.ackId]){
                        this.acks[ap.ackId].apply(this, ap.args);
                        delete this.acks[ap.ackId];
                    };
                    break;
                case ErrorPacket.TYPE:
                    if ((packet as ErrorPacket).advice){
                        return (this.socket.onError((packet as ErrorPacket)));
                    };
            };
            this.$emit.apply(this, packet.getParams());
        }

    }
}//package io 
