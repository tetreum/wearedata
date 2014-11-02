package wd.http {
    import wd.core.*;
    import flash.utils.*;
    import flash.events.*;
    import com.facebook.graph.*;
    import com.facebook.graph.data.*;
    import wd.utils.*;
    import wd.providers.texts.*;

    public class FacebookConnector {

        public static const FB_LOGGED_IN:String = "FB_LOGGED_IN";
        public static const FB_NOT_LOGGED:String = "FB_NOT_LOGGED";
        public static const FB_LOGIN_FAIL:String = "FB_LOGIN_FAIL";
        public static const FB_ON_DATA:String = "FB_ON_DATA";
        public static const FB_ERROR:String = "FB_ERROR";

        public static var isConnected:Boolean = false;
        public static var fbSession:FacebookSession;
        public static var evtDispatcher:EventDispatcher;
        public static var currentData:Object;
        private static var userId:String;

        public function FacebookConnector(){
            super();
        }
        public static function init():void{
            trace(("FacebookConnector Init: " + Config.FACEBOOK_APP_ID));
            setTimeout(FacebookConnector.initFb, 3000);
            evtDispatcher = new EventDispatcher();
        }
        public static function initFb():void{
            Facebook.init(Config.FACEBOOK_APP_ID, onInit);
        }
        public static function handleFacebookFriendsLoaded(result:Object, fail:Object):void{
            trace(("handleFacebookFriendsLoaded : " + result));
            trace(("handleFacebookFriendsLoaded fail : " + fail));
        }
        public static function onInit(result:Object, fail:Object):void{
            var i:*;
            trace(("onInit result : " + result));
            if (result){
                setConnected((result as FacebookSession));
                trace(("result " + result));
            } else {
                isConnected = false;
                trace(("fail : " + fail));
                for (i in fail) {
                    trace(((i + ":") + fail[i]));
                };
                evtDispatcher.dispatchEvent(new Event(FB_NOT_LOGGED));
            };
        }
        private static function setConnected(_fbSession:FacebookSession):void{
            isConnected = true;
            fbSession = _fbSession;
            trace(("fbSession : " + fbSession));
            evtDispatcher.dispatchEvent(new Event(FB_LOGGED_IN));
        }
        public static function login():void{
            Facebook.login(onLoginResult, {scope:"user_work_history,user_birthday"});
        }
        public static function getUserData():void{
            Facebook.api("/me", onData);
        }
        public static function onData(result:Object, fail:Object):void{
            var i:*;
            if (result){
                currentData = result;
                evtDispatcher.dispatchEvent(new Event(FB_ON_DATA));
            } else {
                trace(("fail : " + fail));
                for (i in fail) {
                    trace(((i + ":") + fail[i]));
                };
                evtDispatcher.dispatchEvent(new Event(FB_ERROR));
            };
        }
        private static function onLoginResult(result:Object, fail:Object):void{
            if (result){
                setConnected((result as FacebookSession));
            } else {
                isConnected = false;
                evtDispatcher.dispatchEvent(new Event(FB_LOGIN_FAIL));
            };
        }
        public static function share():void{
            URLFormater.shorten(fbCallback, URLFormater.SHARE_TO_FACEBOOK);
        }
        private static function fbCallback(shorten:String):void{
            var shareOpt:Object;
            if (isConnected){
                shareOpt = {
                    method:"feed",
                    name:ShareText.FBGtitle,
                    link:shorten,
                    picture:(Config.ROOT_URL + ShareText.FBGimage),
                    caption:ShareText.FBGtitle,
                    description:replaceTags(ShareText.FBGtext)
                };
                Facebook.ui("feed", shareOpt, shareCb, "popup");
            } else {
                JsPopup.open(("https://www.facebook.com/sharer.php?u=" + shorten));
            };
        }
        private static function replaceTags(input:String):String{
            return (URLFormater.replaceTags(input));
        }
        public static function shareCb(result:Object):void{
            if (result){
                trace("[share] Success");
            } else {
                trace("[share] Fail");
            };
        }

    }
}//package wd.http 
