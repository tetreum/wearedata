package wd.hud.popins.legalspopin {
    import wd.providers.texts.*;
    import flash.display.*;
    import flash.events.*;
    import wd.hud.popins.textpopin.*;

    public class LegalsPopin extends TextPopin {

        private var btn1:BtnPopin;
        private var btn2:BtnPopin;

        public function LegalsPopin(){
            super();
            setTitle(LegalsText.title);
            setIcon(new Sprite());
            setLine();
            disposeHeader();
            setText(LegalsText.text, "legalsPopinText");
            this.btn2 = new BtnPopin(LegalsText.btnCredits.toUpperCase(), this.openCredits);
            this.btn2.x = (POPIN_WIDTH - this.btn2.width);
            this.btn1 = new BtnPopin(LegalsText.btnTerms.toUpperCase(), this.openTerms);
            this.btn1.x = ((this.btn2.x - this.btn1.width) - 5);
            this.btn1.y = (this.btn2.y = (line.y + 10));
            this.addChild(this.btn1);
            this.addChild(this.btn2);
            addTweenInItem([this.btn1]);
            addTweenInItem([this.btn2]);
            text.y = (txtY0 = ((this.btn1.y + this.btn1.height) + 10));
            if (sbar){
                sbar.y = (txtMask.y = text.y);
            };
        }
        private function openTerms(e:Event):void{
            setText(LegalsText.text, "legalsPopinText");
            tweenIn();
            text.y = (txtY0 = ((this.btn1.y + this.btn1.height) + 10));
            if (sbar){
                sbar.y = (txtMask.y = text.y);
            };
        }
        private function openCredits(e:Event):void{
            setText(LegalsText.text2, "legalsPopinText");
            tweenIn();
            text.y = (txtY0 = ((this.btn1.y + this.btn1.height) + 10));
            if (sbar){
                sbar.y = (txtMask.y = text.y);
            };
        }

    }
}//package wd.hud.popins.legalspopin 

import flash.display.*;
import flash.events.*;
import wd.hud.common.text.*;
import aze.motion.*;

class BtnPopin extends Sprite {

    private var bg:Sprite;
    private var txt:CustomTextField;

    public function BtnPopin(label:String, clickMethod:Function):void{
        super();
        this.bg = new Sprite();
        this.bg.graphics.beginFill(0xFFFFFF, 1);
        this.addChild(this.bg);
        this.txt = new CustomTextField(label, "legalsPopinBtn");
        this.txt.wordWrap = false;
        this.addChild(this.txt);
        this.bg.graphics.drawRect(-5, 0, (this.txt.width + 10), this.txt.height);
        this.buttonMode = true;
        this.mouseChildren = false;
        this.addEventListener(MouseEvent.ROLL_OVER, this.rov);
        this.addEventListener(MouseEvent.ROLL_OUT, this.rou);
        this.addEventListener(MouseEvent.CLICK, clickMethod);
    }
    private function rov(e:Event):void{
        eaze(this.bg).to(0.3, {alpha:0.8});
    }
    private function rou(e:Event):void{
        eaze(this.bg).to(0.3, {alpha:18});
    }

}
