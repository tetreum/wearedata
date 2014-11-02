package away3d.cameras.lenses {
    import __AS3__.vec.*;
    import flash.geom.*;
    import away3d.events.*;
    import away3d.errors.*;
    import flash.events.*;

    public class LensBase extends EventDispatcher {

        protected var _matrix:Matrix3D;
        protected var _near:Number = 20;
        protected var _far:Number = 3000;
        protected var _aspectRatio:Number = 1;
        protected var _matrixInvalid:Boolean = true;
        protected var _frustumCorners:Vector.<Number>;
        private var _unprojection:Matrix3D;
        private var _unprojectionInvalid:Boolean = true;

        public function LensBase(){
            this._frustumCorners = new Vector.<Number>((8 * 3), true);
            super();
            this._matrix = new Matrix3D();
        }
        public function get frustumCorners():Vector.<Number>{
            return (this._frustumCorners);
        }
        public function set frustumCorners(frustumCorners:Vector.<Number>):void{
            this._frustumCorners = frustumCorners;
        }
        public function get matrix():Matrix3D{
            if (this._matrixInvalid){
                this.updateMatrix();
                this._matrixInvalid = false;
            };
            return (this._matrix);
        }
        public function set matrix(value:Matrix3D):void{
            this._matrix = value;
            this.invalidateMatrix();
        }
        public function get near():Number{
            return (this._near);
        }
        public function set near(value:Number):void{
            if (value == this._near){
                return;
            };
            this._near = value;
            this.invalidateMatrix();
        }
        public function get far():Number{
            return (this._far);
        }
        public function set far(value:Number):void{
            if (value == this._far){
                return;
            };
            this._far = value;
            this.invalidateMatrix();
        }
        public function project(point3d:Vector3D):Vector3D{
            var v:Vector3D = this.matrix.transformVector(point3d);
            v.x = (v.x / v.w);
            v.y = (-(v.y) / v.w);
            return (v);
        }
        public function get unprojectionMatrix():Matrix3D{
            if (this._unprojectionInvalid){
                this._unprojection = ((this._unprojection) || (new Matrix3D()));
                this._unprojection.copyFrom(this.matrix);
                this._unprojection.invert();
                this._unprojectionInvalid = false;
            };
            return (this._unprojection);
        }
        public function unproject(mX:Number, mY:Number, mZ:Number):Vector3D{
            var v:Vector3D = new Vector3D(mX, -(mY), mZ, 1);
            v = this.unprojectionMatrix.transformVector(v);
            var inv:Number = (1 / v.w);
            v.x = (v.x * inv);
            v.y = (v.y * inv);
            v.z = (v.z * inv);
            v.w = 1;
            return (v);
        }
        function get aspectRatio():Number{
            return (this._aspectRatio);
        }
        function set aspectRatio(value:Number):void{
            if (this._aspectRatio == value){
                return;
            };
            this._aspectRatio = value;
            this.invalidateMatrix();
        }
        protected function invalidateMatrix():void{
            this._matrixInvalid = true;
            this._unprojectionInvalid = true;
            dispatchEvent(new LensEvent(LensEvent.MATRIX_CHANGED, this));
        }
        protected function updateMatrix():void{
            throw (new AbstractMethodError());
        }

    }
}//package away3d.cameras.lenses 
