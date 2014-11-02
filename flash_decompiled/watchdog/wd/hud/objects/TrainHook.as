package wd.hud.objects {
    import wd.hud.panels.*;
    import wd.hud.items.datatype.*;
    import wd.d3.control.*;
    import flash.utils.*;
    import wd.hud.items.*;
    import flash.display.*;

    public class TrainHook extends Sprite {

        private var label:TrainLabel;
        public var tracker:Tracker;
        private var interval:uint;
        private var data:TrainTrackerData;

        public function TrainHook(){
            super();
            this.label = new TrainLabel();
            addChild(this.label);
        }
        public function hook(tracker:Tracker):void{
            this.tracker = tracker;
            this.data = (tracker.data as TrainTrackerData);
            this.label.rolloverHandler(tracker);
            CameraController.instance.follow(tracker);
            this.interval = setInterval(this.update, 50);
        }
        private function update():void{
            this.label.update(this.tracker.screenPosition);
        }
        public function release():void{
            CameraController.instance.unfollow();
            clearInterval(this.interval);
            this.label.rolloutHandler(this.tracker);
        }

    }
}//package wd.hud.objects 
