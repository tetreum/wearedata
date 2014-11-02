package away3d.cameras.lenses {

    public class FreeMatrixLens extends LensBase {

        public function FreeMatrixLens(){
            super();
            _matrix.copyFrom(new PerspectiveLens().matrix);
        }
        override protected function updateMatrix():void{
            _matrixInvalid = false;
        }
        override public function set near(value:Number):void{
            _near = value;
        }
        override public function set far(value:Number):void{
            _far = value;
        }
        override function set aspectRatio(value:Number):void{
            _aspectRatio = value;
        }

    }
}//package away3d.cameras.lenses 
