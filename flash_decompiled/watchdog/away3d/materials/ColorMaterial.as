package away3d.materials {

    public class ColorMaterial extends DefaultMaterialBase {

        private var _diffuseAlpha:Number = 1;

        public function ColorMaterial(color:uint=0xCCCCCC, alpha:Number=1){
            super();
            this.color = color;
            this.alpha = alpha;
        }
        public function get alpha():Number{
            return (_screenPass.diffuseMethod.diffuseAlpha);
        }
        public function set alpha(value:Number):void{
            if (value > 1){
                value = 1;
            } else {
                if (value < 0){
                    value = 0;
                };
            };
            _screenPass.diffuseMethod.diffuseAlpha = (this._diffuseAlpha = value);
        }
        public function get color():uint{
            return (_screenPass.diffuseMethod.diffuseColor);
        }
        public function set color(value:uint):void{
            _screenPass.diffuseMethod.diffuseColor = value;
        }
        override public function get requiresBlending():Boolean{
            return (((super.requiresBlending) || ((this._diffuseAlpha < 1))));
        }

    }
}//package away3d.materials 
