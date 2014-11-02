package wd.http {
    import flash.net.*;
    import wd.core.*;
    import wd.utils.*;
    import wd.events.*;

    public class PlacesService extends Service {

        private var responder:Responder;
        private var param:ServiceConstants;

        public function PlacesService(){
            super();
            this.responder = new Responder(this.onComplete, this.onCancel);
            this.param = Service.initServiceConstants();
            switch (Config.CITY){
                case Locator.BERLIN:
                    this.param["lng"] = 13.40933;
                    this.param["lat"] = 52.52219;
                    break;
                case Locator.LONDON:
                    this.param["lng"] = -0.127962;
                    this.param["lat"] = 51.507723;
                    break;
                case Locator.PARIS:
                    this.param["lng"] = 2.294254;
                    this.param["lat"] = 48.858278;
                    break;
            };
            this.param["radius"] = 100;
            this.param["town"] = Config.CITY;
            connection.call(Service.METHOD_PLACES, this.responder, this.param);
        }
        private function onComplete(result):void{
            var p:*;
            var q:*;
            var place:Place;
            Places[Locator.CITY.toUpperCase()].length = 0;
            for (p in result) {
                if (p == "places"){
                    for (q in result[p]) {
                        place = new Place(result[p][q].name, result[p][q].lng, result[p][q].lat);
                        Places[Locator.CITY.toUpperCase()].push(place);
                    };
                };
            };
            dispatchEvent(new ServiceEvent(ServiceEvent.PLACES_COMPLETE));
        }
        private function onCancel(fault:Object):void{
            dispatchEvent(new ServiceEvent(ServiceEvent.PLACES_CANCEL));
        }

    }
}//package wd.http 
