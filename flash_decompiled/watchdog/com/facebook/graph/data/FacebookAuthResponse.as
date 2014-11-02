package com.facebook.graph.data {

    public class FacebookAuthResponse {

        public var uid:String;
        public var expireDate:Date;
        public var accessToken:String;
        public var signedRequest:String;

        public function FacebookAuthResponse(){
            super();
        }
        public function fromJSON(result:Object):void{
            if (result != null){
                this.expireDate = new Date();
                this.expireDate.setTime((this.expireDate.time + (result.expiresIn * 1000)));
                this.accessToken = ((result.access_token) || (result.accessToken));
                this.signedRequest = result.signedRequest;
                this.uid = result.userID;
            };
        }
        public function toString():String{
            return ((("[userId:" + this.uid) + "]"));
        }

    }
}//package com.facebook.graph.data 
