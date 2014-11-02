package wd.hud.items {
    import __AS3__.vec.*;
    import flash.geom.*;
    import wd.data.*;
    import wd.core.*;
    import wd.utils.*;
    import aze.motion.*;
    import aze.motion.easing.*;
    import flash.utils.*;
    import wd.d3.control.*;
    import wd.intro.*;
    import flash.ui.*;
    import wd.hud.*;
    import wd.d3.*;
    import wd.wq.display.*;
    import wd.hud.items.pictos.*;
    import wd.sound.*;
    import flash.media.*;
    import flash.events.*;

    public class Tracker extends Vector3D {

        private static var pool:Vector.<Tracker> = new Vector.<Tracker>();
;
        private static var transform:Vector3D;
        private static var extendedStaticSortingArea:SortArea;
        private static var staticSortingArea:SortArea;
        private static var dynamicSortingArea:SortArea;
        private static var test:Vector.<Tracker> = new Vector.<Tracker>();
;
        private static var mouseX:Number;
        private static var mouseY:Number;
        private static var mouseOver:Boolean;
        private static var mouseResults:ListVec3D;
        private static var node:ListNodeVec3D;
        private static var v:Tracker;
        private static var allwaysOnViewList:ListVec3D;
        private static var pts0:Point = new Point();
        private static var pts1:Point = new Point();
        private static var pts2:Point = new Point();
        private static var maskTop:Number;
        public static var trackerOnMouse:Tracker = null;
        public static var _staticTrackersOnView:ListVec3D = new ListVec3D();
        public static var SCALE:Number = 0;
        public static var trackerSelected:Tracker;
        private static var sound:Sound;
        private static var channel:SoundChannel;
        private static var playing:Boolean;

        public var screenPosition:Point;
        public var active:Boolean;
        public var visible:Boolean;
        public var mouseEnabled:Boolean = false;
        public var flag:uint;
        public var sortNode:ListNodeVec3D;
        public var updateCallback:Function;
        public var nodeOnTrackersList:ListNodeTracker;
        public var selected:Boolean = false;
        public var scale2:Number = 0;
        public var scaleFinal:Number;
        private var _data:TrackerData;
        private var uvs:UVPicto;
        private var sortNode2:ListNodeVec3D;

        public function Tracker(data:TrackerData, uv:UVPicto){
            super(data.position.x, data.position.y, data.position.z, data.position.w);
            this.screenPosition = new Point();
            this.uvs = uv;
            this.data = data;
            if (Intro.visible){
                this.scale2 = 1;
            } else {
                eaze(this).delay(Math.random()).to(1, {scale2:1}).easing(Expo.easeOut);
            };
            this.playSndApear();
        }
        public static function init():void{
            staticSortingArea = new SortArea(Constants.GRID_TRACKERS_CASE_SIZE, Locator.world_rect);
            dynamicSortingArea = new SortArea(Constants.GRID_TRACKERS_CASE_SIZE, Locator.world_rect, true);
            extendedStaticSortingArea = new SortArea((Constants.GRID_TRACKERS_CASE_SIZE * 2), Locator.world_rect);
        }
        public static function dispose():void{
            var l:int = staticSortingArea.caseCount;
            while (l--) {
                purge(l, 0);
            };
            l = dynamicSortingArea.caseCount;
            while (l--) {
                purge(l, 1);
            };
            l = extendedStaticSortingArea.caseCount;
            while (l--) {
                purge(l, 2);
            };
            staticSortingArea.clear();
            staticSortingArea = null;
            dynamicSortingArea.clear();
            dynamicSortingArea = null;
            extendedStaticSortingArea.clear();
            extendedStaticSortingArea = null;
        }
        public static function show():void{
            eaze(Tracker).delay((Math.random() * 2)).to(3, {SCALE:[0, 1.15, 1]}).easing(Expo.easeOut);
        }
        public static function hide():void{
            eaze(Tracker).to(4, {SCALE:0});
        }
        public static function get staticTrackersOnView():ListVec3D{
            return (_staticTrackersOnView);
        }
        public static function update(scene:Simulation, quad:WQuad):void{
            var t:Tracker;
            var t2:int;
            if (Config.DEBUG_TRACKER){
                t2 = getTimer();
            };
            var target:Vector3D = scene.cameraTargetPos;
            maskTop = (scene.camera.y / CameraController.MAX_HEIGHT);
            pts1.x = (scene.camera.x - target.x);
            pts1.y = (scene.camera.z - target.z);
            pts1.normalize(1);
            pts0.x = (scene.camera.x + ((pts1.x * 1000) * maskTop));
            pts0.y = (scene.camera.z + ((pts1.y * 1000) * maskTop));
            pts1.x = (pts0.x - target.x);
            pts1.y = (pts0.y - target.z);
            mouseOver = false;
            _staticTrackersOnView = staticSortingArea.getNeighbors(target, null, 1);
            mouseResults = new ListVec3D();
            drawListOnGPU(scene, quad, _staticTrackersOnView);
            node = dynamicSortingArea.entitys.head;
            while (node) {
                t = (node.data as Tracker);
                t.x = t.data.object.x;
                t.y = t.data.object.y;
                t.z = t.data.object.z;
                t.w = t.data.object.w;
                node = node.next;
            };
            dynamicSortingArea.update();
            var vec:ListVec3D = extendedStaticSortingArea.getNeighbors(target, null, 2);
            drawListOnGPUWithCheckFront(scene, quad, vec);
            vec = dynamicSortingArea.getNeighbors(target, null, 1);
            drawListOnGPU(scene, quad, vec);
            v = null;
            var nodeHead:ListNodeVec3D = mouseResults.head;
            if (nodeHead != null){
                if (nodeHead.next != null){
                    zSort(mouseResults);
                };
                node = nodeHead.next;
                while (node) {
                    v = (node.data as Tracker);
                    addToQuad(v, quad);
                    node = node.next;
                };
                v = (nodeHead.data as Tracker);
                quad.add((v.screenPosition.x - ((v.uvs.halfWidth * v.scale2) * SCALE)), (v.screenPosition.y - ((v.uvs.halfHeight * v.scale2) * SCALE)), ((v.uvs.width * v.scale2) * SCALE), ((v.uvs.height * v.scale2) * SCALE), v.uvs.uvsRoll.x, v.uvs.uvsRoll.y, v.uvs.uvsRoll.xC, v.uvs.uvsRoll.yC);
            };
            if (!(Intro.visible)){
                Mouse.cursor = ((mouseOver) ? MouseCursor.BUTTON : MouseCursor.AUTO);
            };
            if (Config.DEBUG_TRACKER){
                trace("grid Sorting+Z sorting+ draw quad", (getTimer() - t2), "ms");
            };
            if (Tracker.trackerOnMouse != v){
                if (Tracker.trackerOnMouse != null){
                    Hud.getInstance().trackerRollOut(Tracker.trackerOnMouse);
                };
                if (v != null){
                    Hud.getInstance().trackerRollOver(v);
                };
            };
            Tracker.trackerOnMouse = v;
            if (((!((Tracker.trackerOnMouse == null))) && (Hud.getInstance().mouseIsClicked))){
                Hud.getInstance().trackerClick(Tracker.trackerOnMouse);
                v.selected = true;
                if (Tracker.trackerSelected != null){
                    Tracker.trackerSelected.selected = false;
                };
                Tracker.trackerSelected = v;
            };
            Hud.getInstance().mouseIsClicked = false;
        }
        public static function getTracker(data:TrackerData, uv:UVPicto=null, flag:uint=0, mouseEnabled:Boolean=false):Tracker{
            var t:Tracker = pool.shift();
            if (t == null){
                t = new Tracker(data, uv);
                t.mouseEnabled = mouseEnabled;
            } else {
                t.init(data, uv);
                t.mouseEnabled = mouseEnabled;
            };
            t.flag = flag;
            if (flag == 0){
                t.sortNode = staticSortingArea.addEntity(t);
            } else {
                if (flag == 1){
                    t.sortNode = dynamicSortingArea.addEntity(t);
                    t.sortNode2 = dynamicSortingArea.nodeEntity;
                } else {
                    t.sortNode = extendedStaticSortingArea.addEntity(t);
                };
            };
            return (t);
        }
        public static function purge(i:int, flag:int=0):void{
            var list:ListVec3D;
            if (flag == 0){
                list = staticSortingArea.getEntityCaseGrid(i);
                staticSortingArea.clearCaseGrid(i);
            } else {
                if (flag == 1){
                    list = dynamicSortingArea.getEntityCaseGrid(i);
                    dynamicSortingArea.clearCaseGrid(i);
                } else {
                    list = extendedStaticSortingArea.getEntityCaseGrid(i);
                    extendedStaticSortingArea.clearCaseGrid(i);
                };
            };
            var node:ListNodeVec3D = list.head;
            while (node) {
                (node.data as Tracker).recycle();
                node = node.next;
            };
        }
        private static function drawListOnGPUWithCheckFront(scene:Simulation, quad:WQuad, vec:ListVec3D):void{
            var vec2:Vector3D;
            var dist:Number;
            node = vec.head;
            while (node) {
                v = (node.data as Tracker);
                vec2 = v.subtract(scene.cameraTargetPos);
                dist = (Math.max(30, (vec2.length - 200)) / 4);
                v.y = dist;
                if (onView(scene, v)){
                    transform = scene.view.project(v);
                    if ((((((transform.x < 300)) || ((transform.x > (scene.view.width - 300))))) || ((transform.y < 0)))){
                        node = node.next;
                        continue;
                    };
                    v.screenPosition.x = transform.x;
                    v.screenPosition.y = transform.y;
                    v.w = transform.z;
                    v.scaleFinal = (v.scale2 * SCALE);
                    quad.add((v.screenPosition.x - (v.uvs.halfWidth * v.scaleFinal)), (v.screenPosition.y - (v.uvs.halfHeight * v.scaleFinal)), (v.uvs.width * v.scaleFinal), (v.uvs.height * v.scaleFinal), v.uvs.uvs.x, v.uvs.uvs.y, v.uvs.uvs.xC, v.uvs.uvs.yC);
                };
                node = node.next;
            };
        }
        private static function onView(scene:Simulation, v:Tracker):Boolean{
            pts2.x = (pts0.x - v.x);
            pts2.y = (pts0.y - v.z);
            return ((((pts2.x * pts1.x) + (pts2.y * pts1.y)) > 0));
        }
        private static function drawListOnGPU(scene:Simulation, quad:WQuad, vec:ListVec3D):void{
            var locked:Boolean = !((Hud.getInstance().popinManager.currentPopin == null));
            node = vec.head;
            while (node) {
                v = (node.data as Tracker);
                if (v.active){
                    v.w = -1;
                    if (onView(scene, v)){
                        transform = scene.view.project(v);
                        v.screenPosition.x = transform.x;
                        v.screenPosition.y = transform.y;
                        v.w = transform.z;
                    } else {
                        v.w = -1;
                    };
                };
                node = node.next;
            };
            zSort(vec);
            mouseX = scene.stage.mouseX;
            mouseY = scene.stage.mouseY;
            node = vec.head;
            while (node) {
                v = (node.data as Tracker);
                if (v.active){
                    if (v.w != -1){
                        if ((((v.screenPosition.y > 0)) && ((v.screenPosition.y < scene.view.height)))){
                            v.scaleFinal = (v.scale2 * SCALE);
                            if (((v.mouseEnabled) && (!(Hud.getInstance().mouseIsOver)))){
                                if (((!(locked)) && (isMouseOver((v.screenPosition.x - v.uvs.btnSizeD2), (v.screenPosition.y - v.uvs.btnSizeD2), v.uvs.btnSize, v.uvs.btnSize)))){
                                    mouseOver = true;
                                    mouseResults.insert(v);
                                } else {
                                    addToQuad(v, quad);
                                };
                            } else {
                                addToQuad(v, quad);
                            };
                        };
                    };
                };
                node = node.next;
            };
        }
        private static function addToQuad(v:Tracker, quad:WQuad):void{
            if (v.selected){
                quad.add((v.screenPosition.x - (v.uvs.halfWidth * v.scaleFinal)), (v.screenPosition.y - (v.uvs.halfHeight * v.scaleFinal)), (v.uvs.width * v.scaleFinal), (v.uvs.height * v.scaleFinal), v.uvs.uvsRoll.x, v.uvs.uvsRoll.y, v.uvs.uvsRoll.xC, v.uvs.uvsRoll.yC);
            } else {
                quad.add((v.screenPosition.x - (v.uvs.halfWidth * v.scaleFinal)), (v.screenPosition.y - (v.uvs.halfHeight * v.scaleFinal)), (v.uvs.width * v.scaleFinal), (v.uvs.height * v.scaleFinal), v.uvs.uvs.x, v.uvs.uvs.y, v.uvs.uvs.xC, v.uvs.uvs.yC);
            };
        }
        private static function isMouseOver(x:Number, y:Number, w:int, h:int):Boolean{
            if (x > mouseX){
                return (false);
            };
            if (y > mouseY){
                return (false);
            };
            if ((x + w) < mouseX){
                return (false);
            };
            if ((y + h) < mouseY){
                return (false);
            };
            return (true);
        }
        private static function zSort(vec:ListVec3D):void{
            var f:ListNodeVec3D;
            var n:ListNodeVec3D;
            var j:ListNodeVec3D;
            var p:ListNodeVec3D;
            var c:ListNodeVec3D;
            if (vec.head == null){
                return;
            };
            if (vec.head.next == null){
                return;
            };
            f = vec.head;
            c = f.next;
            while (c) {
                n = c.next;
                p = c.prev;
                if (c.data.w > p.data.w){
                    j = p;
                    while (j.prev) {
                        if (c.data.w > j.prev.data.w){
                            j = j.prev;
                        } else {
                            break;
                        };
                    };
                    if (n){
                        p.next = n;
                        n.prev = p;
                    } else {
                        p.next = null;
                    };
                    if (j == f){
                        c.prev = null;
                        c.next = j;
                        j.prev = c;
                        f = c;
                    } else {
                        c.prev = j.prev;
                        j.prev.next = c;
                        c.next = j;
                        j.prev = c;
                    };
                };
                c = n;
            };
            vec.head = f;
        }

        private function playSndApear():void{
            var vec2:Vector3D = subtract(Simulation.instance.cameraTargetPos);
            var v:Number = vec2.length;
            if (v < 1000){
                if (((playing) || ((SoundManager.MASTER_VOLUME == 0)))){
                    return;
                };
                playing = true;
                sound = ((sound) || (SoundLibrary.getSound("ApparitionSignalisation")));
                channel = sound.play();
                channel.addEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
                channel.soundTransform.volume = 0.5;
            };
        }
        private function onSoundComplete(e:Event):void{
            channel.removeEventListener(Event.SOUND_COMPLETE, this.onSoundComplete);
            channel.stop();
            playing = false;
        }
        public function recycle():void{
            if (this.flag == 0){
                staticSortingArea.deleteEntity(this.sortNode);
            } else {
                if (this.flag == 1){
                    dynamicSortingArea.deleteEntity(this.sortNode, this.sortNode2);
                } else {
                    extendedStaticSortingArea.deleteEntity(this.sortNode);
                };
            };
            this.active = false;
            Hud.removeItem(this._data.type, this.nodeOnTrackersList);
            TrackerData.remove(this._data.id);
            this._data = null;
            this.uvs = null;
            pool.push(this);
        }
        public function init(data:TrackerData, uv:UVPicto):Tracker{
            this.uvs = uv;
            this.data = data;
            return (this);
        }
        public function get data():TrackerData{
            return (this._data);
        }
        public function set data(value:TrackerData):void{
            this._data = value;
            x = this._data.position.x;
            y = this._data.position.y;
            z = this._data.position.z;
            w = this._data.position.w;
            this.active = AppState.isActive(this._data.type);
        }

    }
}//package wd.hud.items 
