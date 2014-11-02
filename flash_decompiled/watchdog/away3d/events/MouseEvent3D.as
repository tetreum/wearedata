package away3d.events {
    import flash.events.*;
    import away3d.containers.*;
    import flash.geom.*;
    import away3d.core.base.*;
    import away3d.materials.*;

    public class MouseEvent3D extends Event {

        public static const MOUSE_OVER:String = "mouseOver3d";
        public static const MOUSE_OUT:String = "mouseOut3d";
        public static const MOUSE_UP:String = "mouseUp3d";
        public static const MOUSE_DOWN:String = "mouseDown3d";
        public static const MOUSE_MOVE:String = "mouseMove3d";
        public static const CLICK:String = "click3d";
        public static const DOUBLE_CLICK:String = "doubleClick3d";
        public static const MOUSE_WHEEL:String = "mouseWheel3d";

        private var _propagataionStopped:Boolean;
        public var screenX:Number;
        public var screenY:Number;
        public var view:View3D;
        public var object:ObjectContainer3D;
        public var renderable:IRenderable;
        public var material:MaterialBase;
        public var uv:Point;
        public var localPosition:Vector3D;
        public var localNormal:Vector3D;
        public var ctrlKey:Boolean;
        public var altKey:Boolean;
        public var shiftKey:Boolean;
        public var delta:int;

        public function MouseEvent3D(type:String){
            super(type, true, true);
        }
        override public function get bubbles():Boolean{
            return (((super.bubbles) && (!(this._propagataionStopped))));
        }
        override public function stopPropagation():void{
            super.stopPropagation();
            this._propagataionStopped = true;
        }
        override public function stopImmediatePropagation():void{
            super.stopImmediatePropagation();
            this._propagataionStopped = true;
        }
        override public function clone():Event{
            var result:MouseEvent3D = new MouseEvent3D(type);
            if (isDefaultPrevented()){
                result.preventDefault();
            };
            result.screenX = this.screenX;
            result.screenY = this.screenY;
            result.view = this.view;
            result.object = this.object;
            result.renderable = this.renderable;
            result.material = this.material;
            result.uv = this.uv;
            result.localPosition = this.localPosition;
            result.localNormal = this.localNormal;
            result.ctrlKey = this.ctrlKey;
            result.shiftKey = this.shiftKey;
            return (result);
        }
        public function get scenePosition():Vector3D{
            if ((this.object is ObjectContainer3D)){
                return (ObjectContainer3D(this.object).sceneTransform.transformVector(this.localPosition));
            };
            return (this.localPosition);
        }
        public function get sceneNormal():Vector3D{
            var sceneNormal:Vector3D;
            if ((this.object is ObjectContainer3D)){
                sceneNormal = ObjectContainer3D(this.object).sceneTransform.deltaTransformVector(this.localNormal);
                sceneNormal.normalize();
                return (sceneNormal);
            };
            return (this.localNormal);
        }

    }
}//package away3d.events 
