package wd.d3.geom.monuments {
    import flash.utils.*;
    import flash.display.*;
    import flash.net.*;
    import flash.events.*;
    import flash.system.*;
    import wd.utils.*;
    import __AS3__.vec.*;

    public class MonumentsProvider extends EventDispatcher {

        public static var paris:Vector.<Monument>;
        public static var berlin:Vector.<Monument>;
        public static var london:Vector.<Monument>;
        private static var data:Dictionary = new Dictionary();
        public static var _isLoaded:Boolean = false;
        public static var _instance:MonumentsProvider;
        public static var ON_LOAD:String = "ON_LOAD";

        public function MonumentsProvider(){
            super();
        }
        public static function get isLoaded():Boolean{
            if (!(_isLoaded)){
                startLoad();
            };
            return (_isLoaded);
        }
        private static function startLoad():void{
            trace("Monuments startLoad");
            var loader:Loader = new Loader();
            var req:URLRequest = new URLRequest("assets/swf/monuments.swf");
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fooLoadComplete);
            loader.load(req, new LoaderContext(false, ApplicationDomain.currentDomain));
        }
        protected static function fooLoadComplete(e:Event):void{
            _isLoaded = true;
            _instance.dispatchEvent(new Event(ON_LOAD));
        }
        public static function get instance():MonumentsProvider{
            if (_instance == null){
                _instance = new (MonumentsProvider)();
            };
            return (_instance);
        }
        public static function setMeshData(xml:XMLList, city:String):void{
            data[city] = xml;
        }
        public static function getMonumentsByCity(city:String):Vector.<Monument>{
            switch (city){
                case Locator.PARIS:
                    if (paris == null){
                        paris = setCity(Locator.PARIS);
                    };
                    return (paris);
                case Locator.LONDON:
                    if (london == null){
                        london = setCity(Locator.LONDON);
                    };
                    return (london);
                case Locator.BERLIN:
                    if (berlin == null){
                        berlin = setCity(Locator.BERLIN);
                    };
                    return (berlin);
            };
            return (null);
        }
        private static function setCity(city:String):Vector.<Monument>{
            var c:Class;
            var m:Vector.<Monument> = new Vector.<Monument>();
            var xml:XMLList = data[city];
            var l:int = xml.mesh.length();
            while (l--) {
                c = (getDefinitionByName(String(xml.mesh[l].@classpath)) as Class);
                m.push(new Monument(new (c)(), xml.mesh[l]));
            };
            return (m);
        }

    }
}//package wd.d3.geom.monuments 
