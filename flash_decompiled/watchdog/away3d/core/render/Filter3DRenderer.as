package away3d.core.render {
    import away3d.core.managers.*;
    import flash.events.*;
    import flash.display3D.textures.*;
    import away3d.filters.*;
    import __AS3__.vec.*;
    import away3d.filters.tasks.*;
    import flash.display3D.*;
    import away3d.cameras.*;

    public class Filter3DRenderer {

        private var _filters:Array;
        private var _tasks:Vector.<Filter3DTaskBase>;
        private var _filterTasksInvalid:Boolean;
        private var _mainInputTexture:Texture;
        private var _requireDepthRender:Boolean;
        private var _rttManager:RTTBufferManager;
        private var _stage3DProxy:Stage3DProxy;
        private var _filterSizesInvalid:Boolean = true;

        public function Filter3DRenderer(stage3DProxy:Stage3DProxy){
            super();
            this._stage3DProxy = stage3DProxy;
            this._rttManager = RTTBufferManager.getInstance(stage3DProxy);
            this._rttManager.addEventListener(Event.RESIZE, this.onRTTResize);
        }
        private function onRTTResize(event:Event):void{
            this._filterSizesInvalid = true;
        }
        public function get requireDepthRender():Boolean{
            return (this._requireDepthRender);
        }
        public function getMainInputTexture(stage3DProxy:Stage3DProxy):Texture{
            if (this._filterTasksInvalid){
                this.updateFilterTasks(stage3DProxy);
            };
            return (this._mainInputTexture);
        }
        public function get filters():Array{
            return (this._filters);
        }
        public function set filters(value:Array):void{
            this._filters = value;
            this._filterTasksInvalid = true;
            this._requireDepthRender = false;
            if (!(this._filters)){
                return;
            };
            var i:int;
            while (i < this._filters.length) {
                this._requireDepthRender = ((this._requireDepthRender) || (this._filters[i].requireDepthRender));
                i++;
            };
            this._filterSizesInvalid = true;
        }
        private function updateFilterTasks(stage3DProxy:Stage3DProxy):void{
            var len:uint;
            var filter:Filter3DBase;
            if (this._filterSizesInvalid){
                this.updateFilterSizes();
            };
            if (!(this._filters)){
                this._tasks = null;
                return;
            };
            this._tasks = new Vector.<Filter3DTaskBase>();
            len = (this._filters.length - 1);
            var i:uint;
            while (i <= len) {
                filter = this._filters[i];
                filter.setRenderTargets((((i == len)) ? null : Filter3DBase(this._filters[(i + 1)]).getMainInputTexture(stage3DProxy)), stage3DProxy);
                this._tasks = this._tasks.concat(filter.tasks);
                i++;
            };
            this._mainInputTexture = this._filters[0].getMainInputTexture(stage3DProxy);
        }
        public function render(stage3DProxy:Stage3DProxy, camera3D:Camera3D, depthTexture:Texture):void{
            var len:int;
            var i:int;
            var task:Filter3DTaskBase;
            var context:Context3D = stage3DProxy.context3D;
            var indexBuffer:IndexBuffer3D = this._rttManager.indexBuffer;
            var vertexBuffer:VertexBuffer3D = this._rttManager.renderToTextureVertexBuffer;
            if (!(this._filters)){
                return;
            };
            if (this._filterSizesInvalid){
                this.updateFilterSizes();
            };
            if (this._filterTasksInvalid){
                this.updateFilterTasks(stage3DProxy);
            };
            len = this._filters.length;
            i = 0;
            while (i < len) {
                this._filters[i].update(stage3DProxy, camera3D);
                i++;
            };
            len = this._tasks.length;
            if (len > 1){
                context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
                context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
            };
            i = 0;
            while (i < len) {
                task = this._tasks[i];
                stage3DProxy.setRenderTarget(task.target);
                if (!(task.target)){
                    stage3DProxy.scissorRect = null;
                    vertexBuffer = this._rttManager.renderToScreenVertexBuffer;
                    context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
                    context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
                };
                stage3DProxy.setTextureAt(0, task.getMainInputTexture(stage3DProxy));
                stage3DProxy.setProgram(task.getProgram3D(stage3DProxy));
                context.clear(0, 0, 0, 1);
                task.activate(stage3DProxy, camera3D, depthTexture);
                context.drawTriangles(indexBuffer, 0, 2);
                task.deactivate(stage3DProxy);
                i++;
            };
            stage3DProxy.setTextureAt(0, null);
            stage3DProxy.setSimpleVertexBuffer(0, null, null, 0);
            stage3DProxy.setSimpleVertexBuffer(1, null, null, 0);
        }
        private function updateFilterSizes():void{
            var i:int;
            while (i < this._filters.length) {
                this._filters[i].textureWidth = this._rttManager.textureWidth;
                this._filters[i].textureHeight = this._rttManager.textureHeight;
                i++;
            };
            this._filterSizesInvalid = true;
        }
        public function dispose():void{
            this._rttManager.removeEventListener(Event.RESIZE, this.onRTTResize);
            this._rttManager = null;
            this._stage3DProxy = null;
        }

    }
}//package away3d.core.render 
