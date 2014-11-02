package io.packet {

    public class Packet {

        public static const TYPE:String = "8";

        public var endpoint:String = "";
        public var id:String = "";
        public var ack:String = "";

        public function get type():String{
            return (TYPE);
        }
        public function fromData(pieces:Array):Packet{
            this.endpoint = ((pieces[4]) || (""));
            if (pieces[2]){
                this.id = ((pieces[2]) || (""));
                this.ack = ((pieces[3]) ? "data" : "true");
            };
            this.parseData(pieces, ((pieces[5]) || ("")));
            return (this);
        }
        protected function parseData(pieces:Array, data:String):void{
        }
        public function toData():String{
            var encoded:Array = [this.type, (this.id + (((this.ack == "data")) ? "+" : "")), this.endpoint];
            if (this.getData()){
                encoded.push(this.getData());
            };
            return (encoded.join(":"));
        }
        protected function getData():String{
            return ("");
        }
        public function getParams():Array{
            return (["noop"]);
        }
        public function equals(packet:Packet):Boolean{
            return ((((((((this.type == packet.type)) && ((this.endpoint == packet.endpoint)))) && ((this.id == packet.id)))) && ((this.ack == packet.ack))));
        }

    }
}//package io.packet 
