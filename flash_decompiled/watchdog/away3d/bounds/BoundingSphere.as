package away3d.bounds {
    import away3d.core.math.*;
    import __AS3__.vec.*;
    import away3d.core.pick.*;
    import away3d.primitives.*;
    import flash.geom.*;

    public class BoundingSphere extends BoundingVolumeBase {

        private var _radius:Number = 0;
        private var _centerX:Number = 0;
        private var _centerY:Number = 0;
        private var _centerZ:Number = 0;

        public function BoundingSphere(){
            super();
        }
        public function get radius():Number{
            return (this._radius);
        }
        override public function nullify():void{
            super.nullify();
            this._centerX = (this._centerY = (this._centerZ = 0));
            this._radius = 0;
        }
        override public function isInFrustum(mvpMatrix:Matrix3D):Boolean{
            var a:Number;
            var b:Number;
            var c:Number;
            var d:Number;
            var dd:Number;
            var raw:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
            mvpMatrix.copyRawDataTo(raw);
            var c11:Number = raw[uint(0)];
            var c12:Number = raw[uint(4)];
            var c13:Number = raw[uint(8)];
            var c14:Number = raw[uint(12)];
            var c21:Number = raw[uint(1)];
            var c22:Number = raw[uint(5)];
            var c23:Number = raw[uint(9)];
            var c24:Number = raw[uint(13)];
            var c31:Number = raw[uint(2)];
            var c32:Number = raw[uint(6)];
            var c33:Number = raw[uint(10)];
            var c34:Number = raw[uint(14)];
            var c41:Number = raw[uint(3)];
            var c42:Number = raw[uint(7)];
            var c43:Number = raw[uint(11)];
            var c44:Number = raw[uint(15)];
            var rr:Number = this._radius;
            a = (c41 + c11);
            b = (c42 + c12);
            c = (c43 + c13);
            d = (c44 + c14);
            dd = (((a * this._centerX) + (b * this._centerY)) + (c * this._centerZ));
            if (a < 0){
                a = -(a);
            };
            if (b < 0){
                b = -(b);
            };
            if (c < 0){
                c = -(c);
            };
            rr = (((a + b) + c) * this._radius);
            if ((dd + rr) < -(d)){
                return (false);
            };
            a = (c41 - c11);
            b = (c42 - c12);
            c = (c43 - c13);
            d = (c44 - c14);
            dd = (((a * this._centerX) + (b * this._centerY)) + (c * this._centerZ));
            if (a < 0){
                a = -(a);
            };
            if (b < 0){
                b = -(b);
            };
            if (c < 0){
                c = -(c);
            };
            rr = (((a + b) + c) * this._radius);
            if ((dd + rr) < -(d)){
                return (false);
            };
            a = (c41 + c21);
            b = (c42 + c22);
            c = (c43 + c23);
            d = (c44 + c24);
            dd = (((a * this._centerX) + (b * this._centerY)) + (c * this._centerZ));
            if (a < 0){
                a = -(a);
            };
            if (b < 0){
                b = -(b);
            };
            if (c < 0){
                c = -(c);
            };
            rr = (((a + b) + c) * this._radius);
            if ((dd + rr) < -(d)){
                return (false);
            };
            a = (c41 - c21);
            b = (c42 - c22);
            c = (c43 - c23);
            d = (c44 - c24);
            dd = (((a * this._centerX) + (b * this._centerY)) + (c * this._centerZ));
            if (a < 0){
                a = -(a);
            };
            if (b < 0){
                b = -(b);
            };
            if (c < 0){
                c = -(c);
            };
            rr = (((a + b) + c) * this._radius);
            if ((dd + rr) < -(d)){
                return (false);
            };
            a = c31;
            b = c32;
            c = c33;
            d = c34;
            dd = (((a * this._centerX) + (b * this._centerY)) + (c * this._centerZ));
            if (a < 0){
                a = -(a);
            };
            if (b < 0){
                b = -(b);
            };
            if (c < 0){
                c = -(c);
            };
            rr = (((a + b) + c) * this._radius);
            if ((dd + rr) < -(d)){
                return (false);
            };
            a = (c41 - c31);
            b = (c42 - c32);
            c = (c43 - c33);
            d = (c44 - c34);
            dd = (((a * this._centerX) + (b * this._centerY)) + (c * this._centerZ));
            if (a < 0){
                a = -(a);
            };
            if (b < 0){
                b = -(b);
            };
            if (c < 0){
                c = -(c);
            };
            rr = (((a + b) + c) * this._radius);
            if ((dd + rr) < -(d)){
                return (false);
            };
            return (true);
        }
        override public function fromSphere(center:Vector3D, radius:Number):void{
            this._centerX = center.x;
            this._centerY = center.y;
            this._centerZ = center.z;
            this._radius = radius;
            _max.x = (this._centerX + radius);
            _max.y = (this._centerY + radius);
            _max.z = (this._centerZ + radius);
            _min.x = (this._centerX - radius);
            _min.y = (this._centerY - radius);
            _min.z = (this._centerZ - radius);
            _aabbPointsDirty = true;
            if (_boundingRenderable){
                this.updateBoundingRenderable();
            };
        }
        override public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void{
            this._centerX = ((maxX + minX) * 0.5);
            this._centerY = ((maxY + minY) * 0.5);
            this._centerZ = ((maxZ + minZ) * 0.5);
            var d:Number = (maxX - minX);
            var y:Number = (maxY - minY);
            var z:Number = (maxZ - minZ);
            if (y > d){
                d = y;
            };
            if (z > d){
                d = z;
            };
            this._radius = (d * Math.sqrt(0.5));
            super.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
        }
        override public function clone():BoundingVolumeBase{
            var clone:BoundingSphere = new BoundingSphere();
            clone.fromSphere(new Vector3D(this._centerX, this._centerY, this._centerZ), this._radius);
            return (clone);
        }
        override public function rayIntersection(position:Vector3D, direction:Vector3D, targetNormal:Vector3D):Number{
            var rayEntryDistance:Number;
            var sqrtDet:Number;
            if (this.containsPoint(position)){
                return (0);
            };
            var px:Number = (position.x - this._centerX);
            var py:Number = (position.y - this._centerY);
            var pz:Number = (position.z - this._centerZ);
            var vx:Number = direction.x;
            var vy:Number = direction.y;
            var vz:Number = direction.z;
            var a:Number = (((vx * vx) + (vy * vy)) + (vz * vz));
            var b:Number = (2 * (((px * vx) + (py * vy)) + (pz * vz)));
            var c:Number = ((((px * px) + (py * py)) + (pz * pz)) - (this._radius * this._radius));
            var det:Number = ((b * b) - ((4 * a) * c));
            if (det >= 0){
                sqrtDet = Math.sqrt(det);
                rayEntryDistance = ((-(b) - sqrtDet) / (2 * a));
                if (rayEntryDistance >= 0){
                    targetNormal.x = (px + (rayEntryDistance * vx));
                    targetNormal.y = (py + (rayEntryDistance * vy));
                    targetNormal.z = (pz + (rayEntryDistance * vz));
                    targetNormal.normalize();
                    return (rayEntryDistance);
                };
            };
            return (-1);
        }
        override public function containsPoint(position:Vector3D):Boolean{
            var px:Number = (position.x - this._centerX);
            var py:Number = (position.y - this._centerY);
            var pz:Number = (position.z - this._centerZ);
            var distance:Number = Math.sqrt((((px * px) + (py * py)) + (pz * pz)));
            return ((distance <= this._radius));
        }
        override protected function updateBoundingRenderable():void{
            var sc:Number = this._radius;
            if (sc == 0){
                sc = 0.001;
            };
            _boundingRenderable.scaleX = sc;
            _boundingRenderable.scaleY = sc;
            _boundingRenderable.scaleZ = sc;
            _boundingRenderable.x = this._centerX;
            _boundingRenderable.y = this._centerY;
            _boundingRenderable.z = this._centerZ;
        }
        override protected function createBoundingRenderable():WireframePrimitiveBase{
            return (new WireframeSphere(1));
        }

    }
}//package away3d.bounds 
