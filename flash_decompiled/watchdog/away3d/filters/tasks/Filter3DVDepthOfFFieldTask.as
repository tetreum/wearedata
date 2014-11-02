package away3d.filters.tasks {
    import __AS3__.vec.*;
    import flash.display3D.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import flash.display3D.textures.*;

    public class Filter3DVDepthOfFFieldTask extends Filter3DTaskBase {

        private static var MAX_AUTO_SAMPLES:int = 10;

        private var _maxBlur:uint;
        private var _data:Vector.<Number>;
        private var _focusDistance:Number;
        private var _range:Number = 1000;
        private var _stepSize:int;
        private var _realStepSize:Number;

        public function Filter3DVDepthOfFFieldTask(maxBlur:uint, stepSize:int=-1){
            super(true);
            this._maxBlur = maxBlur;
            this._data = Vector.<Number>([0, 0, 0, this._focusDistance, 0, 0, 0, 0, this._range, 0, 0, 0, 1, (1 / 0xFF), (1 / 65025), (1 / 16581375)]);
            this.stepSize = stepSize;
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
        public function get range():Number{
            return (this._range);
        }
        public function set range(value:Number):void{
            this._range = value;
            this._data[8] = value;
        }
        public function get focusDistance():Number{
            return (this._focusDistance);
        }
        public function set focusDistance(value:Number):void{
            this._data[3] = (this._focusDistance = value);
        }
        public function get maxBlur():uint{
            return (this._maxBlur);
        }
        public function set maxBlur(value:uint):void{
            if (this._maxBlur == value){
                return;
            };
            this._maxBlur = value;
            invalidateProgram3D();
            this.updateBlurData();
            this.calculateStepSize();
        }
        override protected function getFragmentCode():String{
            var code:String;
            var numSamples:uint = 1;
            code = (((((((("tex ft0, v0, fs1 <2d, nearest>\t\n" + "dp4 ft1.z, ft0, fc3\t\t\t\t\n") + "sub ft1.z, ft1.z, fc1.z\t\t\t\n") + "div ft1.z, fc1.w, ft1.z\t\t\t\n") + "sub ft1.z, ft1.z, fc0.w\t\t\t\n") + "div ft1.z, ft1.z, fc2.x\t\t\t\n") + "abs ft1.z, ft1.z\t\t\t\t\t\n") + "sat ft1.z, ft1.z\t\t\t\t\t\n") + "mul ft6.xy, ft1.z, fc0.xy\t\t\t\n");
            code = (code + (("mov ft0, v0\t\n" + "sub ft0.y, ft0.y, ft6.x\n") + "tex ft1, ft0, fs0 <2d,linear,clamp>\n"));
            var y:Number = this._realStepSize;
            while (y <= this._maxBlur) {
                code = (code + (("add ft0.y, ft0.y, ft6.y\t\n" + "tex ft2, ft0, fs0 <2d,linear,clamp>\n") + "add ft1, ft1, ft2 \n"));
                numSamples++;
                y = (y + this._realStepSize);
            };
            code = (code + "mul oc, ft1, fc0.z");
            this._data[2] = (1 / numSamples);
            return (code);
        }
        override public function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, depthTexture:Texture):void{
            var context:Context3D = stage3DProxy._context3D;
            var n:Number = camera.lens.near;
            var f:Number = camera.lens.far;
            this._data[6] = (f / (f - n));
            this._data[7] = (-(n) * this._data[6]);
            stage3DProxy.setTextureAt(1, depthTexture);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._data, 4);
        }
        override public function deactivate(stage3DProxy:Stage3DProxy):void{
            stage3DProxy.setTextureAt(1, null);
        }
        override protected function updateTextures(stage:Stage3DProxy):void{
            super.updateTextures(stage);
            this.updateBlurData();
        }
        private function updateBlurData():void{
            var invH:Number = (1 / _textureHeight);
            this._data[0] = ((this._maxBlur * 0.5) * invH);
            this._data[1] = (this._realStepSize * invH);
        }
        private function calculateStepSize():void{
            this._realStepSize = (((this._stepSize > 0)) ? this._stepSize : (((this._maxBlur > MAX_AUTO_SAMPLES)) ? (this._maxBlur / MAX_AUTO_SAMPLES) : 1));
        }

    }
}//package away3d.filters.tasks 
