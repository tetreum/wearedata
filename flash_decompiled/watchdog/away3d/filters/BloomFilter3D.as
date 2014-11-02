package away3d.filters {
    import away3d.filters.tasks.*;
    import flash.display.*;
    import flash.display3D.textures.*;
    import away3d.core.managers.*;

    public class BloomFilter3D extends Filter3DBase {

        private var _brightPassTask:Filter3DBrightPassTask;
        private var _vBlurTask:Filter3DVBlurTask;
        private var _hBlurTask:Filter3DHBlurTask;
        private var _compositeTask:Filter3DCompositeTask;

        public function BloomFilter3D(blurX:uint=15, blurY:uint=15, threshold:Number=0.75, exposure:Number=3, quality:int=3){
            super();
            this._brightPassTask = new Filter3DBrightPassTask(threshold);
            this._hBlurTask = new Filter3DHBlurTask(blurX);
            this._vBlurTask = new Filter3DVBlurTask(blurY);
            this._compositeTask = new Filter3DCompositeTask(BlendMode.ADD, exposure);
            if (quality > 4){
                quality = 4;
            } else {
                if (quality < 0){
                    quality = 0;
                };
            };
            this._hBlurTask.textureScale = (4 - quality);
            this._vBlurTask.textureScale = (4 - quality);
            addTask(this._brightPassTask);
            addTask(this._hBlurTask);
            addTask(this._vBlurTask);
            addTask(this._compositeTask);
        }
        override public function setRenderTargets(mainTarget:Texture, stage3DProxy:Stage3DProxy):void{
            this._brightPassTask.target = this._hBlurTask.getMainInputTexture(stage3DProxy);
            this._hBlurTask.target = this._vBlurTask.getMainInputTexture(stage3DProxy);
            this._vBlurTask.target = this._compositeTask.getMainInputTexture(stage3DProxy);
            this._compositeTask.overlayTexture = this._brightPassTask.getMainInputTexture(stage3DProxy);
            super.setRenderTargets(mainTarget, stage3DProxy);
        }
        public function get exposure():Number{
            return (this._compositeTask.exposure);
        }
        public function set exposure(value:Number):void{
            this._compositeTask.exposure = value;
        }
        public function get blurX():uint{
            return (this._hBlurTask.amount);
        }
        public function set blurX(value:uint):void{
            this._hBlurTask.amount = value;
        }
        public function get blurY():uint{
            return (this._vBlurTask.amount);
        }
        public function set blurY(value:uint):void{
            this._vBlurTask.amount = value;
        }
        public function get threshold():Number{
            return (this._brightPassTask.threshold);
        }
        public function set threshold(value:Number):void{
            this._brightPassTask.threshold = value;
        }

    }
}//package away3d.filters 
