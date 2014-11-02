package io.packet {
    import flash.utils.*;
    import __AS3__.vec.*;

    public class PacketFactory {

        public static var PACKET_TYPE_MAP:Dictionary = new Dictionary();

        public static function decodePacket(data:String):Packet{
            var pieces:Array = data.match(/([^:]+):([0-9]+)?(\+)?:([^:]+)?:?([\s\S]*)?/);
            if ((PACKET_TYPE_MAP[pieces[1]] is Class)){
                return (new ((PACKET_TYPE_MAP[pieces[1]] as Class))().fromData(pieces));
            };
            return (null);
        }
        public static function decodePayload(data:String):Vector.<Packet>{
            var i:uint;
            var length:String;
            var ret:Vector.<Packet> = new Vector.<Packet>();
            if (data.charAt(0) == "�"){
                i = 1;
                length = "";
                while (i < data.length) {
                    if (data.charAt(i) == "�"){
                        ret.push(decodePacket(data.substr((i + 1)).substr(0, parseInt(length))));
                        i = (i + (Number(length) + 1));
                        length = "";
                    } else {
                        length = (length + data.charAt(i));
                    };
                    i++;
                };
            } else {
                ret.push(decodePacket(data));
            };
            return (ret);
        }
        public static function encodePacket(packet:Packet):String{
            return (packet.toData());
        }
        public static function encodePayload(packets:Vector.<Packet>):String{
            var packet:String;
            var encoded:String = "";
            if (packets.length == 1){
                return (packets[0].toData());
            };
            var i:uint;
            var l:uint = packets.length;
            while (i < l) {
                packet = packets[i].toData();
                encoded = (encoded + ((("�" + packet.length) + "�") + packet));
                i++;
            };
            return (encoded);
        }

        PACKET_TYPE_MAP[DisconnectPacket.TYPE] = DisconnectPacket;
        PACKET_TYPE_MAP[ConnectPacket.TYPE] = ConnectPacket;
        PACKET_TYPE_MAP[HeartbeatPacket.TYPE] = HeartbeatPacket;
        PACKET_TYPE_MAP[MessagePacket.TYPE] = MessagePacket;
        PACKET_TYPE_MAP[JSONPacket.TYPE] = JSONPacket;
        PACKET_TYPE_MAP[EventPacket.TYPE] = EventPacket;
        PACKET_TYPE_MAP[AckPacket.TYPE] = AckPacket;
        PACKET_TYPE_MAP[ErrorPacket.TYPE] = ErrorPacket;
        PACKET_TYPE_MAP[Packet.TYPE] = Packet;
    }
}//package io.packet 
