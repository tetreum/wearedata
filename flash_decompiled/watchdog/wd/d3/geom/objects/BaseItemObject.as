package wd.d3.geom.objects {
    import __AS3__.vec.*;
    import wd.hud.items.*;
    import flash.geom.*;
    import wd.d3.geom.objects.delaunay.*;
    import wd.d3.geom.objects.networks.*;
    import away3d.containers.*;

    public class BaseItemObject extends ObjectContainer3D {

        protected var manager:ItemObjectsManager;
        protected var net:Network;
        private var _list:Vector.<Tracker>;
        private var _tracker:Tracker;
        private var _opened:Boolean;

        public function BaseItemObject(manager:ItemObjectsManager){
            super();
            this.manager = manager;
            this.net = manager.net;
            manager.addChild(this);
            this.list = new Vector.<Tracker>();
        }
        public function open(tracker:Tracker, list:Vector.<Tracker>=null, apply:Boolean=false):void{
            this.tracker = tracker;
            if (list != null){
                this.list = list;
            };
            this.opened = apply;
        }
        public function onOpened():void{
            this.opened = true;
            this.manager.popinManager.openPopin(this.tracker.data);
        }
        public function show():void{
        }
        public function hide():void{
        }
        public function close(apply:Boolean=true):void{
            this.opened = apply;
        }
        public function onClosed():void{
            this.opened = false;
        }
        public function update():void{
        }
        public function get tracker():Tracker{
            return (this._tracker);
        }
        public function set tracker(value:Tracker):void{
            this._tracker = value;
        }
        public function get list():Vector.<Tracker>{
            return (this._list);
        }
        public function set list(value:Vector.<Tracker>):void{
            this._list = value;
        }
        public function get opened():Boolean{
            return (this._opened);
        }
        public function set opened(value:Boolean):void{
            this._opened = value;
        }
        public function createDelaunayFromList():void{
            if (this.list == null){
                return;
            };
            var v:Vector3D = new Vector3D(this.tracker.x, 0, this.tracker.z);
            if (this.list.length == 0){
                this.net.flush();
                this.net.addSegment(this.tracker, v);
                this.net.triangleRenderCount = 1;
                return;
            };
            if (this.list.length == 1){
                this.net.flush();
                this.net.addSegment(this.tracker, v);
                this.net.addSegment(v, this.list[0]);
                this.net.addSegment(this.list[0], this.tracker);
                this.net.triangleRenderCount = 1;
                return;
            };
            this.list.unshift(this.tracker);
            var inds:Vector.<int> = CustomDelaunay.instance.compute(Vector.<Vector3D>(this.list));
            if (inds == null){
                return;
            };
            this.net.initAsTriangles(this.list, inds);
            this.net.triangleRenderCount = 0;
        }
        private function horizontalSort(a:Tracker, b:Tracker):Number{
            return ((((a.x < b.x)) ? -1 : 1));
        }
        public function removeListeners():void{
        }

    }
}//package wd.d3.geom.objects 
