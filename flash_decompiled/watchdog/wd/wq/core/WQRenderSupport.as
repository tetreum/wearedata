package wd.wq.core {
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.display3D.*;

    public class WQRenderSupport {

        private var mProjectionMatrix:Matrix3D;
        private var mModelViewMatrix:Matrix3D;
        private var mMatrixStack:Vector.<Matrix3D>;

        public function WQRenderSupport(){
            super();
            this.mMatrixStack = new <Matrix3D>[];
            this.mProjectionMatrix = new Matrix3D();
            this.mModelViewMatrix = new Matrix3D();
            this.loadIdentity();
            this.setOrthographicProjection(400, 300);
        }
        public function setOrthographicProjection(width:Number, height:Number, near:Number=-1, far:Number=1):void{
            var coords:Vector.<Number> = new <Number>[(2 / width), 0, 0, 0, 0, (-2 / height), 0, 0, 0, 0, (-2 / (far - near)), 0, -1, 1, (-((far + near)) / (far - near)), 1];
            this.mProjectionMatrix.copyRawDataFrom(coords);
        }
        public function loadIdentity():void{
            this.mModelViewMatrix.identity();
        }
        public function translateMatrix(dx:Number, dy:Number, dz:Number=0):void{
            this.mModelViewMatrix.prependTranslation(dx, dy, dz);
        }
        public function rotateMatrix(angle:Number, axis:Vector3D=null):void{
            this.mModelViewMatrix.prependRotation(((angle / Math.PI) * 180), (((axis == null)) ? Vector3D.Z_AXIS : axis));
        }
        public function scaleMatrix(sx:Number, sy:Number, sz:Number=1):void{
            this.mModelViewMatrix.prependScale(sx, sy, sz);
        }
        public function pushMatrix():void{
            this.mMatrixStack.push(this.mModelViewMatrix.clone());
        }
        public function popMatrix():void{
            this.mModelViewMatrix = this.mMatrixStack.pop();
        }
        public function resetMatrix():void{
            if (this.mMatrixStack.length != 0){
                this.mMatrixStack = new <Matrix3D>[];
            };
            this.loadIdentity();
        }
        public function get mvpMatrix():Matrix3D{
            var mvpMatrix:Matrix3D = new Matrix3D();
            mvpMatrix.append(this.mModelViewMatrix);
            mvpMatrix.append(this.mProjectionMatrix);
            return (mvpMatrix);
        }
        public function setDefaultBlendFactors(premultipliedAlpha:Boolean):void{
            var destFactor:String = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
            var sourceFactor:String = ((premultipliedAlpha) ? Context3DBlendFactor.ONE : Context3DBlendFactor.SOURCE_ALPHA);
            WatchQuads.context.setBlendFactors(sourceFactor, destFactor);
        }
        public function clear(rgb:uint=0, alpha:Number=0):void{
            WatchQuads.context.clear((((rgb >> 16) & 0xFF) / 0xFF), (((rgb >> 8) & 0xFF) / 0xFF), ((rgb & 0xFF) / 0xFF), alpha);
        }

    }
}//package wd.wq.core 
