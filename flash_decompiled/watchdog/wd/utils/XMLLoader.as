package wd.utils {
    import flash.net.*;
    import flash.events.*;

    public class XMLLoader extends EventDispatcher {

        protected var urlLoader:URLLoader;
        protected var _xml:XML;
        private var _name:String;

        public function XMLLoader(name:String){
            super();
            this.name = name;
            this.urlLoader = new URLLoader();
            this.urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
            this.urlLoader.addEventListener(Event.COMPLETE, this.onComplete);
            this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
        }
        public function load(url:String):void{
            this.urlLoader.load(new URLRequest(url));
        }
        protected function onComplete(event:Event):void{
            this.xml = new XML(event.target.data);
            dispatchEvent(new Event(Event.COMPLETE));
        }
        protected function onError(event:IOErrorEvent):void{
            dispatchEvent(event);
            this.urlLoader.removeEventListener(Event.COMPLETE, this.onComplete);
            this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
            this.urlLoader = null;
        }
        public function get xml():XML{
            return (this._xml);
        }
        public function set xml(value:XML):void{
            this._xml = value;
        }
        public function get name():String{
            return (this._name);
        }
        public function set name(value:String):void{
            this._name = value;
        }

    }
}//package wd.utils 
