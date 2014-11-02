package wd.hud.popins.helppopin {
    import flash.geom.*;
    import flash.utils.*;
    import flash.events.*;
    import biga.utils.*;

    public class HelpPopinWrapper extends HelpPopinContent {

        private var drag_rect:Rectangle;
        private var interval:uint;
        private var ratio:Number;

        public function HelpPopinWrapper(){
            super();
        }
        private function onMouseHandler(e:MouseEvent):void{
            this.drag_rect = new Rectangle(scrollbar.bg.x, scrollbar.bg.y, ((scrollbar.bg.width - scrollbar.carret.width) + 14), 0);
            switch (e.type){
                case MouseEvent.MOUSE_DOWN:
                    scrollbar.carret.startDrag(false, this.drag_rect);
                    this.interval = setInterval(this.checkRatio, 30);
                    break;
                default:
                    scrollbar.carret.stopDrag();
                    this.checkRatio();
                    clearInterval(this.interval);
                    return;
            };
        }
        private function checkRatio():void{
            this.ratio = GeomUtils.normalize(scrollbar.carret.x, this.drag_rect.x, this.drag_rect.right);
            contenu.x = (contenu.x + (((this.ratio * -((contenu.width - masque.width))) - contenu.x) * 0.5));
        }

    }
}//package wd.hud.popins.helppopin 
