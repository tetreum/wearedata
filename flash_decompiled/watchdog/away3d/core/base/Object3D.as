package away3d.core.base {
    import away3d.events.*;
    import away3d.core.math.*;
    import flash.geom.*;
    import __AS3__.vec.*;
    import away3d.controllers.*;
    import away3d.library.assets.*;

    public class Object3D extends NamedAssetBase {

        var _controller:ControllerBase;
        private var _smallestNumber:Number = 1E-22;
        private var _transformDirty:Boolean = true;
        private var _positionDirty:Boolean;
        private var _rotationDirty:Boolean;
        private var _scaleDirty:Boolean;
        private var _positionChanged:Object3DEvent;
        private var _rotationChanged:Object3DEvent;
        private var _scaleChanged:Object3DEvent;
        private var _rotationX:Number = 0;
        private var _rotationY:Number = 0;
        private var _rotationZ:Number = 0;
        private var _eulers:Vector3D;
        private var _flipY:Matrix3D;
        private var _listenToPositionChanged:Boolean;
        private var _listenToRotationChanged:Boolean;
        private var _listenToScaleChanged:Boolean;
        protected var _transform:Matrix3D;
        protected var _scaleX:Number = 1;
        protected var _scaleY:Number = 1;
        protected var _scaleZ:Number = 1;
        protected var _x:Number = 0;
        protected var _y:Number = 0;
        protected var _z:Number = 0;
        protected var _pivotPoint:Vector3D;
        protected var _pivotZero:Boolean = true;
        protected var _pos:Vector3D;
        protected var _rot:Vector3D;
        protected var _sca:Vector3D;
        protected var _transformComponents:Vector.<Vector3D>;
        public var extra:Object;

        public function Object3D(){
            this._eulers = new Vector3D();
            this._flipY = new Matrix3D();
            this._transform = new Matrix3D();
            this._pivotPoint = new Vector3D();
            this._pos = new Vector3D();
            this._rot = new Vector3D();
            this._sca = new Vector3D();
            super();
            this._transformComponents = new Vector.<Vector3D>(3, true);
            this._transformComponents[0] = this._pos;
            this._transformComponents[1] = this._rot;
            this._transformComponents[2] = this._sca;
            this._transform.identity();
            this._flipY.appendScale(1, -1, 1);
        }
        private function invalidatePivot():void{
            this._pivotZero = (((((this._pivotPoint.x == 0)) && ((this._pivotPoint.y == 0)))) && ((this._pivotPoint.z == 0)));
            this.invalidateTransform();
        }
        private function invalidatePosition():void{
            if (this._positionDirty){
                return;
            };
            this._positionDirty = true;
            this.invalidateTransform();
            if (this._listenToPositionChanged){
                this.notifyPositionChanged();
            };
        }
        private function notifyPositionChanged():void{
            if (!(this._positionChanged)){
                this._positionChanged = new Object3DEvent(Object3DEvent.POSITION_CHANGED, this);
            };
            dispatchEvent(this._positionChanged);
        }
        override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            switch (type){
                case Object3DEvent.POSITION_CHANGED:
                    this._listenToPositionChanged = true;
                    break;
                case Object3DEvent.ROTATION_CHANGED:
                    this._listenToRotationChanged = true;
                    break;
                case Object3DEvent.SCALE_CHANGED:
                    this._listenToRotationChanged = true;
                    break;
            };
        }
        override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
            super.removeEventListener(type, listener, useCapture);
            if (hasEventListener(type)){
                return;
            };
            switch (type){
                case Object3DEvent.POSITION_CHANGED:
                    this._listenToPositionChanged = false;
                    break;
                case Object3DEvent.ROTATION_CHANGED:
                    this._listenToRotationChanged = false;
                    break;
                case Object3DEvent.SCALE_CHANGED:
                    this._listenToScaleChanged = false;
                    break;
            };
        }
        private function invalidateRotation():void{
            if (this._rotationDirty){
                return;
            };
            this._rotationDirty = true;
            this.invalidateTransform();
            if (this._listenToRotationChanged){
                this.notifyRotationChanged();
            };
        }
        private function notifyRotationChanged():void{
            if (!(this._rotationChanged)){
                this._rotationChanged = new Object3DEvent(Object3DEvent.ROTATION_CHANGED, this);
            };
            dispatchEvent(this._rotationChanged);
        }
        private function invalidateScale():void{
            if (this._scaleDirty){
                return;
            };
            this._scaleDirty = true;
            this.invalidateTransform();
            if (this._listenToScaleChanged){
                this.notifyScaleChanged();
            };
        }
        private function notifyScaleChanged():void{
            if (!(this._scaleChanged)){
                this._scaleChanged = new Object3DEvent(Object3DEvent.SCALE_CHANGED, this);
            };
            dispatchEvent(this._scaleChanged);
        }
        public function get x():Number{
            return (this._x);
        }
        public function set x(val:Number):void{
            if (this._x == val){
                return;
            };
            this._x = val;
            this.invalidatePosition();
        }
        public function get y():Number{
            return (this._y);
        }
        public function set y(val:Number):void{
            if (this._y == val){
                return;
            };
            this._y = val;
            this.invalidatePosition();
        }
        public function get z():Number{
            return (this._z);
        }
        public function set z(val:Number):void{
            if (this._z == val){
                return;
            };
            this._z = val;
            this.invalidatePosition();
        }
        public function get rotationX():Number{
            return ((this._rotationX * MathConsts.RADIANS_TO_DEGREES));
        }
        public function set rotationX(val:Number):void{
            if (this.rotationX == val){
                return;
            };
            this._rotationX = (val * MathConsts.DEGREES_TO_RADIANS);
            this.invalidateRotation();
        }
        public function get rotationY():Number{
            return ((this._rotationY * MathConsts.RADIANS_TO_DEGREES));
        }
        public function set rotationY(val:Number):void{
            if (this.rotationY == val){
                return;
            };
            this._rotationY = (val * MathConsts.DEGREES_TO_RADIANS);
            this.invalidateRotation();
        }
        public function get rotationZ():Number{
            return ((this._rotationZ * MathConsts.RADIANS_TO_DEGREES));
        }
        public function set rotationZ(val:Number):void{
            if (this.rotationZ == val){
                return;
            };
            this._rotationZ = (val * MathConsts.DEGREES_TO_RADIANS);
            this.invalidateRotation();
        }
        public function get scaleX():Number{
            return (this._scaleX);
        }
        public function set scaleX(val:Number):void{
            if (this._scaleX == val){
                return;
            };
            this._scaleX = val;
            this.invalidateScale();
        }
        public function get scaleY():Number{
            return (this._scaleY);
        }
        public function set scaleY(val:Number):void{
            if (this._scaleY == val){
                return;
            };
            this._scaleY = val;
            this.invalidateScale();
        }
        public function get scaleZ():Number{
            return (this._scaleZ);
        }
        public function set scaleZ(val:Number):void{
            if (this._scaleZ == val){
                return;
            };
            this._scaleZ = val;
            this.invalidateScale();
        }
        public function get eulers():Vector3D{
            this._eulers.x = (this._rotationX * MathConsts.RADIANS_TO_DEGREES);
            this._eulers.y = (this._rotationY * MathConsts.RADIANS_TO_DEGREES);
            this._eulers.z = (this._rotationZ * MathConsts.RADIANS_TO_DEGREES);
            return (this._eulers);
        }
        public function set eulers(value:Vector3D):void{
            this._rotationX = (value.x * MathConsts.DEGREES_TO_RADIANS);
            this._rotationY = (value.y * MathConsts.DEGREES_TO_RADIANS);
            this._rotationZ = (value.z * MathConsts.DEGREES_TO_RADIANS);
            this.invalidateRotation();
        }
        public function get transform():Matrix3D{
            if (this._transformDirty){
                this.updateTransform();
            };
            return (this._transform);
        }
        public function set transform(val:Matrix3D):void{
            var vec:Vector3D;
            var raw:Vector.<Number>;
            if (!(val.rawData[uint(0)])){
                raw = Matrix3DUtils.RAW_DATA_CONTAINER;
                val.copyRawDataTo(raw);
                raw[uint(0)] = this._smallestNumber;
                val.copyRawDataFrom(raw);
            };
            var elements:Vector.<Vector3D> = val.decompose();
            vec = elements[0];
            if (((((!((this._x == vec.x))) || (!((this._y == vec.y))))) || (!((this._z == vec.z))))){
                this._x = vec.x;
                this._y = vec.y;
                this._z = vec.z;
                this.invalidatePosition();
            };
            vec = elements[1];
            if (((((!((this._rotationX == vec.x))) || (!((this._rotationY == vec.y))))) || (!((this._rotationZ == vec.z))))){
                this._rotationX = vec.x;
                this._rotationY = vec.y;
                this._rotationZ = vec.z;
                this.invalidateRotation();
            };
            vec = elements[2];
            if (((((!((this._scaleX == vec.x))) || (!((this._scaleY == vec.y))))) || (!((this._scaleZ == vec.z))))){
                this._scaleX = vec.x;
                this._scaleY = vec.y;
                this._scaleZ = vec.z;
                this.invalidateScale();
            };
        }
        public function get pivotPoint():Vector3D{
            return (this._pivotPoint);
        }
        public function set pivotPoint(pivot:Vector3D):void{
            this._pivotPoint = pivot.clone();
            this.invalidatePivot();
        }
        public function get position():Vector3D{
            this.transform.copyColumnTo(3, this._pos);
            return (this._pos.clone());
        }
        public function set position(value:Vector3D):void{
            this._x = value.x;
            this._y = value.y;
            this._z = value.z;
            this.invalidatePosition();
        }
        public function get forwardVector():Vector3D{
            return (Matrix3DUtils.getForward(this.transform));
        }
        public function get rightVector():Vector3D{
            return (Matrix3DUtils.getRight(this.transform));
        }
        public function get upVector():Vector3D{
            return (Matrix3DUtils.getUp(this.transform));
        }
        public function get backVector():Vector3D{
            var director:Vector3D = Matrix3DUtils.getForward(this.transform);
            director.negate();
            return (director);
        }
        public function get leftVector():Vector3D{
            var director:Vector3D = Matrix3DUtils.getRight(this.transform);
            director.negate();
            return (director);
        }
        public function get downVector():Vector3D{
            var director:Vector3D = Matrix3DUtils.getUp(this.transform);
            director.negate();
            return (director);
        }
        public function scale(value:Number):void{
            this._scaleX = (this._scaleX * value);
            this._scaleY = (this._scaleY * value);
            this._scaleZ = (this._scaleZ * value);
            this.invalidateScale();
        }
        public function moveForward(distance:Number):void{
            this.translateLocal(Vector3D.Z_AXIS, distance);
        }
        public function moveBackward(distance:Number):void{
            this.translateLocal(Vector3D.Z_AXIS, -(distance));
        }
        public function moveLeft(distance:Number):void{
            this.translateLocal(Vector3D.X_AXIS, -(distance));
        }
        public function moveRight(distance:Number):void{
            this.translateLocal(Vector3D.X_AXIS, distance);
        }
        public function moveUp(distance:Number):void{
            this.translateLocal(Vector3D.Y_AXIS, distance);
        }
        public function moveDown(distance:Number):void{
            this.translateLocal(Vector3D.Y_AXIS, -(distance));
        }
        public function moveTo(dx:Number, dy:Number, dz:Number):void{
            if ((((((this._x == dx)) && ((this._y == dy)))) && ((this._z == dz)))){
                return;
            };
            this._x = dx;
            this._y = dy;
            this._z = dz;
            this.invalidatePosition();
        }
        public function movePivot(dx:Number, dy:Number, dz:Number):void{
            this._pivotPoint = ((this._pivotPoint) || (new Vector3D()));
            this._pivotPoint.x = (this._pivotPoint.x + dx);
            this._pivotPoint.y = (this._pivotPoint.y + dy);
            this._pivotPoint.z = (this._pivotPoint.z + dz);
            this.invalidatePivot();
        }
        public function translate(axis:Vector3D, distance:Number):void{
            var x:Number = axis.x;
            var y:Number = axis.y;
            var z:Number = axis.z;
            var len:Number = (distance / Math.sqrt((((x * x) + (y * y)) + (z * z))));
            this._x = (this._x + (x * len));
            this._y = (this._y + (y * len));
            this._z = (this._z + (z * len));
            this.invalidatePosition();
        }
        public function translateLocal(axis:Vector3D, distance:Number):void{
            var x:Number = axis.x;
            var y:Number = axis.y;
            var z:Number = axis.z;
            var len:Number = (distance / Math.sqrt((((x * x) + (y * y)) + (z * z))));
            this.transform.prependTranslation((x * len), (y * len), (z * len));
            this._transform.copyColumnTo(3, this._pos);
            this._x = this._pos.x;
            this._y = this._pos.y;
            this._z = this._pos.z;
            this.invalidatePosition();
        }
        public function pitch(angle:Number):void{
            this.rotate(Vector3D.X_AXIS, angle);
        }
        public function yaw(angle:Number):void{
            this.rotate(Vector3D.Y_AXIS, angle);
        }
        public function roll(angle:Number):void{
            this.rotate(Vector3D.Z_AXIS, angle);
        }
        public function clone():Object3D{
            var clone:Object3D = new Object3D();
            clone.pivotPoint = this.pivotPoint;
            clone.transform = this.transform;
            clone.name = name;
            return (clone);
        }
        public function rotateTo(ax:Number, ay:Number, az:Number):void{
            this._rotationX = (ax * MathConsts.DEGREES_TO_RADIANS);
            this._rotationY = (ay * MathConsts.DEGREES_TO_RADIANS);
            this._rotationZ = (az * MathConsts.DEGREES_TO_RADIANS);
            this.invalidateRotation();
        }
        public function rotate(axis:Vector3D, angle:Number):void{
            this.transform.prependRotation(angle, axis);
            this.transform = this.transform;
        }
        public function lookAt(target:Vector3D, upAxis:Vector3D=null):void{
            var yAxis:Vector3D;
            var zAxis:Vector3D;
            var xAxis:Vector3D;
            var raw:Vector.<Number>;
            upAxis = ((upAxis) || (Vector3D.Y_AXIS));
            zAxis = target.subtract(this.position);
            zAxis.normalize();
            xAxis = upAxis.crossProduct(zAxis);
            xAxis.normalize();
            if (xAxis.length < 0.05){
                xAxis = upAxis.crossProduct(Vector3D.Z_AXIS);
            };
            yAxis = zAxis.crossProduct(xAxis);
            raw = Matrix3DUtils.RAW_DATA_CONTAINER;
            raw[uint(0)] = (this._scaleX * xAxis.x);
            raw[uint(1)] = (this._scaleX * xAxis.y);
            raw[uint(2)] = (this._scaleX * xAxis.z);
            raw[uint(3)] = 0;
            raw[uint(4)] = (this._scaleY * yAxis.x);
            raw[uint(5)] = (this._scaleY * yAxis.y);
            raw[uint(6)] = (this._scaleY * yAxis.z);
            raw[uint(7)] = 0;
            raw[uint(8)] = (this._scaleZ * zAxis.x);
            raw[uint(9)] = (this._scaleZ * zAxis.y);
            raw[uint(10)] = (this._scaleZ * zAxis.z);
            raw[uint(11)] = 0;
            raw[uint(12)] = this._x;
            raw[uint(13)] = this._y;
            raw[uint(14)] = this._z;
            raw[uint(15)] = 1;
            this._transform.copyRawDataFrom(raw);
            this.transform = this.transform;
            if (zAxis.z < 0){
                this.rotationY = (180 - this.rotationY);
                this.rotationX = (this.rotationX - 180);
                this.rotationZ = (this.rotationZ - 180);
            };
        }
        public function dispose():void{
        }
        public function disposeAsset():void{
            this.dispose();
        }
        function invalidateTransform():void{
            this._transformDirty = true;
        }
        protected function updateTransform():void{
            this._pos.x = this._x;
            this._pos.y = this._y;
            this._pos.z = this._z;
            this._rot.x = this._rotationX;
            this._rot.y = this._rotationY;
            this._rot.z = this._rotationZ;
            this._sca.x = this._scaleX;
            this._sca.y = this._scaleY;
            this._sca.z = this._scaleZ;
            this._transform.recompose(this._transformComponents);
            if (!(this._pivotZero)){
                this._transform.prependTranslation(-(this._pivotPoint.x), -(this._pivotPoint.y), -(this._pivotPoint.z));
                this._transform.appendTranslation(this._pivotPoint.x, this._pivotPoint.y, this._pivotPoint.z);
            };
            this._transformDirty = false;
            this._positionDirty = false;
            this._rotationDirty = false;
            this._scaleDirty = false;
        }

    }
}//package away3d.core.base 
