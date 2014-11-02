package wd.d3.geom.objects {
    import wd.utils.*;
    import flash.utils.*;
    import wd.d3.geom.objects.networks.*;
    import wd.d3.*;
    import wd.hud.items.*;
    import wd.data.*;
    import wd.http.*;
    import __AS3__.vec.*;
    import flash.geom.*;
    import wd.hud.popins.*;
    import flash.events.*;
    import wd.events.*;
    import away3d.containers.*;

    public class ItemObjectsManager extends ObjectContainer3D {

        private static var instance:ItemObjectsManager;

        private var objects:Dictionary;
        private var current:BaseItemObject;
        private var nextTracker:Tracker;
        private var nextList:Vector.<Tracker>;
        public var sim:Simulation;
        public var net:Network;
        private var tracker:Tracker;
        private var _popinManager:PopinsManager;

        public function ItemObjectsManager(sim:Simulation){
            this.objects = new Dictionary(true);
            super();
            this.sim = sim;
            this.net = new Network(this, 0xFF00, 0.5);
            this.objects["network"] = new NetworkObject(this);
            this.objects["spot"] = new WifiItemObject(this);
            this.objects["electro"] = new AntennasItemObject(this);
            instance = this;
        }
        public static function get activityType():int{
            var type:int = -1;
            if (((((!((instance == null))) && (!((instance.current == null))))) && (instance.current.opened))){
                type = instance.current.tracker.data.type;
            };
            URLFormater.activityType = type;
            return (type);
        }

        public function update():void{
            if (this.current != null){
                this.current.update();
            };
        }
        public function itemRollOutHandler(tracker:Tracker, staticTrackersOnView:ListVec3D):void{
        }
        public function itemRollOverHandler(tracker:Tracker, staticTrackersOnView:ListVec3D):void{
        }
        public function itemClickHandler(tracker:Tracker):void{
            if (this.closeCurrent(tracker)){
                return;
            };
            if ((((tracker.data.type == DataType.TRAINS)) || ((tracker.data.type == DataType.METRO_STATIONS)))){
                this.popinManager.openPopin(tracker.data);
                return;
            };
            switch (tracker.data.type){
                case DataType.WIFIS:
                    this.current = this.objects["spot"];
                    (this.current as WifiItemObject).radius = 100;
                    break;
                case DataType.INTERNET_RELAYS:
                    this.current = this.objects["spot"];
                    (this.current as WifiItemObject).radius = 200;
                    break;
                case DataType.ELECTROMAGNETICS:
                    this.current = this.objects["electro"];
                    break;
                default:
                    this.current = this.objects["network"];
            };
            this.current.open(tracker, this.collectListFromTrackers(tracker));
        }
        private function collectListFromTrackers(tracker:Tracker):Vector.<Tracker>{
            var t:Tracker;
            var i:int;
            var node:ListNodeVec3D = Tracker.staticTrackersOnView.head;
            var list:Vector.<Tracker> = new Vector.<Tracker>();
            if (node != null){
                i = 0;
                while (node) {
                    t = (node.data as Tracker);
                    if (((!((t == tracker))) && ((t.data.type == tracker.data.type)))){
                        list.push(t);
                    };
                    node = node.next;
                };
            };
            this.tracker = tracker;
            list.sort(this.closestSort);
            list = list.splice(0, 10);
            return (list);
        }
        private function closestSort(a:Tracker, b:Tracker):Number{
            return ((((Vector3D.distance(this.tracker, a) < Vector3D.distance(this.tracker, b))) ? -1 : 1));
        }
        public function get popinManager():PopinsManager{
            return (this._popinManager);
        }
        public function set popinManager(value:PopinsManager):void{
            if (this._popinManager != null){
                this._popinManager.removeEventListener(Event.CLOSE, this.onPopinClose);
            };
            this._popinManager = value;
            this._popinManager.addEventListener(Event.CLOSE, this.onPopinClose);
        }
        private function onPopinClose(e:Event=null):void{
            this.closeCurrent(null);
        }
        private function closeCurrent(next:Tracker):Boolean{
            var o:BaseItemObject;
            var sameId:Boolean;
            if (this.current != null){
                if (this.current.opened){
                    this.current.close();
                    dispatchEvent(new NavigatorEvent(NavigatorEvent.DO_WAVE, this.current.tracker));
                };
                this.current.opened = false;
                this.current.tracker.selected = false;
                this.current.removeListeners();
                if (((!((next == null))) && ((next.data.id == this.current.tracker.data.id)))){
                    sameId = true;
                };
            };
            this.current = null;
            for each (o in this.objects) {
                o.opened = false;
            };
            return (sameId);
        }

    }
}//package wd.d3.geom.objects 
