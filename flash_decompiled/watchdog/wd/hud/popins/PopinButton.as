package wd.hud.popins {
    import wd.hud.common.text.*;
    import flash.display.*;
    import flash.events.*;
    import aze.motion.*;

    public class PopinButton extends Sprite {

        private const MIN_WIDTH:uint = 100;
        private const ROLLOVER_WIDTH:uint = 10;
        private const TEXT_MARGIN:uint = 5;

        private var btnBaseWidth:uint;
        private var bgRov:Shape;
        private var btnBaseHeight:uint;

        public function PopinButton(label:String, onClick:Function){
            super();
            var txt:CustomTextField = new CustomTextField(label, "popinBtn");
            txt.wordWrap = false;
            this.btnBaseWidth = Math.max(this.MIN_WIDTH, (txt.width + (2 * this.TEXT_MARGIN)));
            this.btnBaseHeight = (txt.height + (2 * this.TEXT_MARGIN));
            this.setBg(this.btnBaseWidth, this.btnBaseHeight);
            var bg:Shape = new Shape();
            bg.graphics.beginFill(0xFFFFFF, 1);
            bg.graphics.drawRect(0, 0, this.btnBaseWidth, this.btnBaseHeight);
            this.addChild(bg);
            txt.x = ((bg.width - txt.width) / 2);
            txt.y = ((bg.height - txt.height) / 2);
            this.addChild(txt);
            this.buttonMode = true;
            this.mouseChildren = false;
            this.addEventListener(MouseEvent.ROLL_OVER, this.rov);
            this.addEventListener(MouseEvent.ROLL_OUT, this.rou);
            this.addEventListener(MouseEvent.CLICK, onClick);
        }
        private function setBg(w:uint, h:uint):void{
            this.bgRov = new Shape();
            this.bgRov.graphics.beginBitmapFill(new RayPatternAsset(5, 5), null, true, true);
            this.bgRov.graphics.drawRect(0, 0, (w + (this.ROLLOVER_WIDTH * 2)), (h + (this.ROLLOVER_WIDTH * 2)));
            this.bgRov.width = w;
            this.bgRov.height = h;
            this.bgRov.alpha = 0.5;
            this.addChildAt(this.bgRov, 0);
        }
        private function rov(e:Event):void{
            eaze(this.bgRov).to(0.5, {
                x:-(this.ROLLOVER_WIDTH),
                y:-(this.ROLLOVER_WIDTH),
                width:(this.btnBaseWidth + (this.ROLLOVER_WIDTH * 2)),
                height:(this.btnBaseHeight + (this.ROLLOVER_WIDTH * 2))
            });
        }
        private function rou(e:Event):void{
            eaze(this.bgRov).to(0.3, {
                x:0,
                y:0,
                width:this.btnBaseWidth,
                height:this.btnBaseHeight
            });
        }

    }
}//package wd.hud.popins 
