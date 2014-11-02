package wd.hud.items.datatype {
    import wd.d3.geom.metro.trains.*;
    import wd.providers.texts.*;
    import wd.hud.items.*;

    public class TrainTrackerData extends TrackerData {

        private var train:Train;

        public function TrainTrackerData(type:int, id:int, lon:Number, lat:Number, train:Train){
            super(type, train.id, lon, lat, train);
            this.train = train;
        }
        public function update():void{
        }
        override public function get labelData():String{
            var str:String = ((DataLabel.train_line + " ") + this.train.edge.line.name.toUpperCase());
            str = (str + (((("<br>" + DataLabel.train_frequency) + this.train.trainset) + " ") + DataLabel.train_frequency_unit));
            str = (str + ((("<br>" + DataLabel.train_from) + " ") + this.train.edge.start.name));
            str = (str + ((("<br>" + DataLabel.train_to) + " ") + this.train.edge.end.name));
            str = (str + (((("<br>" + DataLabel.train_arrival_time) + " ") + ((this.train.duration * (1 - this.train.progress)) / 1000).toFixed(3)) + " s"));
            return (str);
        }

    }
}//package wd.hud.items.datatype 
