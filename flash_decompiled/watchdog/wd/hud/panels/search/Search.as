package wd.hud.panels.search {
    import flash.events.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import flash.text.*;
    import aze.motion.*;
    import wd.core.*;
    import flash.geom.*;
    import wd.hud.*;

    public class Search extends HudElement {

        private static const WIDTH:Number = 333;
        private static const HEIGHT:Number = 23;

        public static var tutoStartPoint:Point;

        private var asset:SearchIconAsset;
        private var label:CustomTextField;
        private var labelRov:CustomTextField;
        private var input:TextField;
        private var WIDTH_REDUCED:Number;
        private var _expanded:Boolean;
        private var results:ResultList;

        public function Search(){
            super();
            this.asset = new SearchIconAsset();
            this.asset.iconRov.alpha = 0;
            this.asset.barRov.alpha = 0;
            this.asset.name = "searchbar";
            this.addChild(this.asset);
            this.asset.iconRov.buttonMode = (this.asset.iconRov.buttonMode = true);
            this.asset.iconRov.mouseEnabled = false;
            this.asset.barRov.mouseEnabled = false;
            this.asset.addEventListener(MouseEvent.ROLL_OVER, this.onRoll);
            this.asset.addEventListener(MouseEvent.ROLL_OUT, this.onRoll);
            this.asset.addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            this.label = new CustomTextField((("_ " + FooterText.search) + " /"), "searchTitle");
            this.labelRov = new CustomTextField((("_ " + FooterText.search) + " /"), "searchTitleRollover");
            this.label.wordWrap = (this.labelRov.wordWrap = false);
            this.WIDTH_REDUCED = ((this.label.width + 20) + 15);
            this.label.x = (this.labelRov.x = ((this.asset.x - this.label.width) - 15));
            this.label.y = (this.labelRov.y = ((HEIGHT - this.label.height) / 2));
            this.asset.addChild(this.label);
            this.asset.addChild(this.labelRov);
            this.labelRov.alpha = 0;
            this.label.mouseEnabled = (this.labelRov.mouseEnabled = false);
            this.input = new TextField();
            this.input.defaultTextFormat = new TextFormat("Arial", 11, 0);
            this.input.name = "searchbartf";
            this.input.multiline = false;
            this.input.condenseWhite = false;
            this.input.text = (("_ " + FooterText.search) + " /");
            this.input.type = TextFieldType.INPUT;
            this.input.wordWrap = false;
            this.input.selectable = true;
            this.input.addEventListener(FocusEvent.FOCUS_IN, this.focusInHandler);
            this.input.addEventListener(FocusEvent.FOCUS_OUT, this.focusOutHandler);
            this.input.width = (WIDTH - 25);
            this.input.height = (HEIGHT - 4);
            this.input.x = (-(WIDTH) + 10);
            this.input.y = 2;
            this.asset.addChild(this.input);
            this.asset.x = this.WIDTH_REDUCED;
            this.results = new ResultList();
            this.results.addEventListener(Event.SELECT, this.onDown);
            this.results.x = 10;
            this.results.y = (this.asset.y - 5);
            addChild(this.results);
            tutoMode = false;
        }
        private function focusInHandler(e:FocusEvent):void{
            if (this.input.text == (("_ " + FooterText.search) + " /")){
                this.input.text = "";
            };
            this.input.setSelection(0, this.input.text.length);
        }
        private function focusOutHandler(e:FocusEvent):void{
            this.input.text = (("_ " + FooterText.search) + " /");
            this.results.flushItemList();
        }
        private function expand(e:Event):void{
            if (e != null){
                eaze(this.asset).to(0.5, {x:WIDTH}, true).onComplete(stage.addEventListener, MouseEvent.MOUSE_DOWN, this.onDown);
            } else {
                eaze(this.asset).to(0.5, {x:WIDTH}, true);
            };
            this.rou();
            eaze(this.label).to(0.7, {alpha:0}, true);
            eaze(this.labelRov).to(0.7, {alpha:0}, true);
        }
        private function reduce(e:Event):void{
            if (e != null){
                eaze(this.asset).to(0.5, {x:0}, true).onComplete(stage.removeEventListener, MouseEvent.MOUSE_DOWN, this.onDown);
            } else {
                eaze(this.asset).to(0.5, {x:0}, true);
            };
            this.rou();
        }
        private function onDown(e:Event):void{
            if (tutoMode){
                return;
            };
            if (((this.expanded) && (((!((e == null))) && (!((e.target == this.input))))))){
                Config.NAVIGATION_LOCKED = false;
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
                stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyDown);
                this.reduce(null);
            } else {
                Config.NAVIGATION_LOCKED = true;
                stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyDown);
                this.expand(null);
            };
            this.expanded = ((!(this.expanded)) ? true : false);
        }
        private function onKeyDown(e:KeyboardEvent):void{
            if (tutoMode){
                return;
            };
            if (this.input.text.length > 1){
                this.results.search(this.input.text);
            };
        }
        private function onRoll(e:MouseEvent):void{
            if (tutoMode){
                return;
            };
            if (!(this.expanded)){
                switch (e.type){
                    case MouseEvent.ROLL_OVER:
                        this.rov();
                        break;
                    case MouseEvent.ROLL_OUT:
                        this.rou();
                        break;
                };
            };
        }
        private function rov():void{
            eaze(this.asset.iconRov).to(0.5, {alpha:1}, true);
            eaze(this.asset.barRov).to(0.5, {alpha:1}, true);
            eaze(this.label).to(0.7, {alpha:0}, true);
            eaze(this.labelRov).to(0.7, {alpha:1}, true);
        }
        private function rou():void{
            eaze(this.asset.iconRov).to(0.5, {alpha:0}, true);
            eaze(this.asset.barRov).to(0.5, {alpha:0}, true);
            eaze(this.label).to(0.7, {alpha:1}, true);
            eaze(this.labelRov).to(0.7, {alpha:0}, true);
        }
        public function get expanded():Boolean{
            return (this._expanded);
        }
        public function set expanded(value:Boolean):void{
            this._expanded = value;
        }
        override public function set x(value:Number):void{
            super.x = value;
            tutoStartPoint = new Point(((this.x + WIDTH) + 20), (this.y + 10));
        }
        override public function set y(value:Number):void{
            super.y = value;
            tutoStartPoint = new Point(((this.x + WIDTH) + 20), (this.y + 10));
        }
        override public function tutoFocusIn():void{
            super.tutoFocusIn();
            this.expand(null);
        }
        override public function tutoFocusOut():void{
            super.tutoFocusOut();
            this.reduce(null);
        }

    }
}//package wd.hud.panels.search 
