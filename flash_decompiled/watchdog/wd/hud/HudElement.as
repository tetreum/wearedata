package wd.hud {
    import flash.events.*;
    import flash.display.*;
    import aze.motion.*;
    import wd.hud.popins.datapopins.triangledatapopin.*;

    public class HudElement extends Sprite {

        protected const DESACTIVATION_ALPHA:Number = 0.2;

        protected var _enabled:Boolean = true;
        protected var _tutoMode:Boolean = true;
        private var tweenSequence:Array;
        protected var tweenInSpeed:Number = 0.3;
        protected var tweenInBaseDelay:Number = 0.05;

        public function HudElement(){
            super();
            this.tweenSequence = new Array();
        }
        protected function activate():void{
            this.activationTween(this);
        }
        protected function desactivate(e:Event=null):void{
            this.desactivationTween(this);
        }
        public function tutoFocusIn():void{
            this.activationTween(this);
        }
        public function tutoFocusOut():void{
            this.desactivationTween(this);
        }
        protected function activationTween(dp:DisplayObject=null):void{
            if (dp == null){
                dp = this;
            };
            eaze(dp).to(0.5, {alpha:1}, false);
        }
        protected function desactivationTween(dp:DisplayObject=null):void{
            if (dp == null){
                dp = this;
            };
            eaze(dp).to(0.5, {alpha:this.DESACTIVATION_ALPHA}, false);
        }
        public function disable():void{
            this._enabled = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
            this.desactivationTween(this);
        }
        public function enable():void{
            this._enabled = true;
            this.mouseEnabled = true;
            this.mouseChildren = true;
            this.activationTween(this);
        }
        public function get tutoMode():Boolean{
            return (this._tutoMode);
        }
        public function set tutoMode(value:Boolean):void{
            this._tutoMode = value;
            if (this._tutoMode){
                this.disable();
            } else {
                this.enable();
            };
        }
        protected function addTweenInItem(element:Array):void{
            if (element[1] == null){
                element[1] = {alpha:0};
                element[2] = {alpha:1};
            };
            if ((element[0] is TriangleDataPopin)){
                eaze(element[0]).apply({alpha:0});
            } else {
                eaze(element[0]).apply(element[1]);
            };
            this.tweenSequence.push(element);
        }
        public function tweenIn(delay:Number=0):void{
            var i:Array;
            var d:int;
            for each (i in this.tweenSequence) {
                if ((i[0] is TriangleDataPopin)){
                    eaze(i[0]).delay((delay + (this.tweenInBaseDelay * d))).to(this.tweenInSpeed, {alpha:1}).onComplete(i[1]);
                } else {
                    eaze(i[0]).delay((delay + (this.tweenInBaseDelay * d))).to(this.tweenInSpeed, i[2]);
                };
                d++;
            };
        }
        public function tweenInElement(element:DisplayObject, from:Object, to:Object):void{
            eaze(element).apply(from);
            eaze(element).to(this.tweenInSpeed, to);
        }

    }
}//package wd.hud 
