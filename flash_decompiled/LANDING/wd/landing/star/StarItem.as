package wd.landing.star {
    import flash.display.*;
    import flash.geom.*;

    public class StarItem extends Sprite {

        public static const SIMPLE_STAR:String = "simple star";
        public static const BUTTON_STAR:String = "button star";

        public var vector3d:Vector3D;
        private var _radiusRatio:Number;
        private var shapeWhite:Shape;
        private var shapeRed:Shape;
        private var shapeGreen:Shape;
        private var shapeBlue:Shape;
        private var _i:int;
        private var size:int = 4;
        protected var _realSize:Number;
        public var typeStar:String;
        public var isOver:Boolean = false;

        public function StarItem(){
            this.typeStar = SIMPLE_STAR;
            this.size = (this.size + (Math.random() * this.size));
            this.shapeWhite = new Shape();
            this.shapeWhite.graphics.beginFill(0xFFFFFF, 1);
            this.shapeWhite.graphics.drawRect(0, 0, this.size, this.size);
            addChild(this.shapeWhite);
            this.shapeRed = new Shape();
            this.shapeRed.graphics.beginFill(0xFF0000, 1);
            this.shapeRed.graphics.drawRect(0, 0, this.size, this.size);
            addChildAt(this.shapeRed, 0);
            this.shapeRed.blendMode = BlendMode.SCREEN;
            this.shapeGreen = new Shape();
            this.shapeGreen.graphics.beginFill(0xFF00, 1);
            this.shapeGreen.graphics.drawRect(0, 0, this.size, this.size);
            addChildAt(this.shapeGreen, 0);
            this.shapeGreen.blendMode = BlendMode.SCREEN;
            this.shapeBlue = new Shape();
            this.shapeBlue.graphics.beginFill(39423, 1);
            this.shapeBlue.graphics.drawRect(0, 0, this.size, this.size);
            addChildAt(this.shapeBlue, 0);
            this.shapeBlue.blendMode = BlendMode.SCREEN;
            this._realSize = this.width;
        }
        public function distortIt():void{
            if (this.typeStar != SIMPLE_STAR){
                return;
            };
            this.shapeWhite.alpha = 0.8;
            this._i = 0;
            while (this._i < this.numChildren) {
                if (this.getChildAt(this._i) != this.shapeWhite){
                    this.getChildAt(this._i).y = this.randRange(-2, 2);
                    this.getChildAt(this._i).x = this.randRange(-2, 2);
                    this.getChildAt(this._i).alpha = (this.randRange(2, 9) / 10);
                };
                this._i++;
            };
        }
        public function resetDistort():void{
            if (this.typeStar != SIMPLE_STAR){
                return;
            };
            this.shapeWhite.alpha = 1;
            this._i = 0;
            while (this._i < this.numChildren) {
                if (this.getChildAt(this._i) != this.shapeWhite){
                    this.getChildAt(this._i).y = 0;
                    this.getChildAt(this._i).x = 0;
                    this.getChildAt(this._i).alpha = 0;
                };
                this._i++;
            };
        }
        private function randRange(_arg1:int, _arg2:int):int{
            var _local3:int = (Math.floor((Math.random() * ((_arg2 - _arg1) + 1))) + _arg1);
            return (_local3);
        }
        public function setPtNotVisible():void{
            this.shapeWhite.visible = false;
            this.shapeBlue.visible = false;
            this.shapeGreen.visible = false;
            this.shapeRed.visible = false;
        }
        public function set radiusRatio(_arg1:Number):void{
            this._radiusRatio = _arg1;
            if (this.typeStar != SIMPLE_STAR){
                return;
            };
            this.scaleX = (this.scaleY = _arg1);
            this._i = 0;
            while (this._i < this.numChildren) {
                if (this.getChildAt(this._i) != this.shapeWhite){
                    this.getChildAt(this._i).y = 0;
                    this.getChildAt(this._i).x = 0;
                    this.getChildAt(this._i).alpha = 0;
                };
                this._i++;
            };
            this._realSize = this.width;
        }
        public function get radiusRatio():Number{
            return (this._radiusRatio);
        }
        public function get realSize():Number{
            return (this._realSize);
        }

    }
}//package wd.landing.star 
