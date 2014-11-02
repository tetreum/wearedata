package wd.d3.geom.objects {
    import wd.core.*;
    import flash.events.*;
    import wd.sound.*;
    import aze.motion.*;
    import wd.hud.items.*;
    import __AS3__.vec.*;
    import flash.ui.*;
    import wd.http.*;
    import wd.d3.control.*;
    import wd.events.*;
    import wd.hud.items.datatype.*;
    import flash.geom.*;
    import flash.utils.*;

    public class NetworkObject extends BaseItemObject {

        private var height:Number = 15;
        private var iterator:int = 0;
        public var switching:Boolean;

        public function NetworkObject(manager:ItemObjectsManager){
            super(manager);
        }
        override public function open(tracker:Tracker, list:Vector.<Tracker>=null, apply:Boolean=false):void{
            Config.NAVIGATION_LOCKED = true;
            tracker.data.visited = true;
            manager.sim.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            super.open(tracker, list, apply);
            net.reloacte(manager);
            net.color = Colors.getColorByType(tracker.data.type);
            createDelaunayFromList();
            net.triangleRenderCount = 0;
            SoundManager.playFX("MultiConnecteV17", (0.5 + (Math.random() * 0.5)));
            eaze(net).to(1.5, {triangleRenderCount:1});
            eaze(this).delay(0.75).onComplete(onOpened);
        }
        private function onKeyDown(e:KeyboardEvent):void{
            if ((((((((((e.keyCode == Keyboard.ESCAPE)) || ((e.keyCode == Keyboard.UP)))) || ((e.keyCode == Keyboard.DOWN)))) || ((e.charCode == "+".charCodeAt(0))))) || ((e.charCode == "-".charCodeAt(0))))){
                manager.popinManager.hide(null);
                return;
            };
            if (list.length <= 1){
                return;
            };
            if ((((((((((((((((((((list[0].data.type == DataType.ADS)) || ((list[0].data.type == DataType.ATMS)))) || ((list[0].data.type == DataType.CAMERAS)))) || ((list[0].data.type == DataType.ELECTROMAGNETICS)))) || ((list[0].data.type == DataType.FOUR_SQUARE)))) || ((list[0].data.type == DataType.MOBILES)))) || ((list[0].data.type == DataType.TOILETS)))) || ((list[0].data.type == DataType.TRAFFIC_LIGHTS)))) || ((list[0].data.type == DataType.VELO_STATIONS)))) || ((this.pickBestCandidate(list) == false)))){
                list.splice(list.indexOf(tracker), 1);
                list.sort(this.randomSort);
                tracker = list[0];
            };
            tracker.data.visited = true;
            manager.popinManager.hide(null);
            manager.sim.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            CameraController.instance.addEventListener(NavigatorEvent.TARGET_REACHED, this.onTargetReached);
            CameraController.instance.setTarget(tracker, tracker.data.lon, tracker.data.lat);
        }
        private function pickBestCandidate(list:Vector.<Tracker>):Boolean{
            var item:Tracker;
            var tw:TwitterTrackerData;
            var ntw:TwitterTrackerData;
            var f:FlickrTrackerData;
            var nf:FlickrTrackerData;
            var i:InstagramTrackerData;
            var ni:InstagramTrackerData;
            var found:Boolean;
            var t:Tracker = tracker;
            t.data.visited = true;
            for each (item in list) {
                if (item != t){
                    if (item.data.visited){
                    } else {
                        if ((item.data is TwitterTrackerData)){
                            tw = (t.data as TwitterTrackerData);
                            ntw = (item.data as TwitterTrackerData);
                            if ((((((tw.from_user == ntw.from_user)) || (!((ntw.caption.lastIndexOf(tw.name) == -1))))) || (((!((tw.place_name == ""))) && ((tw.place_name == ntw.place_name)))))){
                                tracker = item;
                                return (true);
                            };
                        };
                        if ((item.data is FlickrTrackerData)){
                            f = (t.data as FlickrTrackerData);
                            nf = (item.data as FlickrTrackerData);
                            if ((((f.userName == nf.userName)) || ((f.time == nf.time)))){
                                tracker = item;
                                return (true);
                            };
                        };
                        if ((item.data is InstagramTrackerData)){
                            i = (t.data as InstagramTrackerData);
                            ni = (item.data as InstagramTrackerData);
                            if (i.name == ni.name){
                                tracker = item;
                                return (true);
                            };
                        };
                    };
                };
            };
            return (false);
        }
        private function closestSort(a:Tracker, b:Tracker):Number{
            return ((((Vector3D.distance(tracker, a) < Vector3D.distance(tracker, b))) ? -1 : 1));
        }
        private function randomSort(a:Tracker, b:Tracker):Number{
            return ((((Math.random() > 0.5)) ? -1 : 1));
        }
        private function onTargetReached(e:NavigatorEvent):void{
            CameraController.instance.removeEventListener(NavigatorEvent.TARGET_REACHED, this.onTargetReached);
            manager.itemClickHandler(e.data);
        }
        override public function close(apply:Boolean=false):void{
            manager.sim.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            Config.NAVIGATION_LOCKED = false;
            super.close(true);
            eaze(net).to(0.5, {triangleRenderCount:0});
        }
        override public function update():void{
            var t:Number = (0.5 + (Math.sin((getTimer() * 0.001)) * 0.5));
            net.thickness = (0.2 + (Math.random() * 1));
            net.alpha = (0.5 + (Math.random() * 0.5));
        }
        override public function removeListeners():void{
            manager.sim.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            CameraController.instance.removeEventListener(NavigatorEvent.TARGET_REACHED, this.onTargetReached);
        }

    }
}//package wd.d3.geom.objects 
