package wd.footer {
    import __AS3__.vec.*;
    import wd.providers.texts.*;
    import wd.utils.*;
    import flash.display.*;
    import flash.events.*;
    import wd.core.*;
    import aze.motion.*;
    import flash.net.*;

    public class CitySelector extends Sprite {

        public static const ITEM_HEIGHT:uint = 20;
        public static const DEFAULT_WIDTH:uint = 70;

        private const ITEM_PADDING:uint = 2;

        private var items:Array;
        private var arrow:DropListArrowAsset;
        private var mouseZone:Shape;

        public function CitySelector(){
            super();
            this.items = new Array();
            this.build();
            this.defaultSelection();
        }
        public function build():void{
            var item:CitySelectorItem;
            var maxWidth:uint;
            var c:CitySelectorItem;
            var h:CitySelectorItem;
            var items:Vector.<CitySelectorItem> = Vector.<CitySelectorItem>([new CitySelectorItem(CommonsText.paris, this.clickItemHandler, Locator.PARIS, CitySelector.DEFAULT_WIDTH, CitySelector.ITEM_HEIGHT), new CitySelectorItem(CommonsText.berlin, this.clickItemHandler, Locator.BERLIN, CitySelector.DEFAULT_WIDTH, CitySelector.ITEM_HEIGHT), new CitySelectorItem(CommonsText.london, this.clickItemHandler, Locator.LONDON, CitySelector.DEFAULT_WIDTH, CitySelector.ITEM_HEIGHT)]);
            items.sort(this.citySort);
            for each (item in items) {
                this.addItem(item);
            };
            maxWidth = 0;
            for each (c in items) {
                maxWidth = Math.max(maxWidth, c.width);
            };
            for each (h in items) {
                h.setWidth(maxWidth);
            };
            this.mouseZone = new Shape();
            this.mouseZone.graphics.beginFill(0xFF0000, 0);
            this.mouseZone.graphics.drawRect(0, 0, DEFAULT_WIDTH, ITEM_HEIGHT);
            this.addChildAt(this.mouseZone, 0);
            this.addEventListener(MouseEvent.ROLL_OVER, this.expand);
            this.addEventListener(MouseEvent.ROLL_OUT, this.reduce);
            this.arrow = new DropListArrowAsset();
            this.arrow.x = (maxWidth - 10);
            this.arrow.y = ((ITEM_HEIGHT / 2) - 2);
            this.addChild(this.arrow);
        }
        private function citySort(a:CitySelectorItem, b:CitySelectorItem):Number{
            if (a.id == Config.CITY){
                return (-1);
            };
            if (b.id == Config.CITY){
                return (-1);
            };
            return (0);
        }
        private function expand(e:Event):void{
            var c:CitySelectorItem;
            this.mouseZone.height = (this.items.length * (ITEM_HEIGHT + this.ITEM_PADDING));
            this.mouseZone.y = (-((this.items.length - 1)) * (ITEM_HEIGHT + this.ITEM_PADDING));
            var l:uint;
            for each (c in this.items) {
                if (c.id == Locator.CITY){
                } else {
                    c.visible = true;
                    eaze(c).to(0.5, {alpha:1});
                    c.y = (-((this.ITEM_PADDING + ITEM_HEIGHT)) * (l + 1));
                    l++;
                };
            };
            eaze(this.arrow).to(0.25, {
                rotation:-180,
                y:((ITEM_HEIGHT / 2) + 2)
            });
        }
        private function reduce(e:Event=null):void{
            var c:CitySelectorItem;
            this.mouseZone.y = 0;
            for each (c in this.items) {
                if (c.id == Locator.CITY){
                } else {
                    c.visible = true;
                    eaze(c).to(0.5, {alpha:0});
                };
            };
            eaze(this.arrow).to(0.25, {
                rotation:0,
                y:((ITEM_HEIGHT / 2) - 2)
            });
        }
        private function addItem(item:CitySelectorItem):void{
            this.items.push(item);
            this.addChild(item);
        }
        public function defaultSelection():void{
            var s:CitySelectorItem;
            for each (s in this.items) {
                if (s.id == Locator.CITY){
                    s.visible = true;
                    this.select(s);
                } else {
                    s.alpha = 0;
                    s.visible = false;
                };
            };
        }
        public function select(item:CitySelectorItem):void{
            item.y = 0;
            item.visible = true;
        }
        private function clickItemHandler(e:Event):void{
            URLFormater.city = e.target.id;
            URLFormater.shortenURL(URLFormater.changeCityUrl(e.target.id), this.goToURL);
            this.select((e.target as CitySelectorItem));
            this.reduce();
        }
        public function goToURL(url:String):void{
            navigateToURL(new URLRequest(url), "_self");
        }

    }
}//package wd.footer 

import flash.display.*;
import flash.events.*;
import wd.core.*;
import aze.motion.*;
import wd.hud.common.text.*;

class CitySelectorItem extends Sprite {

    private var label:CustomTextField;
    private var bg:Shape;
    public var id:String;

    public function CitySelectorItem(label:String, clickFunc:Function, id:String, w:uint, h:uint){
        super();
        this.id = id;
        this.label = new CustomTextField(label.toUpperCase(), "centerFooterItem");
        this.label.wordWrap = false;
        this.addChild(this.label);
        this.bg = new Shape();
        this.bg.graphics.beginFill(0x343434, 1);
        this.bg.graphics.drawRoundRect(0, 0, (this.label.width + 30), h, 5, 5);
        this.label.x = ((w - this.label.width) / 2);
        this.label.y = ((h - this.label.height) / 2);
        this.addChildAt(this.bg, 0);
        if (Config.CITY != id){
            this.buttonMode = true;
            this.mouseChildren = false;
            this.addEventListener(MouseEvent.CLICK, clickFunc);
        };
    }
    public function setWidth(w:uint):void{
        this.bg.graphics.beginFill(0x343434, 1);
        this.bg.graphics.drawRoundRect(0, 0, w, this.bg.height, 3, 3);
        this.label.x = ((w - this.label.width) / 2);
    }
    public function hide(delay:Number):void{
        eaze(this).to(0.5, {alpha:0}).delay(delay);
    }
    public function show(delay:Number):void{
        this.visible = true;
        eaze(this).to(0.5, {alpha:1}).delay(delay);
    }

}
