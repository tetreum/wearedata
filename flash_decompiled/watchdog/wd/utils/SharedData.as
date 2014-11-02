package wd.utils {
    import flash.net.*;

    public class SharedData {

        private static var _instance:SharedData;

        private var mySO:SharedObject;
        private var _firstTime:Boolean;

        public function SharedData(){
            super();
            if (_instance == null){
                _instance = this;
                this.mySO = SharedObject.getLocal("watchdogs");
                if (this.mySO.data.firstTime == null){
                    this.mySO.data.firstTime = "1";
                    this._firstTime = true;
                    this.mySO.flush();
                } else {
                    this._firstTime = false;
                };
            };
        }
        private static function get instance():SharedData{
            if (_instance == null){
                new (SharedData)();
            };
            return (_instance);
        }
        public static function get firstTime():Boolean{
            return (instance._firstTime);
        }
        public static function set soundVolume(n:Number):void{
            _instance.mySO.data.soundVolume = n;
            _instance.mySO.flush();
        }
        public static function get soundVolume():Number{
            if (_instance.mySO.data.soundVolume == null){
                _instance.mySO.data.soundVolume = "1";
                _instance.mySO.flush();
            };
            return (_instance.mySO.data.soundVolume);
        }
        public static function set isHq(v:Boolean):void{
            _instance.mySO.data.isHq = v;
            _instance.mySO.flush();
        }
        public static function get isHq():Boolean{
            if (_instance.mySO.data.isHq == null){
                _instance.mySO.data.isHq = true;
                _instance.mySO.flush();
            };
            return (_instance.mySO.data.isHq);
        }

    }
}//package wd.utils 
