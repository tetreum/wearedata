package away3d.cameras {
    import flash.geom.*;
    import away3d.cameras.lenses.*;
    import away3d.events.*;
    import __AS3__.vec.*;
    import away3d.core.math.*;
    import away3d.core.partition.*;
    import away3d.entities.*;

    public class Camera3D extends Entity {

        private var _viewProjection:Matrix3D;
        private var _viewProjectionDirty:Boolean = true;
        private var _lens:LensBase;
        private var _frustumPlanes:Vector.<Plane3D>;
        private var _frustumPlanesDirty:Boolean = true;

        public function Camera3D(lens:LensBase=null){
            this._viewProjection = new Matrix3D();
            super();
            this._lens = ((lens) || (new PerspectiveLens()));
            this._lens.addEventListener(LensEvent.MATRIX_CHANGED, this.onLensMatrixChanged);
            this._frustumPlanes = new Vector.<Plane3D>(6, true);
            var i:int;
            while (i < 6) {
                this._frustumPlanes[i] = new Plane3D();
                i++;
            };
            z = -1000;
        }
        private function onLensMatrixChanged(event:LensEvent):void{
            this._viewProjectionDirty = true;
            this._frustumPlanesDirty = true;
            dispatchEvent(event);
        }
        public function get frustumPlanes():Vector.<Plane3D>{
            var c11:Number;
            var c12:Number;
            var c13:Number;
            var c14:Number;
            var c21:Number;
            var c22:Number;
            var c23:Number;
            var c24:Number;
            var c31:Number;
            var c32:Number;
            var c33:Number;
            var c34:Number;
            var c41:Number;
            var c42:Number;
            var c43:Number;
            var c44:Number;
            var p:Plane3D;
            var raw:Vector.<Number>;
            if (this._frustumPlanesDirty){
                raw = Matrix3DUtils.RAW_DATA_CONTAINER;
                this.viewProjection.copyRawDataTo(raw);
                c11 = raw[uint(0)];
                c12 = raw[uint(4)];
                c13 = raw[uint(8)];
                c14 = raw[uint(12)];
                c21 = raw[uint(1)];
                c22 = raw[uint(5)];
                c23 = raw[uint(9)];
                c24 = raw[uint(13)];
                c31 = raw[uint(2)];
                c32 = raw[uint(6)];
                c33 = raw[uint(10)];
                c34 = raw[uint(14)];
                c41 = raw[uint(3)];
                c42 = raw[uint(7)];
                c43 = raw[uint(11)];
                c44 = raw[uint(15)];
                p = this._frustumPlanes[0];
                p.a = (c41 + c11);
                p.b = (c42 + c12);
                p.c = (c43 + c13);
                p.d = (c44 + c14);
                p = this._frustumPlanes[1];
                p.a = (c41 - c11);
                p.b = (c42 - c12);
                p.c = (c43 - c13);
                p.d = (c44 - c14);
                p = this._frustumPlanes[2];
                p.a = (c41 + c21);
                p.b = (c42 + c22);
                p.c = (c43 + c23);
                p.d = (c44 + c24);
                p = this._frustumPlanes[3];
                p.a = (c41 - c21);
                p.b = (c42 - c22);
                p.c = (c43 - c23);
                p.d = (c44 - c24);
                p = this._frustumPlanes[4];
                p.a = c31;
                p.b = c32;
                p.c = c33;
                p.d = c34;
                p = this._frustumPlanes[5];
                p.a = (c41 - c31);
                p.b = (c42 - c32);
                p.c = (c43 - c33);
                p.d = (c44 - c34);
                this._frustumPlanesDirty = false;
            };
            return (this._frustumPlanes);
        }
        override protected function invalidateSceneTransform():void{
            super.invalidateSceneTransform();
            this._viewProjectionDirty = true;
            this._frustumPlanesDirty = true;
        }
        override protected function updateBounds():void{
            _bounds.nullify();
            _boundsInvalid = false;
        }
        override protected function createEntityPartitionNode():EntityNode{
            return (new CameraNode(this));
        }
        public function get lens():LensBase{
            return (this._lens);
        }
        public function set lens(value:LensBase):void{
            if (this._lens == value){
                return;
            };
            if (!(value)){
                throw (new Error("Lens cannot be null!"));
            };
            this._lens.removeEventListener(LensEvent.MATRIX_CHANGED, this.onLensMatrixChanged);
            this._lens = value;
            this._lens.addEventListener(LensEvent.MATRIX_CHANGED, this.onLensMatrixChanged);
            dispatchEvent(new LensEvent(LensEvent.MATRIX_CHANGED, value));
        }
        public function get viewProjection():Matrix3D{
            if (this._viewProjectionDirty){
                this._viewProjection.copyFrom(inverseSceneTransform);
                this._viewProjection.append(this._lens.matrix);
                this._viewProjectionDirty = false;
            };
            return (this._viewProjection);
        }
        public function unproject(mX:Number, mY:Number, mZ:Number=0):Vector3D{
            return (sceneTransform.transformVector(this.lens.unproject(mX, mY, mZ)));
        }
        public function getRay(mX:Number, mY:Number, mZ:Number=0):Vector3D{
            return (sceneTransform.deltaTransformVector(this.lens.unproject(mX, mY, mZ)));
        }
        public function project(point3d:Vector3D):Vector3D{
            return (this.lens.project(inverseSceneTransform.transformVector(point3d)));
        }

    }
}//package away3d.cameras 
