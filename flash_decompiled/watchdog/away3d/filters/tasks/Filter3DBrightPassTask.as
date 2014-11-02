package away3d.filters.tasks {
    import __AS3__.vec.*;
    import away3d.cameras.*;
    import flash.display3D.textures.*;
    import flash.display3D.*;
    import away3d.core.managers.*;

    public class Filter3DBrightPassTask extends Filter3DTaskBase {

        private var _brightPassData:Vector.<Number>;
        private var _threshold:Number;

        public function Filter3DBrightPassTask(threshold:Number=0.75){
            super();
            this._threshold = threshold;
            this._brightPassData = Vector.<Number>([threshold, (1 / (1 - threshold)), 0, 0]);
        }
        public function get threshold():Number{
            return (this._threshold);
        }
        public function set threshold(value:Number):void{
            this._threshold = value;
            this._brightPassData[0] = value;
            this._brightPassData[1] = (1 / (1 - value));
        }
        override protected function getFragmentCode():String{
            return (((((((("tex ft0, v0, fs0 <2d,linear,clamp>\t\n" + "dp3 ft1.x, ft0.xyz, ft0.xyz\t\n") + "sqt ft1.x, ft1.x\t\t\t\t\n") + "sub ft1.y, ft1.x, fc0.x\t\t\n") + "mul ft1.y, ft1.y, fc0.y\t\t\n") + "sat ft1.y, ft1.y\t\t\t\t\n") + "mul ft0.xyz, ft0.xyz, ft1.y\t\n") + "mov oc, ft0\t\t\t\t\t\n"));
        }
        override public function activate(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):void{
            stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._brightPassData, 1);
        }

    }
}//package away3d.filters.tasks 
