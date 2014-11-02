package wd.hud.panels.district {
    import wd.hud.common.graphics.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import wd.events.*;
    import wd.utils.*;
    import wd.hud.panels.district.distictDataDisplay.*;
    import flash.events.*;
    import flash.utils.*;
    import flash.geom.*;
    import wd.hud.panels.*;

    public class DistrictPanel extends Panel {

        public static var tutoStartPoint:Point;

        private var info:DistrictInfo;
        private var districtName:CustomTextField;
        private var districtName2:CustomTextField;
        private var latlong:CustomTextField;
        private var timerRefreshLatLong:Timer;
        private var line2:Line;
        private var firstRefresh:Boolean = true;
        private var infoBubble:InfoBubble;

        public function DistrictPanel(){
            var unit:String;
            super();
            var l:Line = new Line(RIGHT_PANEL_WIDTH);
            addTweenInItem([l, {
                scaleX:0,
                x:RIGHT_PANEL_WIDTH
            }, {
                scaleX:1,
                x:0
            }]);
            this.addChild(l);
            title = new CustomTextField(StatsText.title, "panelTitle");
            title.width = RIGHT_PANEL_WIDTH;
            title.y = 0;
            addTweenInItem([title, {alpha:0}, {alpha:1}]);
            this.addChild(title);
            addArrow((RIGHT_PANEL_WIDTH - 7));
            addTweenInItem([arrow, {alpha:0}, {alpha:1}]);
            this.districtName = new CustomTextField("", "statsPanelLocation");
            this.districtName.wordWrap = false;
            this.districtName.width = RIGHT_PANEL_WIDTH;
            addChild(this.districtName);
            this.districtName.y = ((title.height + title.y) - 15);
            this.districtName2 = new CustomTextField("e", "exp");
            this.districtName2.y = this.districtName.y;
            this.districtName2.visible = false;
            addChild(this.districtName2);
            this.latlong = new CustomTextField("", "latlong", CustomTextField.AUTOSIZE_RIGHT);
            addChild(this.latlong);
            this.latlong.wordWrap = false;
            this.latlong.y = ((this.districtName.height + this.districtName.y) - 26);
            this.latlong.x = RIGHT_PANEL_WIDTH;
            this.line2 = new Line(RIGHT_PANEL_WIDTH);
            this.line2.y = ((this.latlong.y + this.latlong.height) + LINE_H_MARGIN);
            addTweenInItem([this.line2, {
                scaleX:0,
                x:RIGHT_PANEL_WIDTH
            }, {
                scaleX:1,
                x:0
            }]);
            this.addChild(this.line2);
            this.info = new DistrictInfo();
            this.info.addEventListener(ServiceEvent.STATISTICS_COMPLETE, this.onStatsComplete);
            var oy:int = (this.line2.y + 5);
            var slideHeight:int = 40;
            if (Locator.CITY == Locator.LONDON){
                unit = "£";
            } else {
                unit = "€";
            };
            var d1:DistrictDataAmount = new DistrictDataAmount(this.info.data, "salary_monthly", StatsText.incomeText, RIGHT_PANEL_WIDTH, oy, unit, CityTexts.perMonth);
            expandedContainer.addChild(d1);
            d1.addEventListener(TextEvent.LINK, this.linkHandler);
            addTweenInItem([d1, {alpha:0}, {alpha:1}]);
            oy = (oy + d1.height);
            var d2:DistrictDataSlider = new DistrictDataSlider(this.info.data, "unemployment", StatsText.unemploymentText, RIGHT_PANEL_WIDTH, oy);
            expandedContainer.addChild(d2);
            d2.addEventListener(TextEvent.LINK, this.linkHandler);
            addTweenInItem([d2, {alpha:0}, {alpha:1}]);
            oy = (oy + d2.height);
            var d3:DistrictDataSlider = new DistrictDataSlider(this.info.data, "crimes_thousand", StatsText.crimeInfractionText, RIGHT_PANEL_WIDTH, oy);
            expandedContainer.addChild(d3);
            d3.addEventListener(TextEvent.LINK, this.linkHandler);
            addTweenInItem([d3, {alpha:0}, {alpha:1}]);
            oy = (oy + d3.height);
            var d4:DistrictDataAmount = new DistrictDataAmount(this.info.data, "electricity", StatsText.electricityConsumption, RIGHT_PANEL_WIDTH, oy, CityTexts.electricityConsumptionUnit);
            expandedContainer.addChild(d4);
            d4.addEventListener(TextEvent.LINK, this.linkHandler);
            addTweenInItem([d4, {alpha:0}, {alpha:1}]);
            this.setBg(this.width, this.height);
            this.infoBubble = new InfoBubble();
            this.infoBubble.x = -20;
            this.addChild(this.infoBubble);
            this.timerRefreshLatLong = new Timer(100);
            this.timerRefreshLatLong.addEventListener(TimerEvent.TIMER, this.refreshLatLong);
            this.timerRefreshLatLong.start();
        }
        private function linkHandler(e:TextEvent):void{
            trace(e.currentTarget.property);
            this.infoBubble.setText(e.currentTarget.property);
            this.infoBubble.y = e.currentTarget.y;
        }
        private function refreshLatLong(e:Event):void{
            this.latlong.text = ((Locator.LATITUDE.toFixed(6) + " ") + Locator.LONGITUDE.toFixed(6));
        }
        private function onStatsComplete(e:ServiceEvent):void{
            URLFormater.district = this.info.data.name;
            if (this.info.data.name.length < 4){
                this.districtName2.visible = true;
                if (!(this.firstRefresh)){
                    tweenInElement(this.districtName2, {alpha:0}, {alpha:1});
                };
                this.districtName.text = this.info.data.name.split("e")[0];
            } else {
                this.districtName2.visible = false;
                this.districtName.text = this.info.data.name;
            };
            if (!(this.firstRefresh)){
                tweenInElement(this.districtName, {alpha:0}, {alpha:1});
            };
            this.districtName.scaleX = (this.districtName.scaleY = 1);
            this.districtName.y = ((title.height + title.y) - 15);
            while (this.districtName.width > RIGHT_PANEL_WIDTH) {
                this.districtName.scaleX = (this.districtName.scaleX - 0.05);
                this.districtName.y = (this.districtName.y + 1);
                this.districtName.scaleY = this.districtName.scaleX;
            };
            if (this.info.data.name.length > 4){
                while (this.districtName.height > 41) {
                    this.districtName.scaleX = (this.districtName.scaleX - 0.05);
                    this.districtName.y = (this.districtName.y + 1);
                    this.districtName.scaleY = this.districtName.scaleX;
                };
            };
            this.districtName2.x = (this.districtName.x + this.districtName.width);
            if ((((this.districtName.height > 41)) && ((this.info.data.name.length > 4)))){
                this.latlong.visible = false;
            } else {
                this.latlong.visible = true;
            };
            if (this.info.data.name.length < 4){
                this.latlong.y = ((this.districtName.height + this.districtName.y) - 26);
            } else {
                this.latlong.y = ((this.line2.y - this.latlong.height) + 1);
            };
            var i:int;
            while (i < DistrictDataDisplay.datatsDisplays.length) {
                DistrictDataDisplay.datatsDisplays[i].update(1, (i * 0.25));
                i++;
            };
            this.firstRefresh = false;
        }
        override protected function setBg(w:uint, h:uint):void{
            if (reduced){
                super.setBg(RIGHT_PANEL_WIDTH, this.line2.y);
            } else {
                super.setBg(RIGHT_PANEL_WIDTH, h);
            };
        }
        override public function set x(value:Number):void{
            super.x = value;
            tutoStartPoint = new Point(this.x, this.y);
        }
        override public function set y(value:Number):void{
            super.y = value;
            tutoStartPoint = new Point(this.x, this.y);
        }

    }
}//package wd.hud.panels.district 
