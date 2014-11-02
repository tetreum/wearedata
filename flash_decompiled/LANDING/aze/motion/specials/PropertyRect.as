package aze.motion.specials {
    import flash.geom.*;
    import aze.motion.*;

    public class PropertyRect extends EazeSpecial {

        private var original:Rectangle;
        private var targetRect:Rectangle;
        private var tmpRect:Rectangle;

        public function PropertyRect(_arg1:Object, _arg2, _arg3, _arg4:EazeSpecial):void{
            super(_arg1, _arg2, _arg3, _arg4);
            this.targetRect = ((((_arg3) && ((_arg3 is Rectangle)))) ? _arg3.clone() : new Rectangle());
        }
        public static function register():void{
            EazeTween.specialProperties["__rect"] = PropertyRect;
        }

        override public function init(_arg1:Boolean):void{
            this.original = (((target[property] is Rectangle)) ? (target[property].clone() as Rectangle) : new Rectangle(0, 0, target.width, target.height));
            if (_arg1){
                this.tmpRect = this.original;
                this.original = this.targetRect;
                this.targetRect = this.tmpRect;
                target.scrollRect = this.original;
            };
            this.tmpRect = new Rectangle();
        }
        override public function update(_arg1:Number, _arg2:Boolean):void{
            if (_arg2){
                target.scrollRect = this.targetRect;
            } else {
                this.tmpRect.x = (this.original.x + ((this.targetRect.x - this.original.x) * _arg1));
                this.tmpRect.y = (this.original.y + ((this.targetRect.y - this.original.y) * _arg1));
                this.tmpRect.width = (this.original.width + ((this.targetRect.width - this.original.width) * _arg1));
                this.tmpRect.height = (this.original.height + ((this.targetRect.height - this.original.height) * _arg1));
                target[property] = this.tmpRect;
            };
        }
        override public function dispose():void{
            this.original = (this.targetRect = (this.tmpRect = null));
            super.dispose();
        }

    }
}//package aze.motion.specials 
