package away3d.materials.passes {
    import __AS3__.vec.*;
    import away3d.textures.*;
    import flash.geom.*;
    import flash.display3D.*;
    import away3d.core.base.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import away3d.materials.lightpickers.*;

    public class DistanceMapPass extends MaterialPassBase {

        private var _fragmentData:Vector.<Number>;
        private var _vertexData:Vector.<Number>;
        private var _alphaThreshold:Number;
        private var _alphaMask:Texture2DBase;

        public function DistanceMapPass(){
            super();
            this._fragmentData = Vector.<Number>([1, 0xFF, 65025, 16581375, (1 / 0xFF), (1 / 0xFF), (1 / 0xFF), 0, 0, 0, 0, 0]);
            this._vertexData = new Vector.<Number>(4, true);
            this._vertexData[3] = 1;
            _numUsedVertexConstants = 9;
        }
        public function get alphaThreshold():Number{
            return (this._alphaThreshold);
        }
        public function set alphaThreshold(value:Number):void{
            if (value < 0){
                value = 0;
            } else {
                if (value > 1){
                    value = 1;
                };
            };
            if (value == this._alphaThreshold){
                return;
            };
            if ((((value == 0)) || ((this._alphaThreshold == 0)))){
                invalidateShaderProgram();
            };
            this._alphaThreshold = value;
            this._fragmentData[8] = this._alphaThreshold;
        }
        public function get alphaMask():Texture2DBase{
            return (this._alphaMask);
        }
        public function set alphaMask(value:Texture2DBase):void{
            this._alphaMask = value;
        }
        override function getVertexCode(code:String):String{
            code = (code + ((("m44 vt7, vt0, vc0\t\t\n" + "mul op, vt7, vc4\t\t\n") + "m44 vt1, vt0, vc5\t\t\n") + "sub v0, vt1, vc9\t\t\n"));
            if (this._alphaThreshold > 0){
                code = (code + "mov v1, va1\n");
                _numUsedTextures = 1;
                _numUsedStreams = 2;
            } else {
                _numUsedTextures = 0;
                _numUsedStreams = 1;
            };
            return (code);
        }
        override function getFragmentCode():String{
            var code:String;
            var filter:String;
            var wrap:String = ((_repeat) ? "wrap" : "clamp");
            if (_smooth){
                filter = ((_mipmap) ? "linear,miplinear" : "linear");
            } else {
                filter = ((_mipmap) ? "nearest,mipnearest" : "nearest");
            };
            code = ((("dp3 ft2.z, v0.xyz, v0.xyz\t\n" + "mul ft0, fc0, ft2.z\t\n") + "frc ft0, ft0\t\t\t\n") + "mul ft1, ft0.yzww, fc1\t\n");
            if (this._alphaThreshold > 0){
                code = (code + (((((("tex ft3, v1, fs0 <2d," + filter) + ",") + wrap) + ">\n") + "sub ft3.w, ft3.w, fc2.x\n") + "kil ft3.w\n"));
            };
            code = (code + "sub oc, ft0, ft1\t\t\n");
            return (code);
        }
        override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, lightPicker:LightPickerBase):void{
            var pos:Vector3D = camera.scenePosition;
            this._vertexData[0] = pos.x;
            this._vertexData[1] = pos.y;
            this._vertexData[2] = pos.z;
            this._vertexData[3] = 1;
            stage3DProxy._context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 5, renderable.sceneTransform, true);
            stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 9, this._vertexData, 1);
            if (this._alphaThreshold > 0){
                stage3DProxy.setSimpleVertexBuffer(1, renderable.getUVBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_2, renderable.UVBufferOffset);
            };
            super.render(renderable, stage3DProxy, camera, lightPicker);
        }
        override function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, textureRatioX:Number, textureRatioY:Number):void{
            super.activate(stage3DProxy, camera, textureRatioX, textureRatioY);
            var f:Number = camera.lens.far;
            f = (1 / ((2 * f) * f));
            this._fragmentData[0] = (1 * f);
            this._fragmentData[1] = (0xFF * f);
            this._fragmentData[2] = (65025 * f);
            this._fragmentData[3] = (16581375 * f);
            if (this._alphaThreshold > 0){
                stage3DProxy.setTextureAt(0, this._alphaMask.getTextureForStage3D(stage3DProxy));
                stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._fragmentData, 3);
            } else {
                stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._fragmentData, 2);
            };
        }

    }
}//package away3d.materials.passes 
