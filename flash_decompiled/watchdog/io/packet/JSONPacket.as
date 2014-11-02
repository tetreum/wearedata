package io.packet {

    public class JSONPacket extends Packet {

        public static const TYPE:String = "4";

        public var data:Object;

        public function JSONPacket(){
            this.data = {};
            super();
        }
        override public function get type():String{
            return (TYPE);
        }
        override protected function parseData(pieces:Array, data:String):void{
            this.data = JSON.parse(data);
        }
        override protected function getData():String{
            return (JSON.stringify(this.data));
        }
        override public function getParams():Array{
            var ret:Array = ["message", this.data];
            (((ack == "data")) && (ret.push(ack)));
            return (ret);
        }

    }
}//package io.packet 
