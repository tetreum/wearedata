package wd.landing.loading {
    import flash.events.*;
    import flash.display.*;
    import flash.net.*;

    public class FontLoading extends EventDispatcher {

        private static var _oI:FontLoading;
        public static var FONT_ARE_READY:String = "Font are ready to use";

        public function FontLoading(_arg1:PrivateConstructorAccess):void{
        }
        public static function getInstance():FontLoading{
            if (!_oI){
                _oI = new FontLoading(new PrivateConstructorAccess());
            };
            return (_oI);
        }

        public function loadFont(_arg1:String):void{
            var _local2:URLLoader = new URLLoader();
            _local2.dataFormat = "binary";
            _local2.addEventListener(IOErrorEvent.IO_ERROR, this.ioError);
            _local2.addEventListener(Event.COMPLETE, this.fontsLoadCompleteHandler);
            _local2.load(new URLRequest(_arg1));
        }
        private function fontsLoadCompleteHandler(_arg1:Event):void{
            var _local2:Loader = new Loader();
            _local2.loadBytes(_arg1.target.data);
            _local2.contentLoaderInfo.addEventListener(Event.INIT, this.fontsInit);
        }
        private function fontsInit(_arg1:Event):void{
            dispatchEvent(new Event(FONT_ARE_READY));
        }
        private function ioError(_arg1:IOErrorEvent):void{
        }

    }
}//package wd.landing.loading 

class PrivateConstructorAccess {

    public function PrivateConstructorAccess(){
    }
}
