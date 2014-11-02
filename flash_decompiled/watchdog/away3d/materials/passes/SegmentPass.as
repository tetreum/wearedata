package away3d.materials.passes {
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.display3D.*;
    import away3d.core.base.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import away3d.materials.lightpickers.*;

    public class SegmentPass extends MaterialPassBase {

        protected static const ONE_VECTOR:Vector.<Number> = Vector.<Number>([1, 1, 1, 1]);
        protected static const FRONT_VECTOR:Vector.<Number> = Vector.<Number>([0, 0, -1, 0]);

        private static var VARIABLES:Vector.<Number> = Vector.<Number>([1, 2]);
        private static var angle:Number = 0;

        private var _constants:Vector.<Number>;
        private var _calcMatrix:Matrix3D;
        private var _thickness:Number;

        public function SegmentPass(thickness:Number){
            this._constants = new Vector.<Number>(4, true);
            this._calcMatrix = new Matrix3D();
            this._thickness = thickness;
            this._constants[1] = (1 / 0xFF);
            super();
        }
        override function getVertexCode(code:String):String{
            code = (((((((((((((((((((((((((((("m44 vt0, va0, vc8\t\t\t\t\n" + "m44 vt1, va1, vc8\t\t\t\t\n") + "sub vt2, vt1, vt0 \t\t\t\t\n") + "slt vt5.x, vt0.z, vc7.z\t\t\n") + "sub vt5.y, vc5.x, vt5.x\t\t\n") + "add vt4.x, vt0.z, vc7.z\t\t\n") + "sub vt4.y, vt0.z, vt1.z\t\t\n") + "div vt4.z, vt4.x, vt4.y\t\t\n") + "mul vt4.xyz, vt4.zzz, vt2.xyz\t\n") + "add vt3.xyz, vt0.xyz, vt4.xyz\t\n") + "mov vt3.w, vc5.x\t\t\t\t\n") + "mul vt0, vt0, vt5.yyyy\t\t\t\n") + "mul vt3, vt3, vt5.xxxx\t\t\t\n") + "add vt0, vt0, vt3\t\t\t\t\n") + "sub vt2, vt1, vt0 \t\t\t\t\n") + "nrm vt2.xyz, vt2.xyz\t\t\t\n") + "nrm vt5.xyz, vt0.xyz\t\t\t\n") + "mov vt5.w, vc5.x\t\t\t\t\n") + "crs vt3.xyz, vt2, vt5\t\t\t\n") + "nrm vt3.xyz, vt3.xyz\t\t\t\n") + "mul vt3.xyz, vt3.xyz, va2.xxx\t\n") + "mov vt3.w, vc5.x\t\t\t\t\n") + "dp3 vt4.x, vt0, vc6\t\t\t\n") + "mul vt4.x, vt4.x, vc7.x\t\t\n") + "mul vt3.xyz, vt3.xyz, vt4.xxx\t\n") + "add vt0.xyz, vt0.xyz, vt3.xyz\t\n") + "m44 vt0, vt0, vc0\t\t\t\t\n") + "mul op, vt0, vc4\t\t\t\t\n") + "mov v0, va3\t\t\t\t\t\n");
            return (code);
        }
        override function getFragmentCode():String{
            return ("mov oc, v0\n");
        }
        override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, lightPicker:LightPickerBase):void{
            var context:Context3D = stage3DProxy._context3D;
            var vertexBuffer:VertexBuffer3D = renderable.getVertexBuffer(stage3DProxy);
            context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            context.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
            context.setVertexBufferAt(2, vertexBuffer, 6, Context3DVertexBufferFormat.FLOAT_1);
            context.setVertexBufferAt(3, vertexBuffer, 7, Context3DVertexBufferFormat.FLOAT_4);
            this._calcMatrix.copyFrom(renderable.sourceEntity.sceneTransform);
            this._calcMatrix.append(camera.inverseSceneTransform);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 8, this._calcMatrix, true);
            context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
        }
        override function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, textureRatioX:Number, textureRatioY:Number):void{
            var context:Context3D = stage3DProxy._context3D;
            super.activate(stage3DProxy, camera, textureRatioX, textureRatioY);
            this._constants[0] = (this._thickness / Math.min(stage3DProxy.width, stage3DProxy.height));
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, ONE_VECTOR);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6, FRONT_VECTOR);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 7, this._constants);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, camera.lens.matrix, true);
        }
        override function deactivate(stage3DProxy:Stage3DProxy):void{
            stage3DProxy.setSimpleVertexBuffer(0, null, null, 0);
            stage3DProxy.setSimpleVertexBuffer(1, null, null, 0);
            stage3DProxy.setSimpleVertexBuffer(2, null, null, 0);
            stage3DProxy.setSimpleVertexBuffer(3, null, null, 0);
        }

    }
}//package away3d.materials.passes 
