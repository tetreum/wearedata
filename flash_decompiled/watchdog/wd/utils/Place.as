package wd.utils {
    import flash.geom.*;

    public class Place extends Point {

        private static var _id:int = 0;

        public var id:int;
        public var lat:Number;
        public var lon:Number;
        public var name:String;

        public function Place(name:String, lon:Number, lat:Number){
            super();
            this.name = name;
            this.lon = lon;
            this.lat = lat;
            this.id = _id;
            _id++;
        }
    }
}//package wd.utils 
