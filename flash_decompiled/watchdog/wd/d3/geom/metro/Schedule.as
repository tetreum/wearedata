package wd.d3.geom.metro {
    import __AS3__.vec.*;
    import flash.utils.*;
    import flash.events.*;
    import wd.d3.geom.metro.trains.*;

    public class Schedule {

        public static const TIME_INTERVAL:int = 1000;

        private var _stations:Vector.<MetroStation>;
        private var trips:Vector.<Trip>;
        private var timer:Timer;
        private var date:Date;
        private var time:Number;

        public function Schedule(){
            super();
        }
        public function reset(_time:String, _trips:Array):void{
            var bits:Array;
            var t:Trip;
            if (isNaN(this.time)){
                bits = _time.split(":");
                this.date = new Date();
                this.date.hours = parseFloat(bits[0]);
                this.date.minutes = parseFloat(bits[1]);
                this.date.seconds = parseFloat(bits[2]);
                this.time = this.date.getTime();
            };
            this.trips = ((this.trips) || (new Vector.<Trip>()));
            var i:int;
            while (i < _trips.length) {
                if ((((_trips[i] == null)) || ((_trips[i] == false)))){
                } else {
                    t = new Trip(_trips[i]);
                    if (((!((t.edge == null))) && ((this.time < (t.time + t.duration))))){
                        if (this.time < t.time){
                            this.trips.push(t);
                        };
                    } else {
                        t.dispose();
                        t = null;
                    };
                };
                i++;
            };
            this.timer = new Timer(TIME_INTERVAL);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTick);
            this.timer.start();
        }
        private function onTick(e:TimerEvent):void{
            var i:int;
            var t:Trip;
            i = 0;
            while (i < this.trips.length) {
                t = this.trips[i];
                if (t == null){
                } else {
                    if (this.time <= (t.time + t.duration)){
                        if (this.time >= (t.time - TIME_INTERVAL)){
                            this.startTrain(t);
                        };
                    } else {
                        t.dispose();
                        t = null;
                    };
                };
                i++;
            };
            this.time = (this.time + TIME_INTERVAL);
        }
        private function startTrain(trip:Trip):void{
            if (trip.edge.busy){
                trip.time = (trip.time + (5 * TIME_INTERVAL));
                return;
            };
            new Train(trip);
            this.trips.splice(this.trips.indexOf(trip), 1);
            trip.dispose();
            trip = null;
        }
        public function get stations():Vector.<MetroStation>{
            return (this._stations);
        }
        public function set stations(value:Vector.<MetroStation>):void{
            this._stations = value;
        }

    }
}//package wd.d3.geom.metro 
