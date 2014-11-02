package away3d.core.managers {
    import flash.utils.*;
    import flash.geom.*;
    import away3d.tools.utils.*;
    import flash.events.*;
    import flash.display3D.*;
    import __AS3__.vec.*;

    public class RTTBufferManager extends EventDispatcher {

        private static var _instances:Dictionary;

        private var _renderToTextureVertexBuffer:VertexBuffer3D;
        private var _renderToScreenVertexBuffer:VertexBuffer3D;
        private var _indexBuffer:IndexBuffer3D;
        private var _stage3DProxy:Stage3DProxy;
        private var _viewWidth:int = -1;
        private var _viewHeight:int = -1;
        private var _textureWidth:int = -1;
        private var _textureHeight:int = -1;
        private var _renderToTextureRect:Rectangle;
        private var _buffersInvalid:Boolean = true;
        private var _textureRatioX:Number;
        private var _textureRatioY:Number;

        public function RTTBufferManager(se:SingletonEnforcer, stage3DProxy:Stage3DProxy){
            super();
            if (!(se)){
                throw (new Error("No cheating the multiton!"));
            };
            this._renderToTextureRect = new Rectangle();
            this._stage3DProxy = stage3DProxy;
        }
        public static function getInstance(stage3DProxy:Stage3DProxy):RTTBufferManager{
            if (!(stage3DProxy)){
                throw (new Error("stage3DProxy key cannot be null!"));
            };
            _instances = ((_instances) || (new Dictionary()));
            return ((_instances[stage3DProxy] = ((_instances[stage3DProxy]) || (new RTTBufferManager(new SingletonEnforcer(), stage3DProxy)))));
        }

        public function get textureRatioX():Number{
            if (this._buffersInvalid){
                this.updateRTTBuffers();
            };
            return (this._textureRatioX);
        }
        public function get textureRatioY():Number{
            if (this._buffersInvalid){
                this.updateRTTBuffers();
            };
            return (this._textureRatioY);
        }
        public function get viewWidth():int{
            return (this._viewWidth);
        }
        public function set viewWidth(value:int):void{
            if (value == this._viewWidth){
                return;
            };
            this._viewWidth = value;
            this._buffersInvalid = true;
            this._textureWidth = TextureUtils.getBestPowerOf2(this._viewWidth);
            if (this._textureWidth > this._viewWidth){
                this._renderToTextureRect.x = uint(((this._textureWidth - this._viewWidth) * 0.5));
                this._renderToTextureRect.width = this._viewWidth;
            } else {
                this._renderToTextureRect.x = 0;
                this._renderToTextureRect.width = this._textureWidth;
            };
            dispatchEvent(new Event(Event.RESIZE));
        }
        public function get viewHeight():int{
            return (this._viewHeight);
        }
        public function set viewHeight(value:int):void{
            if (value == this._viewHeight){
                return;
            };
            this._viewHeight = value;
            this._buffersInvalid = true;
            this._textureHeight = TextureUtils.getBestPowerOf2(this._viewHeight);
            if (this._textureHeight > this._viewHeight){
                this._renderToTextureRect.y = uint(((this._textureHeight - this._viewHeight) * 0.5));
                this._renderToTextureRect.height = this._viewHeight;
            } else {
                this._renderToTextureRect.y = 0;
                this._renderToTextureRect.height = this._textureHeight;
            };
            dispatchEvent(new Event(Event.RESIZE));
        }
        public function get renderToTextureVertexBuffer():VertexBuffer3D{
            if (this._buffersInvalid){
                this.updateRTTBuffers();
            };
            return (this._renderToTextureVertexBuffer);
        }
        public function get renderToScreenVertexBuffer():VertexBuffer3D{
            if (this._buffersInvalid){
                this.updateRTTBuffers();
            };
            return (this._renderToScreenVertexBuffer);
        }
        public function get indexBuffer():IndexBuffer3D{
            return (this._indexBuffer);
        }
        public function get renderToTextureRect():Rectangle{
            if (this._buffersInvalid){
                this.updateRTTBuffers();
            };
            return (this._renderToTextureRect);
        }
        public function get textureWidth():int{
            return (this._textureWidth);
        }
        public function get textureHeight():int{
            return (this._textureHeight);
        }
        public function dispose():void{
            delete _instances[this._stage3DProxy];
            if (this._indexBuffer){
                this._indexBuffer.dispose();
                this._renderToScreenVertexBuffer.dispose();
                this._renderToTextureVertexBuffer.dispose();
                this._renderToScreenVertexBuffer = null;
                this._renderToTextureVertexBuffer = null;
                this._indexBuffer = null;
            };
        }
        private function updateRTTBuffers():void{
            var textureVerts:Vector.<Number>;
            var screenVerts:Vector.<Number>;
            var x:Number;
            var y:Number;
            var u:Number;
            var v:Number;
            var context:Context3D = this._stage3DProxy.context3D;
            this._renderToTextureVertexBuffer = ((this._renderToTextureVertexBuffer) || (context.createVertexBuffer(4, 5)));
            this._renderToScreenVertexBuffer = ((this._renderToScreenVertexBuffer) || (context.createVertexBuffer(4, 5)));
            if (!(this._indexBuffer)){
                this._indexBuffer = context.createIndexBuffer(6);
                this._indexBuffer.uploadFromVector(new <uint>[2, 1, 0, 3, 2, 0], 0, 6);
            };
            if (this._viewWidth > this._textureWidth){
                x = 1;
                u = 0;
            } else {
                x = (this._viewWidth / this._textureWidth);
                u = (this._renderToTextureRect.x / this._textureWidth);
            };
            if (this._viewHeight > this._textureHeight){
                y = 1;
                v = 0;
            } else {
                y = (this._viewHeight / this._textureHeight);
                v = (this._renderToTextureRect.y / this._textureHeight);
            };
            this._textureRatioX = x;
            this._textureRatioY = y;
            textureVerts = new <Number>[-(x), -(y), u, (1 - v), 0, x, -(y), (1 - u), (1 - v), 1, x, y, (1 - u), v, 2, -(x), y, u, v, 3];
            screenVerts = new <Number>[-1, -1, u, (1 - v), 0, 1, -1, (1 - u), (1 - v), 1, 1, 1, (1 - u), v, 2, -1, 1, u, v, 3];
            this._renderToTextureVertexBuffer.uploadFromVector(textureVerts, 0, 4);
            this._renderToScreenVertexBuffer.uploadFromVector(screenVerts, 0, 4);
            this._buffersInvalid = false;
        }

    }
}//package away3d.core.managers 

class SingletonEnforcer {

    public function SingletonEnforcer(){
    }
}
