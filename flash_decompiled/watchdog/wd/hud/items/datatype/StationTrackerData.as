package wd.hud.items.datatype {
    import wd.d3.geom.metro.*;
    import __AS3__.vec.*;
    import wd.d3.geom.metro.trains.*;
    import wd.hud.items.*;

    public class StationTrackerData extends TrackerData {

        private var name:String;
        private var _station:MetroStation;
        private var _averageCommuters:String;

        public function StationTrackerData(type:int, id:int, lon:Number, lat:Number, station:MetroStation){
            super(type, id, lon, lat, null);
            this.station = station;
            this.resetVars();
        }
        public function get station():MetroStation{
            return (this._station);
        }
        public function set station(value:MetroStation):void{
            this._station = value;
            this.resetVars();
        }
        public function get trainsPerHour():int{
            return (this.station.getTrainset());
        }
        public function get averageCommuters():String{
            return (this._averageCommuters);
        }
        private function resetVars():void{
            this.name = this.station.name;
            if (this.station.passengers != null){
                this._averageCommuters = (((this.station.passengers.toLowerCase() == "nc")) ? "--" : this.station.passengers);
            } else {
                this._averageCommuters = "--";
            };
        }
        public function get nextTrains():Vector.<Train>{
            return (this.station.getClosestTrains());
        }

    }
}//package wd.hud.items.datatype 
