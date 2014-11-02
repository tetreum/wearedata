package wd.hud.preloaders {
    import wd.d3.control.*;
    import wd.events.*;
    import wd.http.*;
    import flash.display.*;

    public class BuildingPreloader extends Sprite {

        private var bs:BuildingService;

        public function BuildingPreloader(){
            super();
            this.bs = Navigator.instance.building_service;
            Navigator.instance.addEventListener(NavigatorEvent.LOADING_START, this.loadingHandler);
            Navigator.instance.addEventListener(NavigatorEvent.LOADING_PROGRESS, this.loadingHandler);
            Navigator.instance.addEventListener(NavigatorEvent.LOADING_STOP, this.loadingHandler);
        }
        private function loadingHandler(e:NavigatorEvent):void{
        }

    }
}//package wd.hud.preloaders 
