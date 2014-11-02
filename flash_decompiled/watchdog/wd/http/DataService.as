package wd.http {
    import __AS3__.vec.*;
    import wd.hud.items.*;
    import flash.net.*;
    import wd.events.*;
    import wd.hud.items.datatype.*;
    import wd.hud.*;
    import flash.utils.*;
    import wd.core.*;

    public class DataService extends Service {

        public static var debug:Boolean = false;

        private var responder:Responder;
        private var param:ServiceConstants;
        private var twitterService:TwitterService;
        private var currentType:int;
        private var currentResultArrayName:String;
        private var currentMethod:String;
        private var currentCompleteEvent:String;
        private var currentCancelEvent:String;
        private var pool:Vector.<TrackerData>;
        private var addInterval:uint;
        private var typeIterator:int = -1;
        private var types:Vector.<int>;
        private var ready:Boolean = true;
        private var reload:Boolean = false;

        public function DataService(){
            this.types = Vector.<int>([DataType.ADS, DataType.ATMS, DataType.CAMERAS, DataType.ELECTROMAGNETICS, DataType.INTERNET_RELAYS, DataType.FLICKRS, DataType.FOUR_SQUARE, DataType.INSTAGRAMS, DataType.MOBILES, DataType.RADARS, DataType.TOILETS, DataType.TRAFFIC_LIGHTS, DataType.WIFIS, DataType.TWITTERS]);
            super();
            this.pool = new Vector.<TrackerData>();
            this.param = Service.initServiceConstants();
            this.responder = new Responder(this.onComplete, this.onCancel);
            this.twitterService = new TwitterService();
            this.twitterService.addEventListener(ServiceEvent.TWITTERS_COMPLETE, this.onTwitterComplete);
        }
        private function onTwitterComplete(e:ServiceEvent):void{
            var tweet:TwitterTrackerData;
            var i:int;
            while (i < e.data.length) {
                tweet = (e.data[i] as TwitterTrackerData);
                if (tweet.isValid){
                    Hud.addItem(tweet);
                } else {
                    TrackerData.remove(tweet.id);
                };
                i++;
            };
        }
        public function batchCall():void{
            if (!(this.ready)){
                this.reload = true;
                return;
            };
            this.ready = false;
            this.typeIterator = -1;
            this.callNext(true);
            clearInterval(this.addInterval);
            this.addInterval = setInterval(this.addItem, 25);
        }
        private function callNext(flush:Boolean=false):void{
            this.typeIterator++;
            if (this.typeIterator >= this.types.length){
                dispatchEvent(new ServiceEvent(ServiceEvent.BATCH_COMPLETE));
                this.ready = true;
                if (this.reload){
                    this.reload = false;
                    this.batchCall();
                };
                return;
            };
            if (!(FilterAvailability.instance.isActive(this.types[this.typeIterator]))){
                return (this.callNext(flush));
            };
            this.call(this.types[this.typeIterator], flush);
        }
        private function call(type:int, flush:Boolean=false):void{
            if (flush){
                resetServiceConstants(this.param);
                this.param[ServiceConstants.PAGE] = 0;
                this.param["radius"] = Config.SETTINGS_DATA_RADIUS;
                this.param["item_per_page"] = Config.SETTINGS_DATA_PAGINATION;
            };
            this.currentType = type;
            switch (type){
                case DataType.ADS:
                    this.currentMethod = Service.METHOD_ADS;
                    this.currentResultArrayName = "advertisements";
                    this.currentCompleteEvent = ServiceEvent.ADS_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.ADS_CANCEL;
                    break;
                case DataType.ATMS:
                    this.currentMethod = Service.METHOD_ATM;
                    this.currentResultArrayName = "atms";
                    this.currentCompleteEvent = ServiceEvent.ATM_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.ATM_CANCEL;
                    break;
                case DataType.CAMERAS:
                    this.currentMethod = Service.METHOD_CAMERAS;
                    this.currentResultArrayName = "cameras";
                    this.currentCompleteEvent = ServiceEvent.CAMERA_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.CAMERA_CANCEL;
                    break;
                case DataType.ELECTROMAGNETICS:
                    this.currentMethod = Service.METHOD_ELECTROMAGNETIC;
                    this.currentResultArrayName = "electromagnicals";
                    this.currentCompleteEvent = ServiceEvent.ELECTROMAGNETIC_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.ELECTROMAGNETIC_CANCEL;
                    break;
                case DataType.FLICKRS:
                    this.currentMethod = Service.METHOD_FLICKRS;
                    this.currentResultArrayName = "flickrs";
                    this.currentCompleteEvent = ServiceEvent.FLICKRS_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.FLICKRS_CANCEL;
                    break;
                case DataType.FOUR_SQUARE:
                    this.currentMethod = Service.METHOD_FOUR_SQUARE;
                    this.currentResultArrayName = "places";
                    this.currentCompleteEvent = ServiceEvent.FOUR_SQUARES_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.FOUR_SQUARES_CANCEL;
                    break;
                case DataType.INTERNET_RELAYS:
                    this.currentMethod = Service.METHOD_INTERNET_RELAYS;
                    this.currentResultArrayName = "nras";
                    this.currentCompleteEvent = ServiceEvent.INETRNET_REALYS_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.INETRNET_REALYS_CANCEL;
                    break;
                case DataType.INSTAGRAMS:
                    this.currentMethod = Service.METHOD_INSTAGRAMS;
                    this.currentResultArrayName = "instagrams";
                    this.currentCompleteEvent = ServiceEvent.INSTAGRAMS_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.INSTAGRAMS_CANCEL;
                    break;
                case DataType.MOBILES:
                    this.currentMethod = Service.METHOD_MOBILE;
                    this.currentResultArrayName = "antennas";
                    this.currentCompleteEvent = ServiceEvent.MOBILES_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.MOBILES_CANCEL;
                    break;
                case DataType.RADARS:
                    this.currentMethod = Service.METHOD_RADARS;
                    this.currentResultArrayName = "radars";
                    this.currentCompleteEvent = ServiceEvent.RADARS_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.RADARS_CANCEL;
                    break;
                case DataType.TOILETS:
                    this.currentMethod = Service.METHOD_TOILETS;
                    this.currentResultArrayName = "toilets";
                    this.currentCompleteEvent = ServiceEvent.TOILETS_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.TOILETS_CANCEL;
                    break;
                case DataType.TRAFFIC_LIGHTS:
                    this.currentMethod = Service.METHOD_TRAFFIC;
                    this.currentResultArrayName = "signals";
                    this.currentCompleteEvent = ServiceEvent.TRAFFIC_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.TRAFFIC_CANCEL;
                    break;
                case DataType.TWITTERS:
                    this.currentMethod = Service.METHOD_TWITTERS;
                    this.currentResultArrayName = "twitters";
                    this.currentCompleteEvent = ServiceEvent.TWITTERS_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.TWITTERS_CANCEL;
                    break;
                case DataType.WIFIS:
                    this.currentMethod = Service.METHOD_WIFI;
                    this.currentResultArrayName = "wifis";
                    this.currentCompleteEvent = ServiceEvent.WIFI_COMPLETE;
                    this.currentCancelEvent = ServiceEvent.WIFI_CANCEL;
                    break;
            };
            customCall(this.currentMethod, this.responder, this.param);
        }
        private function onComplete(result:Object):void{
            if (Config.DEBUG_SERVICES){
                trace("\t\tDataService.onComplete", DataType.toString(this.currentType), "result > ", result[this.currentResultArrayName], "<");
                if (result[this.currentResultArrayName] != null){
                    trace("\tDS results: ", DataType.toString(this.currentType), result[this.currentResultArrayName].length);
                };
            };
            this.addPins(this.currentType, result[this.currentResultArrayName]);
            if (((false) && (!((result.next_page == null))))){
                if (Config.DEBUG_SERVICES){
                    trace("\t", this, DataType.toString(this.currentType), "complete call next page:", result.next_page);
                };
                this.param[ServiceConstants.PAGE] = result.next_page;
                this.call(this.currentType);
            } else {
                if (Config.DEBUG_SERVICES){
                    trace("\t", this, DataType.toString(this.currentType), "all done next type");
                    trace("-----------------------------------");
                };
                dispatchEvent(new ServiceEvent(this.currentCompleteEvent, result));
                this.callNext();
            };
        }
        private function onCancel(fault:Object):void{
            if (Config.DEBUG_SERVICES){
                trace(this, DataType.toString(this.currentType), "cancel");
            };
            dispatchEvent(new ServiceEvent(this.currentCancelEvent));
            this.callNext();
        }
        private function addPins(type:int, array:Array):void{
            var _p:*;
            var baseClass:Class;
            var extra:*;
            var trackerData:TrackerData;
            var trackerDataBaseClass:String = "";
            switch (type){
                case DataType.ADS:
                    trackerDataBaseClass = getQualifiedClassName(AdsTrackerData);
                    break;
                case DataType.ATMS:
                    trackerDataBaseClass = getQualifiedClassName(AtmTrackerData);
                    break;
                case DataType.CAMERAS:
                    trackerDataBaseClass = getQualifiedClassName(CamerasTrackerData);
                    break;
                case DataType.ELECTROMAGNETICS:
                    trackerDataBaseClass = getQualifiedClassName(ElectroMagneticTrackerData);
                    break;
                case DataType.FLICKRS:
                    trackerDataBaseClass = getQualifiedClassName(FlickrTrackerData);
                    break;
                case DataType.FOUR_SQUARE:
                    trackerDataBaseClass = getQualifiedClassName(FoursquareTrackerData);
                    break;
                case DataType.INTERNET_RELAYS:
                    trackerDataBaseClass = getQualifiedClassName(InternetRelaysTrackerData);
                    break;
                case DataType.INSTAGRAMS:
                    trackerDataBaseClass = getQualifiedClassName(InstagramTrackerData);
                    break;
                case DataType.MOBILES:
                    trackerDataBaseClass = getQualifiedClassName(MobilesTrackerData);
                    break;
                case DataType.TOILETS:
                    trackerDataBaseClass = getQualifiedClassName(ToiletsTrackerData);
                    break;
                case DataType.TWITTERS:
                    trackerDataBaseClass = getQualifiedClassName(TwitterTrackerData);
                    break;
                default:
                    trackerDataBaseClass = "wd.hud.items.TrackerData";
            };
            for (_p in array) {
                if (TrackerData.exists(array[_p][ServiceConstants.KEY_ID])){
                } else {
                    baseClass = (getDefinitionByName(trackerDataBaseClass) as Class);
                    extra = ((array[_p].tags) || (array[_p].info));
                    if (extra == null){
                        extra = array[_p];
                    };
                    trackerData = new baseClass(type, array[_p][ServiceConstants.KEY_ID], array[_p][ServiceConstants.KEY_LONGITUDE], array[_p][ServiceConstants.KEY_LATITUDE], extra);
                    if (trackerData.isValid){
                        Hud.addItem(trackerData);
                    } else {
                        TrackerData.remove(array[_p][ServiceConstants.KEY_ID]);
                    };
                };
            };
        }
        private function addItem():void{
            var i:int;
            while (i < 10) {
                if ((((this.pool.length > 0)) && (!((Hud.getInstance() == null))))){
                    Hud.addItem(this.pool.splice(int((Math.random() * this.pool.length)), 1)[0]);
                };
                i++;
            };
        }

    }
}//package wd.http 
