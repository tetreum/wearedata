package wd.hud.popins.datapopins {
    import wd.hud.items.*;
    import flash.display.*;
    import flash.geom.*;
    import wd.http.*;
    import wd.hud.popins.*;

    public class DataPopin extends Popin {

        private static var icons_src:Class = DataPopin_icons_src;
        public static var icons:BitmapData = new icons_src().bitmapData;

        protected var tdata:TrackerData;

        public function DataPopin(data:Object){
            super();
            this.tdata = (data as TrackerData);
            setTitle(this.titleData);
            trace(("Popin eating data : " + data));
            data.debugExtra();
            setIcon(this.getIcon(data.type));
            setLine();
            disposeHeader();
        }
        protected function get titleData():String{
            return (this.tdata.labelData);
        }
        protected function getIcon(type:uint):Sprite{
            var r:Sprite = new Sprite();
            var m:Matrix = new Matrix();
            var rect:Rectangle = new Rectangle(0, 0, 43, 43);
            var w:int = rect.width;
            var h:int = rect.height;
            m.tx = -107;
            switch (type){
                case DataType.ATMS:
                    m.ty = -752;
                    break;
                case DataType.CAMERAS:
                    m.ty = -540;
                    break;
                case DataType.ELECTROMAGNETICS:
                    m.ty = -371;
                    break;
                case DataType.FLICKRS:
                    m.ty = 0;
                    break;
                case DataType.INSTAGRAMS:
                    m.ty = -626;
                    break;
                case DataType.WIFIS:
                    m.ty = -284;
                    break;
                case DataType.INTERNET_RELAYS:
                    m.ty = -196;
                    break;
                case DataType.ADS:
                    m.ty = -410;
                    break;
                case DataType.METRO_STATIONS:
                    m.ty = -15;
                    break;
                case DataType.MOBILES:
                    m.ty = -325;
                    break;
                case DataType.TRAFFIC_LIGHTS:
                    m.ty = -453;
                    break;
                case DataType.TOILETS:
                    m.ty = -498;
                    break;
                case DataType.TWITTERS:
                    m.ty = -584;
                    break;
                case DataType.VELO_STATIONS:
                    m.ty = -108;
                    break;
                case DataType.FOUR_SQUARE:
                    m.ty = -706;
                    break;
            };
            r.graphics.beginBitmapFill(icons, m, false, false);
            r.graphics.drawRect((-(rect.width) * 0.5), (-(rect.height) * 0.5), rect.width, rect.height);
            r.cacheAsBitmap = true;
            return (r);
        }
        public function getUnixDate(ts:Number):String{
            var r:String;
            var d:Date = new Date((ts * 1000));
            r = ("" + d.getDate());
            r = (r + ("/" + (d.getMonth() + 1)));
            r = (r + ("/" + d.getFullYear()));
            return (r);
        }

    }
}//package wd.hud.popins.datapopins 
