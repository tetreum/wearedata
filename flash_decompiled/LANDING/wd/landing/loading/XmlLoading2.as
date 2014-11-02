package wd.landing.loading {
    import flash.events.*;
    import flash.net.*;

    public class XmlLoading2 extends EventDispatcher {

        private static var _oI:XmlLoading2;
        public static var XML_IS_READY:String = "xml is ready to use";

        private var _xml:XML;
        public var isComplete:Boolean = false;

        public function XmlLoading2(_arg1:PrivateConstructorAccess):void{
        }
        public static function getInstance():XmlLoading2{
            if (!_oI){
                _oI = new XmlLoading2(new PrivateConstructorAccess());
            };
            return (_oI);
        }

        public function startToLoad(_arg1:String):void{
            var _local2:URLLoader = new URLLoader();
            var _local3:URLRequest = new URLRequest(_arg1);
            _local2.addEventListener(Event.COMPLETE, this.chargementComplet);
            _local2.load(_local3);
        }
        private function chargementComplet(_arg1:Event):void{
            this.isComplete = true;
            this._xml = new XML(_arg1.target.data);
            dispatchEvent(new Event(XML_IS_READY));
        }
        public function getXml():XML{
            return (this._xml);
        }

    }
}//package wd.landing.loading 

class PrivateConstructorAccess {

    public function PrivateConstructorAccess(){
    }
}
