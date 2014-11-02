package wd.hud.panels.layers {
    import flash.geom.*;
    import wd.http.*;
    import flash.events.*;
    import flash.display.*;

    public class LayerItemIcon extends Sprite {

        private static var icons_src:Class = LayerItemIcon_icons_src;
        public static var icons:BitmapData = new icons_src().bitmapData;
        private static var rect:Rectangle = new Rectangle(0, 0, 12, 12);

        public function LayerItemIcon(type:uint){
            super();
            var m:Matrix = new Matrix();
            var w:int = rect.width;
            var h:int = rect.height;
            m.tx = -16;
            switch (type){
                case DataType.ATMS:
                    m.ty = -752;
                    break;
                case DataType.CAMERAS:
                    m.ty = -531;
                    break;
                case DataType.ELECTROMAGNETICS:
                    m.ty = -362;
                    break;
                case DataType.FLICKRS:
                    m.ty = -661;
                    break;
                case DataType.INSTAGRAMS:
                    m.ty = -617;
                    break;
                case DataType.WIFIS:
                    m.ty = -273;
                    break;
                case DataType.INTERNET_RELAYS:
                    m.ty = -189;
                    break;
                case DataType.ADS:
                    m.ty = -404;
                    break;
                case DataType.METRO_STATIONS:
                    m.ty = -15;
                    break;
                case DataType.MOBILES:
                    m.ty = -316;
                    break;
                case DataType.TRAFFIC_LIGHTS:
                    m.ty = -447;
                    break;
                case DataType.TOILETS:
                    m.ty = -487;
                    break;
                case DataType.TWITTERS:
                    m.ty = -574;
                    break;
                case DataType.VELO_STATIONS:
                    m.ty = -102;
                    break;
                case DataType.FOUR_SQUARE:
                    m.ty = -706;
                    break;
            };
            m.tx = (m.tx - (rect.width * 0.5));
            m.ty = (m.ty - (rect.height * 0.5));
            graphics.beginBitmapFill(icons, m, false, false);
            graphics.drawRect((-(rect.width) * 0.5), (-(rect.height) * 0.5), rect.width, rect.height);
            cacheAsBitmap = true;
            buttonMode = true;
            addEventListener(MouseEvent.CLICK, this.onClick);
        }
        private function onClick(e:MouseEvent):void{
        }

    }
}//package wd.hud.panels.layers 
