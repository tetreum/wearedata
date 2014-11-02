package away3d.lights {
    import flash.geom.*;
    import away3d.core.partition.*;
    import away3d.bounds.*;
    import away3d.lights.shadowmaps.*;
    import away3d.core.math.*;
    import __AS3__.vec.*;
    import away3d.core.base.*;

    public class DirectionalLight extends LightBase {

        private var _direction:Vector3D;
        private var _tmpLookAt:Vector3D;
        private var _sceneDirection:Vector3D;
        private var _projAABBPoints:Vector.<Number>;

        public function DirectionalLight(xDir:Number=0, yDir:Number=-1, zDir:Number=1){
            super();
            this.direction = new Vector3D(xDir, yDir, zDir);
            this._sceneDirection = new Vector3D();
        }
        override protected function createEntityPartitionNode():EntityNode{
            return (new DirectionalLightNode(this));
        }
        public function get sceneDirection():Vector3D{
            return (this._sceneDirection);
        }
        public function get direction():Vector3D{
            return (this._direction);
        }
        public function set direction(value:Vector3D):void{
            this._direction = value;
            if (!(this._tmpLookAt)){
                this._tmpLookAt = new Vector3D();
            };
            this._tmpLookAt.x = (x + this._direction.x);
            this._tmpLookAt.y = (y + this._direction.y);
            this._tmpLookAt.z = (z + this._direction.z);
            lookAt(this._tmpLookAt);
        }
        override protected function getDefaultBoundingVolume():BoundingVolumeBase{
            return (new NullBounds());
        }
        override protected function updateBounds():void{
        }
        override protected function updateSceneTransform():void{
            super.updateSceneTransform();
            sceneTransform.copyColumnTo(2, this._sceneDirection);
            this._sceneDirection.normalize();
        }
        override protected function createShadowMapper():ShadowMapperBase{
            return (new DirectionalShadowMapper());
        }
        override function getObjectProjectionMatrix(renderable:IRenderable, target:Matrix3D=null):Matrix3D{
            var d:Number;
            var raw:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
            var bounds:BoundingVolumeBase = renderable.sourceEntity.bounds;
            var m:Matrix3D = new Matrix3D();
            m.copyFrom(renderable.sceneTransform);
            m.append(inverseSceneTransform);
            if (!(this._projAABBPoints)){
                this._projAABBPoints = new Vector.<Number>();
            };
            m.transformVectors(bounds.aabbPoints, this._projAABBPoints);
            var xMin:Number = Number.POSITIVE_INFINITY;
            var xMax:Number = Number.NEGATIVE_INFINITY;
            var yMin:Number = Number.POSITIVE_INFINITY;
            var yMax:Number = Number.NEGATIVE_INFINITY;
            var zMin:Number = Number.POSITIVE_INFINITY;
            var zMax:Number = Number.NEGATIVE_INFINITY;
            var i:int;
            while (i < 24) {
                var _temp1 = i;
                i = (i + 1);
                d = this._projAABBPoints[_temp1];
                if (d < xMin){
                    xMin = d;
                };
                if (d > xMax){
                    xMax = d;
                };
                var _temp2 = i;
                i = (i + 1);
                d = this._projAABBPoints[_temp2];
                if (d < yMin){
                    yMin = d;
                };
                if (d > yMax){
                    yMax = d;
                };
                var _temp3 = i;
                i = (i + 1);
                d = this._projAABBPoints[_temp3];
                if (d < zMin){
                    zMin = d;
                };
                if (d > zMax){
                    zMax = d;
                };
            };
            var invXRange:Number = (1 / (xMax - xMin));
            var invYRange:Number = (1 / (yMax - yMin));
            var invZRange:Number = (1 / (zMax - zMin));
            raw[0] = (2 * invXRange);
            raw[5] = (2 * invYRange);
            raw[10] = invZRange;
            raw[12] = (-((xMax + xMin)) * invXRange);
            raw[13] = (-((yMax + yMin)) * invYRange);
            raw[14] = (-(zMin) * invZRange);
            raw[1] = (raw[2] = (raw[3] = (raw[4] = (raw[6] = (raw[7] = (raw[8] = (raw[9] = (raw[11] = 0))))))));
            raw[15] = 1;
            target = ((target) || (new Matrix3D()));
            target.copyRawDataFrom(raw);
            target.prepend(m);
            return (target);
        }

    }
}//package away3d.lights 
