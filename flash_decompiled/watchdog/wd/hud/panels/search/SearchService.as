package wd.hud.panels.search {
    import flash.net.*;
    import wd.core.*;

    public class SearchService {

        private var connection:NetConnection;
        private var responder:Responder;
        private var args:Array;
        private var list:ResultList;

        public function SearchService(list:ResultList){
            this.args = [];
            super();
            this.list = list;
            this.connection = new NetConnection();
            this.connection.connect(Config.GATEWAY);
            this.responder = new Responder(this.onResult, this.onCancel);
            this.args["town"] = Config.CITY;
            this.args["query"] = "";
        }
        public function search(term:String):void{
            this.args["town"] = Config.CITY;
            this.args["query"] = term;
            this.connection.call("WatchDog.search", this.responder, this.args);
        }
        private function onResult(res:Object):void{
            var result:Array = (res as Array);
            this.list.onResult(result);
        }
        private function onCancel(res:Object):void{
            this.list.onCancel(res);
        }

    }
}//package wd.hud.panels.search 
