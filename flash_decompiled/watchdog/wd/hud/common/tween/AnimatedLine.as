package wd.hud.common.tween {
    import aze.motion.*;
    import flash.geom.*;
    import flash.events.*;
    import flash.display.*;

    public class AnimatedLine extends Sprite {

        public static const TWEEN_END:String = "TWEEN_END";
        public static const TWEEN_RENDER:String = "TWEEN_RENDER";

        private var _pDest:Point;
        private var _color:uint;
        public var step:Number = 0;

        public function AnimatedLine(destination:Point, color:uint=0xFFFFFF, time:Number=0.7){
            super();
            this._color = color;
            this._pDest = destination;
            this.graphics.lineStyle(1, color, 1);
            this.graphics.moveTo(0, 0);
            eaze(this).to(time, {step:1}).onUpdate(this.render).onComplete(this.tweenEnd);
        }
        public function render():void{
            this.graphics.clear();
            this.graphics.lineStyle(1, this._color, 1);
            this.graphics.lineTo(((this._pDest.x * this.step) / 1), ((this._pDest.y * this.step) / 1));
            this.dispatchEvent(new Event(TWEEN_RENDER));
        }
        public function tweenEnd():void{
            this.dispatchEvent(new Event(TWEEN_END));
        }

    }
}//package wd.hud.common.tween 
