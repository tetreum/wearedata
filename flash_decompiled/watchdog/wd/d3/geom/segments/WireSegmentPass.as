package wd.d3.geom.segments {
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.display3D.*;
    import wd.d3.*;
    import wd.d3.control.*;
    import away3d.core.base.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import away3d.materials.lightpickers.*;
    import away3d.materials.passes.*;

    public class WireSegmentPass extends MaterialPassBase {

        protected static const ONE_VECTOR:Vector.<Number> = Vector.<Number>([1, 1, 1, 1]);
        protected static const FRONT_VECTOR:Vector.<Number> = Vector.<Number>([0, 0, -1, 0]);

        private static var VARIABLES:Vector.<Number> = Vector.<Number>([1, 2]);
        private static var angle:Number = 0;

        private var _constants:Vector.<Number>;
        private var _calcMatrix:Matrix3D;
        private var _thickness:Number;
        private var useCustomData:Boolean;
        private var mVarsV:Vector.<Number>;
        private var mVarsV2:Vector.<Number>;
        private var useFog:Boolean;

        public function WireSegmentPass(thickness:Number, useCustomData:Boolean=false, useFog:Boolean=false){
            this._constants = new Vector.<Number>(4, true);
            this.mVarsV = new <Number>[30, 30, 30, 30];
            this.mVarsV2 = new <Number>[1, 30, 30, 30];
            this.useFog = useFog;
            this.useCustomData = useCustomData;
            this._calcMatrix = new Matrix3D();
            this._thickness = thickness;
            this._constants[1] = (1 / 0xFF);
            this.radius = 400;
            this.falloff = 200;
            super();
        }
        public function set radius(v:Number):void{
            this.mVarsV[2] = v;
        }
        public function set falloff(v:Number):void{
            this.mVarsV[3] = v;
        }
        override function getVertexCode(code:String):String{
            code = ((((((((((((((((((((((((((("m44 vt0, va0, vc8\t\t\t\t\n" + "m44 vt1, va1, vc8\t\t\t\t\n") + "sub vt2, vt1, vt0 \t\t\t\t\n") + "slt vt5.x, vt0.z, vc7.z\t\t\n") + "sub vt5.y, vc5.x, vt5.x\t\t\n") + "add vt4.x, vt0.z, vc7.z\t\t\n") + "sub vt4.y, vt0.z, vt1.z\t\t\n") + "div vt4.z, vt4.x, vt4.y\t\t\n") + "mul vt4.xyz, vt4.zzz, vt2.xyz\t\n") + "add vt3.xyz, vt0.xyz, vt4.xyz\t\n") + "mov vt3.w, vc5.x\t\t\t\t\n") + "mul vt0, vt0, vt5.yyyy\t\t\t\n") + "mul vt3, vt3, vt5.xxxx\t\t\t\n") + "add vt0, vt0, vt3\t\t\t\t\n") + "sub vt2, vt1, vt0 \t\t\t\t\n") + "nrm vt2.xyz, vt2.xyz\t\t\t\n") + "nrm vt5.xyz, vt0.xyz\t\t\t\n") + "mov vt5.w, vc5.x\t\t\t\t\n") + "crs vt3.xyz, vt2, vt5\t\t\t\n") + "nrm vt3.xyz, vt3.xyz\t\t\t\n") + "mul vt3.xyz, vt3.xyz, va2.xxx\t\n") + "mov vt3.w, vc5.x\t\t\t\t\n") + "dp3 vt4.x, vt0, vc6\t\t\t\n") + "mul vt4.x, vt4.x, vc7.x\t\t\n") + "mul vt3.xyz, vt3.xyz, vt4.xxx\t\n") + "add vt0.xyz, vt0.xyz, vt3.xyz\t\n") + "m44 vt0, vt0, vc0\t\t\t\t\n") + "mul op, vt0, vc4\t\t\t\t\n");
            if (this.useFog){
                code = (code + ("mov v0, va0\t\t\t\t\t\n" + "mov v1, va3\t\t\t\t\t\n"));
            } else {
                code = (code + "mov v0, va3\t\t\t\t\t\n");
            };
            return (code);
        }
        override function getFragmentCode():String{
            var code:String;
            if (this.useFog){
                code = ((((((((((("sub ft0.x, v0.x, \tfc1.x  \n" + "mul ft0.x, ft0.x, ft0.x  \n") + "sub ft0.y, v0.z, \tfc1.y  \n") + "mul ft0.y, ft0.y, ft0.y  \n") + "add ft0.z, ft0.x, ft0.y  \n") + "sqt ft0.z, ft0.z \n") + "sub ft0.x, ft0.z,\tfc1.z \n") + "div ft0.w, ft0.x,\tfc1.w \n") + "sub ft0.w, fc2.x,ft0.w \n") + "mov ft1,v1  \n") + "mov ft1.w , ft0.w \n") + "mov oc, ft1 \n");
                return (code);
            };
            return ("mov oc, v0\n");
        }
        override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, lightPicker:LightPickerBase):void{
            var context:Context3D = stage3DProxy._context3D;
            this._constants[0] = (this._thickness / Math.min(stage3DProxy.width, stage3DProxy.height));
            this._constants[2] = camera.lens.near;
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, ONE_VECTOR);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6, FRONT_VECTOR);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 7, this._constants);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, camera.lens.matrix, true);
            context.setCulling(Context3DTriangleFace.BACK);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            var vertexBuffer:VertexBuffer3D = ((this.useCustomData) ? renderable.getCustomBuffer(stage3DProxy) : renderable.getVertexBuffer(stage3DProxy));
            context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            context.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
            context.setVertexBufferAt(2, vertexBuffer, 6, Context3DVertexBufferFormat.FLOAT_1);
            context.setVertexBufferAt(3, vertexBuffer, 7, Context3DVertexBufferFormat.FLOAT_4);
            this._calcMatrix.copyFrom(renderable.sourceEntity.sceneTransform);
            this._calcMatrix.append(camera.inverseSceneTransform);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, this._calcMatrix, true);
            if (this.useFog){
                this.mVarsV[0] = Simulation.instance.cameraTargetPos.x;
                this.mVarsV[1] = Simulation.instance.cameraTargetPos.z;
                this.falloff = (400 + (CameraController.CAM_HEIGHT * 1500));
                context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.mVarsV);
                context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, this.mVarsV2);
            };
            context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
        }
        override function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, textureRatioX:Number, textureRatioY:Number):void{
            var context:Context3D = stage3DProxy._context3D;
            super.activate(stage3DProxy, camera, textureRatioX, textureRatioY);
        }
        override function deactivate(stage3DProxy:Stage3DProxy):void{
            stage3DProxy.setSimpleVertexBuffer(0, null, null, 0);
            stage3DProxy.setSimpleVertexBuffer(1, null, null, 0);
            stage3DProxy.setSimpleVertexBuffer(2, null, null, 0);
            stage3DProxy.setSimpleVertexBuffer(3, null, null, 0);
        }

    }
}//package wd.d3.geom.segments 
