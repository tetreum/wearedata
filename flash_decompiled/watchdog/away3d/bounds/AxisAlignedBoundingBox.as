package away3d.bounds {
    import away3d.core.math.*;
    import __AS3__.vec.*;
    import away3d.core.pick.*;
    import away3d.primitives.*;
    import flash.geom.*;

    public class AxisAlignedBoundingBox extends BoundingVolumeBase {

        private var _centerX:Number = 0;
        private var _centerY:Number = 0;
        private var _centerZ:Number = 0;
        private var _halfExtentsX:Number = 0;
        private var _halfExtentsY:Number = 0;
        private var _halfExtentsZ:Number = 0;

        public function AxisAlignedBoundingBox(){
            super();
        }
        override public function nullify():void{
            super.nullify();
            this._centerX = (this._centerY = (this._centerZ = 0));
            this._halfExtentsX = (this._halfExtentsY = (this._halfExtentsZ = 0));
        }
        override public function isInFrustum(mvpMatrix:Matrix3D):Boolean{
            var a:Number;
            var b:Number;
            var c:Number;
            var d:Number;
            var dd:Number;
            var rr:Number;
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
            rr = (((a * this._halfExtentsX) + (b * this._halfExtentsY)) + (c * this._halfExtentsZ));
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
            rr = (((a * this._halfExtentsX) + (b * this._halfExtentsY)) + (c * this._halfExtentsZ));
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
            rr = (((a * this._halfExtentsX) + (b * this._halfExtentsY)) + (c * this._halfExtentsZ));
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
            rr = (((a * this._halfExtentsX) + (b * this._halfExtentsY)) + (c * this._halfExtentsZ));
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
            rr = (((a * this._halfExtentsX) + (b * this._halfExtentsY)) + (c * this._halfExtentsZ));
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
            rr = (((a * this._halfExtentsX) + (b * this._halfExtentsY)) + (c * this._halfExtentsZ));
            if ((dd + rr) < -(d)){
                return (false);
            };
            return (true);
        }
        override public function rayIntersection(position:Vector3D, direction:Vector3D, targetNormal:Vector3D):Number{
            var ix:Number;
            var iy:Number;
            var iz:Number;
            var rayEntryDistance:Number;
            var intersects:Boolean;
            if (this.containsPoint(position)){
                return (0);
            };
            var px:Number = (position.x - this._centerX);
            var py:Number = (position.y - this._centerY);
            var pz:Number = (position.z - this._centerZ);
            var vx:Number = direction.x;
            var vy:Number = direction.y;
            var vz:Number = direction.z;
            if (vx < 0){
                rayEntryDistance = ((this._halfExtentsX - px) / vx);
                if (rayEntryDistance > 0){
                    iy = (py + (rayEntryDistance * vy));
                    iz = (pz + (rayEntryDistance * vz));
                    if ((((((((iy > -(this._halfExtentsY))) && ((iy < this._halfExtentsY)))) && ((iz > -(this._halfExtentsZ))))) && ((iz < this._halfExtentsZ)))){
                        targetNormal.x = 1;
                        targetNormal.y = 0;
                        targetNormal.z = 0;
                        intersects = true;
                    };
                };
            };
            if (((!(intersects)) && ((vx > 0)))){
                rayEntryDistance = ((-(this._halfExtentsX) - px) / vx);
                if (rayEntryDistance > 0){
                    iy = (py + (rayEntryDistance * vy));
                    iz = (pz + (rayEntryDistance * vz));
                    if ((((((((iy > -(this._halfExtentsY))) && ((iy < this._halfExtentsY)))) && ((iz > -(this._halfExtentsZ))))) && ((iz < this._halfExtentsZ)))){
                        targetNormal.x = -1;
                        targetNormal.y = 0;
                        targetNormal.z = 0;
                        intersects = true;
                    };
                };
            };
            if (((!(intersects)) && ((vy < 0)))){
                rayEntryDistance = ((this._halfExtentsY - py) / vy);
                if (rayEntryDistance > 0){
                    ix = (px + (rayEntryDistance * vx));
                    iz = (pz + (rayEntryDistance * vz));
                    if ((((((((ix > -(this._halfExtentsX))) && ((ix < this._halfExtentsX)))) && ((iz > -(this._halfExtentsZ))))) && ((iz < this._halfExtentsZ)))){
                        targetNormal.x = 0;
                        targetNormal.y = 1;
                        targetNormal.z = 0;
                        intersects = true;
                    };
                };
            };
            if (((!(intersects)) && ((vy > 0)))){
                rayEntryDistance = ((-(this._halfExtentsY) - py) / vy);
                if (rayEntryDistance > 0){
                    ix = (px + (rayEntryDistance * vx));
                    iz = (pz + (rayEntryDistance * vz));
                    if ((((((((ix > -(this._halfExtentsX))) && ((ix < this._halfExtentsX)))) && ((iz > -(this._halfExtentsZ))))) && ((iz < this._halfExtentsZ)))){
                        targetNormal.x = 0;
                        targetNormal.y = -1;
                        targetNormal.z = 0;
                        intersects = true;
                    };
                };
            };
            if (((!(intersects)) && ((vz < 0)))){
                rayEntryDistance = ((this._halfExtentsZ - pz) / vz);
                if (rayEntryDistance > 0){
                    ix = (px + (rayEntryDistance * vx));
                    iy = (py + (rayEntryDistance * vy));
                    if ((((((((iy > -(this._halfExtentsY))) && ((iy < this._halfExtentsY)))) && ((ix > -(this._halfExtentsX))))) && ((ix < this._halfExtentsX)))){
                        targetNormal.x = 0;
                        targetNormal.y = 0;
                        targetNormal.z = 1;
                        intersects = true;
                    };
                };
            };
            if (((!(intersects)) && ((vz > 0)))){
                rayEntryDistance = ((-(this._halfExtentsZ) - pz) / vz);
                if (rayEntryDistance > 0){
                    ix = (px + (rayEntryDistance * vx));
                    iy = (py + (rayEntryDistance * vy));
                    if ((((((((iy > -(this._halfExtentsY))) && ((iy < this._halfExtentsY)))) && ((ix > -(this._halfExtentsX))))) && ((ix < this._halfExtentsX)))){
                        targetNormal.x = 0;
                        targetNormal.y = 0;
                        targetNormal.z = -1;
                        intersects = true;
                    };
                };
            };
            return (((intersects) ? rayEntryDistance : -1));
        }
        override public function containsPoint(position:Vector3D):Boolean{
            var px:Number = (position.x - this._centerX);
            var py:Number = (position.y - this._centerY);
            var pz:Number = (position.z - this._centerZ);
            if ((((px > this._halfExtentsX)) || ((px < -(this._halfExtentsX))))){
                return (false);
            };
            if ((((py > this._halfExtentsY)) || ((py < -(this._halfExtentsY))))){
                return (false);
            };
            if ((((pz > this._halfExtentsZ)) || ((pz < -(this._halfExtentsZ))))){
                return (false);
            };
            return (true);
        }
        override public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void{
            this._centerX = ((maxX + minX) * 0.5);
            this._centerY = ((maxY + minY) * 0.5);
            this._centerZ = ((maxZ + minZ) * 0.5);
            this._halfExtentsX = ((maxX - minX) * 0.5);
            this._halfExtentsY = ((maxY - minY) * 0.5);
            this._halfExtentsZ = ((maxZ - minZ) * 0.5);
            super.fromExtremes(minX, minY, minZ, maxX, maxY, maxZ);
        }
        override public function clone():BoundingVolumeBase{
            var clone:AxisAlignedBoundingBox = new AxisAlignedBoundingBox();
            clone.fromExtremes(_min.x, _min.y, _min.z, _max.x, _max.y, _max.z);
            return (clone);
        }
        public function get halfExtentsX():Number{
            return (this._halfExtentsX);
        }
        public function get halfExtentsY():Number{
            return (this._halfExtentsY);
        }
        public function get halfExtentsZ():Number{
            return (this._halfExtentsZ);
        }
        public function closestPointToPoint(point:Vector3D, target:Vector3D=null):Vector3D{
            var p:Number;
            target = ((target) || (new Vector3D()));
            p = point.x;
            if (p < _min.x){
                p = _min.x;
            };
            if (p > _max.x){
                p = _max.x;
            };
            target.x = p;
            p = point.y;
            if (p < _min.y){
                p = _min.y;
            };
            if (p > _max.y){
                p = _max.y;
            };
            target.y = p;
            p = point.z;
            if (p < _min.z){
                p = _min.z;
            };
            if (p > _max.z){
                p = _max.z;
            };
            target.z = p;
            return (target);
        }
        override protected function updateBoundingRenderable():void{
            _boundingRenderable.scaleX = Math.max((this._halfExtentsX * 2), 0.001);
            _boundingRenderable.scaleY = Math.max((this._halfExtentsY * 2), 0.001);
            _boundingRenderable.scaleZ = Math.max((this._halfExtentsZ * 2), 0.001);
            _boundingRenderable.x = this._centerX;
            _boundingRenderable.y = this._centerY;
            _boundingRenderable.z = this._centerZ;
        }
        override protected function createBoundingRenderable():WireframePrimitiveBase{
            return (new WireframeCube(1, 1, 1));
        }

    }
}//package away3d.bounds 
