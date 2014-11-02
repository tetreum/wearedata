package away3d.bounds {
    import flash.geom.*;
    import __AS3__.vec.*;
    import away3d.primitives.*;
    import away3d.core.base.*;
    import away3d.core.pick.*;
    import away3d.errors.*;

    public class BoundingVolumeBase {

        protected var _min:Vector3D;
        protected var _max:Vector3D;
        protected var _aabbPoints:Vector.<Number>;
        protected var _aabbPointsDirty:Boolean = true;
        protected var _boundingRenderable:WireframePrimitiveBase;

        public function BoundingVolumeBase(){
            this._aabbPoints = new Vector.<Number>();
            super();
            this._min = new Vector3D();
            this._max = new Vector3D();
        }
        public function get max():Vector3D{
            return (this._max);
        }
        public function get min():Vector3D{
            return (this._min);
        }
        public function get aabbPoints():Vector.<Number>{
            if (this._aabbPointsDirty){
                this.updateAABBPoints();
            };
            return (this._aabbPoints);
        }
        public function get boundingRenderable():WireframePrimitiveBase{
            if (!(this._boundingRenderable)){
                this._boundingRenderable = this.createBoundingRenderable();
                this.updateBoundingRenderable();
            };
            return (this._boundingRenderable);
        }
        public function nullify():void{
            this._min.x = (this._min.y = (this._min.z = 0));
            this._max.x = (this._max.y = (this._max.z = 0));
            this._aabbPointsDirty = true;
            if (this._boundingRenderable){
                this.updateBoundingRenderable();
            };
        }
        public function disposeRenderable():void{
            if (this._boundingRenderable){
                this._boundingRenderable.dispose();
            };
            this._boundingRenderable = null;
        }
        public function fromVertices(vertices:Vector.<Number>):void{
            var i:uint;
            var minX:Number;
            var minY:Number;
            var minZ:Number;
            var maxX:Number;
            var maxY:Number;
            var maxZ:Number;
            var v:Number;
            var len:uint = vertices.length;
            if (len == 0){
                this.nullify();
                return;
            };
            var _temp1 = i;
            i = (i + 1);
            maxX = vertices[uint(_temp1)];
            minX = maxX;
            var _temp2 = i;
            i = (i + 1);
            maxY = vertices[uint(_temp2)];
            minY = maxY;
            var _temp3 = i;
            i = (i + 1);
            maxZ = vertices[uint(_temp3)];
            minZ = maxZ;
            while (i < len) {
                var _temp4 = i;
                i = (i + 1);
                v = vertices[_temp4];
                if (v < minX){
                    minX = v;
                } else {
                    if (v > maxX){
                        maxX = v;
                    };
                };
                var _temp5 = i;
                i = (i + 1);
                v = vertices[_temp5];
                if (v < minY){
                    minY = v;
                } else {
                    if (v > maxY){
                        maxY = v;
                    };
                };
                var _temp6 = i;
                i = (i + 1);
                v = vertices[_temp6];
                if (v < minZ){
                    minZ = v;
                } else {
                    if (v > maxZ){
                        maxZ = v;
                    };
                };
            };
            this.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
        }
        public function fromGeometry(geometry:Geometry):void{
            var subs:Vector.<SubGeometry> = geometry.subGeometries;
            var lenS:uint = subs.length;
            if ((((lenS > 0)) && ((subs[0].vertexData.length >= 3)))){
                this.fromExtremes(-99999, -99999, -99999, 99999, 99999, 99999);
            } else {
                this.fromExtremes(0, 0, 0, 0, 0, 0);
            };
        }
        public function fromSphere(center:Vector3D, radius:Number):void{
            this.fromExtremes((center.x - radius), (center.y - radius), (center.z - radius), (center.x + radius), (center.y + radius), (center.z + radius));
        }
        public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void{
            this._min.x = minX;
            this._min.y = minY;
            this._min.z = minZ;
            this._max.x = maxX;
            this._max.y = maxY;
            this._max.z = maxZ;
            this._aabbPointsDirty = true;
            if (this._boundingRenderable){
                this.updateBoundingRenderable();
            };
        }
        public function isInFrustum(mvpMatrix:Matrix3D):Boolean{
            throw (new AbstractMethodError());
        }
        public function clone():BoundingVolumeBase{
            throw (new AbstractMethodError());
        }
        public function rayIntersection(position:Vector3D, direction:Vector3D, targetNormal:Vector3D):Number{
            return (-1);
        }
        public function containsPoint(position:Vector3D):Boolean{
            return (false);
        }
        protected function updateAABBPoints():void{
            var maxX:Number = this._max.x;
            var maxY:Number = this._max.y;
            var maxZ:Number = this._max.z;
            var minX:Number = this._min.x;
            var minY:Number = this._min.y;
            var minZ:Number = this._min.z;
            this._aabbPoints[0] = minX;
            this._aabbPoints[1] = minY;
            this._aabbPoints[2] = minZ;
            this._aabbPoints[3] = maxX;
            this._aabbPoints[4] = minY;
            this._aabbPoints[5] = minZ;
            this._aabbPoints[6] = minX;
            this._aabbPoints[7] = maxY;
            this._aabbPoints[8] = minZ;
            this._aabbPoints[9] = maxX;
            this._aabbPoints[10] = maxY;
            this._aabbPoints[11] = minZ;
            this._aabbPoints[12] = minX;
            this._aabbPoints[13] = minY;
            this._aabbPoints[14] = maxZ;
            this._aabbPoints[15] = maxX;
            this._aabbPoints[16] = minY;
            this._aabbPoints[17] = maxZ;
            this._aabbPoints[18] = minX;
            this._aabbPoints[19] = maxY;
            this._aabbPoints[20] = maxZ;
            this._aabbPoints[21] = maxX;
            this._aabbPoints[22] = maxY;
            this._aabbPoints[23] = maxZ;
            this._aabbPointsDirty = false;
        }
        protected function updateBoundingRenderable():void{
            throw (new AbstractMethodError());
        }
        protected function createBoundingRenderable():WireframePrimitiveBase{
            throw (new AbstractMethodError());
        }

    }
}//package away3d.bounds 
