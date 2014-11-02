package wd.d3.geom.segments {
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.display3D.*;
    import wd.d3.*;
    import flash.utils.*;
    import away3d.core.base.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import away3d.materials.lightpickers.*;
    import away3d.materials.passes.*;

    public class WireSegmentPassbuilding2 extends MaterialPassBase {

        protected static const ONE_VECTOR:Vector.<Number> = Vector.<Number>([1, 1, 1, 1]);
        protected static const FRONT_VECTOR:Vector.<Number> = Vector.<Number>([0, 0, -1, 0]);

        private static var VARIABLES:Vector.<Number> = Vector.<Number>([1, 2]);
        private static var angle:Number = 0;

        private var _constants:Vector.<Number>;
        private var _color:Vector.<Number>;
        private var _calcMatrix:Matrix3D;
        private var _thickness:Number;
        private var mVarsV:Vector.<Number>;
        private var mVarsV2:Vector.<Number>;
        private var mVarsF:Vector.<Number>;
        private var mVarsF2:Vector.<Number>;
        private var sintille:Boolean;

        public function WireSegmentPassbuilding2(color:int, thickness:Number, sintille:Boolean=false){
            this._constants = new Vector.<Number>(4, true);
            this._color = new Vector.<Number>(4, true);
            this.mVarsV = new <Number>[30, 30, 30, 30];
            this.mVarsV2 = new <Number>[30, 0.5, 0, 1];
            this.mVarsF = new <Number>[100, 100, 200, 50];
            this.mVarsF2 = new <Number>[30, 0.5, 30, 1];
            this.sintille = sintille;
            this._calcMatrix = new Matrix3D();
            this._thickness = thickness;
            this._color[0] = (((color >> 16) & 0xFF) / 0xFF);
            this._color[1] = (((color >> 8) & 0xFF) / 0xFF);
            this._color[2] = ((color & 0xFF) / 0xFF);
            this._color[3] = 1;
            this._constants[1] = (1 / 0xFF);
            this.radius = 100;
            this.falloff = 100;
            super();
        }
        public function set radius(v:Number):void{
            this.mVarsV[2] = v;
        }
        public function set falloff(v:Number):void{
            this.mVarsV[3] = v;
        }
        override function getVertexCode(code:String):String{
            code = (((((((((((((((((((((((((((((("mov vt0, va0 \n" + "m44 vt0, vt0, vc8\t\t\t\n") + "mov vt1, va1 \n") + "m44 vt1, vt1, vc8\t\t\t\n") + "sub vt2, vt1, vt0 \t\t\t\t\n") + "slt vt5.x, vt0.z, vc7.z\t\t\n") + "sub vt5.y, vc5.x, vt5.x\t\t\n") + "add vt4.x, vt0.z, vc7.z\t\t\n") + "sub vt4.y, vt0.z, vt1.z\t\t\n") + "div vt4.z, vt4.x, vt4.y\t\t\n") + "mul vt4.xyz, vt4.zzz, vt2.xyz\t\n") + "add vt3.xyz, vt0.xyz, vt4.xyz\t\n") + "mov vt3.w, vc5.x\t\t\t\t\n") + "mul vt0, vt0, vt5.yyyy\t\t\t\n") + "mul vt3, vt3, vt5.xxxx\t\t\t\n") + "add vt0, vt0, vt3\t\t\t\t\n") + "sub vt2, vt1, vt0 \t\t\t\t\n") + "nrm vt2.xyz, vt2.xyz\t\t\t\n") + "nrm vt5.xyz, vt0.xyz\t\t\t\n") + "mov vt5.w, vc5.x\t\t\t\t\n") + "crs vt3.xyz, vt2, vt5\t\t\t\n") + "nrm vt3.xyz, vt3.xyz\t\t\t\n") + "mul vt3.xyz, vt3.xyz, va2.xxx\t\n") + "mov vt3.w, vc5.x\t\t\t\t\n") + "dp3 vt4.x, vt0, vc6\t\t\t\n") + "mul vt4.x, vt4.x, vc7.x\t\t\n") + "mul vt3.xyz, vt3.xyz, vt4.xxx\t\n") + "add vt0.xyz, vt0.xyz, vt3.xyz\t\n") + "m44 vt0, vt0, vc0\t\t\t\t\n") + "mul op, vt0, vc4\t\t\t\t\n") + "mov v0, va0\t\t\t\t\t\n");
            return (code);
        }
        override function getFragmentCode():String{
            var code:String = (((((((((("sub ft0.x, v0.x, \tfc1.x  \n" + "mul ft0.x, ft0.x, ft0.x  \n") + "sub ft0.y, v0.z, \tfc1.y  \n") + "mul ft0.y, ft0.y, ft0.y  \n") + "add ft0.z, ft0.x, ft0.y  \n") + "sqt ft0.z, ft0.z \n") + "sub ft0.x, ft0.z,\tfc1.z \n") + "div ft0.w, ft0.x,\tfc1.w \n") + "sub ft0.w, fc2.w,ft0.w \n") + "mov ft1,fc0  \n") + "mov ft1.w , ft0.w \n");
            if (this.sintille){
                code = (code + (((("add ft2.x, fc2.x, v0.x \n" + "div ft2.x, ft2.x, v0.z \n") + "cos ft2.x, ft2.x \n") + "abs ft2.x, ft2.x\t\t\n") + "mul ft1.w, ft1.w, ft2.x \n"));
            };
            code = (code + "mov oc, ft1 \n");
            return (code);
        }
        override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, lightPicker:LightPickerBase):void{
            var context:Context3D = stage3DProxy._context3D;
            this._constants[0] = (this._thickness / Math.min(stage3DProxy.width, stage3DProxy.height));
            this._constants[2] = camera.lens.near;
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, camera.lens.matrix, true);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, ONE_VECTOR);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6, FRONT_VECTOR);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 7, this._constants);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._color);
            context.setCulling(Context3DTriangleFace.NONE);
            if (!(this.sintille)){
                context.setDepthTest(true, Context3DCompareMode.ALWAYS);
            };
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            var vertexBuffer:VertexBuffer3D = renderable.getCustomBuffer(stage3DProxy);
            context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            context.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
            context.setVertexBufferAt(2, vertexBuffer, 6, Context3DVertexBufferFormat.FLOAT_1);
            this._calcMatrix.copyFrom(renderable.sourceEntity.sceneTransform);
            this._calcMatrix.append(camera.inverseSceneTransform);
            this.mVarsV[0] = Simulation.instance.cameraTargetPos.x;
            this.mVarsV[1] = Simulation.instance.cameraTargetPos.z;
            this.radius = (Simulation.instance.cameraTargetPos.y + 300);
            this.mVarsF[0] = Simulation.instance.cameraTargetPos.x;
            this.mVarsF[1] = Simulation.instance.cameraTargetPos.z;
            this.mVarsF[2] = this.mVarsV[2];
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, this.mVarsF);
            if (this.sintille){
                this.mVarsF2[0] = getTimer();
            };
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, this.mVarsF2);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, this._calcMatrix, true);
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
        }

    }
}//package wd.d3.geom.segments 
