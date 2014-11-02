package wd.d3.material {
    import __AS3__.vec.*;
    import flash.geom.*;
    import wd.d3.*;
    import away3d.textures.*;
    import flash.display3D.*;
    import away3d.core.base.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import away3d.materials.lightpickers.*;
    import flash.display3D.textures.*;
    import away3d.materials.passes.*;

    public class BuildingPass2 extends MaterialPassBase {

        private var texture:BitmapTexture;
        private var _calcMatrix:Matrix3D;
        private var textGPU:TextureBase;
        private var mVarsV:Vector.<Number>;
        private var waveVars:Vector.<Number>;
        private var mVarsV2:Vector.<Number>;
        private var mVarsF2:Vector.<Number>;
        private var shockRadius:Number = 0;
        private var shockForce:Number = 100;
        private var startPart:String = "mov vt0, va0 \n";
        private var carpetPart:String;
        private var inceptionPart:String;
        private var distancePart:String;
        private var earthQuakePart:String;
        private var shockwavePart:String;
        private var hidePart:String = "mul vt0.y, vc7.z, vt0.y \n";
        private var endPart:String;
        private var _waveEnabled:Boolean = false;
        private var _programDirty:Boolean = false;
        private var _earthQuakeEnabled:Boolean = false;
        private var _hideEnabled:Boolean = false;
        private var _hideValue:Number = 1;

        public function BuildingPass2(tex:BitmapTexture){
            this.mVarsV = new <Number>[30, 30, 30, 30];
            this.waveVars = new <Number>[30, 30, 30, 30];
            this.mVarsV2 = new <Number>[3, 30, 0, 1];
            this.mVarsF2 = new <Number>[1, 1, 1, 0.8];
            this.carpetPart = ((((((((("sub vt1.x, \tvt0.x, \tvc5.x  \n" + "mul vt1.x, \tvt1.x, \tvt1.x  \n") + "sub vt1.y, \tvt0.z, \tvc5.y  \n") + "mul vt1.y, \tvt1.y, \tvt1.y  \n") + "add vt1.z, \tvt1.x, \tvt1.y  \n") + "sqt vt1.z, \tvt1.z \n") + "slt vt1.w, vc5.z,vt1.z \n") + "sub vt1.x, vt1.z,vc5.z \n") + "mul vt1.x, vt1.w, vt1.x \n") + "add vt0.y, vt0.y, vt1.x \n");
            this.inceptionPart = ((((((((((("sub vt1.x, \tvt0.x, \tvc5.x  \n" + "mul vt1.x, \tvt1.x, \tvt1.x  \n") + "sub vt1.y, \tvt0.z, \tvc5.y  \n") + "mul vt1.y, \tvt1.y, \tvt1.y  \n") + "add vt1.z, \tvt1.x, \tvt1.y  \n") + "sqt vt1.z, \tvt1.z \n") + "sub vt1.x, vt1.z,vc5.z \n") + "slt vt1.w,vc6.z, vt1.x \n") + "div vt1.x, vt1.x ,vc5.w \n") + "mul vt1.x, vt0.y, vt1.x \n") + "mul vt1.x, vt1.x, vt1.w \n") + "add vt0.y, vt1.x,vt0.y \n");
            this.distancePart = ((((("sub vt1.x, \tvt0.x, \tvc7.x  \n" + "mul vt1.x, \tvt1.x, \tvt1.x  \n") + "sub vt1.y, \tvt0.z, \tvc7.y  \n") + "mul vt1.y, \tvt1.y, \tvt1.y  \n") + "add vt1.z, \tvt1.x, \tvt1.y  \n") + "sqt vt1.z, \tvt1.z \n");
            this.earthQuakePart = (((("slt vt1.w,  vt1.z, vc5.z \n" + "div vt1.x, vt1.z, vc5.z \n") + "mul vt1.x, vt1.x, vc5.w \n") + "mul vt1.x, vt1.x, vt1.w \n") + "add vt0.y, vt0.y, vt1.x \n");
            this.shockwavePart = ((((("slt vt1.w,  vt1.z, vc7.z \n" + "div vt1.x, vt1.z, vc7.z \n") + "mul vt1.x, vt1.x, vc7.w \n") + "mul vt1.x, vt1.x, vc6.x \n") + "mul vt1.x, vt1.x, vt1.w \n") + "add vt0.y, vt0.y, vt1.x \n");
            this.endPart = ("m44 op, vt0, vc0\t\n" + "mov v0, va1\t\t\n");
            this.texture = tex;
            this._calcMatrix = new Matrix3D();
            this.textGPU = this.texture.getTextureForStage3D(Simulation.stage3DProxy);
            this.radius = 600;
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
            code = this.startPart;
            if (this._waveEnabled){
                code = (code + this.distancePart);
                code = (code + this.shockwavePart);
            };
            if (this._earthQuakeEnabled){
                code = (code + this.distancePart);
                code = (code + this.earthQuakePart);
            };
            if (this._hideEnabled){
                code = (code + this.hidePart);
            };
            code = (code + this.endPart);
            return (code);
        }
        override function getFragmentCode():String{
            var code:String = (("tex ft0, v0, fs0 <2d,linear, mipnone>  \n" + "mul ft0.w, ft0.w,fc0.w  \n") + "mov oc, ft0  \n");
            return (code);
        }
        override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, lightPicker:LightPickerBase):void{
            var context:Context3D = stage3DProxy._context3D;
            if (this._programDirty){
                updateProgram(stage3DProxy);
                this._programDirty = false;
            };
            context.setCulling(Context3DTriangleFace.NONE);
            context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            context.setVertexBufferAt(0, renderable.getVertexBuffer(stage3DProxy), 0, Context3DVertexBufferFormat.FLOAT_3);
            context.setVertexBufferAt(1, renderable.getUVBuffer(stage3DProxy), 0, Context3DVertexBufferFormat.FLOAT_2);
            this._calcMatrix.copyFrom(renderable.sceneTransform);
            this._calcMatrix.append(camera.viewProjection);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, this._calcMatrix, true);
            this.mVarsV[0] = Simulation.instance.cameraTargetPos.x;
            this.mVarsV[1] = Simulation.instance.cameraTargetPos.z;
            this.radius = (Simulation.instance.cameraTargetPos.y + 400);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, this.mVarsV);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 6, this.mVarsV2);
            if (this._earthQuakeEnabled){
                this.waveVars[2] = ((this.shockRadius++ % 50) + 1);
                this.waveVars[3] = ((1 - ((this.shockForce++ % 100) / 100)) + 1);
                context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 7, this.waveVars);
            };
            if (this._waveEnabled){
                this.shockRadius = (this.shockRadius + 0.3);
                this.waveVars[2] = ((this.shockRadius + 1) * 2);
                this.shockForce = (this.shockForce + 0.3);
                if (this.shockForce > 100){
                    this.shockForce = 100;
                    this._waveEnabled = false;
                    this._programDirty = true;
                };
                this.waveVars[3] = (1 - (this.shockForce / 100));
                context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 7, this.waveVars);
            };
            if (this._hideEnabled){
                this._hideValue = (this._hideValue - 0.002);
                if (this._hideValue < 0){
                    this._hideValue = 0;
                };
                this.waveVars[2] = this._hideValue;
                context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 7, this.waveVars);
            };
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this.mVarsF2);
            context.setTextureAt(0, this.textGPU);
            context.drawTriangles(renderable.getIndexBuffer(stage3DProxy), 0, renderable.numTriangles);
        }
        public function doHide():void{
            this._hideValue = 1;
            this._hideEnabled = true;
            this._programDirty = true;
        }
        public function doWave(_x:Number, _y:Number):void{
            this.shockRadius = 0;
            this.shockForce = 0;
            this.waveVars[0] = _x;
            this.waveVars[1] = _y;
            this._waveEnabled = true;
            this._programDirty = true;
        }
        public function doEarthQuake(_x:Number, _y:Number):void{
            this.shockRadius = 0;
            this.shockForce = 0;
            this.waveVars[0] = _x;
            this.waveVars[1] = _y;
            this._earthQuakeEnabled = true;
            this._programDirty = true;
        }
        public function stopEarthQuake():void{
            this._earthQuakeEnabled = false;
            this._programDirty = true;
        }
        override function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, textureRatioX:Number, textureRatioY:Number):void{
            var context:Context3D = stage3DProxy._context3D;
            super.activate(stage3DProxy, camera, textureRatioX, textureRatioY);
        }
        override function deactivate(stage3DProxy:Stage3DProxy):void{
            stage3DProxy.setSimpleVertexBuffer(0, null, null, 0);
            stage3DProxy.setSimpleVertexBuffer(1, null, null, 0);
            stage3DProxy.setTextureAt(0, null);
        }

    }
}//package wd.d3.material 
