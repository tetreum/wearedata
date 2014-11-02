package wd.d3.control {
    import __AS3__.vec.*;
    import wd.events.*;
    import aze.motion.*;
    import wd.core.*;
    import away3d.cameras.lenses.*;
    import flash.geom.*;
    import away3d.cameras.*;
    import away3d.containers.*;
    import flash.events.*;
    import wd.utils.*;
    import biga.utils.*;
    import flash.display.*;
    import aze.motion.easing.*;
    import wd.hud.items.*;

    public class CameraController extends EventDispatcher {

        public static const TOP_VIEW:String = "topView";
        public static const BIRD_VIEW:String = "birdView";
        public static const BLOCK_VIEW:String = "blockView";
        public static const STREET_VIEW:String = "streetView";

        private static var VIEWS:Vector.<String> = Vector.<String>([TOP_VIEW, STREET_VIEW]);
        private static var VIEWS_ITERATOR:int = 0;
        private static var _VIEW:String = VIEWS[VIEWS_ITERATOR];
        public static var MIN_HEIGHT:Number;
        public static var MAX_HEIGHT:Number;
        public static var CAM_HEIGHT:Number;
        public static var CAM_TARGET_HEIGHT:Number;
        public static var instance:CameraController;
        public static var CAM_MIN_RAIDUS:Number = -1;
        public static var CAM_MAX_RAIDUS:Number = -100;
        public static var CAM_RAIDUS:Number = CAM_MIN_RAIDUS;
        public static var MIN_FOV:Number = 60;
        public static var MAX_FOV:Number = -15;
        public static var locked:Boolean;

        public var FRICTION_X:Number = 0.75;
        public var FRICTION_Y:Number = 0.1;
        public var FRICTION_Z:Number = 0.65;
        public var camera:Camera3D;
        private var perspective:PerspectiveLens;
        public var target:ObjectContainer3D;
        private var objectToListenTo:InteractiveObject;
        private var mouseDown:Boolean;
        public var tweenTime:Number = 0;
        private var mouse:Point;
        private var lastMouse:Point;
        private var reachTarget:Boolean;
        private var location:Location;
        private var targetLocation:Point;
        private var followTarget:Tracker;
        private var following:Boolean;
        public var radius:Number;
        public var zoomLevel:Number = 1;
        public var mouseWheelAccu:Number = 0;
        public var mouseWheelAccuLimit:Number = -84;

        public function CameraController(location:Location, camera:Camera3D, target:ObjectContainer3D){
            super();
            instance = this;
            this.location = location;
            this.location.y = -5;
            this.camera = camera;
            this.target = target;
            MIN_HEIGHT = Config.CAM_MIN_HEIGHT;
            MAX_HEIGHT = Config.CAM_MAX_HEIGHT;
            CAM_MIN_RAIDUS = Config.CAM_MIN_RADIUS;
            CAM_MAX_RAIDUS = Config.CAM_MAX_RADIUS;
            MIN_FOV = Config.CAM_MIN_FOV;
            MAX_FOV = (Config.CAM_MAX_FOV - MIN_FOV);
            this.camera.y = (CAM_HEIGHT = MAX_HEIGHT);
            VIEW = VIEWS[VIEWS_ITERATOR];
            this.perspective = new PerspectiveLens(60);
            this.perspective.far = 10000000;
            this.perspective.near = 1;
            this.camera.lens = this.perspective;
            this.mouse = new Point();
            this.lastMouse = new Point();
        }
        public static function forward(value:Number=0.01, apply:Boolean=false):void{
            instance.zoomLevel = (instance.zoomLevel + value);
            if (apply){
                VIEW = STREET_VIEW;
            };
            instance.checkZoomLevel();
            instance.dispatchEvent(new NavigatorEvent(NavigatorEvent.ZOOM_CHANGE));
            instance.mouseWheelAccu = 0;
        }
        public static function backward(value:Number=0.01, apply:Boolean=false):void{
            instance.zoomLevel = (instance.zoomLevel - value);
            if (apply){
                VIEW = TOP_VIEW;
            };
            instance.checkZoomLevel();
            instance.dispatchEvent(new NavigatorEvent(NavigatorEvent.ZOOM_CHANGE));
            if (instance.zoomLevel <= 0){
                if (instance.zoomLevel <= 0){
                    instance.mouseWheelAccu = (instance.mouseWheelAccu - 7);
                };
                if (instance.mouseWheelAccu <= instance.mouseWheelAccuLimit){
                    VIEW = TOP_VIEW;
                };
            };
        }
        public static function forceLocation():void{
            instance.location.reset();
            instance.camera.x = instance.location.x;
            instance.camera.z = instance.location.z;
            instance.target.x = instance.location.x;
            instance.target.z = instance.location.z;
        }
        public static function get VIEW():String{
            return (_VIEW);
        }
        public static function set VIEW(value:String):void{
            _VIEW = value;
            switch (value){
                case TOP_VIEW:
                    if (instance.mouseWheelAccu <= instance.mouseWheelAccuLimit){
                        VIEWS_ITERATOR = 0;
                        instance.FRICTION_X = (instance.FRICTION_Z = 1);
                        instance.dispatchEvent(new NavigatorEvent(NavigatorEvent.INTRO_SHOW));
                        instance.mouseWheelAccu = 0;
                    };
                    break;
                case STREET_VIEW:
                    VIEWS_ITERATOR = 1;
                    eaze(instance).to(2, {
                        FRICTION_X:0.25,
                        FRICTION_Z:0.25
                    });
                    instance.mouseWheelAccu = 0;
                    instance.zoomLevel = 1;
                    break;
            };
        }
        public static function applyView():void{
            instance.camera.y = CAM_TARGET_HEIGHT;
        }
        public static function nextView():void{
            instance.mouseWheelAccu = 0;
            VIEWS_ITERATOR++;
            VIEWS_ITERATOR = ((VIEWS_ITERATOR)>(VIEWS.length - 1)) ? (VIEWS.length - 1) : VIEWS_ITERATOR;
            VIEW = VIEWS[VIEWS_ITERATOR];
        }
        public static function prevView(delta:Number):void{
            instance.mouseWheelAccu = (instance.mouseWheelAccu + delta);
            VIEWS_ITERATOR--;
            VIEWS_ITERATOR = ((VIEWS_ITERATOR)<0) ? 0 : VIEWS_ITERATOR;
            VIEW = VIEWS[VIEWS_ITERATOR];
        }

        private function onUp(e:MouseEvent):void{
            this.mouseDown = false;
        }
        private function onDown(e:MouseEvent):void{
            this.mouseDown = true;
            this.lastMouse.x = (this.mouse.x = this.objectToListenTo.mouseX);
            this.lastMouse.y = (this.mouse.y = this.objectToListenTo.mouseY);
        }
        private function onWheel(e:MouseEvent):void{
            this.zoomLevel = (this.zoomLevel + (e.delta / 140));
            this.checkZoomLevel();
            instance.dispatchEvent(new NavigatorEvent(NavigatorEvent.ZOOM_CHANGE));
            if (this.zoomLevel <= 0){
                if (e.delta <= 0){
                    this.mouseWheelAccu = (this.mouseWheelAccu - 7);
                };
                if (this.mouseWheelAccu <= this.mouseWheelAccuLimit){
                    VIEW = TOP_VIEW;
                };
            };
        }
        private function checkZoomLevel():void{
            if (this.zoomLevel < 0){
                this.zoomLevel = 0;
            };
            if (this.zoomLevel > 1){
                this.zoomLevel = 1;
            };
        }
        public function update(location:Location):void{
            if (this.location == null){
                this.location = location;
                this.location.y = 10;
            };
            if (this.reachTarget){
                return;
            };
            if (this.following){
                this.targetLocation = ((this.targetLocation) || (new Point()));
                Locator.LOCATE(this.followTarget.x, this.followTarget.z, this.targetLocation);
                Locator.LONGITUDE = (Locator.LONGITUDE + ((this.targetLocation.x - Locator.LONGITUDE) * 0.25));
                Locator.LATITUDE = (Locator.LATITUDE + ((this.targetLocation.y - Locator.LATITUDE) * 0.25));
                location.update(false);
                this.updateCameraPosition();
                return;
            };
            this.mouse.x = this.objectToListenTo.mouseX;
            this.mouse.y = this.objectToListenTo.mouseY;
            var a:Number = location.angle;
            var v:Number = location.velocity;
            var dx:Number = 0;
            var dz:Number = 0;
            if (this.mouseDown){
                dx = (this.lastMouse.x - this.objectToListenTo.mouseX);
                dz = (this.lastMouse.y - this.objectToListenTo.mouseY);
                location.angle = (a + (Math.PI / 2));
                location.velocity = ((-(dx) * location.SPEED) * 0.1);
                location.update(false);
                location.angle = a;
                location.velocity = ((-(dz) * location.SPEED) * 0.1);
                location.update(false);
                location.velocity = v;
            } else {
                location.update(true);
            };
            this.updateCameraPosition();
        }
        private function updateCameraPosition():void{
            if (this.camera.y < MIN_HEIGHT){
                this.camera.y = MIN_HEIGHT;
            };
            if (this.camera.y > MAX_HEIGHT){
                this.camera.y = MAX_HEIGHT;
            };
            if (VIEW == STREET_VIEW){
                CAM_TARGET_HEIGHT = (MIN_HEIGHT + ((1 - this.zoomLevel) * ((MAX_HEIGHT * 0.5) - MIN_HEIGHT)));
            };
            CAM_HEIGHT = GeomUtils.normalize(this.camera.y, MIN_HEIGHT, MAX_HEIGHT);
            this.perspective.fieldOfView = (MIN_FOV + (CAM_HEIGHT * MAX_FOV));
            this.target.x = (this.target.x + ((this.location.x - this.target.x) * 0.1));
            this.target.z = (this.target.z + ((this.location.z - this.target.z) * 0.1));
            this.radius = (CAM_MIN_RAIDUS + (Math.min(0.99, (1 - CAM_HEIGHT)) * CAM_MAX_RAIDUS));
            var dx:Number = (this.target.x + (Math.cos(this.location.angle) * this.radius));
            var dz:Number = (this.target.z + (Math.sin(this.location.angle) * this.radius));
            this.FRICTION_X = (this.FRICTION_Z = 1);
            if (isNaN(CAM_HEIGHT)){
                CAM_TARGET_HEIGHT = (MAX_HEIGHT * 0.75);
            };
            this.camera.x = (this.camera.x + ((dx - this.camera.x) * this.FRICTION_X));
            if (!(locked)){
                this.camera.y = (this.camera.y + ((CAM_TARGET_HEIGHT - this.camera.y) * this.FRICTION_Y));
            };
            this.camera.z = (this.camera.z + ((dz - this.camera.z) * this.FRICTION_Z));
            this.camera.lookAt(this.target.position);
        }
        public function set listenTarget(value:InteractiveObject):void{
            this.objectToListenTo = value;
            this.objectToListenTo.addEventListener(MouseEvent.MOUSE_UP, this.onUp);
            this.objectToListenTo.addEventListener(MouseEvent.MOUSE_OUT, this.onUp);
            this.objectToListenTo.addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
            this.objectToListenTo.addEventListener(MouseEvent.MOUSE_WHEEL, this.onWheel);
        }
        public function setTarget(tracker:Tracker, lon:Number, lat:Number):void{
            this.reachTarget = true;
            this.targetLocation = new Point(lon, lat);
            var o:Point = new Point(Locator.LONGITUDE, Locator.LATITUDE);
            var p:Point = new Point(lon, lat);
            var d:Number = GeomUtils.distance(o, p);
            var a:Number = GeomUtils.angle(o, p);
            var t:Number = 0.75;
            if (d < 0.0002){
                this.updateCameraPosition();
                this.onTargetReached(tracker);
                return;
            };
            this.FRICTION_X = (this.FRICTION_Z = 1);
            this.tweenTime = 0;
            eaze(this).to(t, {tweenTime:1}, false).easing(Expo.easeOut).onUpdate(this.onTargetUpdate).onComplete(this.onTargetReached, tracker);
        }
        public function follow(tracker:Tracker):void{
            this.following = true;
            this.followTarget = tracker;
        }
        public function unfollow():void{
            this.following = false;
            this.followTarget = null;
        }
        private function onTargetUpdate():void{
            Locator.LONGITUDE = (Locator.LONGITUDE + ((this.targetLocation.x - Locator.LONGITUDE) * this.tweenTime));
            Locator.LATITUDE = (Locator.LATITUDE + ((this.targetLocation.y - Locator.LATITUDE) * this.tweenTime));
            this.location.update(false);
            this.updateCameraPosition();
        }
        private function onTargetReached(tracker:Tracker):void{
            this.reachTarget = false;
            var s:String = VIEW;
            VIEW = s;
            dispatchEvent(new NavigatorEvent(NavigatorEvent.TARGET_REACHED, tracker));
        }

    }
}//package wd.d3.control 
