package away3d.materials.utils {

    public class ShaderRegisterCache {

        private var _fragmentTempCache:RegisterPool;
        private var _vertexTempCache:RegisterPool;
        private var _varyingCache:RegisterPool;
        private var _fragmentConstantsCache:RegisterPool;
        private var _vertexConstantsCache:RegisterPool;
        private var _textureCache:RegisterPool;
        private var _vertexAttributesCache:RegisterPool;
        private var _vertexConstantOffset:uint;
        private var _vertexAttributesOffset:uint;
        private var _fragmentOutputRegister:ShaderRegisterElement;
        private var _vertexOutputRegister:ShaderRegisterElement;
        private var _numUsedVertexConstants:uint;
        private var _numUsedFragmentConstants:uint;
        private var _numUsedStreams:uint;
        private var _numUsedTextures:uint;

        public function ShaderRegisterCache(){
            super();
        }
        public function reset():void{
            var i:int;
            this._fragmentTempCache = new RegisterPool("ft", 8, false);
            this._vertexTempCache = new RegisterPool("vt", 8, false);
            this._varyingCache = new RegisterPool("v", 8);
            this._textureCache = new RegisterPool("fs", 8);
            this._vertexAttributesCache = new RegisterPool("va", 8);
            this._fragmentConstantsCache = new RegisterPool("fc", 28);
            this._vertexConstantsCache = new RegisterPool("vc", 128);
            this._fragmentOutputRegister = new ShaderRegisterElement("oc", -1);
            this._vertexOutputRegister = new ShaderRegisterElement("op", -1);
            this._numUsedVertexConstants = 0;
            this._numUsedStreams = 0;
            this._numUsedTextures = 0;
            i = 0;
            while (i < this._vertexAttributesOffset) {
                this.getFreeVertexAttribute();
                i++;
            };
            i = 0;
            while (i < this._vertexConstantOffset) {
                this.getFreeVertexConstant();
                i++;
            };
        }
        public function dispose():void{
            this._fragmentTempCache.dispose();
            this._vertexTempCache.dispose();
            this._varyingCache.dispose();
            this._fragmentConstantsCache.dispose();
            this._vertexAttributesCache.dispose();
            this._fragmentTempCache = null;
            this._vertexTempCache = null;
            this._varyingCache = null;
            this._fragmentConstantsCache = null;
            this._vertexAttributesCache = null;
            this._fragmentOutputRegister = null;
            this._vertexOutputRegister = null;
        }
        public function addFragmentTempUsages(register:ShaderRegisterElement, usageCount:uint):void{
            this._fragmentTempCache.addUsage(register, usageCount);
        }
        public function removeFragmentTempUsage(register:ShaderRegisterElement):void{
            this._fragmentTempCache.removeUsage(register);
        }
        public function addVertexTempUsages(register:ShaderRegisterElement, usageCount:uint):void{
            this._vertexTempCache.addUsage(register, usageCount);
        }
        public function removeVertexTempUsage(register:ShaderRegisterElement):void{
            this._vertexTempCache.removeUsage(register);
        }
        public function getFreeFragmentVectorTemp():ShaderRegisterElement{
            return (this._fragmentTempCache.requestFreeVectorReg());
        }
        public function getFreeFragmentSingleTemp():ShaderRegisterElement{
            return (this._fragmentTempCache.requestFreeRegComponent());
        }
        public function getFreeVarying():ShaderRegisterElement{
            return (this._varyingCache.requestFreeVectorReg());
        }
        public function getFreeFragmentConstant():ShaderRegisterElement{
            this._numUsedFragmentConstants++;
            return (this._fragmentConstantsCache.requestFreeVectorReg());
        }
        public function getFreeVertexConstant():ShaderRegisterElement{
            this._numUsedVertexConstants++;
            return (this._vertexConstantsCache.requestFreeVectorReg());
        }
        public function getFreeVertexVectorTemp():ShaderRegisterElement{
            return (this._vertexTempCache.requestFreeVectorReg());
        }
        public function getFreeVertexSingleTemp():ShaderRegisterElement{
            return (this._vertexTempCache.requestFreeRegComponent());
        }
        public function getFreeVertexAttribute():ShaderRegisterElement{
            this._numUsedStreams++;
            return (this._vertexAttributesCache.requestFreeVectorReg());
        }
        public function getFreeTextureReg():ShaderRegisterElement{
            this._numUsedTextures++;
            return (this._textureCache.requestFreeVectorReg());
        }
        public function get vertexConstantOffset():uint{
            return (this._vertexConstantOffset);
        }
        public function set vertexConstantOffset(vertexConstantOffset:uint):void{
            this._vertexConstantOffset = vertexConstantOffset;
        }
        public function get vertexAttributesOffset():uint{
            return (this._vertexAttributesOffset);
        }
        public function set vertexAttributesOffset(value:uint):void{
            this._vertexAttributesOffset = value;
        }
        public function get fragmentOutputRegister():ShaderRegisterElement{
            return (this._fragmentOutputRegister);
        }
        public function get numUsedVertexConstants():uint{
            return (this._numUsedVertexConstants);
        }
        public function get numUsedFragmentConstants():uint{
            return (this._numUsedFragmentConstants);
        }
        public function get numUsedStreams():uint{
            return (this._numUsedStreams);
        }
        public function get numUsedTextures():uint{
            return (this._numUsedTextures);
        }

    }
}//package away3d.materials.utils 
