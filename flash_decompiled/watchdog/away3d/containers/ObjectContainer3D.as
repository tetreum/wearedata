package away3d.containers {
    import away3d.core.partition.*;
    import away3d.events.*;
    import away3d.library.assets.*;
    import flash.geom.*;
    import __AS3__.vec.*;
    import away3d.core.base.*;
    import flash.events.*;

    public class ObjectContainer3D extends Object3D implements IAsset {

        var _ancestorsAllowMouseEnabled:Boolean;
        var _isRoot:Boolean;
        protected var _scene:Scene3D;
        protected var _parent:ObjectContainer3D;
        protected var _sceneTransform:Matrix3D;
        protected var _sceneTransformDirty:Boolean = true;
        protected var _explicitPartition:Partition3D;
        protected var _implicitPartition:Partition3D;
        protected var _mouseEnabled:Boolean;
        private var _sceneTransformChanged:Object3DEvent;
        private var _scenechanged:Object3DEvent;
        private var _children:Vector.<ObjectContainer3D>;
        private var _mouseChildren:Boolean = true;
        private var _oldScene:Scene3D;
        private var _inverseSceneTransform:Matrix3D;
        private var _inverseSceneTransformDirty:Boolean = true;
        private var _scenePosition:Vector3D;
        private var _scenePositionDirty:Boolean = true;
        private var _explicitVisibility:Boolean = true;
        private var _implicitVisibility:Boolean = true;
        private var _listenToSceneTransformChanged:Boolean;
        private var _listenToSceneChanged:Boolean;

        public function ObjectContainer3D(){
            this._sceneTransform = new Matrix3D();
            this._children = new Vector.<ObjectContainer3D>();
            this._inverseSceneTransform = new Matrix3D();
            this._scenePosition = new Vector3D();
            super();
        }
        function get implicitPartition():Partition3D{
            return (this._implicitPartition);
        }
        function set implicitPartition(value:Partition3D):void{
            var i:uint;
            var child:ObjectContainer3D;
            if (value == this._implicitPartition){
                return;
            };
            var len:uint = this._children.length;
            this._implicitPartition = value;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                child = this._children[_temp1];
                if (!(child._explicitPartition)){
                    child.implicitPartition = value;
                };
            };
        }
        function get isVisible():Boolean{
            return (((this._implicitVisibility) && (this._explicitVisibility)));
        }
        function setParent(value:ObjectContainer3D):void{
            this._parent = value;
            this.updateMouseChildren();
            if (value == null){
                this.scene = null;
                return;
            };
            this.notifySceneTransformChange();
            this.notifySceneChange();
        }
        private function notifySceneTransformChange():void{
            var i:uint;
            if (this._sceneTransformDirty){
                return;
            };
            this.invalidateSceneTransform();
            var len:uint = this._children.length;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                this._children[_temp1].notifySceneTransformChange();
            };
            if (this._listenToSceneTransformChanged){
                if (!(this._sceneTransformChanged)){
                    this._sceneTransformChanged = new Object3DEvent(Object3DEvent.SCENETRANSFORM_CHANGED, this);
                };
                this.dispatchEvent(this._sceneTransformChanged);
            };
        }
        private function notifySceneChange():void{
            var i:uint;
            this.notifySceneTransformChange();
            var len:uint = this._children.length;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                this._children[_temp1].notifySceneChange();
            };
            if (this._listenToSceneChanged){
                if (!(this._scenechanged)){
                    this._scenechanged = new Object3DEvent(Object3DEvent.SCENE_CHANGED, this);
                };
                this.dispatchEvent(this._scenechanged);
            };
        }
        protected function updateMouseChildren():void{
            if (((this._parent) && (!(this._parent._isRoot)))){
                this._ancestorsAllowMouseEnabled = ((this.parent._ancestorsAllowMouseEnabled) && (this._parent.mouseChildren));
            } else {
                this._ancestorsAllowMouseEnabled = this.mouseChildren;
            };
            var len:uint = this._children.length;
            var i:uint;
            while (i < len) {
                this._children[i].updateMouseChildren();
                i++;
            };
        }
        public function get mouseEnabled():Boolean{
            return (this._mouseEnabled);
        }
        public function set mouseEnabled(value:Boolean):void{
            this._mouseEnabled = value;
            this.updateMouseChildren();
        }
        override function invalidateTransform():void{
            super.invalidateTransform();
            this.notifySceneTransformChange();
        }
        protected function invalidateSceneTransform():void{
            this._sceneTransformDirty = true;
            this._inverseSceneTransformDirty = true;
            this._scenePositionDirty = true;
        }
        protected function updateSceneTransform():void{
            if (((this._parent) && (!(this._parent._isRoot)))){
                this._sceneTransform.copyFrom(this._parent.sceneTransform);
                this._sceneTransform.prepend(transform);
            } else {
                this._sceneTransform.copyFrom(transform);
            };
            this._sceneTransformDirty = false;
        }
        public function get mouseChildren():Boolean{
            return (this._mouseChildren);
        }
        public function set mouseChildren(value:Boolean):void{
            this._mouseChildren = value;
            this.updateMouseChildren();
        }
        public function get visible():Boolean{
            return (this._explicitVisibility);
        }
        public function set visible(value:Boolean):void{
            var len:uint = this._children.length;
            this._explicitVisibility = value;
            var i:uint;
            while (i < len) {
                this._children[i].updateImplicitVisibility();
                i++;
            };
        }
        public function get assetType():String{
            return (AssetType.CONTAINER);
        }
        public function get scenePosition():Vector3D{
            if (this._scenePositionDirty){
                this.sceneTransform.copyColumnTo(3, this._scenePosition);
                this._scenePositionDirty = false;
            };
            return (this._scenePosition);
        }
        public function get minX():Number{
            var i:uint;
            var m:Number;
            var len:uint = this._children.length;
            var min:Number = Number.POSITIVE_INFINITY;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                m = this._children[_temp1].minX;
                if (m < min){
                    min = m;
                };
            };
            return (min);
        }
        public function get minY():Number{
            var i:uint;
            var m:Number;
            var len:uint = this._children.length;
            var min:Number = Number.POSITIVE_INFINITY;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                m = this._children[_temp1].minY;
                if (m < min){
                    min = m;
                };
            };
            return (min);
        }
        public function get minZ():Number{
            var i:uint;
            var m:Number;
            var len:uint = this._children.length;
            var min:Number = Number.POSITIVE_INFINITY;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                m = this._children[_temp1].minZ;
                if (m < min){
                    min = m;
                };
            };
            return (min);
        }
        public function get maxX():Number{
            var i:uint;
            var m:Number;
            var len:uint = this._children.length;
            var max:Number = Number.NEGATIVE_INFINITY;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                m = this._children[_temp1].maxX;
                if (m > max){
                    max = m;
                };
            };
            return (max);
        }
        public function get maxY():Number{
            var i:uint;
            var m:Number;
            var len:uint = this._children.length;
            var max:Number = Number.NEGATIVE_INFINITY;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                m = this._children[_temp1].maxY;
                if (m > max){
                    max = m;
                };
            };
            return (max);
        }
        public function get maxZ():Number{
            var i:uint;
            var m:Number;
            var len:uint = this._children.length;
            var max:Number = Number.NEGATIVE_INFINITY;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                m = this._children[_temp1].maxZ;
                if (m > max){
                    max = m;
                };
            };
            return (max);
        }
        public function get partition():Partition3D{
            return (this._explicitPartition);
        }
        public function set partition(value:Partition3D):void{
            this._explicitPartition = value;
            this.implicitPartition = ((value) ? value : ((this._parent) ? this._parent.implicitPartition : null));
        }
        public function get sceneTransform():Matrix3D{
            if (this._sceneTransformDirty){
                this.updateSceneTransform();
            };
            return (this._sceneTransform);
        }
        public function get scene():Scene3D{
            return (this._scene);
        }
        public function set scene(value:Scene3D):void{
            var i:uint;
            var len:uint = this._children.length;
            while (i < len) {
                var _temp1 = i;
                i = (i + 1);
                this._children[_temp1].scene = value;
            };
            if (this._scene == value){
                return;
            };
            if (value == null){
                this._oldScene = this._scene;
            };
            if (((((this._explicitPartition) && (this._oldScene))) && (!((this._oldScene == this._scene))))){
                this.partition = null;
            };
            if (value){
                this._oldScene = null;
            };
            this._scene = value;
            if (this._scene){
                this._scene.dispatchEvent(new Scene3DEvent(Scene3DEvent.ADDED_TO_SCENE, this));
            } else {
                if (this._oldScene){
                    this._oldScene.dispatchEvent(new Scene3DEvent(Scene3DEvent.REMOVED_FROM_SCENE, this));
                };
            };
        }
        public function get inverseSceneTransform():Matrix3D{
            if (this._inverseSceneTransformDirty){
                this._inverseSceneTransform.copyFrom(this.sceneTransform);
                this._inverseSceneTransform.invert();
                this._inverseSceneTransformDirty = false;
            };
            return (this._inverseSceneTransform);
        }
        public function get parent():ObjectContainer3D{
            return (this._parent);
        }
        public function contains(child:ObjectContainer3D):Boolean{
            return ((this._children.indexOf(child) >= 0));
        }
        public function addChild(child:ObjectContainer3D):ObjectContainer3D{
            if (child == null){
                throw (new Error("Parameter child cannot be null."));
            };
            if (child._parent){
                child._parent.removeChild(child);
            };
            if (!(child._explicitPartition)){
                child.implicitPartition = this._implicitPartition;
            };
            child.setParent(this);
            child.scene = this._scene;
            child.notifySceneTransformChange();
            child.updateMouseChildren();
            child.updateImplicitVisibility();
            this._children.push(child);
            return (child);
        }
        public function addChildren(... _args):void{
            var child:ObjectContainer3D;
            for each (child in _args) {
                this.addChild(child);
            };
        }
        public function removeChild(child:ObjectContainer3D):void{
            if (child == null){
                throw (new Error("Parameter child cannot be null"));
            };
            var childIndex:int = this._children.indexOf(child);
            if (childIndex == -1){
                throw (new Error("Parameter is not a child of the caller"));
            };
            this._children.splice(childIndex, 1);
            child.setParent(null);
            if (!(child._explicitPartition)){
                child.implicitPartition = null;
            };
        }
        public function getChildAt(index:uint):ObjectContainer3D{
            return (this._children[index]);
        }
        public function get numChildren():uint{
            return (this._children.length);
        }
        override public function lookAt(target:Vector3D, upAxis:Vector3D=null):void{
            super.lookAt(target, upAxis);
            this.notifySceneTransformChange();
        }
        override public function translateLocal(axis:Vector3D, distance:Number):void{
            super.translateLocal(axis, distance);
            this.notifySceneTransformChange();
        }
        override public function dispose():void{
            if (this.parent){
                this.parent.removeChild(this);
            };
        }
        override public function clone():Object3D{
            var clone:ObjectContainer3D = new ObjectContainer3D();
            clone.pivotPoint = pivotPoint;
            clone.transform = transform;
            clone.partition = this.partition;
            clone.name = name;
            var len:uint = this._children.length;
            var i:uint;
            while (i < len) {
                clone.addChild(ObjectContainer3D(this._children[i].clone()));
                i++;
            };
            return (clone);
        }
        override public function rotate(axis:Vector3D, angle:Number):void{
            super.rotate(axis, angle);
            this.notifySceneTransformChange();
        }
        override public function dispatchEvent(event:Event):Boolean{
            var ret:Boolean = super.dispatchEvent(event);
            if (event.bubbles){
                if (this._parent){
                    this._parent.dispatchEvent(event);
                } else {
                    if (this._scene){
                        this._scene.dispatchEvent(event);
                    };
                };
            };
            return (ret);
        }
        public function updateImplicitVisibility():void{
            var len:uint = this._children.length;
            this._implicitVisibility = ((this._parent._explicitVisibility) && (this._parent._implicitVisibility));
            var i:uint;
            while (i < len) {
                this._children[i].updateImplicitVisibility();
                i++;
            };
        }
        override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            switch (type){
                case Object3DEvent.SCENETRANSFORM_CHANGED:
                    this._listenToSceneTransformChanged = true;
                    break;
                case Object3DEvent.SCENE_CHANGED:
                    this._listenToSceneChanged = true;
                    break;
            };
        }
        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
            super.removeEventListener(type, listener, useCapture);
            if (hasEventListener(type)){
                return;
            };
            switch (type){
                case Object3DEvent.SCENETRANSFORM_CHANGED:
                    this._listenToSceneTransformChanged = false;
                    break;
                case Object3DEvent.SCENE_CHANGED:
                    this._listenToSceneChanged = false;
                    break;
            };
        }

    }
}//package away3d.containers 
