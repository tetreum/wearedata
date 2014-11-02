package io.packet {

    public class MessagePacket extends Packet {

        public static const TYPE:String = "3";

        public var data:String = "";

        override public function get type():String{
            return (TYPE);
        }
        override protected function parseData(pieces:Array, data:String):void{
            this.data = data;
        }
        override protected function getData():String{
            return (this.data);
        }
        override public function getParams():Array{
            return (["message", this.data]);
        }
        override public function equals(packet:Packet):Boolean{
            return (((super.equals(packet)) && ((this.data == packet["data"]))));
        }

    }
}//package io.packet 
