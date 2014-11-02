package wd.hud.panels.search {
    import wd.hud.common.text.*;
    import wd.utils.*;
    import wd.hud.panels.layers.*;
    import flash.events.*;
    import flash.geom.*;
    import wd.d3.*;
    import flash.display.*;

    public class SearchItem extends Sprite {

        private var picto:LayerItemIcon;
        private var list:ResultList;
        private var _position:Point;
        public var destination:Vector3D;
        public var id:uint;
        public var place:Place;

        public function SearchItem(type:int, result:Array, list:ResultList){
            var t:String;
            var desc:CustomTextField;
            super();
            this.list = list;
            this.id = parseInt(result["id"]);
            this.place = new Place(((((result["description"]) || (result["title"]))) || (result["name"])), parseFloat(result["lng"]), parseFloat(result["lat"]));
            name = ((((result["description"]) || (result["title"]))) || (result["name"]));
            this.picto = new LayerItemIcon(type);
            this.addChild(this.picto);
            this.picto.x = 10;
            this.picto.y = 9;
            t = ((result["title"]) || (result["name"]));
            if (t.length > 40){
                t = (t.substr(0, 35) + "[...]");
            };
            var title:CustomTextField = new CustomTextField(t, "searchResult");
            title.width = 300;
            title.wordWrap = false;
            title.multiline = false;
            this.addChild(title);
            title.x = ((this.picto.x + this.picto.width) + 10);
            title.background = true;
            title.backgroundColor = 0x101010;
            t = ((((result["description"]) || (result["title"]))) || (result["name"]));
            if ((((t == null)) || ((t == "")))){
                if (t.length > 40){
                    t = (t.substr(0, 35) + "[...]");
                };
                desc = new CustomTextField(t, "searchResult");
                desc.width = 300;
                desc.wordWrap = false;
                desc.multiline = false;
                desc.y = title.height;
                this.addChild(desc);
                desc.background = true;
                desc.backgroundColor = 0x101010;
                desc.x = ((this.picto.x + this.picto.width) + 10);
            };
            this.mouseChildren = false;
            this.buttonMode = true;
            addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            var p:Point = Locator.REMAP(this.place.lon, this.place.lat);
            this.destination = new Vector3D(p.x, 0, p.y);
            this.position = new Point((this.width + 10), this.y);
        }
        private function onDown(e:MouseEvent):void{
            if (Simulation.instance != null){
                Simulation.instance.controller.setTarget(null, this.place.lon, this.place.lat);
            };
            e.stopImmediatePropagation();
            removeEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            this.list.onSelect();
        }
        override public function get y():Number{
            return (super.y);
        }
        override public function set y(value:Number):void{
            super.y = value;
            this.position.y = this.y;
        }
        public function get position():Point{
            return (localToGlobal(this._position));
        }
        public function set position(value:Point):void{
            this._position = value;
        }

    }
}//package wd.hud.panels.search 
