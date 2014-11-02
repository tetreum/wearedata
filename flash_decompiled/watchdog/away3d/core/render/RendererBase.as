package away3d.core.render {
    import away3d.core.sort.*;
    import away3d.core.traverse.*;
    import away3d.core.managers.*;
    import away3d.events.*;
    import flash.display3D.textures.*;
    import flash.geom.*;
    import flash.display3D.*;
    import flash.display.*;
    import away3d.errors.*;
    import flash.events.*;
    import away3d.textures.*;

    public class RendererBase {

        protected var _context:Context3D;
        protected var _stage3DProxy:Stage3DProxy;
        protected var _backgroundR:Number = 0;
        protected var _backgroundG:Number = 0;
        protected var _backgroundB:Number = 0;
        protected var _backgroundAlpha:Number = 1;
        protected var _shareContext:Boolean = false;
        protected var _swapBackBuffer:Boolean = true;
        protected var _renderTarget:TextureBase;
        protected var _renderTargetSurface:int;
        protected var _viewWidth:Number;
        protected var _viewHeight:Number;
        private var _renderableSorter:EntitySorterBase;
        private var _backgroundImageRenderer:BackgroundImageRenderer;
        private var _background:Texture2DBase;
        protected var _renderToTexture:Boolean;
        protected var _antiAlias:uint;
        protected var _textureRatioX:Number = 1;
        protected var _textureRatioY:Number = 1;
        private var _snapshotBitmapData:BitmapData;
        private var _snapshotRequired:Boolean;

        public function RendererBase(renderToTexture:Boolean=false){
            super();
            this._renderableSorter = new RenderableMergeSort();
            this._renderToTexture = renderToTexture;
        }
        function createEntityCollector():EntityCollector{
            return (new EntityCollector());
        }
        function get viewWidth():Number{
            return (this._viewWidth);
        }
        function set viewWidth(value:Number):void{
            this._viewWidth = value;
        }
        function get viewHeight():Number{
            return (this._viewHeight);
        }
        function set viewHeight(value:Number):void{
            this._viewHeight = value;
        }
        function get renderToTexture():Boolean{
            return (this._renderToTexture);
        }
        public function get renderableSorter():EntitySorterBase{
            return (this._renderableSorter);
        }
        public function set renderableSorter(value:EntitySorterBase):void{
            this._renderableSorter = value;
        }
        public function get swapBackBuffer():Boolean{
            return (this._swapBackBuffer);
        }
        public function set swapBackBuffer(value:Boolean):void{
            this._swapBackBuffer = value;
        }
        function get backgroundR():Number{
            return (this._backgroundR);
        }
        function set backgroundR(value:Number):void{
            this._backgroundR = value;
        }
        function get backgroundG():Number{
            return (this._backgroundG);
        }
        function set backgroundG(value:Number):void{
            this._backgroundG = value;
        }
        function get backgroundB():Number{
            return (this._backgroundB);
        }
        function set backgroundB(value:Number):void{
            this._backgroundB = value;
        }
        function get stage3DProxy():Stage3DProxy{
            return (this._stage3DProxy);
        }
        function set stage3DProxy(value:Stage3DProxy):void{
            if (value == this._stage3DProxy){
                return;
            };
            if (!(value)){
                if (this._stage3DProxy){
                    this._stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED, this.onContextUpdate);
                };
                this._stage3DProxy = null;
                this._context = null;
                return;
            };
            this._stage3DProxy = value;
            if (this._backgroundImageRenderer){
                this._backgroundImageRenderer.stage3DProxy = value;
            };
            if (value.context3D){
                this._context = value.context3D;
            } else {
                value.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, this.onContextUpdate);
            };
        }
        function get shareContext():Boolean{
            return (this._shareContext);
        }
        function set shareContext(value:Boolean):void{
            this._shareContext = value;
        }
        function dispose():void{
            this.stage3DProxy = null;
            if (this._backgroundImageRenderer){
                this._backgroundImageRenderer.dispose();
                this._backgroundImageRenderer = null;
            };
        }
        function render(entityCollector:EntityCollector, target:TextureBase=null, scissorRect:Rectangle=null, surfaceSelector:int=0):void{
            if (((!(this._stage3DProxy)) || (!(this._context)))){
                return;
            };
            this.executeRender(entityCollector, target, scissorRect, surfaceSelector);
            var i:uint;
            while (i < 8) {
                this._stage3DProxy.setSimpleVertexBuffer(i, null, null, 0);
                this._stage3DProxy.setTextureAt(i, null);
                i++;
            };
        }
        protected function executeRender(entityCollector:EntityCollector, target:TextureBase=null, scissorRect:Rectangle=null, surfaceSelector:int=0):void{
            this._renderTarget = target;
            this._renderTargetSurface = surfaceSelector;
            if (this._renderableSorter){
                this._renderableSorter.sort(entityCollector);
            };
            if (this._renderToTexture){
                this.executeRenderToTexturePass(entityCollector);
            };
            this._stage3DProxy.setRenderTarget(target, true, surfaceSelector);
            if (!(this._shareContext)){
                this._context.clear(this._backgroundR, this._backgroundG, this._backgroundB, this._backgroundAlpha, 1, 0);
            };
            this._context.setDepthTest(false, Context3DCompareMode.ALWAYS);
            this._stage3DProxy.scissorRect = scissorRect;
            if (this._backgroundImageRenderer){
                this._backgroundImageRenderer.render();
            };
            this.draw(entityCollector, target);
            if (!(this._shareContext)){
                if (((this._snapshotRequired) && (this._snapshotBitmapData))){
                    this._context.drawToBitmapData(this._snapshotBitmapData);
                    this._snapshotRequired = false;
                };
                if (((this._swapBackBuffer) && (!(target)))){
                    this._context.present();
                };
            };
            this._stage3DProxy.scissorRect = null;
        }
        public function queueSnapshot(bmd:BitmapData):void{
            this._snapshotRequired = true;
            this._snapshotBitmapData = bmd;
        }
        protected function executeRenderToTexturePass(entityCollector:EntityCollector):void{
            throw (new AbstractMethodError());
        }
        protected function draw(entityCollector:EntityCollector, target:TextureBase):void{
            throw (new AbstractMethodError());
        }
        private function onContextUpdate(event:Event):void{
            this._context = this._stage3DProxy.context3D;
        }
        function get backgroundAlpha():Number{
            return (this._backgroundAlpha);
        }
        function set backgroundAlpha(value:Number):void{
            this._backgroundAlpha = value;
        }
        function get background():Texture2DBase{
            return (this._background);
        }
        function set background(value:Texture2DBase):void{
            if (((this._backgroundImageRenderer) && (!(value)))){
                this._backgroundImageRenderer.dispose();
                this._backgroundImageRenderer = null;
            };
            if (((!(this._backgroundImageRenderer)) && (value))){
                this._backgroundImageRenderer = new BackgroundImageRenderer(this._stage3DProxy);
            };
            this._background = value;
            if (this._backgroundImageRenderer){
                this._backgroundImageRenderer.texture = value;
            };
        }
        public function get backgroundImageRenderer():BackgroundImageRenderer{
            return (this._backgroundImageRenderer);
        }
        public function get antiAlias():uint{
            return (this._antiAlias);
        }
        public function set antiAlias(antiAlias:uint):void{
            this._antiAlias = antiAlias;
        }
        function get textureRatioX():Number{
            return (this._textureRatioX);
        }
        function set textureRatioX(value:Number):void{
            this._textureRatioX = value;
        }
        function get textureRatioY():Number{
            return (this._textureRatioY);
        }
        function set textureRatioY(value:Number):void{
            this._textureRatioY = value;
        }

    }
}//package away3d.core.render 
