package aze.motion.specials {
    import aze.motion.*;
    import flash.display.*;

    public class PropertyFrame extends EazeSpecial {

        private var start:int;
        private var delta:int;
        private var frameStart;
        private var frameEnd;

        public function PropertyFrame(target:Object, property, value, next:EazeSpecial){
            var parts:Array;
            var label:String;
            var index:int;
            super(target, property, value, next);
            var mc:MovieClip = MovieClip(target);
            if ((value is String)){
                label = value;
                if (label.indexOf("+") > 0){
                    parts = label.split("+");
                    this.frameStart = parts[0];
                    this.frameEnd = label;
                } else {
                    if (label.indexOf(">") > 0){
                        parts = label.split(">");
                        this.frameStart = parts[0];
                        this.frameEnd = parts[1];
                    } else {
                        this.frameEnd = label;
                    };
                };
            } else {
                index = int(value);
                if (index <= 0){
                    index = (index + mc.totalFrames);
                };
                this.frameEnd = Math.max(1, Math.min(mc.totalFrames, index));
            };
        }
        public static function register():void{
            EazeTween.specialProperties.frame = PropertyFrame;
        }

        override public function init(reverse:Boolean):void{
            var mc:MovieClip = MovieClip(target);
            if ((this.frameStart is String)){
                this.frameStart = this.findLabel(mc, this.frameStart);
            } else {
                this.frameStart = mc.currentFrame;
            };
            if ((this.frameEnd is String)){
                this.frameEnd = this.findLabel(mc, this.frameEnd);
            };
            if (reverse){
                this.start = this.frameEnd;
                this.delta = (this.frameStart - this.start);
            } else {
                this.start = this.frameStart;
                this.delta = (this.frameEnd - this.start);
            };
            mc.gotoAndStop(this.start);
        }
        private function findLabel(mc:MovieClip, name:String):int{
            var label:FrameLabel;
            for each (label in mc.currentLabels) {
                if (label.name == name){
                    return (label.frame);
                };
            };
            return (1);
        }
        override public function update(ke:Number, isComplete:Boolean):void{
            var mc:MovieClip = MovieClip(target);
            mc.gotoAndStop(Math.round((this.start + (this.delta * ke))));
        }
        public function getPreferredDuration():Number{
            var mc:MovieClip = MovieClip(target);
            var fps:Number = ((mc.stage) ? mc.stage.frameRate : 30);
            return (Math.abs((Number(this.delta) / fps)));
        }

    }
}//package aze.motion.specials 
