package away3d.materials.methods {
    import flash.geom.*;
    import away3d.lights.*;
    import __AS3__.vec.*;
    import away3d.materials.utils.*;
    import away3d.errors.*;
    import away3d.lights.shadowmaps.*;
    import away3d.core.base.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;

    public class ShadowMapMethodBase extends ShadingMethodBase {

        private var _castingLight:LightBase;
        protected var _depthMapCoordReg:ShaderRegisterElement;
        private var _projMatrix:Matrix3D;
        private var _shadowMapper:ShadowMapperBase;
        protected var _usePoint:Boolean;
        private var _epsilon:Number;
        private var _alpha:Number = 1;

        public function ShadowMapMethodBase(castingLight:LightBase){
            this._projMatrix = new Matrix3D();
            this._usePoint = (castingLight is PointLight);
            super();
            this._castingLight = castingLight;
            castingLight.castsShadows = true;
            this._shadowMapper = castingLight.shadowMapper;
            this._epsilon = ((this._usePoint) ? 0.01 : 0.002);
        }
        override function initVO(vo:MethodVO):void{
            vo.needsView = true;
            vo.needsGlobalPos = this._usePoint;
            vo.needsNormals = (vo.numLights > 0);
        }
        override function initConstants(vo:MethodVO):void{
            var fragmentData:Vector.<Number> = vo.fragmentData;
            var vertexData:Vector.<Number> = vo.vertexData;
            var index:int = vo.fragmentConstantsIndex;
            fragmentData[index] = 1;
            fragmentData[(index + 1)] = (1 / 0xFF);
            fragmentData[(index + 2)] = (1 / 65025);
            fragmentData[(index + 3)] = (1 / 16581375);
            fragmentData[(index + 6)] = 0;
            fragmentData[(index + 7)] = 1;
            if (this._usePoint){
                fragmentData[(index + 8)] = 0;
                fragmentData[(index + 9)] = 0;
                fragmentData[(index + 10)] = 0;
                fragmentData[(index + 11)] = 1;
            };
            index = vo.vertexConstantsIndex;
            if (index != -1){
                vertexData[index] = 0.5;
                vertexData[(index + 1)] = -0.5;
                vertexData[(index + 2)] = 1;
                vertexData[(index + 3)] = 1;
            };
        }
        public function get alpha():Number{
            return (this._alpha);
        }
        public function set alpha(value:Number):void{
            this._alpha = value;
        }
        function get depthMapCoordReg():ShaderRegisterElement{
            return (this._depthMapCoordReg);
        }
        function set depthMapCoordReg(value:ShaderRegisterElement):void{
            this._depthMapCoordReg = value;
        }
        public function get castingLight():LightBase{
            return (this._castingLight);
        }
        public function get epsilon():Number{
            return (this._epsilon);
        }
        public function set epsilon(value:Number):void{
            this._epsilon = value;
        }
        override function cleanCompilationData():void{
            super.cleanCompilationData();
            this._depthMapCoordReg = null;
        }
        override function getVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            return (((this._usePoint) ? this.getPointVertexCode(vo, regCache) : this.getPlanarVertexCode(vo, regCache)));
        }
        protected function getPointVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            vo.vertexConstantsIndex = -1;
            return ("");
        }
        protected function getPlanarVertexCode(vo:MethodVO, regCache:ShaderRegisterCache):String{
            var code:String = "";
            var temp:ShaderRegisterElement = regCache.getFreeVertexVectorTemp();
            var toTexReg:ShaderRegisterElement = regCache.getFreeVertexConstant();
            var depthMapProj:ShaderRegisterElement = regCache.getFreeVertexConstant();
            regCache.getFreeVertexConstant();
            regCache.getFreeVertexConstant();
            regCache.getFreeVertexConstant();
            this._depthMapCoordReg = regCache.getFreeVarying();
            vo.vertexConstantsIndex = ((toTexReg.index - vo.vertexConstantsOffset) * 4);
            code = (code + (((((((((((((((((((((((((((((((((((((("m44 " + temp) + ", vt0, ") + depthMapProj) + "\n") + "rcp ") + temp) + ".w, ") + temp) + ".w\n") + "mul ") + temp) + ".xyz, ") + temp) + ".xyz, ") + temp) + ".w\n") + "mul ") + temp) + ".xy, ") + temp) + ".xy, ") + toTexReg) + ".xy\n") + "add ") + temp) + ".xy, ") + temp) + ".xy, ") + toTexReg) + ".xx\n") + "mov ") + this._depthMapCoordReg) + ".xyz, ") + temp) + ".xyz\n") + "mov ") + this._depthMapCoordReg) + ".w, va0.w\n"));
            return (code);
        }
        function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            var code:String = ((this._usePoint) ? this.getPointFragmentCode(vo, regCache, targetReg) : this.getPlanarFragmentCode(vo, regCache, targetReg));
            code = (code + ((((((((((("add " + targetReg) + ".w, ") + targetReg) + ".w, fc") + ((vo.fragmentConstantsIndex / 4) + 1)) + ".y\n") + "sat ") + targetReg) + ".w, ") + targetReg) + ".w\n"));
            return (code);
        }
        protected function getPlanarFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            throw (new AbstractMethodError());
        }
        protected function getPointFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            throw (new AbstractMethodError());
        }
        override function setRenderState(vo:MethodVO, renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D):void{
            if (!(this._usePoint)){
                this._projMatrix.copyFrom(DirectionalShadowMapper(this._shadowMapper).depthProjection);
                this._projMatrix.prepend(renderable.sceneTransform);
                this._projMatrix.copyRawDataTo(vo.vertexData, (vo.vertexConstantsIndex + 4), true);
            };
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
            var pos:Vector3D;
            var f:Number;
            var fragmentData:Vector.<Number> = vo.fragmentData;
            var index:int = vo.fragmentConstantsIndex;
            fragmentData[(index + 4)] = -(this._epsilon);
            fragmentData[(index + 5)] = (1 - this._alpha);
            if (this._usePoint){
                pos = this._castingLight.scenePosition;
                fragmentData[(index + 8)] = pos.x;
                fragmentData[(index + 9)] = pos.y;
                fragmentData[(index + 10)] = pos.z;
                f = PointLight(this._castingLight)._fallOff;
                fragmentData[(index + 11)] = (1 / ((2 * f) * f));
            };
            stage3DProxy.setTextureAt(vo.texturesIndex, this._castingLight.shadowMapper.depthMap.getTextureForStage3D(stage3DProxy));
        }

    }
}//package away3d.materials.methods 
