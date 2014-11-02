package away3d.core.managers {
    import flash.display.*;
    import flash.events.*;
    import __AS3__.vec.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import flash.geom.*;
    import away3d.events.*;
    import away3d.debug.*;

    public class Stage3DProxy extends EventDispatcher {

        private static var _frameEventDriver:Shape = new Shape();

        var _context3D:Context3D;
        var _stage3DIndex:int = -1;
        private var _usesSoftwareRendering:Boolean;
        private var _stage3D:Stage3D;
        private var _activeProgram3D:Program3D;
        private var _stage3DManager:Stage3DManager;
        private var _backBufferWidth:int;
        private var _backBufferHeight:int;
        private var _antiAlias:int;
        private var _enableDepthAndStencil:Boolean;
        private var _contextRequested:Boolean;
        private var _activeVertexBuffers:Vector.<VertexBuffer3D>;
        private var _activeTextures:Vector.<TextureBase>;
        private var _renderTarget:TextureBase;
        private var _renderSurfaceSelector:int;
        private var _scissorRect:Rectangle;
        private var _color:uint;
        private var _backBufferDirty:Boolean;
        private var _viewPort:Rectangle;
        private var _enterFrame:Event;
        private var _exitFrame:Event;

        public function Stage3DProxy(stage3DIndex:int, stage3D:Stage3D, stage3DManager:Stage3DManager, forceSoftware:Boolean=false){
            this._activeVertexBuffers = new Vector.<VertexBuffer3D>(8, true);
            this._activeTextures = new Vector.<TextureBase>(8, true);
            super();
            this._stage3DIndex = stage3DIndex;
            this._stage3D = stage3D;
            this._stage3D.x = 0;
            this._stage3D.y = 0;
            this._stage3D.visible = true;
            this._stage3DManager = stage3DManager;
            this._viewPort = new Rectangle();
            this._enableDepthAndStencil = true;
            this._stage3D.addEventListener(Event.CONTEXT3D_CREATE, this.onContext3DUpdate, false, 1000, false);
            this.requestContext(forceSoftware);
        }
        private function notifyEnterFrame():void{
            if (!(hasEventListener(Event.ENTER_FRAME))){
                return;
            };
            if (!(this._enterFrame)){
                this._enterFrame = new Event(Event.ENTER_FRAME);
            };
            dispatchEvent(this._enterFrame);
        }
        private function notifyExitFrame():void{
            if (!(hasEventListener(Event.EXIT_FRAME))){
                return;
            };
            if (!(this._exitFrame)){
                this._exitFrame = new Event(Event.EXIT_FRAME);
            };
            dispatchEvent(this._exitFrame);
        }
        public function setSimpleVertexBuffer(index:int, buffer:VertexBuffer3D, format:String, offset:int=0):void{
            if (((buffer) && ((this._activeVertexBuffers[index] == buffer)))){
                return;
            };
            this._context3D.setVertexBufferAt(index, buffer, offset, format);
            this._activeVertexBuffers[index] = buffer;
        }
        public function setTextureAt(index:int, texture:TextureBase):void{
            if (((!((texture == null))) && ((this._activeTextures[index] == texture)))){
                return;
            };
            this._context3D.setTextureAt(index, texture);
            this._activeTextures[index] = texture;
        }
        public function setProgram(program3D:Program3D):void{
            if (this._activeProgram3D == program3D){
                return;
            };
            this._context3D.setProgram(program3D);
            this._activeProgram3D = program3D;
        }
        public function dispose():void{
            this._stage3DManager.removeStage3DProxy(this);
            this._stage3D.removeEventListener(Event.CONTEXT3D_CREATE, this.onContext3DUpdate);
            this.freeContext3D();
            this._stage3D = null;
            this._stage3DManager = null;
            this._stage3DIndex = -1;
        }
        public function configureBackBuffer(backBufferWidth:int, backBufferHeight:int, antiAlias:int, enableDepthAndStencil:Boolean):void{
            this._backBufferWidth = backBufferWidth;
            this._backBufferHeight = backBufferHeight;
            this._antiAlias = antiAlias;
            this._enableDepthAndStencil = enableDepthAndStencil;
            if (this._context3D){
                this._context3D.configureBackBuffer(backBufferWidth, backBufferHeight, antiAlias, enableDepthAndStencil);
            };
        }
        public function get enableDepthAndStencil():Boolean{
            return (this._enableDepthAndStencil);
        }
        public function set enableDepthAndStencil(enableDepthAndStencil:Boolean):void{
            this._enableDepthAndStencil = enableDepthAndStencil;
            this._backBufferDirty = true;
        }
        public function get renderTarget():TextureBase{
            return (this._renderTarget);
        }
        public function get renderSurfaceSelector():int{
            return (this._renderSurfaceSelector);
        }
        public function setRenderTarget(target:TextureBase, enableDepthAndStencil:Boolean=false, surfaceSelector:int=0):void{
            if ((((((this._renderTarget == target)) && ((surfaceSelector == this._renderSurfaceSelector)))) && ((this._enableDepthAndStencil == enableDepthAndStencil)))){
                return;
            };
            this._renderTarget = target;
            this._renderSurfaceSelector = surfaceSelector;
            this._enableDepthAndStencil = enableDepthAndStencil;
            if (target){
                this._context3D.setRenderToTexture(target, enableDepthAndStencil, this._antiAlias, surfaceSelector);
            } else {
                this._context3D.setRenderToBackBuffer();
            };
        }
        public function clear():void{
            if (!(this._context3D)){
                return;
            };
            if (this._backBufferDirty){
                this.configureBackBuffer(this._backBufferWidth, this._backBufferHeight, this._antiAlias, this._enableDepthAndStencil);
                this._backBufferDirty = false;
            };
            this._context3D.clear((((this._color >> 16) & 0xFF) / 0xFF), (((this._color >> 8) & 0xFF) / 0xFF), ((this._color & 0xFF) / 0xFF), (((this._color >> 24) & 0xFF) / 0xFF));
        }
        public function present():void{
            if (!(this._context3D)){
                return;
            };
            this._context3D.present();
            this._activeProgram3D = null;
        }
        override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            if ((((((type == Event.ENTER_FRAME)) || ((type == Event.EXIT_FRAME)))) && (!(_frameEventDriver.hasEventListener(Event.ENTER_FRAME))))){
                _frameEventDriver.addEventListener(Event.ENTER_FRAME, this.onEnterFrame, useCapture, priority, useWeakReference);
            };
        }
        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
            super.removeEventListener(type, listener, useCapture);
            if (((((!(hasEventListener(Event.ENTER_FRAME))) && (!(hasEventListener(Event.EXIT_FRAME))))) && (_frameEventDriver.hasEventListener(Event.ENTER_FRAME)))){
                _frameEventDriver.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame, useCapture);
            };
        }
        public function get scissorRect():Rectangle{
            return (this._scissorRect);
        }
        public function set scissorRect(value:Rectangle):void{
            this._scissorRect = value;
            this._context3D.setScissorRectangle(this._scissorRect);
        }
        public function get stage3DIndex():int{
            return (this._stage3DIndex);
        }
        public function get stage3D():Stage3D{
            return (this._stage3D);
        }
        public function get context3D():Context3D{
            return (this._context3D);
        }
        public function get driverInfo():String{
            return (((this._context3D) ? this._context3D.driverInfo : null));
        }
        public function get usesSoftwareRendering():Boolean{
            return (this._usesSoftwareRendering);
        }
        public function get x():Number{
            return (this._stage3D.x);
        }
        public function set x(value:Number):void{
            this._stage3D.x = (this._viewPort.x = value);
        }
        public function get y():Number{
            return (this._stage3D.y);
        }
        public function set y(value:Number):void{
            this._stage3D.y = (this._viewPort.y = value);
        }
        public function get width():int{
            return (this._backBufferWidth);
        }
        public function set width(width:int):void{
            this._backBufferWidth = (this._viewPort.width = width);
            this._backBufferDirty = true;
        }
        public function get height():int{
            return (this._backBufferHeight);
        }
        public function set height(height:int):void{
            this._backBufferHeight = (this._viewPort.height = height);
            this._backBufferDirty = true;
        }
        public function get antiAlias():int{
            return (this._antiAlias);
        }
        public function set antiAlias(antiAlias:int):void{
            this._antiAlias = antiAlias;
            this._backBufferDirty = true;
        }
        public function get viewPort():Rectangle{
            return (this._viewPort);
        }
        public function get color():uint{
            return (this._color);
        }
        public function set color(color:uint):void{
            this._color = color;
        }
        public function get visible():Boolean{
            return (this._stage3D.visible);
        }
        public function set visible(value:Boolean):void{
            this._stage3D.visible = value;
        }
        private function freeContext3D():void{
            if (this._context3D){
                this._context3D.dispose();
                dispatchEvent(new Stage3DEvent(Stage3DEvent.CONTEXT3D_DISPOSED));
            };
            this._context3D = null;
        }
        private function onContext3DUpdate(event:Event):void{
            var hadContext:Boolean;
            if (this._stage3D.context3D){
                hadContext = !((this._context3D == null));
                this._context3D = this._stage3D.context3D;
                this._context3D.enableErrorChecking = Debug.active;
                this._usesSoftwareRendering = (this._context3D.driverInfo.indexOf("Software") == 0);
                if (((this._backBufferWidth) && (this._backBufferHeight))){
                    this._context3D.configureBackBuffer(this._backBufferWidth, this._backBufferHeight, this._antiAlias, this._enableDepthAndStencil);
                };
                dispatchEvent(new Stage3DEvent(((hadContext) ? Stage3DEvent.CONTEXT3D_RECREATED : Stage3DEvent.CONTEXT3D_CREATED)));
            } else {
                throw (new Error("Rendering context lost!"));
            };
        }
        private function requestContext(forceSoftware:Boolean=false):void{
            this._usesSoftwareRendering = ((this._usesSoftwareRendering) || (forceSoftware));
            this._stage3D.requestContext3D(((forceSoftware) ? Context3DRenderMode.SOFTWARE : Context3DRenderMode.AUTO));
            this._contextRequested = true;
        }
        private function onEnterFrame(event:Event):void{
            if (!(this._context3D)){
                return;
            };
            this.clear();
            this.notifyEnterFrame();
            this.present();
            this.notifyExitFrame();
        }
        public function recoverFromDisposal():Boolean{
            if (!(this._context3D)){
                return (false);
            };
            if (this._context3D.driverInfo == "Disposed"){
                this._context3D = null;
                dispatchEvent(new Stage3DEvent(Stage3DEvent.CONTEXT3D_DISPOSED));
                return (false);
            };
            return (true);
        }

    }
}//package away3d.core.managers 
