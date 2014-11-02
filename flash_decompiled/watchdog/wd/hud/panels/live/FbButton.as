package wd.hud.panels.live {
    import flash.display.*;
    import wd.hud.common.text.*;
    import flash.geom.*;
    import flash.filters.*;
    import flash.events.*;

    public class FbButton extends Sprite {

        private const HEIGHT:uint = 23;
        private const MIN_WIDTH:uint = 105;

        private var labelt:CustomTextField;

        public function FbButton(label:String, clickFunc:Function){
            super();
            var f:Sprite = new FacebookFAsset();
            f.x = 5;
            this.addChild(f);
            var l1:Shape = new Shape();
            l1.graphics.lineStyle(1, 5007018, 1, false, "normal", CapsStyle.SQUARE);
            l1.graphics.moveTo(22, 0);
            l1.graphics.lineTo(22, this.HEIGHT);
            l1.graphics.lineStyle(1, 7702973, 1, false, "normal", CapsStyle.SQUARE);
            l1.graphics.moveTo(23, 0);
            l1.graphics.lineTo(23, this.HEIGHT);
            this.addChild(l1);
            this.labelt = new CustomTextField(label, "facebookButton");
            this.labelt.wordWrap = false;
            var padding:int = Math.max(((this.MIN_WIDTH - (22 + this.labelt.width)) / 2), 1);
            this.labelt.x = (22 + padding);
            this.labelt.y = ((this.HEIGHT - this.labelt.height) / 2);
            this.addChild(this.labelt);
            var bg:Shape = new Shape();
            var m:Matrix = new Matrix();
            m.createGradientBox((22 + this.labelt.width), this.HEIGHT, (-(Math.PI) / 2));
            bg.graphics.beginGradientFill(GradientType.LINEAR, [5401772, 8294849], [1, 1], [0, 254], m);
            bg.graphics.drawRoundRect(0, 0, (((22 + padding) + this.labelt.width) + padding), this.HEIGHT, 5, 5);
            this.addChildAt(bg, 0);
            this.filters = [new BevelFilter(1, 45, 0xFFFFFF, 0.5, 0, 0.5, 1, 1)];
            this.buttonMode = true;
            this.mouseChildren = false;
            this.addEventListener(MouseEvent.CLICK, clickFunc);
        }
    }
}//package wd.hud.panels.live 
