package away3d.filters.tasks {
    import __AS3__.vec.*;
    import flash.display3D.textures.*;
    import flash.display3D.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;

    public class Filter3DCompositeTask extends Filter3DTaskBase {

        private var _data:Vector.<Number>;
        private var _overlayTexture:TextureBase;
        private var _blendMode:String;

        public function Filter3DCompositeTask(blendMode:String, exposure:Number=1){
            super();
            this._data = Vector.<Number>([exposure, 0, 0, 0]);
            this._blendMode = blendMode;
        }
        public function get overlayTexture():TextureBase{
            return (this._overlayTexture);
        }
        public function set overlayTexture(value:TextureBase):void{
            this._overlayTexture = value;
        }
        public function get exposure():Number{
            return (this._data[0]);
        }
        public function set exposure(value:Number):void{
            this._data[0] = value;
        }
        override protected function getFragmentCode():String{
            var code:String;
            var op:String;
            code = (("tex ft0, v0, fs0 <2d,linear,clamp>\t\n" + "tex ft1, v0, fs1 <2d,linear,clamp>\t\n") + "mul ft0, ft0, fc0.x\t\t\t\t\n");
            switch (this._blendMode){
                case "multiply":
                    op = "mul";
                    break;
                case "add":
                    op = "add";
                    break;
                case "subtract":
                    op = "sub";
                    break;
                case "normal":
                    op = "mov";
                    break;
                default:
                    throw (new Error("Unknown blend mode"));
            };
            if (op != "mov"){
                code = (code + (op + " oc, ft0, ft1\t\t\t\t\t\n"));
            } else {
                code = (code + "mov oc, ft0\t\t\t\t\t\t\n");
            };
            return (code);
        }
        override public function activate(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):void{
            stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._data, 1);
            stage3DProxy.setTextureAt(1, this._overlayTexture);
        }
        override public function deactivate(stage3DProxy:Stage3DProxy):void{
            stage3DProxy.setTextureAt(1, null);
        }

    }
}//package away3d.filters.tasks 
