package wd.hud.popins.textpopin {
    import flash.display.*;
    import flash.geom.*;
    import flash.events.*;

    public class TextPopinScrollbar extends Sprite {

        public static const SCROLL_EVENT:String = "I'M SCROLLIN' MOTHERFUCKER !";
        public static const BAR_WIDTH:uint = 10;

        private var barHeight:uint;
        private var maxHeight:uint;
        private var scrollBounds:Rectangle;
        private var bar:Sprite;
        private var bgScroll:Sprite;
        public var desty:uint;
        private var wheelHost:Sprite;

        public function TextPopinScrollbar(height:uint, maxHeight:uint, wheelHost:Sprite){
            super();
            this.barHeight = height;
            this.maxHeight = maxHeight;
            this.bgScroll = new Sprite();
            this.bgScroll.graphics.beginBitmapFill(new RayPatternAsset());
            this.bgScroll.graphics.drawRect(0, 0, BAR_WIDTH, this.barHeight);
            this.bgScroll.graphics.endFill();
            this.bgScroll.alpha = 0.3;
            this.addChild(this.bgScroll);
            this.bar = new Sprite();
            this.bar.graphics.beginFill(0xFFFFFF, 1);
            this.bar.graphics.drawRect(0, 0, BAR_WIDTH, (this.barHeight * (this.barHeight / maxHeight)));
            this.bar.graphics.endFill();
            this.addChild(this.bar);
            this.scrollBounds = new Rectangle(0, 0, 0, (this.bgScroll.height - this.bar.height));
            this.bar.mouseChildren = false;
            this.bar.buttonMode = true;
            this.bar.mouseEnabled = true;
            this.bar.addEventListener(MouseEvent.MOUSE_DOWN, this.startScroll);
            wheelHost.addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
        }
        private function startScroll(e:Event):void{
            this.bar.startDrag(false, this.scrollBounds);
            this.bar.removeEventListener(MouseEvent.MOUSE_DOWN, this.startScroll);
            this.bar.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.scroll);
            this.bar.stage.addEventListener(MouseEvent.MOUSE_UP, this.stopScroll);
        }
        private function stopScroll(e:Event):void{
            this.bar.stopDrag();
            this.bar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.scroll);
            this.bar.stage.removeEventListener(MouseEvent.MOUSE_UP, this.stopScroll);
            this.bar.addEventListener(MouseEvent.MOUSE_DOWN, this.startScroll);
        }
        private function onMouseWheel(e:MouseEvent):void{
            var delta:int = (((e.delta > 0)) ? -10 : 10);
            this.bar.y = (this.bar.y + delta);
            this.bar.y = Math.max(this.bar.y, 0);
            this.bar.y = Math.min(this.bar.y, this.scrollBounds.height);
            this.scroll(null);
        }
        private function scroll(e:Event):void{
            this.desty = ((this.bar.y / this.scrollBounds.height) * (this.maxHeight - this.barHeight));
            this.dispatchEvent(new Event(SCROLL_EVENT));
        }

    }
}//package wd.hud.popins.textpopin 
