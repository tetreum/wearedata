package wd.hud.common.ui {
    import flash.display.*;
    import wd.hud.common.text.*;
    import flash.events.*;
    import aze.motion.*;

    public class SimpleButton extends Sprite {

        private var bgrov:Sprite;
        private var bgrou:Sprite;
        private var txtrov:CustomTextField;
        private var txtrou:CustomTextField;

        public function SimpleButton(label:String, clickMethod:Function, textStyle:String="simpleButton", minWidth:uint=80){
            super();
            this.bgrov = new Sprite();
            this.bgrov.graphics.beginFill(0, 1);
            this.addChild(this.bgrov);
            this.bgrou = new Sprite();
            this.bgrou.graphics.beginFill(0xFFFFFF, 1);
            this.addChild(this.bgrou);
            this.txtrov = new CustomTextField(label, (textStyle + "Rollover"));
            this.txtrov.wordWrap = false;
            this.addChild(this.txtrov);
            this.txtrou = new CustomTextField(label, (textStyle + "Rollout"));
            this.txtrou.wordWrap = false;
            this.addChild(this.txtrou);
            if (this.txtrou.width < minWidth){
                this.txtrou.x = (this.txtrov.x = ((minWidth - this.txtrou.width) / 2));
            };
            var w:uint = Math.max(minWidth, this.txtrov.width);
            this.bgrov.graphics.drawRect(-5, 0, (w + 10), (this.txtrov.height + 1));
            this.bgrou.graphics.drawRect(-5, 0, (w + 10), (this.txtrov.height + 1));
            this.bgrov.alpha = 0;
            this.txtrov.alpha = 0;
            this.buttonMode = true;
            this.mouseChildren = false;
            this.addEventListener(MouseEvent.ROLL_OVER, this.rov);
            this.addEventListener(MouseEvent.ROLL_OUT, this.rou);
            this.addEventListener(MouseEvent.CLICK, clickMethod);
        }
        private function rov(e:Event):void{
            eaze(this.bgrov).to(0.3, {alpha:1});
            eaze(this.bgrou).to(0.3, {alpha:0});
            eaze(this.txtrov).to(0.3, {alpha:1});
            eaze(this.txtrou).to(0.3, {alpha:0});
        }
        private function rou(e:Event):void{
            eaze(this.bgrov).to(0.3, {alpha:0});
            eaze(this.bgrou).to(0.3, {alpha:1});
            eaze(this.txtrov).to(0.3, {alpha:0});
            eaze(this.txtrou).to(0.3, {alpha:1});
        }

    }
}//package wd.hud.common.ui 
