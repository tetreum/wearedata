package io.packet {

    public class ErrorPacket extends Packet {

        public static const TYPE:String = "7";

        protected static var REASONS:Array = ["transport not supported", "client not handshaken", "unauthorized"];
        protected static var ADVICE:String = "reconnect";

        protected var _reason:String = "";
        protected var _advice:String = "";

        override public function get type():String{
            return (TYPE);
        }
        public function get reason():String{
            return (this._reason);
        }
        public function set reason(r:String):void{
            if (REASONS.indexOf(r) > -1){
                this._reason = r;
            };
        }
        public function get advice():String{
            return (this._advice);
        }
        public function set advice(a:String):void{
            if (ADVICE == a){
                this._advice = a;
            };
        }
        override protected function parseData(pieces:Array, data:String):void{
            pieces = data.split("+");
            this._reason = ((REASONS[pieces[0]]) || (""));
            this._advice = (((pieces[1] == "0")) ? ADVICE : "");
        }
        override protected function getData():String{
            return ((((this.reason.length) ? REASONS.indexOf(this.reason) : "") + ((this.advice.length) ? "+0" : "")));
        }
        override public function getParams():Array{
            return ([(((this.reason == REASONS[2])) ? "connect_failed" : "error"), this.reason]);
        }
        override public function equals(packet:Packet):Boolean{
            return (((((super.equals(packet)) && ((this.reason == packet["reason"])))) && ((this.advice == packet["advice"]))));
        }

    }
}//package io.packet 
