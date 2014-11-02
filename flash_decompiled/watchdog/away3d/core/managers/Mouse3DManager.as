package away3d.core.managers {
    import away3d.events.*;
    import flash.geom.*;
    import __AS3__.vec.*;
    import flash.events.*;
    import away3d.core.pick.*;
    import away3d.containers.*;

    public class Mouse3DManager {

        private static var _mouseUp:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_UP);
        private static var _mouseClick:MouseEvent3D = new MouseEvent3D(MouseEvent3D.CLICK);
        private static var _mouseOut:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_OUT);
        private static var _mouseDown:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_DOWN);
        private static var _mouseMove:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_MOVE);
        private static var _mouseOver:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_OVER);
        private static var _mouseWheel:MouseEvent3D = new MouseEvent3D(MouseEvent3D.MOUSE_WHEEL);
        private static var _mouseDoubleClick:MouseEvent3D = new MouseEvent3D(MouseEvent3D.DOUBLE_CLICK);

        private var _activeView:View3D;
        private var _updateDirty:Boolean;
        private var _nullVector:Vector3D;
        protected var _collidingObject:PickingCollisionVO;
        private var _previousCollidingObject:PickingCollisionVO;
        private var _queuedEvents:Vector.<MouseEvent3D>;
        private var _mouseMoveEvent:MouseEvent;
        private var _forceMouseMove:Boolean;
        private var _mousePicker:IPicker;

        public function Mouse3DManager(){
            this._nullVector = new Vector3D();
            this._queuedEvents = new Vector.<MouseEvent3D>();
            this._mouseMoveEvent = new MouseEvent(MouseEvent.MOUSE_MOVE);
            this._mousePicker = PickingType.RAYCAST_FIRST_ENCOUNTERED;
            super();
        }
        public function updateCollider(view:View3D):void{
            this._previousCollidingObject = this._collidingObject;
            if ((((view == this._activeView)) && (((this._forceMouseMove) || (this._updateDirty))))){
                this._collidingObject = this._mousePicker.getViewCollision(view.mouseX, view.mouseY, view);
            };
            this._updateDirty = false;
        }
        public function fireMouseEvents():void{
            var i:uint;
            var len:uint;
            var event:MouseEvent3D;
            var dispatcher:ObjectContainer3D;
            if (this._collidingObject != this._previousCollidingObject){
                if (this._previousCollidingObject){
                    this.queueDispatch(_mouseOut, this._mouseMoveEvent, this._previousCollidingObject);
                };
                if (this._collidingObject){
                    this.queueDispatch(_mouseOver, this._mouseMoveEvent, this._collidingObject);
                };
            };
            if (((this._forceMouseMove) && (this._collidingObject))){
                this.queueDispatch(_mouseMove, this._mouseMoveEvent, this._collidingObject);
            };
            len = this._queuedEvents.length;
            i = 0;
            while (i < len) {
                event = this._queuedEvents[i];
                dispatcher = event.object;
                while (((dispatcher) && (!(dispatcher._ancestorsAllowMouseEnabled)))) {
                    dispatcher = dispatcher.parent;
                };
                if (dispatcher){
                    dispatcher.dispatchEvent(event);
                };
                i++;
            };
            this._queuedEvents.length = 0;
        }
        private function queueDispatch(event:MouseEvent3D, sourceEvent:MouseEvent, collider:PickingCollisionVO=null):void{
            event.ctrlKey = sourceEvent.ctrlKey;
            event.altKey = sourceEvent.altKey;
            event.shiftKey = sourceEvent.shiftKey;
            event.delta = sourceEvent.delta;
            event.screenX = sourceEvent.localX;
            event.screenY = sourceEvent.localY;
            collider = ((collider) || (this._collidingObject));
            if (collider){
                event.object = collider.entity;
                event.renderable = collider.renderable;
                event.uv = collider.uv;
                event.localPosition = collider.localPosition;
                event.localNormal = collider.localNormal;
            } else {
                event.uv = null;
                event.object = null;
                event.localPosition = this._nullVector;
                event.localNormal = this._nullVector;
            };
            this._queuedEvents.push(event);
        }
        private function onMouseMove(event:MouseEvent):void{
            if (this._collidingObject){
                this.queueDispatch(_mouseMove, (this._mouseMoveEvent = event));
            };
            this._updateDirty = true;
        }
        private function onMouseOut(event:MouseEvent):void{
            this._activeView = null;
            if (this._collidingObject){
                this.queueDispatch(_mouseOut, event, this._collidingObject);
            };
            this._updateDirty = true;
        }
        private function onMouseOver(event:MouseEvent):void{
            this._activeView = (event.currentTarget as View3D);
            if (this._collidingObject){
                this.queueDispatch(_mouseOver, event, this._collidingObject);
            };
            this._updateDirty = true;
        }
        private function onClick(event:MouseEvent):void{
            if (this._collidingObject){
                this.queueDispatch(_mouseClick, event);
            };
            this._updateDirty = true;
        }
        private function onDoubleClick(event:MouseEvent):void{
            if (this._collidingObject){
                this.queueDispatch(_mouseDoubleClick, event);
            };
            this._updateDirty = true;
        }
        private function onMouseDown(event:MouseEvent):void{
            if (this._collidingObject){
                this.queueDispatch(_mouseDown, event);
            };
            this._updateDirty = true;
        }
        private function onMouseUp(event:MouseEvent):void{
            if (this._collidingObject){
                this.queueDispatch(_mouseUp, event);
            };
            this._updateDirty = true;
        }
        private function onMouseWheel(event:MouseEvent):void{
            if (this._collidingObject){
                this.queueDispatch(_mouseWheel, event);
            };
            this._updateDirty = true;
        }
        public function enableMouseListeners(view:View3D):void{
            view.addEventListener(MouseEvent.CLICK, this.onClick);
            view.addEventListener(MouseEvent.DOUBLE_CLICK, this.onDoubleClick);
            view.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            view.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            view.addEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            view.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            view.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            view.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
        public function disableMouseListeners(view:View3D):void{
            view.removeEventListener(MouseEvent.CLICK, this.onClick);
            view.removeEventListener(MouseEvent.DOUBLE_CLICK, this.onDoubleClick);
            view.removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
            view.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
            view.removeEventListener(MouseEvent.MOUSE_UP, this.onMouseUp);
            view.removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
            view.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            view.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        }
        public function get forceMouseMove():Boolean{
            return (this._forceMouseMove);
        }
        public function set forceMouseMove(value:Boolean):void{
            this._forceMouseMove = value;
        }
        public function get mousePicker():IPicker{
            return (this._mousePicker);
        }
        public function set mousePicker(value:IPicker):void{
            this._mousePicker = value;
        }

    }
}//package away3d.core.managers 
