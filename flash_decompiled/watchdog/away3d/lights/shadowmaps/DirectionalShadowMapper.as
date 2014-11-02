package away3d.lights.shadowmaps {
    import away3d.cameras.*;
    import away3d.cameras.lenses.*;
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.display3D.textures.*;
    import away3d.containers.*;
    import away3d.core.render.*;
    import away3d.core.math.*;
    import away3d.lights.*;

    public class DirectionalShadowMapper extends ShadowMapperBase {

        protected var _depthCamera:Camera3D;
        private var _localFrustum:Vector.<Number>;
        private var _lightOffset:Number = 10000;
        private var _matrix:Matrix3D;
        private var _depthLens:FreeMatrixLens;

        public function DirectionalShadowMapper(){
            super();
            this._depthCamera = new Camera3D();
            this._depthCamera.lens = (this._depthLens = new FreeMatrixLens());
            this._localFrustum = new Vector.<Number>((8 * 3));
            this._matrix = new Matrix3D();
        }
        public function get lightOffset():Number{
            return (this._lightOffset);
        }
        public function set lightOffset(value:Number):void{
            this._lightOffset = value;
        }
        function get depthProjection():Matrix3D{
            return (this._depthCamera.viewProjection);
        }
        override protected function drawDepthMap(target:TextureBase, scene:Scene3D, renderer:DepthRenderer):void{
            _casterCollector.clear();
            _casterCollector.camera = this._depthCamera;
            scene.traversePartitions(_casterCollector);
            renderer.render(_casterCollector, target);
            _casterCollector.cleanUp();
        }
        override protected function updateDepthProjection(viewCamera:Camera3D):void{
            var dir:Vector3D;
            var d:Number;
            var x:Number;
            var y:Number;
            var z:Number;
            var scaleX:Number;
            var scaleY:Number;
            var offsX:Number;
            var offsY:Number;
            var i:uint;
            var raw:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
            var corners:Vector.<Number> = viewCamera.lens.frustumCorners;
            var minX:Number = Number.POSITIVE_INFINITY;
            var minY:Number = Number.POSITIVE_INFINITY;
            var minZ:Number = Number.POSITIVE_INFINITY;
            var maxX:Number = Number.NEGATIVE_INFINITY;
            var maxY:Number = Number.NEGATIVE_INFINITY;
            var maxZ:Number = Number.NEGATIVE_INFINITY;
            var halfSize:Number = (_depthMapSize * 0.5);
            this._depthCamera.transform = _light.sceneTransform;
            dir = DirectionalLight(_light).sceneDirection;
            this._depthCamera.x = (viewCamera.x - (dir.x * this._lightOffset));
            this._depthCamera.y = (viewCamera.y - (dir.y * this._lightOffset));
            this._depthCamera.z = (viewCamera.z - (dir.z * this._lightOffset));
            this._matrix.copyFrom(this._depthCamera.inverseSceneTransform);
            this._matrix.prepend(viewCamera.sceneTransform);
            this._matrix.transformVectors(corners, this._localFrustum);
            i = 0;
            while (i < 24) {
                var _temp1 = i;
                i = (i + 1);
                x = this._localFrustum[_temp1];
                var _temp2 = i;
                i = (i + 1);
                y = this._localFrustum[_temp2];
                var _temp3 = i;
                i = (i + 1);
                z = this._localFrustum[_temp3];
                if (x < minX){
                    minX = x;
                };
                if (x > maxX){
                    maxX = x;
                };
                if (y < minY){
                    minY = y;
                };
                if (y > maxY){
                    maxY = y;
                };
                if (z > maxZ){
                    maxZ = z;
                };
            };
            scaleX = (64 / Math.ceil(((maxX - minX) * 32)));
            scaleY = (64 / Math.ceil(((maxY - minY) * 32)));
            offsX = (Math.ceil((((-0.5 * (maxX + minX)) * scaleX) * halfSize)) / halfSize);
            offsY = (Math.ceil((((-0.5 * (maxY + minY)) * scaleY) * halfSize)) / halfSize);
            minZ = 10;
            d = (1 / (maxZ - minZ));
            raw[0] = (raw[5] = (raw[15] = 1));
            raw[10] = d;
            raw[14] = (-(minZ) * d);
            raw[1] = (raw[2] = (raw[3] = (raw[4] = (raw[6] = (raw[7] = (raw[8] = (raw[9] = (raw[11] = (raw[12] = (raw[13] = 0))))))))));
            this._matrix.copyRawDataFrom(raw);
            this._matrix.prependTranslation(offsX, offsY, 0);
            this._matrix.prependScale(scaleX, scaleY, 1);
            this._depthLens.matrix = this._matrix;
        }

    }
}//package away3d.lights.shadowmaps 
