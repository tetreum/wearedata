package away3d.core.base.data {

    public class UV {

        private var _u:Number;
        private var _v:Number;

        public function UV(u:Number=0, v:Number=0){
            super();
            this._u = u;
            this._v = v;
        }
        public function get v():Number{
            return (this._v);
        }
        public function set v(value:Number):void{
            this._v = value;
        }
        public function get u():Number{
            return (this._u);
        }
        public function set u(value:Number):void{
            this._u = value;
        }
        public function clone():UV{
            return (new UV(this._u, this._v));
        }
        public function toString():String{
            return (((this._u + ",") + this._v));
        }

    }
}//package away3d.core.base.data 
