package wd.d3.geom.metro.trains {
    import aze.motion.*;
    import aze.motion.easing.*;
    import wd.hud.*;
    import wd.d3.geom.metro.*;
    import biga.utils.*;
    import flash.geom.*;

    public class Train extends Vector3D {

        private static var uid:int = 0;

        public var id:int;
        public var duration:Number;
        public var edge:HEdge;
        public var progress:Number;
        public var arrivalTime:Number;
        public var trainset:uint;

        public function Train(trip:Trip, progress:Number=0){
            super();
            this.edge = trip.edge;
            this.edge.busy = true;
            this.id = trip.train_id;
            this.trainset = trip.trainset;
            this.duration = trip.duration;
            this.arrivalTime = (trip.time + this.duration);
            this.progress = progress;
            eaze(this).to(((this.duration / 1000) * (1 - progress)), {progress:1}).easing(Linear.easeNone).onUpdate(this.update).onComplete(this.dispose);
            this.edge.end.trainHasLeft(this);
            Hud.addTrain(this);
        }
        public function update():void{
            x = GeomUtils.lerp(this.progress, this.edge.startPosition.x, this.edge.endPosition.x);
            y = GeomUtils.lerp(this.progress, this.edge.startPosition.y, this.edge.endPosition.y);
            z = GeomUtils.lerp(this.progress, this.edge.startPosition.z, this.edge.endPosition.z);
        }
        public function get line():MetroLine{
            return (this.edge.line);
        }
        public function dispose():void{
            this.edge.start.removeTrain(this);
            this.edge.start.trainHasArrived(this);
            this.edge.end.trainHasArrived(this);
            this.edge.busy = false;
            Hud.removeTrain(this);
        }

    }
}//package wd.d3.geom.metro.trains 
