package wd.hud.popins.datapopins {
    import wd.core.*;
    import wd.http.*;
    import wd.hud.items.datatype.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;

    public class VeloPopin extends DataPopin {

        private var txt1:CustomTextField;
        private var txt2:CustomTextField;
        private var txt3:CustomTextField;
        private var txt4:CustomTextField;

        public function VeloPopin(data:Object){
            super(data);
            if (!(FilterAvailability.isDetailActive(DataType.VELO_STATIONS))){
                return;
            };
            var vdata:VeloTrackerData = (tdata as VeloTrackerData);
            this.txt1 = new CustomTextField(((int(vdata.free) + " ") + DataDetailText.bicycleAvailable), "bikesPopinTxt1");
            this.txt1.width = POPIN_WIDTH;
            this.txt1.y = (this.line.y + 20);
            this.addChild(this.txt1);
            addTweenInItem([this.txt1, {alpha:0}, {alpha:1}]);
            this.txt2 = new CustomTextField(((int(vdata.available) + " ") + DataDetailText.bicycleAvailableSlots), "bikesPopinTxt1");
            this.txt2.width = POPIN_WIDTH;
            this.txt2.y = (this.txt1.y + this.txt1.height);
            this.addChild(this.txt2);
            addTweenInItem([this.txt2, {alpha:0}, {alpha:1}]);
            if (vdata.updated != "null"){
                this.txt3 = new CustomTextField(((DataDetailText.bicycleUpdatedAt + " ") + vdata.updated), "bikesPopinTxt3");
                this.txt3.y = ((this.txt2.y + this.txt2.height) + 5);
                this.txt3.width = POPIN_WIDTH;
                this.addChild(this.txt3);
                addTweenInItem([this.txt3, {alpha:0}, {alpha:1}]);
            };
            this.txt4 = new CustomTextField(vdata.address, "bikesPopinTxt4");
            this.txt4.y = ((this.txt3.y + this.txt3.height) + 5);
            this.txt4.width = POPIN_WIDTH;
            this.addChild(this.txt4);
            addTweenInItem([this.txt4, {alpha:0}, {alpha:1}]);
            this.txt1.x = (this.txt2.x = (this.txt3.x = (this.txt4.x = ICON_WIDTH)));
        }
        override protected function get titleData():String{
            return ((((tdata as VeloTrackerData).id + " - ") + (tdata as VeloTrackerData).name));
        }

    }
}//package wd.hud.popins.datapopins 
