package away3d.core.managers {
    import __AS3__.vec.*;
    import away3d.events.*;
    import flash.display3D.*;
    import flash.utils.*;
    import com.adobe.utils.*;
    import away3d.debug.*;
    import away3d.materials.passes.*;

    public class AGALProgram3DCache {

        private static var _instances:Vector.<AGALProgram3DCache>;
        private static var _currentId:int;

        private var _stage3DProxy:Stage3DProxy;
        private var _program3Ds:Array;
        private var _ids:Array;
        private var _usages:Array;
        private var _keys:Array;

        public function AGALProgram3DCache(stage3DProxy:Stage3DProxy, AGALProgram3DCacheSingletonEnforcer:AGALProgram3DCacheSingletonEnforcer){
            super();
            if (!(AGALProgram3DCacheSingletonEnforcer)){
                throw (new Error("This class is a multiton and cannot be instantiated manually. Use Stage3DManager.getInstance instead."));
            };
            this._stage3DProxy = stage3DProxy;
            this._program3Ds = [];
            this._ids = [];
            this._usages = [];
            this._keys = [];
        }
        public static function getInstance(stage3DProxy:Stage3DProxy):AGALProgram3DCache{
            var index:int = stage3DProxy._stage3DIndex;
            _instances = ((_instances) || (new Vector.<AGALProgram3DCache>(8, true)));
            if (!(_instances[index])){
                _instances[index] = new AGALProgram3DCache(stage3DProxy, new AGALProgram3DCacheSingletonEnforcer());
                stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_DISPOSED, onContext3DDisposed, false, 0, true);
                stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContext3DDisposed, false, 0, true);
            };
            return (_instances[index]);
        }
        public static function getInstanceFromIndex(index:int):AGALProgram3DCache{
            if (!(_instances[index])){
                throw (new Error("Instance not created yet!"));
            };
            return (_instances[index]);
        }
        private static function onContext3DDisposed(event:Stage3DEvent):void{
            var stage3DProxy:Stage3DProxy = Stage3DProxy(event.target);
            var index:int = stage3DProxy._stage3DIndex;
            _instances[index].dispose();
            _instances[index] = null;
            stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_DISPOSED, onContext3DDisposed);
            stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContext3DDisposed);
        }

        public function dispose():void{
            var key:String;
            for (key in this._program3Ds) {
                this.destroyProgram(key);
            };
            this._keys = null;
            this._program3Ds = null;
            this._usages = null;
        }
        public function setProgram3D(pass:MaterialPassBase, vertexCode:String, fragmentCode:String):void{
            var program:Program3D;
            var vertexByteCode:ByteArray;
            var fragmentByteCode:ByteArray;
            var stageIndex:int = this._stage3DProxy._stage3DIndex;
            var key:String = this.getKey(vertexCode, fragmentCode);
            if (this._program3Ds[key] == null){
                this._keys[_currentId] = key;
                this._usages[_currentId] = 0;
                this._ids[key] = _currentId;
                _currentId++;
                program = this._stage3DProxy._context3D.createProgram();
                vertexByteCode = new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX, vertexCode);
                fragmentByteCode = new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT, fragmentCode);
                program.upload(vertexByteCode, fragmentByteCode);
                this._program3Ds[key] = program;
            };
            var oldId:int = pass._program3Dids[stageIndex];
            var newId:int = this._ids[key];
            if (oldId != newId){
                if (oldId >= 0){
                    this.freeProgram3D(oldId);
                };
                var _local11 = this._usages;
                var _local12 = newId;
                var _local13 = (_local11[_local12] + 1);
                _local11[_local12] = _local13;
            };
            pass._program3Dids[stageIndex] = newId;
            pass._program3Ds[stageIndex] = this._program3Ds[key];
        }
        public function freeProgram3D(programId:int):void{
            var _local2 = this._usages;
            var _local3 = programId;
            var _local4 = (_local2[_local3] - 1);
            _local2[_local3] = _local4;
            if (this._usages[programId] == 0){
                this.destroyProgram(this._keys[programId]);
            };
        }
        private function destroyProgram(key:String):void{
            this._program3Ds[key].dispose();
            this._program3Ds[key] = null;
            delete this._program3Ds[key];
            this._ids[key] = -1;
        }
        private function getKey(vertexCode:String, fragmentCode:String):String{
            return (((vertexCode + "---") + fragmentCode));
        }

    }
}//package away3d.core.managers 

class AGALProgram3DCacheSingletonEnforcer {

    public function AGALProgram3DCacheSingletonEnforcer(){
    }
}
