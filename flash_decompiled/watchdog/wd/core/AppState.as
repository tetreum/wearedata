package wd.core {
    import wd.http.*;
    import wd.utils.*;

    public class AppState {

        private static var shift:int = 0;
        public static var TRANSPORTS:int = (1 << shift++);
        public static var NETWORKS:int = (1 << shift++);
        public static var FURNITURE:int = (1 << shift++);
        public static var SOCIAL:int = (1 << shift++);
        private static var _menus:uint = 0;
        private static var _state:uint;
        private static var _isHQ:Boolean = true;

        public function AppState(state:uint){
            super();
            AppState.state = state;
            if (isActive(DataType.METRO_STATIONS)){
                deactivateMenu(TRANSPORTS);
            };
            if (isActive(DataType.VELO_STATIONS)){
                deactivateMenu(TRANSPORTS);
            };
            if (isActive(DataType.INTERNET_RELAYS)){
                deactivateMenu(NETWORKS);
            };
            if (isActive(DataType.MOBILES)){
                deactivateMenu(NETWORKS);
            };
            if (isActive(DataType.WIFIS)){
                deactivateMenu(NETWORKS);
            };
            if (isActive(DataType.ADS)){
                deactivateMenu(FURNITURE);
            };
            if (isActive(DataType.ATMS)){
                deactivateMenu(FURNITURE);
            };
            if (isActive(DataType.TRAFFIC_LIGHTS)){
                deactivateMenu(FURNITURE);
            };
            if (isActive(DataType.TOILETS)){
                deactivateMenu(FURNITURE);
            };
            if (isActive(DataType.CAMERAS)){
                deactivateMenu(FURNITURE);
            };
            if (isActive(DataType.TWITTERS)){
                deactivateMenu(SOCIAL);
            };
            if (isActive(DataType.INSTAGRAMS)){
                deactivateMenu(SOCIAL);
            };
            if (isActive(DataType.FLICKRS)){
                deactivateMenu(SOCIAL);
            };
            if (isActive(DataType.FOUR_SQUARE)){
                deactivateMenu(SOCIAL);
            };
        }
        public static function isActive(type:int):Boolean{
            return (((state & type) == type));
        }
        public static function activate(type:int):void{
            state = (state | type);
            if (type == DataType.METRO_STATIONS){
                activate(DataType.TRAINS);
            };
            checkState(type);
        }
        public static function deactivate(type:int):void{
            state = (state & ~(type));
            if (type == DataType.METRO_STATIONS){
                deactivate(DataType.TRAINS);
            };
        }
        public static function toggle(type:int):void{
            if (isActive(type)){
                deactivate(type);
            } else {
                activate(type);
            };
        }
        public static function all():void{
            state = 0xFFFFFFFF;
            _menus = 0xFFFFFFFF;
            activateMenu(TRANSPORTS);
            activateMenu(NETWORKS);
            activateMenu(FURNITURE);
            activateMenu(SOCIAL);
        }
        public static function none():void{
            state = 0;
            _menus = 0;
            deactivateMenu(TRANSPORTS);
            deactivateMenu(NETWORKS);
            deactivateMenu(FURNITURE);
            deactivateMenu(SOCIAL);
        }
        public static function get state():uint{
            return (_state);
        }
        public static function set state(value:uint):void{
            _state = value;
        }
        private static function checkState(type:int):void{
        }
        public static function get isHQ():Boolean{
            return (_isHQ);
        }
        public static function set isHQ(value:Boolean):void{
            _isHQ = value;
            SharedData.isHq = value;
        }
        public static function isMenuActive(type:int):Boolean{
            return (((_menus & type) == type));
        }
        public static function activateMenu(type:int):void{
            _menus = (_menus | type);
        }
        public static function deactivateMenu(type:int):void{
            _menus = (_menus & ~(type));
        }
        public static function toggleMenu(type:int):void{
            if (isMenuActive(type)){
                deactivateMenu(type);
            } else {
                activateMenu(type);
            };
            checkMenuItemState(type);
        }
        private static function checkMenuItemState(type:int):void{
            if (type == TRANSPORTS){
                if (isMenuActive(TRANSPORTS)){
                    deactivate(DataType.METRO_STATIONS);
                    deactivate(DataType.TRAINS);
                    deactivate(DataType.VELO_STATIONS);
                } else {
                    activate(DataType.METRO_STATIONS);
                    activate(DataType.TRAINS);
                    activate(DataType.VELO_STATIONS);
                };
            };
            if (type == NETWORKS){
                if (isMenuActive(NETWORKS)){
                    deactivate(DataType.ELECTROMAGNETICS);
                    deactivate(DataType.INTERNET_RELAYS);
                    deactivate(DataType.MOBILES);
                    deactivate(DataType.WIFIS);
                } else {
                    activate(DataType.ELECTROMAGNETICS);
                    activate(DataType.INTERNET_RELAYS);
                    activate(DataType.MOBILES);
                    activate(DataType.WIFIS);
                };
            };
            if (type == FURNITURE){
                if (isMenuActive(FURNITURE)){
                    deactivate(DataType.ATMS);
                    deactivate(DataType.ADS);
                    deactivate(DataType.CAMERAS);
                    deactivate(DataType.TRAFFIC_LIGHTS);
                    deactivate(DataType.RADARS);
                    deactivate(DataType.TOILETS);
                } else {
                    activate(DataType.ATMS);
                    activate(DataType.ADS);
                    activate(DataType.CAMERAS);
                    activate(DataType.TRAFFIC_LIGHTS);
                    activate(DataType.RADARS);
                    activate(DataType.TOILETS);
                };
            };
            if (type == SOCIAL){
                if (isMenuActive(SOCIAL)){
                    deactivate(DataType.TWITTERS);
                    deactivate(DataType.FLICKRS);
                    deactivate(DataType.INSTAGRAMS);
                    deactivate(DataType.FOUR_SQUARE);
                } else {
                    activate(DataType.TWITTERS);
                    activate(DataType.FLICKRS);
                    activate(DataType.INSTAGRAMS);
                    activate(DataType.FOUR_SQUARE);
                };
            };
        }
        public static function toggleMenuByType(type:int):void{
            var menu:int = -1;
            if (type == DataType.ADS){
                menu = FURNITURE;
            };
            if (type == DataType.ATMS){
                menu = FURNITURE;
            };
            if (type == DataType.CAMERAS){
                menu = FURNITURE;
            };
            if (type == DataType.ELECTROMAGNETICS){
                menu = NETWORKS;
            };
            if (type == DataType.FLICKRS){
                menu = SOCIAL;
            };
            if (type == DataType.FOUR_SQUARE){
                menu = SOCIAL;
            };
            if (type == DataType.INSTAGRAMS){
                menu = SOCIAL;
            };
            if (type == DataType.INTERNET_RELAYS){
                menu = NETWORKS;
            };
            if (type == DataType.METRO_STATIONS){
                menu = TRANSPORTS;
            };
            if (type == DataType.MOBILES){
                menu = NETWORKS;
            };
            if (type == DataType.RADARS){
                menu = FURNITURE;
            };
            if (type == DataType.TOILETS){
                menu = FURNITURE;
            };
            if (type == DataType.TRAFFIC_LIGHTS){
                menu = FURNITURE;
            };
            if (type == DataType.TRAINS){
                menu = TRANSPORTS;
            };
            if (type == DataType.TWITTERS){
                menu = SOCIAL;
            };
            if (type == DataType.VELO_STATIONS){
                menu = TRANSPORTS;
            };
            if (type == DataType.WIFIS){
                menu = NETWORKS;
            };
            if (menu == -1){
                return;
            };
            toggleMenu(menu);
        }

    }
}//package wd.core 
