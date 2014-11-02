package wd.hud.popins.datapopins {
    import flash.display.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import flash.events.*;
    import wd.utils.*;
    import wd.hud.items.datatype.*;

    public class FoursquarePopin extends DataPopin {

        private var txt1:CustomTextField;
        private var txt2:CustomTextField;
        private var txt3:CustomTextField;

        public function FoursquarePopin(data:Object){
            var sprCtn:Sprite;
            super(data);
            this.txt1 = new CustomTextField("", "foursquarePopinDate");
            this.txt1.y = (line.y + 10);
            this.txt1.x = ICON_WIDTH;
            this.addChild(this.txt1);
            addTweenInItem([this.txt1]);
            var logo2:Sprite = new FoursquarePopinIcon2Asset();
            logo2.y = (line.y + 10);
            logo2.x = (POPIN_WIDTH - logo2.width);
            this.addChild(logo2);
            addTweenInItem([logo2]);
            this.txt2 = new CustomTextField(DataDetailText.fourSquarePowered, "foursquarePopinDate");
            this.txt2.y = (line.y + 10);
            this.txt2.wordWrap = false;
            this.txt2.x = ((logo2.x - this.txt2.width) - 2);
            this.addChild(this.txt2);
            addTweenInItem([this.txt2]);
            var logo3:Sprite = new FoursquarePopinMayorIcon();
            logo3.y = (line.y + 42);
            logo3.x = ICON_WIDTH;
            this.addChild(logo3);
            addTweenInItem([logo3]);
            sprCtn = new Sprite();
            sprCtn.mouseChildren = false;
            sprCtn.buttonMode = true;
            sprCtn.addEventListener(MouseEvent.CLICK, this.clickVenue);
            this.txt3 = new CustomTextField((((DataDetailText.fourSquareIsTheNewMayorOf + "<span class=\"foursquarePopinTextBold\">") + StringUtils.htmlDecode((data as FoursquareTrackerData).place)) + "</span>"), "foursquarePopinText");
            this.txt3.y = (line.y + 42);
            this.txt3.width = ((POPIN_WIDTH - ICON_WIDTH) - logo3.width);
            this.txt3.x = ((logo3.x + logo3.width) + 20);
            sprCtn.addChild(this.txt3);
            this.addChild(sprCtn);
            addTweenInItem([this.txt3]);
        }
        override protected function setTitle(str:String):void{
            super.setTitle(StringUtils.htmlDecode((tdata as FoursquareTrackerData).userName));
            titleCtn.addEventListener(MouseEvent.CLICK, this.clickTitle);
            titleCtn.buttonMode = true;
            titleCtn.mouseChildren = false;
        }
        private function clickVenue(e:MouseEvent):void{
            JsPopup.open((tdata as FoursquareTrackerData).venueUrl);
        }
        private function clickTitle(e:MouseEvent):void{
            JsPopup.open(("https://www.foursquare.com/user/" + (tdata as FoursquareTrackerData).userId));
        }
        override protected function getIcon(type:uint):Sprite{
            return (new FoursquarePopinIconAsset());
        }
        override protected function disposeHeader():void{
            super.disposeHeader();
            icon.x = (icon.y = 0);
        }

    }
}//package wd.hud.popins.datapopins 
