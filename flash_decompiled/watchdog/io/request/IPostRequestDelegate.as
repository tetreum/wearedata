package io.request {

    public interface IPostRequestDelegate extends IHTTPRequestDelegate {

        function postRequestOnSuccess():void;
        function postRequestOnError():void;

    }
}//package io.request 
