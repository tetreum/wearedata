package away3d.core.managers {
    import flash.utils.*;
    import flash.display.*;
    import __AS3__.vec.*;

    public class Stage3DManager {

        private static var _instances:Dictionary;
        private static var _stageProxies:Vector.<Stage3DProxy>;
        private static var _numStageProxies:uint = 0;

        private var _stage:Stage;

        public function Stage3DManager(stage:Stage, Stage3DManagerSingletonEnforcer:Stage3DManagerSingletonEnforcer){
            super();
            if (!(Stage3DManagerSingletonEnforcer)){
                throw (new Error("This class is a multiton and cannot be instantiated manually. Use Stage3DManager.getInstance instead."));
            };
            this._stage = stage;
            if (!(_stageProxies)){
                _stageProxies = new Vector.<Stage3DProxy>(this._stage.stage3Ds.length, true);
            };
        }
        public static function getInstance(stage:Stage):Stage3DManager{
            return (((_instances = ((_instances) || (new Dictionary())))[stage] = (((_instances = ((_instances) || (new Dictionary())))[stage]) || (new Stage3DManager(stage, new Stage3DManagerSingletonEnforcer())))));
        }

        public function getStage3DProxy(index:uint, forceSoftware:Boolean=false):Stage3DProxy{
            if (!(_stageProxies[index])){
                _numStageProxies++;
                _stageProxies[index] = new Stage3DProxy(index, this._stage.stage3Ds[index], this, forceSoftware);
            };
            return (_stageProxies[index]);
        }
        function removeStage3DProxy(stage3DProxy:Stage3DProxy):void{
            _numStageProxies--;
            _stageProxies[stage3DProxy.stage3DIndex] = null;
        }
        public function getFreeStage3DProxy(forceSoftware:Boolean=false):Stage3DProxy{
            var i:uint;
            var len:uint = _stageProxies.length;
            while (i < len) {
                if (!(_stageProxies[i])){
                    this.getStage3DProxy(i, forceSoftware);
                    _stageProxies[i].width = this._stage.stageWidth;
                    _stageProxies[i].height = this._stage.stageHeight;
                    return (_stageProxies[i]);
                };
                i++;
            };
            throw (new Error("Too many Stage3D instances used!"));
        }
        public function get hasFreeStage3DProxy():Boolean{
            return ((((_numStageProxies < _stageProxies.length)) ? true : false));
        }
        public function get numProxySlotsFree():uint{
            return ((_stageProxies.length - _numStageProxies));
        }
        public function get numProxySlotsUsed():uint{
            return (_numStageProxies);
        }
        public function get numProxySlotsTotal():uint{
            return (_stageProxies.length);
        }

    }
}//package away3d.core.managers 

class Stage3DManagerSingletonEnforcer {

    public function Stage3DManagerSingletonEnforcer(){
    }
}
