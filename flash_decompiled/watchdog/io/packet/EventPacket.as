package io.packet {

    public class EventPacket extends Packet {

        public static const TYPE:String = "5";

        public var args:Array;
        public var name:String = "";

        public function EventPacket(){
            this.args = [];
            super();
        }
        override public function get type():String{
            return (TYPE);
        }
        override protected function parseData(pieces:Array, data:String):void{
            var opts:Object;
            try {
                opts = JSON.parse(data);
                this.name = opts.name;
                this.args = ((opts.args) || ([]));
            } catch(e:SyntaxError) {
            };
        }
        override protected function getData():String{
            var ev:Object = {name:this.name};
            if (((this.args) && (this.args.length))){
                ev.args = this.args;
            };
            return (JSON.stringify(ev));
        }
        override public function getParams():Array{
            var ret:Array = [this.name].concat(this.args);
            (((ack == "data")) && (ret.push(ack)));
            return (ret);
        }
        override public function equals(packet:Packet):Boolean{
            return (((super.equals(packet)) && ((this.name == packet["name"]))));
        }

    }
}//package io.packet 
