package away3d.containers {
    import flash.net.*;
    import flash.events.*;
    import away3d.*;
    import flash.ui.*;
    import flash.geom.*;
    import away3d.cameras.*;
    import away3d.core.render.*;
    import away3d.core.managers.*;
    import away3d.textures.*;
    import flash.display.*;
    import flash.utils.*;
    import away3d.core.traverse.*;
    import flash.display3D.*;
    import away3d.core.pick.*;
    import flash.display3D.textures.*;

    public class View3D extends Sprite {

        private var _width:Number = 0;
        private var _height:Number = 0;
        private var _localPos:Point;
        private var _globalPos:Point;
        protected var _scene:Scene3D;
        protected var _camera:Camera3D;
        protected var _entityCollector:EntityCollector;
        protected var _aspectRatio:Number;
        private var _time:Number = 0;
        private var _deltaTime:uint;
        private var _backgroundColor:uint = 0;
        private var _backgroundAlpha:Number = 1;
        private var _mouse3DManager:Mouse3DManager;
        private var _stage3DManager:Stage3DManager;
        protected var _renderer:RendererBase;
        private var _depthRenderer:DepthRenderer;
        private var _addedToStage:Boolean;
        private var _forceSoftware:Boolean;
        protected var _filter3DRenderer:Filter3DRenderer;
        protected var _requireDepthRender:Boolean;
        protected var _depthRender:Texture;
        private var _depthTextureInvalid:Boolean = true;
        private var _hitField:Sprite;
        protected var _parentIsStage:Boolean;
        private var _background:Texture2DBase;
        protected var _stage3DProxy:Stage3DProxy;
        protected var _backBufferInvalid:Boolean = true;
        private var _antiAlias:uint;
        protected var _rttBufferManager:RTTBufferManager;
        private var _rightClickMenuEnabled:Boolean = true;
        private var _sourceURL:String;
        private var _menu0:ContextMenuItem;
        private var _menu1:ContextMenuItem;
        private var _ViewContextMenu:ContextMenu;
        private var _shareContext:Boolean = false;
        private var _viewScissoRect:Rectangle;

        public function View3D(scene:Scene3D=null, camera:Camera3D=null, renderer:RendererBase=null, forceSoftware:Boolean=false){
            this._localPos = new Point();
            this._globalPos = new Point();
            super();
            this._scene = ((scene) || (new Scene3D()));
            this._camera = ((camera) || (new Camera3D()));
            this._renderer = ((renderer) || (new DefaultRenderer()));
            this._depthRenderer = new DepthRenderer();
            this._forceSoftware = forceSoftware;
            this._entityCollector = this._renderer.createEntityCollector();
            this._viewScissoRect = new Rectangle();
            this.initHitField();
            this._mouse3DManager = new Mouse3DManager();
            this._mouse3DManager.enableMouseListeners(this);
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage, false, 0, true);
            addEventListener(Event.ADDED, this.onAdded, false, 0, true);
            this._camera.partition = this._scene.partition;
            this.initRightClickMenu();
        }
        private function viewSource(e:ContextMenuEvent):void{
            var request:URLRequest = new URLRequest(this._sourceURL);
            try {
                navigateToURL(request, "_blank");
            } catch(error:Error) {
            };
        }
        private function visitWebsite(e:ContextMenuEvent):void{
            var url:String = Away3D.WEBSITE_URL;
            var request:URLRequest = new URLRequest(url);
            try {
                navigateToURL(request);
            } catch(error:Error) {
            };
        }
        private function initRightClickMenu():void{
            this._menu0 = new ContextMenuItem(((((("Away3D.com\tv" + Away3D.MAJOR_VERSION) + ".") + Away3D.MINOR_VERSION) + ".") + Away3D.REVISION), true, true, true);
            this._menu1 = new ContextMenuItem("View Source", true, true, true);
            this._menu0.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.visitWebsite);
            this._menu1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.viewSource);
            this._ViewContextMenu = new ContextMenu();
            this.updateRightClickMenu();
        }
        private function updateRightClickMenu():void{
            if (this._rightClickMenuEnabled){
                this._ViewContextMenu.customItems = ((this._sourceURL) ? [this._menu0, this._menu1] : [this._menu0]);
            } else {
                this._ViewContextMenu.customItems = [];
            };
            contextMenu = this._ViewContextMenu;
        }
        public function get rightClickMenuEnabled():Boolean{
            return (this._rightClickMenuEnabled);
        }
        public function set rightClickMenuEnabled(val:Boolean):void{
            this._rightClickMenuEnabled = val;
            this.updateRightClickMenu();
        }
        public function get stage3DProxy():Stage3DProxy{
            return (this._stage3DProxy);
        }
        public function set stage3DProxy(stage3DProxy:Stage3DProxy):void{
            this._stage3DProxy = stage3DProxy;
            this._renderer.stage3DProxy = (this._depthRenderer.stage3DProxy = this._stage3DProxy);
            super.x = this._stage3DProxy.x;
            this._localPos.x = this._stage3DProxy.x;
            this._globalPos.x = ((parent) ? parent.localToGlobal(this._localPos).x : this._stage3DProxy.x);
            super.y = this._stage3DProxy.y;
            this._localPos.y = this._stage3DProxy.y;
            this._globalPos.y = ((parent) ? parent.localToGlobal(this._localPos).y : this._stage3DProxy.y);
            this._viewScissoRect = new Rectangle(this._stage3DProxy.x, this._stage3DProxy.y, this._stage3DProxy.width, this._stage3DProxy.height);
        }
        public function get forceMouseMove():Boolean{
            return (this._mouse3DManager.forceMouseMove);
        }
        public function set forceMouseMove(value:Boolean):void{
            this._mouse3DManager.forceMouseMove = value;
        }
        public function get background():Texture2DBase{
            return (this._background);
        }
        public function set background(value:Texture2DBase):void{
            this._background = value;
            this._renderer.background = this._background;
        }
        private function initHitField():void{
            this._hitField = new Sprite();
            this._hitField.alpha = 0;
            this._hitField.doubleClickEnabled = true;
            this._hitField.graphics.beginFill(0);
            this._hitField.graphics.drawRect(0, 0, 100, 100);
            addChild(this._hitField);
        }
        override public function get filters():Array{
            throw (new Error("filters is not supported in View3D. Use filters3d instead."));
        }
        override public function set filters(value:Array):void{
            throw (new Error("filters is not supported in View3D. Use filters3d instead."));
        }
        public function get filters3d():Array{
            return (((this._filter3DRenderer) ? this._filter3DRenderer.filters : null));
        }
        public function set filters3d(value:Array):void{
            if (((value) && ((value.length == 0)))){
                value = null;
            };
            if (((this._filter3DRenderer) && (!(value)))){
                this._filter3DRenderer.dispose();
                this._filter3DRenderer = null;
            } else {
                if (((!(this._filter3DRenderer)) && (value))){
                    this._filter3DRenderer = new Filter3DRenderer(this.stage3DProxy);
                    this._filter3DRenderer.filters = value;
                };
            };
            if (this._filter3DRenderer){
                this._filter3DRenderer.filters = value;
                this._requireDepthRender = this._filter3DRenderer.requireDepthRender;
            } else {
                this._requireDepthRender = false;
                if (this._depthRender){
                    this._depthRender.dispose();
                    this._depthRender = null;
                };
            };
        }
        public function get renderer():RendererBase{
            return (this._renderer);
        }
        public function set renderer(value:RendererBase):void{
            this._renderer.dispose();
            this._renderer = value;
            this._entityCollector = this._renderer.createEntityCollector();
            this._renderer.stage3DProxy = this._stage3DProxy;
            this._renderer.antiAlias = this._antiAlias;
            this._renderer.backgroundR = (((this._backgroundColor >> 16) & 0xFF) / 0xFF);
            this._renderer.backgroundG = (((this._backgroundColor >> 8) & 0xFF) / 0xFF);
            this._renderer.backgroundB = ((this._backgroundColor & 0xFF) / 0xFF);
            this._renderer.backgroundAlpha = this._backgroundAlpha;
            this._renderer.viewWidth = this._width;
            this._renderer.viewHeight = this._height;
            this.invalidateBackBuffer();
        }
        private function invalidateBackBuffer():void{
            this._backBufferInvalid = true;
        }
        public function get backgroundColor():uint{
            return (this._backgroundColor);
        }
        public function set backgroundColor(value:uint):void{
            this._backgroundColor = value;
            this._renderer.backgroundR = (((value >> 16) & 0xFF) / 0xFF);
            this._renderer.backgroundG = (((value >> 8) & 0xFF) / 0xFF);
            this._renderer.backgroundB = ((value & 0xFF) / 0xFF);
        }
        public function get backgroundAlpha():Number{
            return (this._backgroundAlpha);
        }
        public function set backgroundAlpha(value:Number):void{
            if (value > 1){
                value = 1;
            } else {
                if (value < 0){
                    value = 0;
                };
            };
            this._renderer.backgroundAlpha = value;
            this._backgroundAlpha = value;
        }
        public function get camera():Camera3D{
            return (this._camera);
        }
        public function set camera(camera:Camera3D):void{
            this._camera = camera;
            if (this._scene){
                this._camera.partition = this._scene.partition;
            };
        }
        public function get scene():Scene3D{
            return (this._scene);
        }
        public function set scene(scene:Scene3D):void{
            this._scene = scene;
            if (this._camera){
                this._camera.partition = this._scene.partition;
            };
        }
        public function get deltaTime():uint{
            return (this._deltaTime);
        }
        override public function get width():Number{
            return (this._width);
        }
        override public function set width(value:Number):void{
            if (((((this._stage3DProxy) && (this._stage3DProxy.usesSoftwareRendering))) && ((value > 0x0800)))){
                value = 0x0800;
            };
            if (this._width == value){
                return;
            };
            if (this._rttBufferManager){
                this._rttBufferManager.viewWidth = value;
            };
            this._hitField.width = value;
            this._width = value;
            this._aspectRatio = (this._width / this._height);
            this._depthTextureInvalid = true;
            this._renderer.viewWidth = value;
            this._viewScissoRect.width = value;
            this.invalidateBackBuffer();
        }
        override public function get height():Number{
            return (this._height);
        }
        override public function set height(value:Number):void{
            if (((((this._stage3DProxy) && (this._stage3DProxy.usesSoftwareRendering))) && ((value > 0x0800)))){
                value = 0x0800;
            };
            if (this._height == value){
                return;
            };
            if (this._rttBufferManager){
                this._rttBufferManager.viewHeight = value;
            };
            this._hitField.height = value;
            this._height = value;
            this._aspectRatio = (this._width / this._height);
            this._depthTextureInvalid = true;
            this._renderer.viewHeight = value;
            this._viewScissoRect.height = value;
            this.invalidateBackBuffer();
        }
        override public function set x(value:Number):void{
            super.x = value;
            this._localPos.x = value;
            this._globalPos.x = ((parent) ? parent.localToGlobal(this._localPos).x : value);
            this._viewScissoRect.x = value;
            if (((this._stage3DProxy) && (!(this._shareContext)))){
                this._stage3DProxy.x = this._globalPos.x;
            };
        }
        override public function set y(value:Number):void{
            super.y = value;
            this._localPos.y = value;
            this._globalPos.y = ((parent) ? parent.localToGlobal(this._localPos).y : value);
            this._viewScissoRect.y = value;
            if (((this._stage3DProxy) && (!(this._shareContext)))){
                this._stage3DProxy.y = this._globalPos.y;
            };
        }
        override public function set visible(value:Boolean):void{
            super.visible = value;
            if (((this._stage3DProxy) && (!(this._shareContext)))){
                this._stage3DProxy.visible = value;
            };
        }
        public function get antiAlias():uint{
            return (this._antiAlias);
        }
        public function set antiAlias(value:uint):void{
            this._antiAlias = value;
            this._renderer.antiAlias = value;
            this.invalidateBackBuffer();
        }
        public function get renderedFacesCount():uint{
            return (this._entityCollector.numTriangles);
        }
        public function get shareContext():Boolean{
            return (this._shareContext);
        }
        public function set shareContext(value:Boolean):void{
            this._shareContext = value;
        }
        protected function updateBackBuffer():void{
            if (((this._stage3DProxy.context3D) && (!(this._shareContext)))){
                if (((this._width) && (this._height))){
                    if (this._stage3DProxy.usesSoftwareRendering){
                        if (this._width > 0x0800){
                            this._width = 0x0800;
                        };
                        if (this._height > 0x0800){
                            this._height = 0x0800;
                        };
                    };
                    this._stage3DProxy.configureBackBuffer(this._width, this._height, this._antiAlias, true);
                    this._backBufferInvalid = false;
                } else {
                    this.width = stage.stageWidth;
                    this.height = stage.stageHeight;
                };
            };
        }
        public function addSourceURL(url:String):void{
            this._sourceURL = url;
            this.updateRightClickMenu();
        }
        public function render():void{
            if (!(this.stage3DProxy.recoverFromDisposal())){
                this._backBufferInvalid = true;
                return;
            };
            if (this._backBufferInvalid){
                this.updateBackBuffer();
            };
            if (!(this._parentIsStage)){
                this.updateGlobalPos();
            };
            this.updateTime();
            this._entityCollector.clear();
            this.updateViewSizeData();
            this._scene.traversePartitions(this._entityCollector);
            this._mouse3DManager.updateCollider(this);
            if (this._requireDepthRender){
                this.renderSceneDepth(this._entityCollector);
            };
            if (((this._filter3DRenderer) && (this._stage3DProxy._context3D))){
                this._renderer.render(this._entityCollector, this._filter3DRenderer.getMainInputTexture(this._stage3DProxy), this._rttBufferManager.renderToTextureRect);
                this._filter3DRenderer.render(this._stage3DProxy, this.camera, this._depthRender);
                if (!(this._shareContext)){
                    this._stage3DProxy._context3D.present();
                };
            } else {
                this._renderer.shareContext = this._shareContext;
                if (this._shareContext){
                    this._renderer.render(this._entityCollector, null, this._viewScissoRect);
                } else {
                    this._renderer.render(this._entityCollector);
                };
            };
            this._entityCollector.cleanUp();
            this._mouse3DManager.fireMouseEvents();
        }
        protected function updateGlobalPos():void{
            var globalPos:Point = parent.localToGlobal(this._localPos);
            if (this._globalPos.x != globalPos.x){
                this._stage3DProxy.x = globalPos.x;
            };
            if (this._globalPos.y != globalPos.y){
                this._stage3DProxy.y = globalPos.y;
            };
            this._globalPos = globalPos;
        }
        protected function updateTime():void{
            var time:Number = getTimer();
            if (this._time == 0){
                this._time = time;
            };
            this._deltaTime = (time - this._time);
            this._time = time;
        }
        private function updateViewSizeData():void{
            this._camera.lens.aspectRatio = this._aspectRatio;
            this._entityCollector.camera = this._camera;
            if (((this._filter3DRenderer) || (this._renderer.renderToTexture))){
                this._renderer.textureRatioX = this._rttBufferManager.textureRatioX;
                this._renderer.textureRatioY = this._rttBufferManager.textureRatioY;
            } else {
                this._renderer.textureRatioX = 1;
                this._renderer.textureRatioY = 1;
            };
        }
        protected function renderSceneDepth(entityCollector:EntityCollector):void{
            if (((this._depthTextureInvalid) || (!(this._depthRender)))){
                this.initDepthTexture(this._stage3DProxy._context3D);
            };
            this._depthRenderer.textureRatioX = this._rttBufferManager.textureRatioX;
            this._depthRenderer.textureRatioY = this._rttBufferManager.textureRatioY;
            this._depthRenderer.render(entityCollector, this._depthRender);
        }
        private function initDepthTexture(context:Context3D):void{
            this._depthTextureInvalid = false;
            if (this._depthRender){
                this._depthRender.dispose();
            };
            this._depthRender = context.createTexture(this._rttBufferManager.textureWidth, this._rttBufferManager.textureHeight, Context3DTextureFormat.BGRA, true);
        }
        public function dispose():void{
            this._stage3DProxy.dispose();
            this._renderer.dispose();
            if (this._depthRender){
                this._depthRender.dispose();
            };
            if (this._rttBufferManager){
                this._rttBufferManager.dispose();
            };
            this._mouse3DManager.disableMouseListeners(this);
            this._rttBufferManager = null;
            this._depthRender = null;
            this._mouse3DManager = null;
            this._depthRenderer = null;
            this._stage3DProxy = null;
            this._renderer = null;
            this._entityCollector = null;
        }
        public function project(point3d:Vector3D):Vector3D{
            var v:Vector3D = this._camera.project(point3d);
            v.x = (((v.x + 1) * this._width) / 2);
            v.y = (((v.y + 1) * this._height) / 2);
            return (v);
        }
        public function unproject(mX:Number, mY:Number, mZ:Number=0):Vector3D{
            return (this._camera.unproject((((mX * 2) - this._width) / this._width), (((mY * 2) - this._height) / this._height), mZ));
        }
        public function getRay(mX:Number, mY:Number, mZ:Number=0):Vector3D{
            return (this._camera.getRay((((mX * 2) - this._width) / this._width), (((mY * 2) - this._height) / this._height), mZ));
        }
        public function get mousePicker():IPicker{
            return (this._mouse3DManager.mousePicker);
        }
        public function set mousePicker(value:IPicker):void{
            this._mouse3DManager.mousePicker = value;
        }
        function get entityCollector():EntityCollector{
            return (this._entityCollector);
        }
        private function onAddedToStage(event:Event):void{
            if (this._addedToStage){
                return;
            };
            this._addedToStage = true;
            this._stage3DManager = Stage3DManager.getInstance(stage);
            if (!(this._stage3DProxy)){
                this._stage3DProxy = this._stage3DManager.getFreeStage3DProxy(this._forceSoftware);
            };
            this._stage3DProxy.x = this._globalPos.x;
            this._rttBufferManager = RTTBufferManager.getInstance(this._stage3DProxy);
            this._stage3DProxy.y = this._globalPos.y;
            if (this._width == 0){
                this.width = stage.stageWidth;
            } else {
                this._rttBufferManager.viewWidth = this._width;
            };
            if (this._height == 0){
                this.height = stage.stageHeight;
            } else {
                this._rttBufferManager.viewHeight = this._height;
            };
            this._renderer.stage3DProxy = (this._depthRenderer.stage3DProxy = this._stage3DProxy);
        }
        private function onAdded(event:Event):void{
            this._parentIsStage = (parent == stage);
            this._globalPos = parent.localToGlobal(new Point(x, y));
            if (this._stage3DProxy){
                this._stage3DProxy.x = this._globalPos.x;
                this._stage3DProxy.y = this._globalPos.y;
            };
        }
        override public function set z(value:Number):void{
        }
        override public function set scaleZ(value:Number):void{
        }
        override public function set rotation(value:Number):void{
        }
        override public function set rotationX(value:Number):void{
        }
        override public function set rotationY(value:Number):void{
        }
        override public function set rotationZ(value:Number):void{
        }
        override public function set transform(value:Transform):void{
        }
        override public function set scaleX(value:Number):void{
        }
        override public function set scaleY(value:Number):void{
        }

    }
}//package away3d.containers 
