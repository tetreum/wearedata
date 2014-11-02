package io.packet {

    public class ConnectPacket extends Packet {

        public static const TYPE:String = "1";

        public var qs:String = null;

        override public function get type():String{
            return (TYPE);
        }
        override protected function parseData(pieces:Array, data:String):void{
            this.qs = ((data) || (""));
        }
        override protected function getData():String{
            return (this.qs);
        }
        override public function getParams():Array{
            return (["connect"]);
        }
        override public function equals(packet:Packet):Boolean{
            return (((super.equals(packet)) && ((this.qs == packet["qs"]))));
        }

    }
}//package io.packet 
