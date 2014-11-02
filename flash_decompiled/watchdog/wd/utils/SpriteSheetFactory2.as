package wd.utils {
    import flash.display.*;
    import flash.geom.*;
    import wd.hud.items.pictos.*;
    import wd.wq.datas.*;
    import wd.hud.common.text.*;
    import __AS3__.vec.*;
    import wd.d3.geom.metro.*;

    public class SpriteSheetFactory2 {

        private static var icons_src:Class = SpriteSheetFactory2_icons_src;
        public static var icons:BitmapData = new icons_src().bitmapData;
        private static var metros_src:Class = SpriteSheetFactory2_metros_src;
        public static var metros:BitmapData = new metros_src().bitmapData;
        private static var stations_src:Class = SpriteSheetFactory2_stations_src;
        public static var stations:BitmapData = new stations_src().bitmapData;
        public static var spriteSheet:BitmapData;
        private static var textBitmapInfo:Vector.<BitmapInfo>;
        private static var textfield:CustomTextField;
        private static var clearBitmapdata:Boolean;
        private static var disposeBitmapdata:Boolean = false;
        private static var lastBI:BitmapInfo;
        private static var rec0:FastRectangle;
        private static var rec1:FastRectangle;
        private static var lastIndex:int;
        private static var b:BitmapInfo;
        private static var _h:int = 0x0400;
        private static var width:int;

        public static function makeAtlas(w:int):void{
            width = w;
            b = textBitmapInfo[0];
            b.x = 0;
            b.y = 0;
            _h = b.bitmapData.height;
            b = textBitmapInfo[1];
            b.x = textBitmapInfo[0].bitmapData.width;
            b.y = 0;
            b = textBitmapInfo[2];
            b.x = textBitmapInfo[0].bitmapData.width;
            b.y = textBitmapInfo[1].bitmapData.height;
            rec0 = new FastRectangle(0, 0, (textBitmapInfo[1].x + textBitmapInfo[1].bitmapData.width), (textBitmapInfo[2].y + textBitmapInfo[2].bitmapData.height));
            rec1 = new FastRectangle(0, 0, textBitmapInfo[0].bitmapData.width, textBitmapInfo[0].bitmapData.height);
            lastBI = textBitmapInfo[3];
            lastBI.x = rec0.width;
            lastIndex = 4;
            placeBitmapData(lastIndex);
            draw();
        }
        private static function draw():void{
            _h = getNextPowerOfTwo(_h);
            if (spriteSheet != null){
                spriteSheet.dispose();
                spriteSheet = null;
            };
            spriteSheet = new BitmapData(width, _h, true, 0);
            spriteSheet.lock();
            var l:int = textBitmapInfo.length;
            var i:int;
            while (i < l) {
                b = textBitmapInfo[i];
                spriteSheet.copyPixels(b.bitmapData, b.bitmapData.rect, new Point(b.x, b.y));
                UVPicto.textUVs[b.id] = new UVCoord((b.x / width), (b.y / _h), (b.bitmapData.width / width), (b.bitmapData.height / _h), b.bitmapData.width, b.bitmapData.height);
                i++;
            };
            spriteSheet.unlock();
        }
        private static function placeBitmapData(li:int):void{
            var l:int = textBitmapInfo.length;
            var i:int = li;
            while (i < l) {
                b = textBitmapInfo[i];
                if (((lastBI.x + lastBI.bitmapData.width) + b.bitmapData.width) > width){
                    if ((lastBI.y + lastBI.bitmapData.height) > rec0.height){
                        if ((lastBI.y + lastBI.bitmapData.height) > rec1.height){
                            b.x = 0;
                        } else {
                            b.x = rec1.width;
                        };
                        b.y = (lastBI.y + lastBI.bitmapData.height);
                    } else {
                        b.x = rec0.width;
                    };
                    b.y = (lastBI.y + lastBI.bitmapData.height);
                } else {
                    b.x = (lastBI.x + lastBI.bitmapData.width);
                    b.y = lastBI.y;
                };
                lastBI = b;
                if (_h < (b.y + b.bitmapData.height)){
                    _h = (b.y + b.bitmapData.height);
                };
                i++;
            };
            lastIndex = l;
        }
        public static function getNextPowerOfTwo(n:int):int{
            var result:int = 1;
            while (result < n) {
                result = (result * 2);
            };
            return (result);
        }
        public static function get texture():BitmapData{
            var bi:BitmapInfo;
            if (spriteSheet != null){
                return (spriteSheet);
            };
            textfield = new CustomTextField("", "rolloverTrackerLabel");
            textfield.mouseEnabled = false;
            textfield.wordWrap = false;
            textBitmapInfo = new Vector.<BitmapInfo>();
            bi = new BitmapInfo("icons");
            bi.bitmapData = icons;
            textBitmapInfo.push(bi);
            bi.bitmapDataRect = new FastRectangle(0, 0, bi.bitmapData.width, bi.bitmapData.height);
            var berlinXML:XML = <metroLineColors>
		<line name="U2" color="0xff0000"/> 
		<line name="U3" color="0x087308"/> 
		<line name="U4" color="0xffd800"/> 
		<line name="U5" color="0xb70000"/> 
		<line name="U55" color="0xffa47c"/> 
		<line name="U6" color="0xc600c6"/> 
		<line name="U7" color="0x42b5ff"/> 
		<line name="U8" color="0x0008de"/> 
		<line name="U9" color="0xfe8706"/> 
		<line name="S1" color="0x00b600"/> 
		<line name="S2" color="0x00b600"/> 
		<line name="S25" color="0x00b600"/> 
		<line name="S3" color="0x840084"/> 
		<line name="S41 (CW)" color="0xe37066"/> 
		<line name="S42 (CCW)" color="0xe37066"/> 
		<line name="S45" color="0xe37066"/> 
		<line name="S46" color="0xe37066"/> 
		<line name="S47" color="0xe37066"/> 
		<line name="S5" color="0x840084"/> 
		<line name="S7" color="0x840084"/> 
		<line name="S75" color="0x840084"/> 
		<line name="S8" color="0x00b600"/> 
		<line name="S85" color="0x00b600"/> 
		<line name="S9" color="0x840084"/> 
		<line name="U1" color="0x00c600"/>		
	</metroLineColors>
            ;
            var sprite:Sprite = new Sprite();
            var l:int = berlinXML.line.length();
            var i:int;
            while (i < l) {
                sprite.graphics.beginFill(int(berlinXML.line[i].@color));
                sprite.graphics.drawCircle(((i * 32) + 16), 82, 7);
                sprite.graphics.endFill();
                i++;
            };
            metros.fillRect(new Rectangle(0, 64, stations.width, 32), 0);
            metros.draw(sprite);
            sprite.graphics.clear();
            bi = new BitmapInfo("metros");
            bi.bitmapData = metros;
            textBitmapInfo.push(bi);
            bi.bitmapDataRect = new FastRectangle(0, 0, bi.bitmapData.width, bi.bitmapData.height);
            l = berlinXML.line.length();
            i = 0;
            while (i < l) {
                sprite.graphics.beginFill(int(berlinXML.line[i].@color));
                sprite.graphics.drawCircle(((i * 32) + 16), 82, 7);
                sprite.graphics.endFill();
                sprite.graphics.beginFill(0);
                sprite.graphics.drawCircle(((i * 32) + 16), 82, 4);
                sprite.graphics.endFill();
                i++;
            };
            sprite.graphics.beginFill(0);
            sprite.graphics.drawCircle(((i * 32) + 16), 82, 8);
            sprite.graphics.endFill();
            sprite.graphics.beginFill(0xFFFFFF);
            sprite.graphics.drawCircle(((i * 32) + 16), 82, 5);
            sprite.graphics.endFill();
            stations.fillRect(new Rectangle(0, 64, stations.width, 32), 0);
            stations.draw(sprite);
            sprite.graphics.clear();
            sprite = null;
            bi = new BitmapInfo("stations");
            bi.bitmapData = stations;
            textBitmapInfo.push(bi);
            bi.bitmapDataRect = new FastRectangle(0, 0, bi.bitmapData.width, bi.bitmapData.height);
            rasterizeTexts(Places.PARIS);
            rasterizeTexts(Places.LONDON);
            rasterizeTexts(Places.BERLIN);
            makeAtlas(0x0800);
            return (spriteSheet);
        }
        public static function addStations(vec:Vector.<MetroStation>):void{
            var bi:BitmapInfo;
            var station:MetroStation;
            for each (station in vec) {
                bi = new BitmapInfo(station.name.toUpperCase());
                textfield.htmlText = bi.id;
                bi.bitmapData = new BitmapData(textfield.width, textfield.height, true, 0);
                bi.bitmapData.draw(textfield);
                textBitmapInfo.push(bi);
                bi.bitmapDataRect = new FastRectangle(0, 0, bi.bitmapData.width, bi.bitmapData.height);
            };
            placeBitmapData(lastIndex);
            draw();
        }
        private static function rasterizeTexts(v:Vector.<Place>):void{
            var bi:BitmapInfo;
            var l:int = v.length;
            while (l--) {
                bi = new BitmapInfo(String(v[l].name).toUpperCase());
                textfield.htmlText = bi.id;
                bi.bitmapData = new BitmapData(textfield.width, textfield.height, true, 0);
                bi.bitmapData.draw(textfield);
                bi.bitmapDataRect = new FastRectangle(0, 0, bi.bitmapData.width, bi.bitmapData.height);
                textBitmapInfo.push(bi);
            };
        }
        public static function addText(s:String):void{
            var bi:BitmapInfo = new BitmapInfo(s.toUpperCase());
            textfield.text = bi.id;
            bi.bitmapData = new BitmapData(textfield.width, textfield.height, true, 0);
            bi.bitmapData.draw(textfield);
            textBitmapInfo.push(bi);
            bi.bitmapDataRect = new FastRectangle(0, 0, bi.bitmapData.width, bi.bitmapData.height);
            placeBitmapData(lastIndex);
            draw();
        }
        public static function addTexts(labels:Vector.<String>):void{
            var bi:BitmapInfo;
            var l:int = labels.length;
            while (l--) {
                bi = new BitmapInfo(labels[l]);
                textfield.text = bi.id;
                bi.bitmapData = new BitmapData(textfield.width, textfield.height, true, 0);
                bi.bitmapData.draw(textfield);
                textBitmapInfo.push(bi);
                bi.bitmapDataRect = new FastRectangle(0, 0, bi.bitmapData.width, bi.bitmapData.height);
            };
            placeBitmapData(lastIndex);
            draw();
        }

    }
}//package wd.utils 

import flash.display.*;
import flash.geom.*;

class BitmapInfo {

    public var bitmapData:BitmapData;
    public var bitmapDataRect:FastRectangle;
    public var id:String;
    public var x:uint;
    public var y:uint;
    public var uvs:Rectangle;
    public var rightOccuped:Boolean = false;
    public var topOccuped:Boolean = false;

    public function BitmapInfo(_id:String){
        super();
        this.id = _id;
    }
}
class FastRectangle {

    public var x:uint;
    public var y:uint;
    public var width:uint;
    public var height:uint;
    private var centerX:Number;
    private var centerY:Number;

    public function FastRectangle(_x:uint, _y:uint, _w:uint, _h:uint){
        super();
        this.x = _x;
        this.y = _y;
        this.width = _w;
        this.height = _h;
        this.centerX = (this.x + (this.width / 2));
        this.centerY = (this.y + (this.height / 2));
    }
    public function setWidth(_w:uint):void{
        this.width = _w;
        this.centerX = (this.x + (_w / 2));
    }
    public function setHeight(_h:uint):void{
        this.height = _h;
        this.centerY = (this.y + (_h / 2));
    }
    private function abs(n:Number):Number{
        return ((((n < 0)) ? (n * -1) : n));
    }
    public function intersects(slotToCheck:FastRectangle):Boolean{
        if ((((this.abs((this.centerX - slotToCheck.centerX)) < (this.abs((this.width + slotToCheck.width)) / 2))) && ((this.abs((this.centerY - slotToCheck.centerY)) < (this.abs((this.height + slotToCheck.height)) / 2))))){
            return (true);
        };
        return (false);
    }

}
