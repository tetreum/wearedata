package io.packet {

    public class DisconnectPacket extends Packet {

        public static const TYPE:String = "0";

        public var reason:String = null;

        override public function get type():String{
            return (TYPE);
        }
        override public function getParams():Array{
            return (["disconnect", this.reason]);
        }
        override public function equals(packet:Packet):Boolean{
            return (((super.equals(packet)) && ((this.reason == packet["reason"]))));
        }

    }
}//package io.packet 
