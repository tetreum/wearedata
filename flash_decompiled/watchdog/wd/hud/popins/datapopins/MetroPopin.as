package wd.hud.popins.datapopins {
    import wd.hud.items.datatype.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import wd.core.*;
    import wd.http.*;
    import wd.hud.popins.datapopins.triangledatapopin.*;
    import flash.events.*;
    import flash.display.*;
    import wd.providers.*;

    public class MetroPopin extends DataPopin {

        private var m1:MetroLine1Asset;
        private var m2:MetroLine2Asset;
        private var m3:MetroLine3Asset;
        private var m3BIS:MetroLine3BISAsset;
        private var m4:MetroLine4Asset;
        private var m5:MetroLine5Asset;
        private var m6:MetroLine6Asset;
        private var m7:MetroLine7Asset;
        private var m7BIS:MetroLine7BISAsset;
        private var m8:MetroLine8Asset;
        private var m9:MetroLine9Asset;
        private var m10:MetroLine10Asset;
        private var m11:MetroLine11Asset;
        private var m12:MetroLine12Asset;
        private var m13:MetroLine13Asset;
        private var m14:MetroLine14Asset;
        private var txt1:CustomTextField;
        private var txt2:CustomTextField;
        private var nextTrains:CustomTextField;
        private var triangleData:TriangleDataPopin;

        public function MetroPopin(data:Object){
            super(data);
            var vdata:StationTrackerData = (tdata as StationTrackerData);
            this.txt1 = new CustomTextField(((vdata.trainsPerHour + " ") + CityTexts.metroTrainFrequencyUnit), "trainsPopinTxt1");
            this.txt1.width = POPIN_WIDTH;
            this.txt1.y = (this.line.y + 20);
            this.addChild(this.txt1);
            addTweenInItem([this.txt1]);
            if (FilterAvailability.isDetailActive(DataType.METRO_STATIONS)){
                this.txt2 = new CustomTextField((((vdata.averageCommuters + " <span class=\"trainsDataInfo\">") + CityTexts.metroCommutersFrequencyUnit) + "</span>"), "trainsPopinTxt1");
                this.txt2.width = POPIN_WIDTH;
                this.txt2.y = (this.txt1.y + this.txt1.height);
                this.addChild(this.txt2);
                addTweenInItem([this.txt2]);
                this.txt2.x = ICON_WIDTH;
            };
            this.txt1.x = ICON_WIDTH;
        }
        private function rolloverTrain(e:Event):void{
            if (((this.triangleData) && (this.contains(this.triangleData)))){
                this.removeChild(this.triangleData);
            };
            var icon:Icon = (e.target as Icon);
            var d1:TriangleDataPopinData = new TriangleDataPopinData(DataDetailText.metroNextTrainsTerminus1, icon.terminus1, CityTexts.metroTrainFrequencyUnit);
            var d2:TriangleDataPopinData = new TriangleDataPopinData(DataDetailText.metroNextTrainsTerminus2, icon.terminus2, CityTexts.metroTrainFrequencyUnit);
            this.triangleData = new TriangleDataPopin(d1, d2);
            this.triangleData.start();
            this.triangleData.mouseEnabled = false;
            this.triangleData.x = (e.target.x + (e.target.width / 2));
            this.triangleData.y = (e.target.y + (e.target.height / 2));
            this.addChildAt(this.triangleData, 0);
        }
        override protected function get titleData():String{
            var vdata:StationTrackerData = (tdata as StationTrackerData);
            return (vdata.station.name);
        }
        override protected function getIcon(type:uint):Sprite{
            var vdata:StationTrackerData = (tdata as StationTrackerData);
            var r:Sprite = new Sprite();
            if (vdata.station.lineCount > 1){
                r.graphics.lineStyle(5, 0);
                r.graphics.beginFill(0xFFFFFF);
                r.graphics.drawCircle(0, 0, 15);
                return (r);
            };
            r.graphics.beginFill(0);
            r.graphics.lineStyle(5, MetroLineColors.getColorByName(vdata.station.defaultLine.name));
            r.graphics.drawCircle(0, 0, 15);
            return (r);
        }

    }
}//package wd.hud.popins.datapopins 

import flash.display.*;
import __AS3__.vec.*;
import wd.d3.geom.metro.trains.*;

class Icon extends Sprite {

    public var terminus1:Number;
    public var terminus2:Number;

    public function Icon(trains:Vector.<Train>){
        super();
        this.terminus1 = trains[0].trainset;
        this.terminus2 = 0;
        if (trains.length > 1){
            this.terminus2 = trains[1].trainset;
        };
    }
}
