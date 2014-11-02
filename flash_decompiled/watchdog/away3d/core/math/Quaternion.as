package away3d.core.math {
    import flash.geom.*;
    import __AS3__.vec.*;

    public final class Quaternion {

        public var x:Number = 0;
        public var y:Number = 0;
        public var z:Number = 0;
        public var w:Number = 1;

        public function Quaternion(x:Number=0, y:Number=0, z:Number=0, w:Number=1){
            super();
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }
        public function get magnitude():Number{
            return (Math.sqrt(((((this.w * this.w) + (this.x * this.x)) + (this.y * this.y)) + (this.z * this.z))));
        }
        public function multiply(qa:Quaternion, qb:Quaternion):void{
            var w1:Number = qa.w;
            var x1:Number = qa.x;
            var y1:Number = qa.y;
            var z1:Number = qa.z;
            var w2:Number = qb.w;
            var x2:Number = qb.x;
            var y2:Number = qb.y;
            var z2:Number = qb.z;
            this.w = ((((w1 * w2) - (x1 * x2)) - (y1 * y2)) - (z1 * z2));
            this.x = ((((w1 * x2) + (x1 * w2)) + (y1 * z2)) - (z1 * y2));
            this.y = ((((w1 * y2) - (x1 * z2)) + (y1 * w2)) + (z1 * x2));
            this.z = ((((w1 * z2) + (x1 * y2)) - (y1 * x2)) + (z1 * w2));
        }
        public function multiplyVector(vector:Vector3D, target:Quaternion=null):Quaternion{
            target = ((target) || (new Quaternion()));
            var x2:Number = vector.x;
            var y2:Number = vector.y;
            var z2:Number = vector.z;
            target.w = (((-(this.x) * x2) - (this.y * y2)) - (this.z * z2));
            target.x = (((this.w * x2) + (this.y * z2)) - (this.z * y2));
            target.y = (((this.w * y2) - (this.x * z2)) + (this.z * x2));
            target.z = (((this.w * z2) + (this.x * y2)) - (this.y * x2));
            return (target);
        }
        public function fromAxisAngle(axis:Vector3D, angle:Number):void{
            var sin_a:Number = Math.sin((angle / 2));
            var cos_a:Number = Math.cos((angle / 2));
            this.x = (axis.x * sin_a);
            this.y = (axis.y * sin_a);
            this.z = (axis.z * sin_a);
            this.w = cos_a;
            this.normalize();
        }
        public function slerp(qa:Quaternion, qb:Quaternion, t:Number):void{
            var angle:Number;
            var s:Number;
            var s1:Number;
            var s2:Number;
            var len:Number;
            var w1:Number = qa.w;
            var x1:Number = qa.x;
            var y1:Number = qa.y;
            var z1:Number = qa.z;
            var w2:Number = qb.w;
            var x2:Number = qb.x;
            var y2:Number = qb.y;
            var z2:Number = qb.z;
            var dot:Number = ((((w1 * w2) + (x1 * x2)) + (y1 * y2)) + (z1 * z2));
            if (dot < 0){
                dot = -(dot);
                w2 = -(w2);
                x2 = -(x2);
                y2 = -(y2);
                z2 = -(z2);
            };
            if (dot < 0.95){
                angle = Math.acos(dot);
                s = (1 / Math.sin(angle));
                s1 = (Math.sin((angle * (1 - t))) * s);
                s2 = (Math.sin((angle * t)) * s);
                this.w = ((w1 * s1) + (w2 * s2));
                this.x = ((x1 * s1) + (x2 * s2));
                this.y = ((y1 * s1) + (y2 * s2));
                this.z = ((z1 * s1) + (z2 * s2));
            } else {
                this.w = (w1 + (t * (w2 - w1)));
                this.x = (x1 + (t * (x2 - x1)));
                this.y = (y1 + (t * (y2 - y1)));
                this.z = (z1 + (t * (z2 - z1)));
                len = (1 / Math.sqrt(((((this.w * this.w) + (this.x * this.x)) + (this.y * this.y)) + (this.z * this.z))));
                this.w = (this.w * len);
                this.x = (this.x * len);
                this.y = (this.y * len);
                this.z = (this.z * len);
            };
        }
        public function lerp(qa:Quaternion, qb:Quaternion, t:Number):void{
            var len:Number;
            var w1:Number = qa.w;
            var x1:Number = qa.x;
            var y1:Number = qa.y;
            var z1:Number = qa.z;
            var w2:Number = qb.w;
            var x2:Number = qb.x;
            var y2:Number = qb.y;
            var z2:Number = qb.z;
            if (((((w1 * w2) + (x1 * x2)) + (y1 * y2)) + (z1 * z2)) < 0){
                w2 = -(w2);
                x2 = -(x2);
                y2 = -(y2);
                z2 = -(z2);
            };
            this.w = (w1 + (t * (w2 - w1)));
            this.x = (x1 + (t * (x2 - x1)));
            this.y = (y1 + (t * (y2 - y1)));
            this.z = (z1 + (t * (z2 - z1)));
            len = (1 / Math.sqrt(((((this.w * this.w) + (this.x * this.x)) + (this.y * this.y)) + (this.z * this.z))));
            this.w = (this.w * len);
            this.x = (this.x * len);
            this.y = (this.y * len);
            this.z = (this.z * len);
        }
        public function fromEulerAngles(ax:Number, ay:Number, az:Number):void{
            var halfX:Number = (ax * 0.5);
            var halfY:Number = (ay * 0.5);
            var halfZ:Number = (az * 0.5);
            var cosX:Number = Math.cos(halfX);
            var sinX:Number = Math.sin(halfX);
            var cosY:Number = Math.cos(halfY);
            var sinY:Number = Math.sin(halfY);
            var cosZ:Number = Math.cos(halfZ);
            var sinZ:Number = Math.sin(halfZ);
            this.w = (((cosX * cosY) * cosZ) + ((sinX * sinY) * sinZ));
            this.x = (((sinX * cosY) * cosZ) - ((cosX * sinY) * sinZ));
            this.y = (((cosX * sinY) * cosZ) + ((sinX * cosY) * sinZ));
            this.z = (((cosX * cosY) * sinZ) - ((sinX * sinY) * cosZ));
        }
        public function toEulerAngles(target:Vector3D=null):Vector3D{
            target = ((target) || (new Vector3D()));
            target.x = Math.atan2((2 * ((this.w * this.x) + (this.y * this.z))), (1 - (2 * ((this.x * this.x) + (this.y * this.y)))));
            target.y = Math.asin((2 * ((this.w * this.y) - (this.z * this.x))));
            target.z = Math.atan2((2 * ((this.w * this.z) + (this.x * this.y))), (1 - (2 * ((this.y * this.y) + (this.z * this.z)))));
            return (target);
        }
        public function normalize(val:Number=1):void{
            var mag:Number = (val / Math.sqrt(((((this.x * this.x) + (this.y * this.y)) + (this.z * this.z)) + (this.w * this.w))));
            this.x = (this.x * mag);
            this.y = (this.y * mag);
            this.z = (this.z * mag);
            this.w = (this.w * mag);
        }
        public function toString():String{
            return ((((((((("{x:" + this.x) + " y:") + this.y) + " z:") + this.z) + " w:") + this.w) + "}"));
        }
        public function toMatrix3D(target:Matrix3D=null):Matrix3D{
            var rawData:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
            var xy2:Number = ((2 * this.x) * this.y);
            var xz2:Number = ((2 * this.x) * this.z);
            var xw2:Number = ((2 * this.x) * this.w);
            var yz2:Number = ((2 * this.y) * this.z);
            var yw2:Number = ((2 * this.y) * this.w);
            var zw2:Number = ((2 * this.z) * this.w);
            var xx:Number = (this.x * this.x);
            var yy:Number = (this.y * this.y);
            var zz:Number = (this.z * this.z);
            var ww:Number = (this.w * this.w);
            rawData[0] = (((xx - yy) - zz) + ww);
            rawData[4] = (xy2 - zw2);
            rawData[8] = (xz2 + yw2);
            rawData[12] = 0;
            rawData[1] = (xy2 + zw2);
            rawData[5] = (((-(xx) + yy) - zz) + ww);
            rawData[9] = (yz2 - xw2);
            rawData[13] = 0;
            rawData[2] = (xz2 - yw2);
            rawData[6] = (yz2 + xw2);
            rawData[10] = (((-(xx) - yy) + zz) + ww);
            rawData[14] = 0;
            rawData[3] = 0;
            rawData[7] = 0;
            rawData[11] = 0;
            rawData[15] = 1;
            if (!(target)){
                return (new Matrix3D(rawData));
            };
            target.copyRawDataFrom(rawData);
            return (target);
        }
        public function fromMatrix(matrix:Matrix3D):void{
            var v:Vector3D = matrix.decompose(Orientation3D.QUATERNION)[1];
            this.x = v.x;
            this.y = v.y;
            this.z = v.z;
            this.w = v.w;
        }
        public function toRawData(target:Vector.<Number>, exclude4thRow:Boolean=false):void{
            var xy2:Number = ((2 * this.x) * this.y);
            var xz2:Number = ((2 * this.x) * this.z);
            var xw2:Number = ((2 * this.x) * this.w);
            var yz2:Number = ((2 * this.y) * this.z);
            var yw2:Number = ((2 * this.y) * this.w);
            var zw2:Number = ((2 * this.z) * this.w);
            var xx:Number = (this.x * this.x);
            var yy:Number = (this.y * this.y);
            var zz:Number = (this.z * this.z);
            var ww:Number = (this.w * this.w);
            target[0] = (((xx - yy) - zz) + ww);
            target[1] = (xy2 - zw2);
            target[2] = (xz2 + yw2);
            target[4] = (xy2 + zw2);
            target[5] = (((-(xx) + yy) - zz) + ww);
            target[6] = (yz2 - xw2);
            target[8] = (xz2 - yw2);
            target[9] = (yz2 + xw2);
            target[10] = (((-(xx) - yy) + zz) + ww);
            target[3] = (target[7] = (target[11] = 0));
            if (!(exclude4thRow)){
                target[12] = (target[13] = (target[14] = 0));
                target[15] = 1;
            };
        }
        public function clone():Quaternion{
            return (new Quaternion(this.x, this.y, this.z, this.w));
        }
        public function rotatePoint(vector:Vector3D, target:Vector3D=null):Vector3D{
            var x1:Number;
            var y1:Number;
            var z1:Number;
            var w1:Number;
            var x2:Number = vector.x;
            var y2:Number = vector.y;
            var z2:Number = vector.z;
            target = ((target) || (new Vector3D()));
            w1 = (((-(this.x) * x2) - (this.y * y2)) - (this.z * z2));
            x1 = (((this.w * x2) + (this.y * z2)) - (this.z * y2));
            y1 = (((this.w * y2) - (this.x * z2)) + (this.z * x2));
            z1 = (((this.w * z2) + (this.x * y2)) - (this.y * x2));
            target.x = ((((-(w1) * this.x) + (x1 * this.w)) - (y1 * this.z)) + (z1 * this.y));
            target.y = ((((-(w1) * this.y) + (x1 * this.z)) + (y1 * this.w)) - (z1 * this.x));
            target.z = ((((-(w1) * this.z) - (x1 * this.y)) + (y1 * this.x)) + (z1 * this.w));
            return (target);
        }
        public function copyFrom(q:Quaternion):void{
            this.x = q.x;
            this.y = q.y;
            this.z = q.z;
            this.w = q.w;
        }

    }
}//package away3d.core.math 
