package away3d.materials.utils {

    public class ShaderRegisterElement {

        private var _regName:String;
        private var _index:int;
        private var _component:String;

        public function ShaderRegisterElement(regName:String, index:int, component:String=null){
            super();
            this._regName = regName;
            this._index = index;
            this._component = component;
        }
        public function toString():String{
            if (this._index >= 0){
                return (((this._regName + this._index) + ((this._component) ? ("." + this._component) : "")));
            };
            return ((this._regName + ((this._component) ? ("." + this._component) : "")));
        }
        public function get regName():String{
            return (this._regName);
        }
        public function get index():int{
            return (this._index);
        }
        public function get component():String{
            return (this._component);
        }

    }
}//package away3d.materials.utils 
