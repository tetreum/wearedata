package away3d.filters {
    import __AS3__.vec.*;
    import away3d.filters.tasks.*;
    import flash.display3D.textures.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;

    public class Filter3DBase {

        private var _tasks:Vector.<Filter3DTaskBase>;
        private var _requireDepthRender:Boolean;
        private var _textureWidth:int;
        private var _textureHeight:int;

        public function Filter3DBase(){
            super();
            this._tasks = new Vector.<Filter3DTaskBase>();
        }
        public function get requireDepthRender():Boolean{
            return (this._requireDepthRender);
        }
        protected function addTask(filter:Filter3DTaskBase):void{
            this._tasks.push(filter);
            this._requireDepthRender = ((this._requireDepthRender) || (filter.requireDepthRender));
        }
        public function get tasks():Vector.<Filter3DTaskBase>{
            return (this._tasks);
        }
        public function getMainInputTexture(stage3DProxy:Stage3DProxy):Texture{
            return (this._tasks[0].getMainInputTexture(stage3DProxy));
        }
        public function get textureWidth():int{
            return (this._textureWidth);
        }
        public function set textureWidth(value:int):void{
            this._textureWidth = value;
            var i:int;
            while (i < this._tasks.length) {
                this._tasks[i].textureWidth = value;
                i++;
            };
        }
        public function get textureHeight():int{
            return (this._textureHeight);
        }
        public function set textureHeight(value:int):void{
            this._textureHeight = value;
            var i:int;
            while (i < this._tasks.length) {
                this._tasks[i].textureHeight = value;
                i++;
            };
        }
        public function setRenderTargets(mainTarget:Texture, stage3DProxy:Stage3DProxy):void{
            this._tasks[(this._tasks.length - 1)].target = mainTarget;
        }
        public function dispose():void{
            var i:int;
            while (i < this._tasks.length) {
                this._tasks[i].dispose();
                i++;
            };
        }
        public function update(stage:Stage3DProxy, camera:Camera3D):void{
        }

    }
}//package away3d.filters 
