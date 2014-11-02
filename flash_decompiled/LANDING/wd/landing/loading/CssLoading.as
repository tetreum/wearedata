package wd.landing.loading {
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;

    public class CssLoading extends EventDispatcher {

        private static var _oI:CssLoading;
        public static var CSS_IS_READY:String = "css is ready to use";
        public static var STYLESHEET:StyleSheet;

        public var isComplete:Boolean = false;
        private var loader:URLLoader;

        public function CssLoading(_arg1:PrivateConstructorAccess):void{
        }
        public static function getInstance():CssLoading{
            if (!_oI){
                _oI = new CssLoading(new PrivateConstructorAccess());
            };
            return (_oI);
        }

        public function startToLoad(_arg1:String):void{
            this.loader = new URLLoader();
            this.loader.addEventListener(Event.COMPLETE, this.loaderCompleteHandler);
            var _local2:URLRequest = new URLRequest(_arg1);
            this.loader.load(_local2);
        }
        private function loaderCompleteHandler(_arg1:Event):void{
            this.isComplete = true;
            STYLESHEET = new StyleSheet();
            STYLESHEET.parseCSS(this.loader.data);
            dispatchEvent(new Event(CSS_IS_READY));
        }

    }
}//package wd.landing.loading 

class PrivateConstructorAccess {

    public function PrivateConstructorAccess(){
    }
}
