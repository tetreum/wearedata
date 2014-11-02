package wd.wq.core {
    import flash.display3D.*;
    import wd.wq.display.*;
    import flash.utils.*;
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.text.*;

    public class WatchQuads extends EventDispatcher {

        public static const READY:String = "READY";
        public static const ON_ERROR:String = "ON_ERROR";

        private static var _current:WatchQuads;

        private var stage:Stage;
        private var _viewPort:Rectangle;
        private var stage3D:Stage3D;
        private var antiAliasing:int = 0;
        private var renderMode:String = "auto";
        private var context:Context3D;
        private var enableErrorChecking:Boolean = false;
        private var programs:Dictionary;
        private var mSupport:WQRenderSupport;
        private var shareContext:Boolean = false;
        private var quads:Vector.<WQuad>;

        public function WatchQuads(stage:Stage, viewPort:Rectangle, _stage3D:Stage3D=null, stage3DIndex:int=0){
            var stage:* = stage;
            var viewPort:* = viewPort;
            var _stage3D = _stage3D;
            var stage3DIndex:int = stage3DIndex;
            super();
            this._viewPort = viewPort;
            this.stage = stage;
            if (_stage3D == null){
                this.shareContext = false;
                this.stage3D = stage.stage3Ds[stage3DIndex];
            } else {
                this.shareContext = true;
                this.stage3D = _stage3D;
            };
            trace("stage3D", this.stage3D);
            if (_current == null){
                this.makeCurrent();
            };
            this.programs = new Dictionary();
            this.mSupport = new WQRenderSupport();
            this.quads = new Vector.<WQuad>();
            if (this.shareContext){
                this.context = this.stage3D.context3D;
                this.initializePrograms();
            } else {
                this.stage3D.addEventListener(Event.CONTEXT3D_CREATE, this.onContextCreated, false, 0, true);
                this.stage3D.addEventListener(ErrorEvent.ERROR, this.onStage3DError, false, 0, true);
                try {
                    this.stage3D.requestContext3D(this.renderMode);
                } catch(e:Error) {
                    showFatalError(("Context3D error: " + e.message));
                };
            };
        }
        public static function get current():WatchQuads{
            return (_current);
        }
        public static function get context():Context3D{
            return (current.context);
        }

        public function addQuad(q:WQuad):void{
            this.quads.push(q);
        }
        public function removeQuad(id:int):Boolean{
            var l:int = this.quads.length;
            while (l--) {
                if (this.quads[l].id == id){
                    this.quads.splice(l, 1);
                    return (true);
                };
            };
            return (false);
        }
        public function render():void{
            this.startRender();
            var l:int = this.quads.length;
            while (l--) {
                this.quads[l].render(this.mSupport);
            };
            this.finishRender();
        }
        public function startRender():void{
            if (this.context == null){
                return;
            };
            this.mSupport.setOrthographicProjection(this._viewPort.width, this._viewPort.height);
            this.mSupport.setDefaultBlendFactors(true);
            if (!(this.shareContext)){
                this.mSupport.clear(0xCCCCCC, 0);
            };
        }
        public function finishRender():void{
            if (!(this.shareContext)){
                this.context.present();
            };
            this.mSupport.resetMatrix();
        }
        public function makeCurrent():void{
            _current = this;
        }
        public function getProgram(name:String):Program3D{
            return ((this.programs[name] as Program3D));
        }
        public function registerProgram(name:String, vertexProgram:ByteArray, fragmentProgram:ByteArray):void{
            if (this.programs.hasOwnProperty(name)){
                throw (new Error("Another program with this name is already registered"));
            };
            var program:Program3D = this.context.createProgram();
            program.upload(vertexProgram, fragmentProgram);
            this.programs[name] = program;
        }
        private function initializePrograms():void{
            Image3D.registerPrograms(this);
            WQuad.registerPrograms(this);
        }
        private function initializeGraphicsAPI():void{
            if (this.context){
                return;
            };
            trace("stage3D", this.stage3D);
            trace("stage3D.context3D", this.stage3D.context3D);
            this.context = this.stage3D.context3D;
            this.showFatalError(this.context.driverInfo);
            this.context.enableErrorChecking = this.enableErrorChecking;
            this.updateViewPort();
        }
        private function onContextCreated(event:Event):void{
            this.initializeGraphicsAPI();
            this.initializePrograms();
            dispatchEvent(new Event(READY));
        }
        private function onStage3DError(event:ErrorEvent):void{
            this.showFatalError("This application is not correctly embedded (wrong wmode value) please change the wmode to \"direct\"");
            dispatchEvent(new Event(ON_ERROR));
        }
        public function get viewPort():Rectangle{
            return (this._viewPort);
        }
        public function set viewPort(value:Rectangle):void{
            this._viewPort = value;
            this.updateViewPort();
        }
        private function updateViewPort():void{
            if (this.context){
                this.context.configureBackBuffer(this.viewPort.width, this.viewPort.height, this.antiAliasing, false);
            };
            this.stage3D.x = this.viewPort.x;
            this.stage3D.y = this.viewPort.y;
        }
        private function showFatalError(message:String):void{
            var textField:TextField = new TextField();
            var textFormat:TextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
            textFormat.align = TextFormatAlign.CENTER;
            textField.defaultTextFormat = textFormat;
            textField.wordWrap = true;
            textField.width = (this.stage.stageWidth * 0.75);
            textField.autoSize = TextFieldAutoSize.CENTER;
            textField.text = message;
            textField.x = ((this.stage.stageWidth - textField.width) / 2);
            textField.y = ((this.stage.stageHeight - textField.height) / 2);
            textField.background = true;
            textField.backgroundColor = 0x440000;
            this.stage.addChild(textField);
        }

    }
}//package wd.wq.core 
