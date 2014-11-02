package io.packet {

    public class HeartbeatPacket extends Packet {

        public static const TYPE:String = "2";

        override public function get type():String{
            return (TYPE);
        }

    }
}//package io.packet 
