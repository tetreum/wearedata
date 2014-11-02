package away3d.core.base.data {

    public class Vertex {

        private var _x:Number;
        private var _y:Number;
        private var _z:Number;
        private var _index:uint;

        public function Vertex(x:Number=0, y:Number=0, z:Number=0, index:uint=0){
            super();
            this._x = x;
            this._y = y;
            this._z = z;
            this._index = index;
        }
        public function set index(ind:uint):void{
            this._index = ind;
        }
        public function get index():uint{
            return (this._index);
        }
        public function get x():Number{
            return (this._x);
        }
        public function set x(value:Number):void{
            this._x = value;
        }
        public function get y():Number{
            return (this._y);
        }
        public function set y(value:Number):void{
            this._y = value;
        }
        public function get z():Number{
            return (this._z);
        }
        public function set z(value:Number):void{
            this._z = value;
        }
        public function clone():Vertex{
            return (new Vertex(this._x, this._y, this._z));
        }
        public function toString():String{
            return (((((this._x + ",") + this._y) + ",") + this._z));
        }

    }
}//package away3d.core.base.data 
