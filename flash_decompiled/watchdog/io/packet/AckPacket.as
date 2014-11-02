package io.packet {

    public class AckPacket extends Packet {

        public static const TYPE:String = "6";

        public var ackId:String;
        public var args:Array;

        public function AckPacket(aId:String=""):void{
            super();
            this.ackId = aId;
        }
        override public function get type():String{
            return (TYPE);
        }
        override protected function parseData(pieces:Array, data:String):void{
            pieces = data.match(/^([0-9]+)(\+)?(.*)/);
            if (pieces){
                this.ackId = pieces[1];
                this.args = ((pieces[3]) ? (JSON.parse(pieces[3]) as Array) : []);
            };
        }
        override protected function getData():String{
            return ((this.ackId + ((((this.args) && ((this.args.length > 0)))) ? ("+" + JSON.stringify(this.args)) : "")));
        }
        override public function getParams():Array{
            return ([]);
        }
        override public function equals(packet:Packet):Boolean{
            return (((super.equals(packet)) && ((this.ackId == packet["ackId"]))));
        }

    }
}//package io.packet 
