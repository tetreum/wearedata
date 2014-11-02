package wd.utils {
    import flash.geom.*;
    import __AS3__.vec.*;
    import wd.core.*;
    import biga.utils.*;

    public class Locator {

        public static const DEG_TO_RAD:Number = 0.0174532925199433;
        public static const PARIS:String = "paris";
        public static const LONDON:String = "london";
        public static const BERLIN:String = "berlin";

        private static var instance:Locator;
        public static var CITY:String = "paris";
        public static var rect:Rectangle = new Rectangle();
        public static var world_rect:Rectangle;
        public static var world_rect_camera:Rectangle;
        private static var world_position:Point = new Point();
        public static var WORLD_SCALE:Number = 1000000;
        public static var LONGITUDE:Number;
        public static var LATITUDE:Number;
        public static var STARTING_PLACE:Place;

        public function Locator(city:String, _rect:Rectangle, scale:Number=10000000){
            super();
            instance = this;
            CITY = city;
            WORLD_SCALE = Config.WORLD_SCALE;
            rect = Config.WORLD_RECT;
            WORLD_RECT;
            setRandomLocation();
        }
        public static function setRandomLocation(fromList:Boolean=true):void{
            var list:Vector.<Place>;
            var id:int;
            if (Config.DEBUG_LOCATOR){
                trace("starting place", STARTING_PLACE);
            };
            if (STARTING_PLACE != null){
                LONGITUDE = STARTING_PLACE.lon;
                LATITUDE = STARTING_PLACE.lat;
            } else {
                if (fromList){
                    list = Places[CITY.toUpperCase()];
                    id = int((Math.random() * list.length));
                    LONGITUDE = list[id].lon;
                    LATITUDE = list[id].lat;
                } else {
                    LONGITUDE = (rect.x + (Math.random() * Math.abs((rect.width - rect.x))));
                    LATITUDE = (rect.y + (Math.random() * Math.abs((rect.height - rect.y))));
                };
            };
        }
        public static function project(longitude:Number, latitude:Number, p:Point=null):Point{
            p = ((p) || (new Point()));
            p.x = ((longitude / 180) % 3);
            p.y = (180 - (0.5 - (Math.log(Math.tan(((Math.PI / 4) + ((latitude * Math.PI) / 360)))) / Math.PI)));
            return (p);
        }
        public static function get WORLD_RECT():Rectangle{
            if (world_rect != null){
                return (world_rect);
            };
            world_rect = rect.clone();
            var tl:Point = project(world_rect.x, world_rect.y);
            var br:Point = project(world_rect.width, world_rect.height);
            world_rect.x = tl.x;
            world_rect.y = tl.y;
            world_rect.width = (Math.abs((br.x - tl.x)) * WORLD_SCALE);
            world_rect.height = (Math.abs((br.y - tl.y)) * WORLD_SCALE);
            world_rect.x = (-(world_rect.width) * 0.5);
            world_rect.y = (-(world_rect.height) * 0.5);
            world_rect_camera = world_rect.clone();
            world_rect_camera.x = (world_rect_camera.x + Constants.GRID_CASE_SIZE);
            world_rect_camera.y = (world_rect_camera.y + Constants.GRID_CASE_SIZE);
            world_rect_camera.width = (world_rect_camera.width - (Constants.GRID_CASE_SIZE * 2));
            world_rect_camera.height = (world_rect_camera.height - (Constants.GRID_CASE_SIZE * 2));
            return (world_rect);
        }
        public static function REMAP(lon:Number, lat:Number, p:Point=null):Point{
            p = ((p) || (world_position));
            p.x = (world_rect.x + GeomUtils.map(lon, rect.x, rect.width, 0, world_rect.width));
            p.y = (world_rect.y + GeomUtils.map(lat, rect.y, rect.height, 0, world_rect.height));
            return (p);
        }
        public static function DISTANCE(longitude1:Number, latitude1:Number, longitude2:Number, latitude2:Number):Number{
            var R:Number = 6371;
            var dLat:Number = (((latitude2 - latitude1) * DEG_TO_RAD) * 0.5);
            var dLon:Number = (((longitude2 - longitude1) * DEG_TO_RAD) * 0.5);
            var lat1:Number = (latitude1 * DEG_TO_RAD);
            var lat2:Number = (latitude2 * DEG_TO_RAD);
            var a:Number = ((Math.sin(dLat) * Math.sin(dLat)) + (((Math.sin(dLon) * Math.sin(dLon)) * Math.cos(lat1)) * Math.cos(lat2)));
            var c:Number = (2 * Math.atan2(Math.sqrt(a), Math.sqrt((1 - a))));
            var d:Number = (R * c);
            return (d);
        }
        public static function LOCATE(x:Number, y:Number, p:Point=null):Point{
            p = ((p) || (world_position));
            p.x = GeomUtils.map(x, world_rect.left, world_rect.right, rect.x, rect.width);
            p.y = GeomUtils.map(y, world_rect.top, world_rect.bottom, rect.y, rect.height);
            return (p);
        }
        public static function INTRO_REMAP(lon:Number, lat:Number, local_rect:Rectangle, p:Point=null):Point{
            p = ((p) || (world_position));
            p.x = (local_rect.x + GeomUtils.map(lon, rect.x, rect.width, 0, local_rect.width));
            p.y = (local_rect.y + GeomUtils.map(lat, rect.y, rect.height, 0, local_rect.height));
            return (p);
        }
        public static function INTRO_LOCATE(x:Number, y:Number, local_rect:Rectangle, p:Point=null):Point{
            p = ((p) || (world_position));
            p.x = GeomUtils.map(x, local_rect.left, local_rect.right, rect.x, rect.width);
            p.y = GeomUtils.map(y, local_rect.top, local_rect.bottom, rect.y, rect.height);
            return (p);
        }

    }
}//package wd.utils 
