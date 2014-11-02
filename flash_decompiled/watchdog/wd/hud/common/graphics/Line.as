package wd.hud.common.graphics {
    import flash.display.*;

    public class Line extends Sprite {

        private var sh:Shape;
        private var color:uint;

        public function Line(width:uint, color:uint=0xFFFFFF){
            super();
            this.color = color;
            this.sh = new Shape();
            this.sh.graphics.lineStyle(1, color, 1, false, "normal", CapsStyle.SQUARE);
            this.sh.graphics.lineTo(width, 0);
            this.addChild(this.sh);
        }
        override public function get width():Number{
            return (super.width);
        }
        override public function set width(value:Number):void{
            this.sh.graphics.clear();
            this.sh.graphics.lineStyle(1, this.color, 1, false, "normal", CapsStyle.SQUARE);
            this.sh.graphics.lineTo(value, 0);
        }

    }
}//package wd.hud.common.graphics 
