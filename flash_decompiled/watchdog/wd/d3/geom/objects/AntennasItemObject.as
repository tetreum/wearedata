package wd.d3.geom.objects {
    import wd.hud.items.*;
    import wd.hud.items.datatype.*;
    import wd.core.*;
    import __AS3__.vec.*;
    import biga.utils.*;
    import wd.sound.*;
    import aze.motion.*;
    import flash.geom.*;

    public class AntennasItemObject extends BaseItemObject {

        private var values:Vector.<Number>;
        public var time:Number = 0;

        public function AntennasItemObject(manager:ItemObjectsManager){
            super(manager);
        }
        override public function open(tracker:Tracker, list:Vector.<Tracker>=null, apply:Boolean=false):void{
            var t:Tracker;
            var e:ElectroMagneticTrackerData;
            var i:int;
            super.open(tracker, list, apply);
            net.flush();
            net.reloacte(manager);
            net.color = Colors.getColorByType(tracker.data.type);
            this.values = new Vector.<Number>();
            list.push(tracker);
            if (list.length == 1){
                this.values.push(1);
            } else {
                i = 0;
                while (i < list.length) {
                    e = (list[i].data as ElectroMagneticTrackerData);
                    this.values.push(parseFloat(e.level));
                    i++;
                };
                this.values = VectorUtils.normallizeAbsolute(this.values);
            };
            SoundManager.playFX("MultiConnecteV17", (0.5 + (Math.random() * 0.5)));
            net.triangleRenderCount = 1;
            this.time = 0;
            eaze(this).to(1, {time:1}).onUpdate(this.updateTween).onComplete(onOpened);
        }
        private function updateTween():void{
            var v0:Vector3D;
            var v1:Vector3D;
            var i:int;
            var h:Number;
            net.flush();
            v0 = new Vector3D();
            v1 = new Vector3D();
            i = 0;
            while (i < list.length) {
                h = (((this.time * this.values[i]) * Config.MAX_BUILDING_HEIGHT) * 4);
                v0.x = list[i].x;
                v0.z = list[i].z;
                v1.x = list[i].x;
                v1.y = (list[i].y = h);
                v1.z = list[i].z;
                net.addSegment(v0, v1);
                i++;
            };
        }
        override public function close(apply:Boolean=true):void{
            super.close(apply);
            eaze(this).to(1, {time:0}).onUpdate(this.updateTween).onComplete(onClosed);
        }

    }
}//package wd.d3.geom.objects 
