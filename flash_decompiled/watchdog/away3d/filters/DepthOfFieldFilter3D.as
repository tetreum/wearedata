package away3d.filters {
    import away3d.filters.tasks.*;
    import away3d.containers.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import flash.geom.*;
    import flash.display3D.textures.*;

    public class DepthOfFieldFilter3D extends Filter3DBase {

        private var _focusTarget:ObjectContainer3D;
        private var _hDofTask:Filter3DHDepthOfFFieldTask;
        private var _vDofTask:Filter3DVDepthOfFFieldTask;

        public function DepthOfFieldFilter3D(maxBlurX:uint=3, maxBlurY:uint=3, stepSize:int=-1){
            super();
            this._hDofTask = new Filter3DHDepthOfFFieldTask(maxBlurX, stepSize);
            this._vDofTask = new Filter3DVDepthOfFFieldTask(maxBlurY, stepSize);
            addTask(this._hDofTask);
            addTask(this._vDofTask);
        }
        public function get stepSize():int{
            return (this._hDofTask.stepSize);
        }
        public function set stepSize(value:int):void{
            this._vDofTask.stepSize = (this._hDofTask.stepSize = value);
        }
        public function get focusTarget():ObjectContainer3D{
            return (this._focusTarget);
        }
        public function set focusTarget(value:ObjectContainer3D):void{
            this._focusTarget = value;
        }
        public function get focusDistance():Number{
            return (this._hDofTask.focusDistance);
        }
        public function set focusDistance(value:Number):void{
            this._hDofTask.focusDistance = (this._vDofTask.focusDistance = value);
        }
        public function get range():Number{
            return (this._hDofTask.range);
        }
        public function set range(value:Number):void{
            this._vDofTask.range = (this._hDofTask.range = value);
        }
        public function get maxBlurX():uint{
            return (this._hDofTask.maxBlur);
        }
        public function set maxBlurX(value:uint):void{
            this._hDofTask.maxBlur = value;
        }
        public function get maxBlurY():uint{
            return (this._vDofTask.maxBlur);
        }
        public function set maxBlurY(value:uint):void{
            this._vDofTask.maxBlur = value;
        }
        override public function update(stage:Stage3DProxy, camera:Camera3D):void{
            if (this._focusTarget){
                this.updateFocus(camera);
            };
        }
        private function updateFocus(camera:Camera3D):void{
            var target:Vector3D = camera.inverseSceneTransform.transformVector(this._focusTarget.scenePosition);
            this._hDofTask.focusDistance = (this._vDofTask.focusDistance = target.z);
        }
        override public function setRenderTargets(mainTarget:Texture, stage3DProxy:Stage3DProxy):void{
            this._hDofTask.target = this._vDofTask.getMainInputTexture(stage3DProxy);
        }

    }
}//package away3d.filters 
