package away3d.cameras.lenses {
    import away3d.core.math.*;
    import __AS3__.vec.*;

    public class PerspectiveLens extends LensBase {

        private var _fieldOfView:Number;
        private var _focalLengthInv:Number;
        private var _yMax:Number;
        private var _xMax:Number;

        public function PerspectiveLens(fieldOfView:Number=60){
            super();
            this.fieldOfView = fieldOfView;
        }
        public function get fieldOfView():Number{
            return (this._fieldOfView);
        }
        public function set fieldOfView(value:Number):void{
            if (value == this._fieldOfView){
                return;
            };
            this._fieldOfView = value;
            this._focalLengthInv = Math.tan(((this._fieldOfView * Math.PI) / 360));
            invalidateMatrix();
        }
        override protected function updateMatrix():void{
            var raw:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
            this._yMax = (_near * this._focalLengthInv);
            this._xMax = (this._yMax * _aspectRatio);
            raw[uint(0)] = (_near / this._xMax);
            raw[uint(5)] = (_near / this._yMax);
            raw[uint(10)] = (_far / (_far - _near));
            raw[uint(11)] = 1;
            raw[uint(1)] = (raw[uint(2)] = (raw[uint(3)] = (raw[uint(4)] = (raw[uint(6)] = (raw[uint(7)] = (raw[uint(8)] = (raw[uint(9)] = (raw[uint(12)] = (raw[uint(13)] = (raw[uint(15)] = 0))))))))));
            raw[uint(14)] = (-(_near) * raw[uint(10)]);
            _matrix.copyRawDataFrom(raw);
            var yMaxFar:Number = (_far * this._focalLengthInv);
            var xMaxFar:Number = (yMaxFar * _aspectRatio);
            _frustumCorners[0] = (_frustumCorners[9] = -(this._xMax));
            _frustumCorners[3] = (_frustumCorners[6] = this._xMax);
            _frustumCorners[1] = (_frustumCorners[4] = -(this._yMax));
            _frustumCorners[7] = (_frustumCorners[10] = this._yMax);
            _frustumCorners[12] = (_frustumCorners[21] = -(xMaxFar));
            _frustumCorners[15] = (_frustumCorners[18] = xMaxFar);
            _frustumCorners[13] = (_frustumCorners[16] = -(yMaxFar));
            _frustumCorners[19] = (_frustumCorners[22] = yMaxFar);
            _frustumCorners[2] = (_frustumCorners[5] = (_frustumCorners[8] = (_frustumCorners[11] = _near)));
            _frustumCorners[14] = (_frustumCorners[17] = (_frustumCorners[20] = (_frustumCorners[23] = _far)));
            _matrixInvalid = false;
        }

    }
}//package away3d.cameras.lenses 
