package wd.d3 {
    import flash.events.*;
    import flash.geom.*;
    import away3d.core.managers.*;
    import away3d.events.*;
    import away3d.containers.*;
    import away3d.cameras.*;
    import wd.core.*;
    import flash.text.*;
    import flash.display.*;
    import wd.d3.lights.*;
    import wd.d3.material.*;
    import wd.d3.control.*;
    import wd.d3.geom.*;
    import wd.d3.geom.particle.*;
    import wd.d3.geom.objects.*;
    import wd.d3.geom.monuments.*;
    import wd.utils.*;
    import wd.d3.geom.building.*;
    import wd.d3.geom.river.*;
    import wd.d3.geom.parcs.*;
    import wd.d3.geom.axes.*;
    import wd.d3.geom.rails.*;
    import wd.d3.geom.metro.*;
    import wd.d3.geom.objects.linker.*;
    import away3d.debug.*;
    import flash.ui.*;
    import wd.events.*;
    import wd.http.*;
    import away3d.filters.*;
    import away3d.entities.*;

    public class Simulation extends Sprite {

        public static var instance:Simulation;
        public static var log_tf:TextField;
        public static var CONTEXT_READY:String = "CONTEXT_READY";
        public static var stage3DProxy:Stage3DProxy;

        public var scene:Scene3D;
        public var camera:Camera3D;
        public var view:View3D;
        private var dofFilter:DepthOfFieldFilter3D;
        private var bloom:BloomFilter3D;
        private var ground:Ground;
        private var buildings_service:BuildingService;
        private var buildings:BuildingMesh3;
        private var data:DataService;
        private var metro:Metro;
        public var container:ObjectContainer3D;
        private var target:ObjectContainer3D;
        public var location:Location;
        public var controller:CameraController;
        public var navigation:Navigator;
        public var itemObjects:ItemObjectsManager;
        private var trident:Trident;
        private var mouseDown:Boolean;
        private var stage3DManager:Stage3DManager;
        private var cyclo:Mesh;
        public var stage3DProxy:Stage3DProxy;
        private var monuments:MonumentsMesh;
        private var memoryText:TextField;
        private var rivers:Rivers;
        private var parcs:Parcs;
        private var particles:ParticleMesh;
        private var links:Linker;
        private var rails:Rails;

        public function Simulation(){
            super();
            addEventListener(Event.ADDED_TO_STAGE, this.initProxies);
        }
        public function get cameraTargetPos():Vector3D{
            return (this.target.position);
        }
        private function initProxies(e:Event):void{
            removeEventListener(Event.ADDED_TO_STAGE, this.initProxies);
            this.stage3DManager = Stage3DManager.getInstance(stage);
            this.stage3DProxy = this.stage3DManager.getFreeStage3DProxy();
            this.stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, this.onContextCreated);
            this.stage3DProxy.antiAlias = 2;
            this.stage3DProxy.color = 0;
            Simulation.stage3DProxy = this.stage3DProxy;
        }
        private function onContextCreated(event:Stage3DEvent):void{
            this.scene = new Scene3D();
            this.camera = new Camera3D();
            this.view = new View3D();
            this.view.stage3DProxy = this.stage3DProxy;
            this.view.scene = this.scene;
            this.view.camera = this.camera;
            addChild(this.view);
            this.view.shareContext = true;
            this.container = new ObjectContainer3D();
            this.scene.addChild(this.container);
            if (Config.DEBUG_SIMULATION){
                addChild((log_tf = new TextField()));
                log_tf.autoSize = TextFieldAutoSize.LEFT;
                log_tf.defaultTextFormat.color = 0xFFFFFF;
                log_tf.blendMode = BlendMode.INVERT;
            };
            instance = this;
            this.init();
            dispatchEvent(new Event(CONTEXT_READY));
        }
        private function init():void{
            this.initLights();
            this.initMaterials();
            this.initObjects();
            this.initListeners();
        }
        private function initLights():void{
            new LightProvider();
        }
        private function initMaterials():void{
            new TextureProvider();
            new MaterialProvider();
        }
        private function initObjects():void{
            var bitmapDebug:Bitmap;
            this.location = new Location();
            this.navigation = new Navigator(this.location);
            this.target = new ObjectContainer3D();
            this.container.addChild(this.target);
            this.controller = new CameraController(this.location, this.camera, this.target);
            this.controller.listenTarget = this;
            this.ground = new Ground(3);
            this.ground.y = -50;
            this.container.addChild(this.ground);
            this.particles = new ParticleMesh();
            this.container.addChild(this.particles);
            this.itemObjects = new ItemObjectsManager(this);
            this.scene.addChild(this.itemObjects);
            this.monuments = new MonumentsMesh();
            this.container.addChild(this.monuments);
            this.monuments.setCity(Config.CITY);
            if (Config.CITY == Locator.BERLIN){
                this.scene.addChild(new BerlinWall());
            };
            this.buildings = new BuildingMesh3();
            this.buildings.init(Constants.GRID_CASE_SIZE, Locator.world_rect);
            if (this.buildings.debug){
                bitmapDebug = new Bitmap(this.buildings.debugGrid);
                bitmapDebug.x = 300;
                stage.addChild(bitmapDebug);
                this.memoryText = new TextField();
                this.memoryText.textColor = 0xFFFFFF;
                this.memoryText.x = 300;
                stage.addChild(this.memoryText);
            };
            this.container.addChild(this.buildings);
            this.container.addChild(this.buildings.debris);
            this.container.addChild(this.buildings.roofs);
            this.rivers = new Rivers();
            this.container.addChild(this.rivers);
            this.rivers.y = -0.25;
            this.parcs = new Parcs();
            this.container.addChild(this.parcs);
            this.parcs.y = -0.5;
            new Axes();
            this.rails = new Rails();
            Building3.staticInit(this.buildings);
            this.metro = new Metro();
            this.metro.init(Constants.GRID_METRO_CASE_SIZE, Locator.world_rect);
            this.container.addChild(this.metro.segments);
            this.links = new Linker(this);
            this.scene.addChild(this.links);
            if (Config.DEBUG_SIMULATION){
                this.scene.addChild(this.location);
                this.scene.addChild((this.trident = new Trident(180)));
                MaterialProvider.yellow.alpha = 1;
            };
        }
        protected function deplaceMonumentsTest(e:KeyboardEvent):void{
            if (this.buildings.debug){
                if (e.ctrlKey){
                    switch (e.keyCode){
                        case Keyboard.LEFT:
                            this.monuments.x--;
                            break;
                        case Keyboard.UP:
                            this.monuments.z++;
                            break;
                        case Keyboard.RIGHT:
                            this.monuments.x++;
                            break;
                        case Keyboard.DOWN:
                            this.monuments.z--;
                            break;
                    };
                };
            };
        }
        private function onBatchComplete(e:ServiceEvent):void{
        }
        private function initListeners():void{
            stage.addEventListener(Event.RESIZE, this.onResize);
            this.resize();
            dispatchEvent(new Event(Event.COMPLETE));
        }
        public function update():void{
            if (this.buildings.debug){
            };
            this.controller.update(this.location);
            this.links.update();
            LightProvider.light0.x = this.target.x;
            LightProvider.light0.y = ((this.ground.y + 50) + (CameraController.CAM_HEIGHT * 100));
            LightProvider.light0.z = this.target.z;
            this.buildings.sortBuilding(this);
            if (AppState.isActive(DataType.METRO_STATIONS)){
                this.metro.sortSegment(this, 3);
            };
            this.itemObjects.update();
        }
        public function start():void{
            if (AppState.isHQ){
                this.setHQ();
            } else {
                this.setLQ();
            };
        }
        public function pause():void{
        }
        public function render():void{
            try {
                this.view.render();
            } catch(err:Error) {
                trace("render ", err.message);
            };
        }
        private function onResize(e:Event):void{
            this.resize();
        }
        public function resize():void{
            this.view.width = stage.stageWidth;
            this.view.height = stage.stageHeight;
            this.stage3DProxy.width = stage.stageWidth;
            this.stage3DProxy.height = stage.stageHeight;
        }
        public function checkState():void{
            if (AppState.isActive(DataType.METRO_STATIONS)){
                this.rivers.y = -8;
                this.parcs.y = -9;
                this.ground.y = -15;
            } else {
                this.rivers.y = -0.25;
                this.parcs.y = -0.5;
                this.ground.y = -1;
            };
            this.metro.segments.visible = (this.metro.container.visible = AppState.isActive(DataType.METRO_STATIONS));
        }
        public function setLQ():void{
            if (this.container.contains(this.buildings.debris)){
                this.container.removeChild(this.buildings.debris);
            };
            if (this.container.contains(this.buildings.roofs)){
                this.container.removeChild(this.buildings.roofs);
            };
            if (this.container.contains(this.particles)){
                this.container.removeChild(this.particles);
            };
            this.stage3DProxy.antiAlias = 0;
        }
        public function setHQ():void{
            if (!(this.container.contains(this.buildings.debris))){
                this.container.addChild(this.buildings.debris);
            };
            if (!(this.container.contains(this.buildings.roofs))){
                this.container.addChild(this.buildings.roofs);
            };
            if (!(this.container.contains(this.particles))){
                this.container.addChild(this.particles);
            };
            this.stage3DProxy.antiAlias = 2;
        }
        public function dispose():void{
            this.monuments.dispose();
            this.metro.dispose();
            this.buildings.dispose();
            this.rivers.dispose();
            if (this.parcs != null){
                this.parcs.dispose();
            };
        }
        public function reset():void{
            this.metro.init(Constants.GRID_METRO_CASE_SIZE, Locator.world_rect);
            this.monuments.setCity(Config.CITY);
            this.buildings.init(Constants.GRID_CASE_SIZE, Locator.world_rect);
            this.rivers.init();
        }

    }
}//package wd.d3 
