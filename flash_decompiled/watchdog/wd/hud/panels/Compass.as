package wd.hud.panels {
    import flash.events.*;
    import flash.utils.*;
    import wd.d3.control.*;
    import wd.events.*;
    import wd.d3.*;
    import flash.display.*;
    import aze.motion.*;
    import wd.core.*;
    import flash.geom.*;

    public class Compass extends Panel {

        public static var tutoStartPoint:Point;

        private const DELTA_ANGLE_VAL:Number = 0.1;
        private const DELTA_ZOOM_VAL:Number = 12;

        private var sim:Simulation;
        private var asset:CompassAsset;
        private var timerAct:Timer;
        private var deltaAngle:Number = 0;
        private var deltaZoom:Number = 0;

        public function Compass(sim:Simulation){
            super();
            this.sim = sim;
            this.asset = new CompassAsset();
            this.asset.scaleX = (this.asset.scaleY = 0.6);
            this.addChild(this.asset);
            this.setAsButton(this.asset.left, this.turnLeft);
            this.setAsButton(this.asset.right, this.turnRight);
            this.setAsButton(this.asset.more, this.zoomIn);
            this.setAsButton(this.asset.less, this.zoomOut);
            this.addEventListener(MouseEvent.ROLL_OUT, this.stopAct);
            this.asset.topView.visible = false;
            this.timerAct = new Timer(10);
            this.timerAct.addEventListener(TimerEvent.TIMER, this.act);
            CameraController.instance.addEventListener(NavigatorEvent.ZOOM_CHANGE, this.zoomChange);
            this.setBg(this.width, this.height);
        }
        private function zoomChange(e:Event):void{
            if (CameraController.instance.zoomLevel == 0){
                this.asset.min.visible = false;
                this.asset.topView.visible = true;
            } else {
                this.asset.min.visible = true;
                this.asset.topView.visible = false;
            };
        }
        private function setAsButton(spr:Sprite, downFunc:Function):void{
            spr.buttonMode = true;
            spr.mouseChildren = false;
            spr.addEventListener(MouseEvent.ROLL_OVER, this.rovButton);
            spr.addEventListener(MouseEvent.ROLL_OUT, this.rouButton);
            spr.addEventListener(MouseEvent.MOUSE_DOWN, downFunc);
            spr.addEventListener(MouseEvent.MOUSE_UP, this.stopAct);
        }
        override protected function setBg(w:uint, h:uint):void{
        }
        private function rovButton(e:Event):void{
            eaze(e.target).to(1, {alpha:0.7});
        }
        private function rouButton(e:Event):void{
            eaze(e.target).to(1, {alpha:0.1});
        }
        private function turnLeft(e:Event):void{
            Keys.arrows[0] = true;
            this.timerAct.start();
        }
        private function turnRight(e:Event):void{
            Keys.arrows[2] = true;
            this.timerAct.start();
        }
        private function zoomIn(e:Event):void{
            CameraController.forward(0.2);
        }
        private function zoomOut(e:Event):void{
            if (this.asset.topView.visible){
                CameraController.instance.mouseWheelAccu = CameraController.instance.mouseWheelAccuLimit;
                CameraController.backward(1);
            } else {
                CameraController.backward(0.2);
            };
        }
        private function act(e:Event):void{
            this.sim.location.dest_angle = (this.sim.location.dest_angle + this.deltaAngle);
            this.sim.camera.y = (this.sim.camera.y + this.deltaZoom);
            this.sim.location.update(true);
        }
        private function stopAct(e:Event):void{
            this.deltaAngle = 0;
            this.deltaZoom = 0;
            this.timerAct.stop();
            var i:uint;
            while (i < 4) {
                Keys.arrows[i] = false;
                i++;
            };
        }
        private function onDown(e:MouseEvent):void{
            this.sim.location.dest_angle = (Math.PI * 0.5);
        }
        public function render():void{
        }
        public function update():void{
            var angle:Number = (this.sim.location.dest_angle - (Math.PI / 2));
            this.asset.north.rotation = (angle * Constants.RAD_TO_DEG);
        }
        override public function set x(value:Number):void{
            super.x = value;
            tutoStartPoint = new Point((this.x + 83), (this.y + 83));
        }
        override public function set y(value:Number):void{
            super.y = value;
            tutoStartPoint = new Point((this.x + 83), (this.y + 83));
        }

    }
}//package wd.hud.panels 
