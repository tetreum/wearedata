package away3d.materials.passes {
    import __AS3__.vec.*;
    import away3d.textures.*;
    import flash.display3D.*;
    import away3d.core.base.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import away3d.materials.lightpickers.*;

    public class DepthMapPass extends MaterialPassBase {

        private var _data:Vector.<Number>;
        private var _alphaThreshold:Number = 0;
        private var _alphaMask:Texture2DBase;

        public function DepthMapPass(){
            super();
            this._data = Vector.<Number>([1, 0xFF, 65025, 16581375, (1 / 0xFF), (1 / 0xFF), (1 / 0xFF), 0, 0, 0, 0, 0]);
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
            this._data[8] = this._alphaThreshold;
        }
        public function get alphaMask():Texture2DBase{
            return (this._alphaMask);
        }
        public function set alphaMask(value:Texture2DBase):void{
            this._alphaMask = value;
        }
        override function getVertexCode(code:String):String{
            code = (code + ("m44 vt1, vt0, vc0\t\t\n" + "mul op, vt1, vc4\n"));
            if (this._alphaThreshold > 0){
                _numUsedTextures = 1;
                _numUsedStreams = 2;
                code = (code + ("mov v0, vt1\n" + "mov v1, va1\n"));
            } else {
                _numUsedTextures = 0;
                _numUsedStreams = 1;
                code = (code + "mov v0, vt1\n");
            };
            return (code);
        }
        override function getFragmentCode():String{
            var filter:String;
            var wrap:String = ((_repeat) ? "wrap" : "clamp");
            if (_smooth){
                filter = ((_mipmap) ? "linear,miplinear" : "linear");
            } else {
                filter = ((_mipmap) ? "nearest,mipnearest" : "nearest");
            };
            var code:String = ((("div ft2, v0, v0.w\t\t\n" + "mul ft0, fc0, ft2.z\t\n") + "frc ft0, ft0\t\t\t\n") + "mul ft1, ft0.yzww, fc1\t\n");
            if (this._alphaThreshold > 0){
                code = (code + (((((("tex ft3, v1, fs0 <2d," + filter) + ",") + wrap) + ">\n") + "sub ft3.w, ft3.w, fc2.x\n") + "kil ft3.w\n"));
            };
            code = (code + "sub oc, ft0, ft1\t\t\n");
            return (code);
        }
        override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, lightPicker:LightPickerBase):void{
            if (this._alphaThreshold > 0){
                stage3DProxy.setSimpleVertexBuffer(1, renderable.getUVBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_2, renderable.UVBufferOffset);
            };
            super.render(renderable, stage3DProxy, camera, lightPicker);
        }
        override function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, textureRatioX:Number, textureRatioY:Number):void{
            super.activate(stage3DProxy, camera, textureRatioX, textureRatioY);
            if (this._alphaThreshold > 0){
                stage3DProxy.setTextureAt(0, this._alphaMask.getTextureForStage3D(stage3DProxy));
                stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._data, 3);
            } else {
                stage3DProxy._context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._data, 2);
            };
        }

    }
}//package away3d.materials.passes 
