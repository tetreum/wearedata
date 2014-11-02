package wd.hud.items {
    import flash.geom.*;
    import flash.utils.*;
    import wd.http.*;
    import wd.utils.*;

    public class TrackerData {

        private static var pos:Point = new Point();
        public static var ids:Dictionary = new Dictionary(true);
        public static var lonLat:Dictionary = new Dictionary(true);

        public var position:Vector3D;
        public var type:int;
        public var lat:Number;
        public var lon:Number;
        public var id:uint;
        public var extra;
        public var object;
        public var tracker:Tracker;
        public var visited:Boolean;
        public var canOpenPopin:Boolean = true;

        public function TrackerData(type:int, id:uint, lon:Number, lat:Number, extra){
            super();
            this.id = id;
            this.lon = lon;
            this.lat = lat;
            if (((TrackerData.existsLonLat(((lon + "") + lat))) && (!((type == DataType.METRO_STATIONS))))){
                lon = (lon + ((Math.random() * 0.0003) - 0.00015));
                lat = (lat + ((Math.random() * 0.0003) - 0.00015));
            } else {
                TrackerData.lonLat[((lon + "") + lat)] = true;
            };
            Locator.REMAP(lon, lat, pos);
            this.position = new Vector3D(pos.x, 0, pos.y);
            this.extra = extra;
            this.type = type;
            if (id != 0){
                ids[id] = this;
            };
        }
        public static function remove(id:uint):void{
            ids[id] = null;
        }
        public static function exists(id:uint):Boolean{
            return (!((ids[id] == null)));
        }
        public static function removeLonLat(id:Number):void{
            lonLat[id] = null;
        }
        public static function existsLonLat(id:String):Boolean{
            return (!((lonLat[id] == null)));
        }

        public function debugExtra():void{
            var i:*;
            trace("TrackerData Extra Data trace : ");
            for (i in this.extra) {
                trace(((i + " : ") + this.extra[i]));
            };
        }
        public function get labelData():String{
            return (DataType.toString(this.type));
        }
        public function get labelSubData():String{
            return ("");
        }
        public function get isValid():Boolean{
            return (true);
        }

    }
}//package wd.hud.items 
