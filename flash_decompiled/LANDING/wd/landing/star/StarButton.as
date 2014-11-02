package wd.landing.star {
    import flash.events.*;
    import flash.display.*;
    import wd.landing.sound.*;
    import flash.geom.*;
    import aze.motion.*;
    import wd.landing.*;
    import wd.landing.tag.*;
    import flash.net.*;
    import wd.landing.text.*;
    import flash.text.*;
    import aze.motion.easing.*;
    import flash.external.*;

    public class StarButton extends StarItem {

        public static const ON_OVER:String = "onOver";
        public static const ON_OUT:String = "onOut";

        private var _url:String;
        private var _target:String;
        private var _tag:String;
        private var aStripe:Sprite;
        private var _myLat:String;
        private var _myLong:String;
        public var ptPosition:Point;

        public function StarButton(_arg1:String, _arg2:String, _arg3:String, _arg4:String):void{
            this.ptPosition = new Point();
            super();
            this._url = _arg2;
            this._target = _arg3;
            this._tag = _arg4;
            typeStar = BUTTON_STAR;
            var _local5:Tdf_landing = new Tdf_landing(_arg1, "LandingCityText");
            _local5.multiline = false;
            _local5.wordWrap = false;
            _local5.antiAliasType = AntiAliasType.NORMAL;
            addChild(_local5);
            _local5.x = (-(_local5.width) >> 1);
            _local5.y = (-(_local5.height) >> 1);
            var _local6:Shape = new Shape();
            _local6.graphics.beginFill(0xFFFFFF, 1);
            _local6.graphics.drawRect(0, 0, (_local5.width + 10), _local5.height);
            addChildAt(_local6, 0);
            _local6.x = (-(_local6.width) >> 1);
            _local6.y = (-(_local6.height) >> 1);
            var _local7:BitmapData = new stripe();
            this.aStripe = this.remplirTrame((_local6.width + 12), (_local6.height + 12), _local7);
            addChildAt(this.aStripe, 0);
            this.aStripe.blendMode = BlendMode.ADD;
            this.aStripe.x = (-(this.aStripe.width) >> 1);
            this.aStripe.y = (-(this.aStripe.height) >> 1);
            this.aStripe.visible = false;
            this.buttonMode = true;
            this.mouseChildren = false;
            this.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.addEventListener(MouseEvent.CLICK, this.click);
            _realSize = 5;
            setPtNotVisible();
        }
        private function out(_arg1:MouseEvent):void{
            dispatchEvent(new Event(ON_OUT));
            LandingSoundManager.getInstance().playSound(SoundsName.OUT);
        }
        private function over(_arg1:MouseEvent):void{
            dispatchEvent(new Event(ON_OVER));
            LandingSoundManager.getInstance().playSound(SoundsName.OVER);
        }
        public function setOver():void{
            this.scaleX = (this.scaleY = 1.3);
            isOver = true;
            this.aStripe.visible = true;
        }
        public function setOut():void{
            this.scaleX = (this.scaleY = 1);
            this.alpha = 0.6;
            isOver = false;
            this.aStripe.visible = false;
        }
        public function setNormal():void{
            this.scaleX = (this.scaleY = 1);
            this.alpha = 1;
            this.aStripe.visible = false;
            if (isOver){
                this.gotoPosition();
            };
        }
        public function gotoPosition():void{
            eaze(this).to(0.4, {
                x:this.ptPosition.x,
                y:this.ptPosition.y
            }).easing(Cubic.easeInOut).onComplete(this.isOnPosition);
        }
        private function isOnPosition():void{
            isOver = false;
        }
        private function click(_arg1:MouseEvent):void{
            if (ExternalInterface.available){
                ExternalInterface.call("__landing.hide");
            };
            SendTag.tagPageView(this._tag);
            var _local2:URLRequest = new URLRequest(this.formatUrl());
            navigateToURL(_local2, this._target);
        }
        private function remplirTrame(_arg1:Number, _arg2:Number, _arg3:BitmapData):Sprite{
            var _local4:Sprite = new Sprite();
            _local4.graphics.beginBitmapFill(_arg3, null, true, true);
            _local4.graphics.moveTo(0, 0);
            _local4.graphics.lineTo(0, 0);
            _local4.graphics.lineTo(_arg1, 0);
            _local4.graphics.lineTo(_arg1, _arg2);
            _local4.graphics.lineTo(0, _arg2);
            _local4.graphics.endFill();
            return (_local4);
        }
        private function formatUrl():String{
            var _local1:String;
            _local1 = ("?locale=" + MainLanding.LOCALE);
            if (MainLanding.LAT){
                _local1 = (_local1 + ("&place_lat=" + MainLanding.LAT));
            };
            if (MainLanding.LONG){
                _local1 = (_local1 + ("&place_lon=" + MainLanding.LONG));
            };
            if (MainLanding.PLACE){
                _local1 = (_local1 + ("&place_name=" + MainLanding.PLACE));
            };
            if (MainLanding.LAYER){
                _local1 = (_local1 + ("&app_state=" + MainLanding.LAYER));
            };
            this.getMyLocation();
            if (((this._myLat) && (this._myLong))){
                _local1 = (_local1 + ((("&my_lat=" + this._myLat) + "&my_long=") + this._myLong));
            };
            _local1 = this.strReplace(this._url, "#", _local1);
            return (_local1);
        }
        private function getMyLocation():void{
            var _local1:String;
            var _local2:Array;
            if (ExternalInterface.available){
                _local1 = ExternalInterface.call("getMyLocation");
                if (((_local1) && ((_local1.search("#") > 0)))){
                    _local2 = _local1.split("#");
                    this._myLat = _local2[0];
                    this._myLong = _local2[1];
                };
            };
        }
        public function strReplace(_arg1:String, _arg2:String, _arg3:String):String{
            return (_arg1.split(_arg2).join(_arg3));
        }

    }
}//package wd.landing.star 
