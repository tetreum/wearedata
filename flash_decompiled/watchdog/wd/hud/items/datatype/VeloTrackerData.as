package wd.hud.items.datatype {
    import wd.http.*;
    import wd.utils.*;
    import wd.hud.items.*;

    public class VeloTrackerData extends TrackerData {

        public var address:String = "";
        public var bonus:Number;
        public var name:String;
        public var open:Number;
        public var ref:String;
        public var updated:String;
        public var total:Number;
        public var available:Number;
        public var free:Number;

        public function VeloTrackerData(type:int, id:int, lon:Number, lat:Number, extra){
            var tag:String;
            var i:String;
            super(type, id, lon, lat, extra);
            var tags:Array = [ServiceConstants.TAG_ADDRESS, ServiceConstants.TAG_BONUS, ServiceConstants.TAG_NAME, ServiceConstants.TAG_OPEN, ServiceConstants.TAG_REF, ServiceConstants.TAG_TOTAL, ServiceConstants.TAG_UPDATE];
            if ((extra is Boolean)){
                return;
            };
            if (extra == null){
                return;
            };
            for each (tag in tags) {
                if (((!((extra[tag] == null))) && (!((extra[tag] == ""))))){
                    if ((this[tag] is Number)){
                        this[tag] = parseFloat(extra[tag]);
                    } else {
                        this[tag] = extra[tag];
                    };
                };
            };
            this.update(extra);
            if (Locator.CITY == Locator.PARIS){
                canOpenPopin = false;
                for each (i in this.address.split(" ")) {
                    if ((((int(i) >= 75000)) && ((int(i) < 76000)))){
                        canOpenPopin = true;
                    };
                };
            };
        }
        override public function get isValid():Boolean{
            return (((((!((extra is Boolean))) && (!((extra == null))))) && (canOpenPopin)));
        }
        public function update(tags:Array):void{
            this.available = ((!((tags["available"] == null))) ? parseFloat(tags["available"]) : (this.total * 0.25));
            this.free = ((!((tags["free"] == null))) ? parseFloat(tags["free"]) : (this.total * 0.75));
            if (tags["updated"] == null){
                this.updated = "N/A";
            } else {
                this.updated = tags["updated"];
            };
        }
        public function toString():String{
            return (((((((((("VeloTrackerData: name" + this.name) + ", available: ") + this.available) + ", free: ") + this.free) + ", total: ") + this.total) + ", updated: ") + this.updated));
        }

    }
}//package wd.hud.items.datatype 
