package aze.motion.specials {
    import aze.motion.*;

    public class PropertyShortRotation extends EazeSpecial {

        private var fvalue:Number;
        private var radius:Number;
        private var start:Number;
        private var delta:Number;

        public function PropertyShortRotation(_arg1:Object, _arg2, _arg3, _arg4:EazeSpecial){
            super(_arg1, _arg2, _arg3, _arg4);
            this.fvalue = _arg3[0];
            this.radius = ((_arg3[1]) ? Math.PI : 180);
        }
        public static function register():void{
            EazeTween.specialProperties["__short"] = PropertyShortRotation;
        }

        override public function init(_arg1:Boolean):void{
            var _local2:Number;
            this.start = target[property];
            if (_arg1){
                _local2 = this.start;
                target[property] = (this.start = this.fvalue);
            } else {
                _local2 = this.fvalue;
            };
            while ((_local2 - this.start) > this.radius) {
                this.start = (this.start + (this.radius * 2));
            };
            while ((_local2 - this.start) < -(this.radius)) {
                this.start = (this.start - (this.radius * 2));
            };
            this.delta = (_local2 - this.start);
        }
        override public function update(_arg1:Number, _arg2:Boolean):void{
            target[property] = (this.start + (_arg1 * this.delta));
        }

    }
}//package aze.motion.specials 
