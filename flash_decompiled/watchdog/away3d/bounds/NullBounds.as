package away3d.bounds {
    import away3d.primitives.*;
    import flash.geom.*;
    import away3d.core.base.*;

    public class NullBounds extends BoundingVolumeBase {

        private var _alwaysIn:Boolean;
        private var _renderable:WireframePrimitiveBase;

        public function NullBounds(alwaysIn:Boolean=true, renderable:WireframePrimitiveBase=null){
            super();
            this._alwaysIn = alwaysIn;
            this._renderable = renderable;
        }
        override protected function createBoundingRenderable():WireframePrimitiveBase{
            return (((this._renderable) || (new WireframeSphere(100))));
        }
        override public function isInFrustum(mvpMatrix:Matrix3D):Boolean{
            return (this._alwaysIn);
        }
        override public function fromGeometry(geometry:Geometry):void{
        }
        override public function fromSphere(center:Vector3D, radius:Number):void{
        }
        override public function fromExtremes(minX:Number, minY:Number, minZ:Number, maxX:Number, maxY:Number, maxZ:Number):void{
        }

    }
}//package away3d.bounds 
