package wd.core {
    import __AS3__.vec.*;
    import flash.events.*;
    import flash.display.*;
    import wd.hud.*;
    import wd.d3.*;
    import wd.d3.control.*;
    import flash.ui.*;

    public class Keys {

        public static var arrows:Vector.<Boolean> = Vector.<Boolean>([false, false, false, false]);

        private var simulation:Simulation;
        private var hud:Hud;
        private var main:InteractiveObject;

        public function Keys(main:InteractiveObject, hud:Hud, simulation:Simulation, stage:Stage){
            super();
            this.main = main;
            this.hud = hud;
            this.simulation = simulation;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyboardHandler);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.keyboardHandler);
        }
        private function keyboardHandler(e:KeyboardEvent):void{
            var state:uint;
            var id:int;
            if (Config.NAVIGATION_LOCKED){
                return;
            };
            if (e.type == KeyboardEvent.KEY_DOWN){
                state = AppState.state;
                id = -1;
                if ((((e.charCode == "x".charCodeAt(0))) || ((e.charCode == "X".charCodeAt(0))))){
                    AppState.toggleMenu(AppState.TRANSPORTS);
                };
                if ((((e.charCode == "c".charCodeAt(0))) || ((e.charCode == "C".charCodeAt(0))))){
                    AppState.toggleMenu(AppState.NETWORKS);
                };
                if ((((e.charCode == "v".charCodeAt(0))) || ((e.charCode == "V".charCodeAt(0))))){
                    AppState.toggleMenu(AppState.FURNITURE);
                };
                if ((((e.charCode == "b".charCodeAt(0))) || ((e.charCode == "B".charCodeAt(0))))){
                    AppState.toggleMenu(AppState.SOCIAL);
                };
                if ((((e.charCode == "h".charCodeAt(0))) || ((e.charCode == "H".charCodeAt(0))))){
                    if (AppState.isHQ){
                        AppState.isHQ = false;
                        if (this.simulation != null){
                            this.simulation.setLQ();
                        };
                    } else {
                        AppState.isHQ = true;
                        if (this.simulation != null){
                            this.simulation.setHQ();
                        };
                    };
                };
                if (state != AppState.state){
                    if (this.hud != null){
                        this.hud.checkState();
                    };
                };
            };
            if (e.charCode == "+".charCodeAt(0)){
                CameraController.forward(0.1);
            };
            if (e.charCode == "-".charCodeAt(0)){
                if (CameraController.instance.zoomLevel == 0){
                    CameraController.instance.mouseWheelAccu = CameraController.instance.mouseWheelAccuLimit;
                    CameraController.backward(1);
                } else {
                    CameraController.backward(0.1);
                };
            };
            switch (e.keyCode){
                case Keyboard.LEFT:
                    arrows[0] = (e.type == KeyboardEvent.KEY_DOWN);
                    break;
                case Keyboard.UP:
                    arrows[1] = (e.type == KeyboardEvent.KEY_DOWN);
                    break;
                case Keyboard.RIGHT:
                    arrows[2] = (e.type == KeyboardEvent.KEY_DOWN);
                    break;
                case Keyboard.DOWN:
                    arrows[3] = (e.type == KeyboardEvent.KEY_DOWN);
                    break;
            };
        }

    }
}//package wd.core 
