package wd.hud.panels.layers {
    import flash.display.*;
    import wd.hud.common.text.*;
    import flash.events.*;
    import wd.hud.*;
    import wd.core.*;
    import wd.http.*;
    import wd.sound.*;
    import aze.motion.*;
    import flash.text.*;

    public class LayerItem extends Sprite {

        private var type;
        private var label:TextField;
        private var h:int;
        private var hud:Hud;
        private var picto:Sprite;

        public function LayerItem(hud:Hud, type, labelTxt:String, h:int=20, w:uint=190){
            super();
            this.hud = hud;
            this.h = h;
            this.type = type;
            this.picto = new Sprite();
            if ((type is int)){
                this.picto = new LayerItemIcon(type);
                this.picto.visible = false;
                this.addChild(this.picto);
                this.picto.x = 10;
                this.picto.y = 9;
                this.label = new CustomTextField(labelTxt.toUpperCase(), "layerPanelItem", CustomTextField.AUTOSIZE_LEFT);
                this.label.x = 20;
            } else {
                this.label = new CustomTextField((labelTxt.toUpperCase() + "/"), "layerPanelFolder", CustomTextField.AUTOSIZE_LEFT);
            };
            this.label.width = (w - this.picto.width);
            addChild(this.label);
            this.drawBg();
            this.drawState();
            mouseChildren = false;
            buttonMode = true;
            addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
        }
        public function getType(){
            return (this.type);
        }
        private function onDown(e:MouseEvent):void{
            graphics.clear();
            this.drawBg();
            if ((this.type is Array)){
                AppState.toggleMenuByType(this.type[0]);
            } else {
                AppState.toggle(this.type);
                if (this.type == DataType.TRAFFIC_LIGHTS){
                    if (AppState.isActive(DataType.TRAFFIC_LIGHTS)){
                        AppState.activate(DataType.RADARS);
                    } else {
                        AppState.deactivate(DataType.RADARS);
                    };
                };
            };
            this.hud.checkState();
            this.drawState();
            SoundManager.playFX("ClickPanneauFiltre", 1);
        }
        private function drawBg():void{
            graphics.beginFill(0, 0);
            graphics.drawRect(0, 0, this.label.width, this.h);
        }
        private function drawState():void{
            var palpha:Number = ((AppState.isActive(this.type)) ? 1 : 0.35);
            var lalpha:Number = ((AppState.isActive(this.type)) ? 1 : 0.35);
            eaze(this.picto).to(0.3, {alpha:palpha});
            eaze(this.label).to(0.3, {alpha:lalpha});
        }
        public function checkState():void{
            graphics.clear();
            this.drawBg();
            this.drawState();
        }

    }
}//package wd.hud.panels.layers 
