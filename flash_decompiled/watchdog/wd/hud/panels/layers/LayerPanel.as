package wd.hud.panels.layers {
    import wd.providers.texts.*;
    import wd.http.*;
    import __AS3__.vec.*;
    import wd.hud.common.text.*;
    import wd.hud.common.graphics.*;
    import wd.utils.*;
    import wd.core.*;
    import wd.hud.*;
    import flash.events.*;
    import flash.geom.*;
    import wd.hud.panels.*;

    public class LayerPanel extends Panel {

        public static var tutoStartPoint:Point;

        private var scheme:Array;
        private var items:Vector.<LayerItem>;
        private var labels:Vector.<CustomTextField>;
        private var line:Line;

        public function LayerPanel(hud:Hud){
            var d:Object;
            var dy:int;
            var av:Boolean;
            var i:uint;
            var li:LayerItem;
            this.scheme = [{
                filterLabel:DataFilterText.transports,
                dataType:[DataType.METRO_STATIONS, DataType.VELO_STATIONS]
            }, {
                filterLabel:DataFilterText.metro,
                dataType:DataType.METRO_STATIONS
            }, {
                filterLabel:DataFilterText.bicycle,
                dataType:DataType.VELO_STATIONS
            }, {
                filterLabel:DataFilterText.networks,
                dataType:[DataType.ELECTROMAGNETICS, DataType.INTERNET_RELAYS, DataType.WIFIS, DataType.MOBILES]
            }, {
                filterLabel:DataFilterText.electromagnetics,
                dataType:DataType.ELECTROMAGNETICS
            }, {
                filterLabel:DataFilterText.internetRelays,
                dataType:DataType.INTERNET_RELAYS
            }, {
                filterLabel:DataFilterText.wifiHotSpots,
                dataType:DataType.WIFIS
            }, {
                filterLabel:DataFilterText.mobile,
                dataType:DataType.MOBILES
            }, {
                filterLabel:DataFilterText.streetFurniture,
                dataType:[DataType.ATMS, DataType.ADS, DataType.RADARS, DataType.TRAFFIC_LIGHTS, DataType.TOILETS, DataType.CAMERAS]
            }, {
                filterLabel:DataFilterText.atm,
                dataType:DataType.ATMS
            }, {
                filterLabel:DataFilterText.ad,
                dataType:DataType.ADS
            }, {
                filterLabel:DataFilterText.traffic,
                dataType:DataType.TRAFFIC_LIGHTS
            }, {
                filterLabel:DataFilterText.toilets,
                dataType:DataType.TOILETS
            }, {
                filterLabel:DataFilterText.cameras,
                dataType:DataType.CAMERAS
            }, {
                filterLabel:DataFilterText.social,
                dataType:[DataType.TWITTERS, DataType.INSTAGRAMS, DataType.FOUR_SQUARE, DataType.FLICKRS]
            }, {
                filterLabel:DataFilterText.twitter,
                dataType:DataType.TWITTERS
            }, {
                filterLabel:DataFilterText.instagram,
                dataType:DataType.INSTAGRAMS
            }, {
                filterLabel:DataFilterText.fourSquare,
                dataType:DataType.FOUR_SQUARE
            }, {
                filterLabel:DataFilterText.flickr,
                dataType:DataType.FLICKRS
            }];
            this.items = new Vector.<LayerItem>();
            this.labels = new Vector.<CustomTextField>();
            super();
            this.line = new Line(LEFT_PANEL_WIDTH);
            addTweenInItem([this.line, {scaleX:0}, {scaleX:1}]);
            this.addChild(this.line);
            title = new CustomTextField((CommonsText[Locator.CITY] + " Data."), "panelTitle");
            title.width = LEFT_PANEL_WIDTH;
            title.y = LINE_H_MARGIN;
            addTweenInItem([title, {alpha:0}, {alpha:1}]);
            this.addChild(title);
            addArrow((LEFT_PANEL_WIDTH - 7));
            var oy:int = int(title.height);
            var h:int = 14;
            for each (d in this.scheme) {
                dy = 0;
                if (d.dataType){
                    av = true;
                    if ((d.dataType is Array)){
                        for each (i in d.dataType) {
                            av = ((av) || (FilterAvailability.instance.isActive(d.dataType)));
                        };
                        dy = 3;
                    } else {
                        av = FilterAvailability.instance.isActive(d.dataType);
                    };
                    if (av){
                        li = new LayerItem(hud, d.dataType, d.filterLabel, h, LEFT_PANEL_WIDTH);
                        li.y = (oy + dy);
                        oy = (oy + ((li.height - 3) + dy));
                        expandedContainer.addChild(li);
                        this.items.push(li);
                        addTweenInItem([li, {
                            alpha:0,
                            x:-(LEFT_PANEL_WIDTH)
                        }, {
                            alpha:1,
                            x:0
                        }]);
                    };
                };
            };
            this.setBg(LEFT_PANEL_WIDTH, this.height);
        }
        public function build():void{
        }
        override protected function desactivate(e:Event=null):void{
            var li:LayerItem;
            var label:CustomTextField;
            desactivationTween(this.line);
            desactivationTween(title);
            desactivationTween(arrow);
            for each (li in this.items) {
                if (!(AppState.isActive(li.getType()))){
                    desactivationTween(li);
                };
            };
            for each (label in this.labels) {
                desactivationTween(label);
            };
        }
        override protected function activate():void{
            var li:LayerItem;
            var label:CustomTextField;
            activationTween(this.line);
            activationTween(title);
            activationTween(arrow);
            for each (li in this.items) {
                activationTween(li);
            };
            for each (label in this.labels) {
                activationTween(label);
            };
        }
        override protected function setBg(w:uint, h:uint):void{
            if (reduced){
                super.setBg(LEFT_PANEL_WIDTH, title.height);
            } else {
                super.setBg(LEFT_PANEL_WIDTH, h);
            };
        }
        public function checkState():void{
            var li:LayerItem;
            for each (li in this.items) {
                li.checkState();
            };
        }
        override public function set x(value:Number):void{
            super.x = value;
            tutoStartPoint = new Point((this.x + LEFT_PANEL_WIDTH), this.y);
        }
        override public function set y(value:Number):void{
            super.y = value;
            tutoStartPoint = new Point((this.x + LEFT_PANEL_WIDTH), this.y);
        }

    }
}//package wd.hud.panels.layers 
