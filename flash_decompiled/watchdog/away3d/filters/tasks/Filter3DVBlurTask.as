package away3d.filters.tasks {
    import __AS3__.vec.*;
    import flash.display3D.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import flash.display3D.textures.*;

    public class Filter3DVBlurTask extends Filter3DTaskBase {

        private static var MAX_AUTO_SAMPLES:int = 15;

        private var _amount:uint;
        private var _data:Vector.<Number>;
        private var _stepSize:int = 1;
        private var _realStepSize:Number;

        public function Filter3DVBlurTask(amount:uint, stepSize:int=-1){
            super();
            this._amount = amount;
            this._data = Vector.<Number>([0, 0, 0, 1]);
            this.stepSize = stepSize;
        }
        public function get amount():uint{
            return (this._amount);
        }
        public function set amount(value:uint):void{
            if (value == this._amount){
                return;
            };
            this._amount = value;
            invalidateProgram3D();
            this.updateBlurData();
        }
        public function get stepSize():int{
            return (this._stepSize);
        }
        public function set stepSize(value:int):void{
            if (value == this._stepSize){
                return;
            };
            this._stepSize = value;
            this.calculateStepSize();
            invalidateProgram3D();
            this.updateBlurData();
        }
        override protected function getFragmentCode():String{
            var code:String;
            var numSamples:int = 1;
            code = ("mov ft0, v0\t\n" + "sub ft0.y, v0.y, fc0.x\n");
            code = (code + "tex ft1, ft0, fs0 <2d,nearest,clamp>\n");
            var x:Number = this._realStepSize;
            while (x <= this._amount) {
                code = (code + "add ft0.y, ft0.y, fc0.y\t\n");
                code = (code + ("tex ft2, ft0, fs0 <2d,nearest,clamp>\n" + "add ft1, ft1, ft2 \n"));
                numSamples++;
                x = (x + this._realStepSize);
            };
            code = (code + "mul oc, ft1, fc0.z");
            this._data[2] = (1 / numSamples);
            return (code);
        }
        override public function activate(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):void{
            stage3DProxy.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._data, 1);
        }
        override protected function updateTextures(stage:Stage3DProxy):void{
            super.updateTextures(stage);
            this.updateBlurData();
        }
        private function updateBlurData():void{
            var invH:Number = (1 / _textureHeight);
            this._data[0] = ((this._amount * 0.5) * invH);
            this._data[1] = (this._realStepSize * invH);
        }
        private function calculateStepSize():void{
            this._realStepSize = (((this._stepSize > 0)) ? this._stepSize : (((this._amount > MAX_AUTO_SAMPLES)) ? (this._amount / MAX_AUTO_SAMPLES) : 1));
        }

    }
}//package away3d.filters.tasks 
