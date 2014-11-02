package io.request {

    public interface IPollingRequestDelegate extends IHTTPRequestDelegate {

        function pollingRequestOnData(_arg1:String):void;
        function pollingRequestOnError():void;

    }
}//package io.request 
