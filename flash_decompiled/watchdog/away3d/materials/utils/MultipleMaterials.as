package away3d.materials.utils {
    import away3d.materials.*;

    public class MultipleMaterials {

        private var _left:MaterialBase;
        private var _right:MaterialBase;
        private var _bottom:MaterialBase;
        private var _top:MaterialBase;
        private var _front:MaterialBase;
        private var _back:MaterialBase;

        public function MultipleMaterials(front:MaterialBase=null, back:MaterialBase=null, left:MaterialBase=null, right:MaterialBase=null, top:MaterialBase=null){
            super();
            this._left = left;
            this._right = right;
            this._bottom = this.bottom;
            this._top = top;
            this._front = front;
            this._back = back;
        }
        public function get left():MaterialBase{
            return (this._left);
        }
        public function set left(val:MaterialBase):void{
            if (this._left == val){
                return;
            };
            this._left = val;
        }
        public function get right():MaterialBase{
            return (this._right);
        }
        public function set right(val:MaterialBase):void{
            if (this._right == val){
                return;
            };
            this._right = val;
        }
        public function get bottom():MaterialBase{
            return (this._bottom);
        }
        public function set bottom(val:MaterialBase):void{
            if (this._bottom == val){
                return;
            };
            this._bottom = val;
        }
        public function get top():MaterialBase{
            return (this._top);
        }
        public function set top(val:MaterialBase):void{
            if (this._top == val){
                return;
            };
            this._top = val;
        }
        public function get front():MaterialBase{
            return (this._front);
        }
        public function set front(val:MaterialBase):void{
            if (this._front == val){
                return;
            };
            this._front = val;
        }
        public function get back():MaterialBase{
            return (this._back);
        }
        public function set back(val:MaterialBase):void{
            if (this._back == val){
                return;
            };
            this._back = val;
        }

    }
}//package away3d.materials.utils 
