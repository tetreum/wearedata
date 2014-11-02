package away3d.materials.utils {
    import away3d.materials.utils.*;
    import __AS3__.vec.*;

    class RegisterPool {

        private static const COMPONENTS:Array = ["x", "y", "z", "w"];

        private var _regName:String;
        private var _vectorRegisters:Vector.<ShaderRegisterElement>;
        private var _registerComponents:Array;
        private var _usedSingleCount:Array;
        private var _usedVectorCount:Vector.<uint>;
        private var _regCount:int;
        private var _persistent:Boolean;

        public function RegisterPool(regName:String, regCount:int, persistent:Boolean=true){
            super();
            this._regName = regName;
            this._regCount = regCount;
            this._persistent = persistent;
            this.initRegisters(regName, regCount);
        }
        public function requestFreeVectorReg():ShaderRegisterElement{
            var i:int;
            while (i < this._regCount) {
                if (!(this.isRegisterUsed(i))){
                    if (this._persistent){
                        this.addUsage(this._vectorRegisters[i], 1);
                    };
                    return (this._vectorRegisters[i]);
                };
                i++;
            };
            throw (new Error("Register overflow!"));
        }
        public function requestFreeRegComponent():ShaderRegisterElement{
            var comp:String;
            var j:int;
            var i:int;
            while (i < this._regCount) {
                if (this._usedVectorCount[i] > 0){
                } else {
                    j = 0;
                    while (j < 4) {
                        comp = COMPONENTS[j];
                        if (this._usedSingleCount[comp][i] == 0){
                            if (this._persistent){
                                this.addUsage(this._usedSingleCount[comp][i], 1);
                            };
                            return (this._registerComponents[comp][i]);
                        };
                        j++;
                    };
                };
                i++;
            };
            throw (new Error("Register overflow!"));
        }
        public function addUsage(register:ShaderRegisterElement, usageCount:int):void{
            if (register.component){
                this._usedSingleCount[register.component][register.index] = (this._usedSingleCount[register.component][register.index] + usageCount);
            } else {
                this._usedVectorCount[register.index] = (this._usedVectorCount[register.index] + usageCount);
            };
        }
        public function removeUsage(register:ShaderRegisterElement):void{
            if (register.component){
                var _local2 = this._usedSingleCount[register.component];
                var _local3 = register.index;
                var _local4 = (_local2[_local3] - 1);
                _local2[_local3] = _local4;
                if (_local4 < 0){
                    throw (new Error("More usages removed than exist!"));
                };
            } else {
                _local2 = this._usedVectorCount;
                _local3 = register.index;
                _local4 = (_local2[_local3] - 1);
                _local2[_local3] = _local4;
                if (_local4 < 0){
                    throw (new Error("More usages removed than exist!"));
                };
            };
        }
        public function dispose():void{
            this._vectorRegisters = null;
            this._registerComponents = null;
            this._usedSingleCount = null;
            this._usedVectorCount = null;
        }
        public function hasRegisteredRegs():Boolean{
            var i:int;
            while (i < this._regCount) {
                if (this.isRegisterUsed(i)){
                    return (true);
                };
                i++;
            };
            return (false);
        }
        private function initRegisters(regName:String, regCount:int):void{
            var comp:String;
            var j:int;
            this._vectorRegisters = new Vector.<ShaderRegisterElement>(regCount, true);
            this._registerComponents = [];
            this._usedVectorCount = new Vector.<uint>(regCount, true);
            this._usedSingleCount = [];
            var i:int;
            while (i < regCount) {
                this._vectorRegisters[i] = new ShaderRegisterElement(regName, i);
                this._usedVectorCount[i] = 0;
                j = 0;
                while (j < 4) {
                    comp = COMPONENTS[j];
                    this._registerComponents[comp] = ((this._registerComponents[comp]) || ([]));
                    this._usedSingleCount[comp] = ((this._usedSingleCount[comp]) || ([]));
                    this._registerComponents[comp][i] = new ShaderRegisterElement(regName, i, comp);
                    this._usedSingleCount[comp][i] = 0;
                    j++;
                };
                i++;
            };
        }
        private function isRegisterUsed(index:int):Boolean{
            if (this._usedVectorCount[index] > 0){
                return (true);
            };
            var i:int;
            while (i < 4) {
                if (this._usedSingleCount[COMPONENTS[i]][index] > 0){
                    return (true);
                };
                i++;
            };
            return (false);
        }

    }
}//package away3d.materials.utils 
