package wd.d3.geom.metro {

    public final class Trip {

        public static const DELAY_VARIATION:Number = 0;
        public static const SPEED_VARIATION:Number = 0;

        private static var date:Date = new Date();
        private static var STOP_TIME:Number = 10;
        public static var line:MetroLine;

        public var dep_station:MetroStation;
        public var arr_station:MetroStation;
        public var time:Number;
        public var duration:Number;
        public var trainset:uint;
        public var train_id:uint;
        public var edge:HEdge;
        public var started:Boolean;

        public function Trip(desc:String){
            super();
            var bits:Array = desc.split("|");
            this.edge = HEdge.getEdge((line = MetroLine.getLineByName(bits[1])), MetroStation.getStationByRef(bits[0]), MetroStation.getStationByRef(bits[4]));
            var tmp:Array = bits[2].split(":");
            date.hours = tmp[0];
            date.minutes = tmp[1];
            date.seconds = tmp[2];
            this.time = date.getTime();
            this.duration = (parseFloat(bits[3]) * 1000);
            this.train_id = bits[5];
            this.trainset = bits[6];
        }
        public function dispose():void{
            this.dep_station = null;
            line = null;
            this.time = NaN;
            this.duration = NaN;
            this.arr_station = null;
        }

    }
}//package wd.d3.geom.metro 
