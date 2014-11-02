package away3d.primitives {
    import away3d.core.base.*;
    import __AS3__.vec.*;
    import flash.geom.*;
    import away3d.errors.*;

    public class PrimitiveBase extends Geometry {

        protected var _geomDirty:Boolean = true;
        protected var _uvDirty:Boolean = true;
        private var _subGeometry:SubGeometry;

        public function PrimitiveBase(){
            super();
            this._subGeometry = new SubGeometry();
            addSubGeometry(this._subGeometry);
        }
        override public function get subGeometries():Vector.<SubGeometry>{
            if (this._geomDirty){
                this.updateGeometry();
            };
            if (this._uvDirty){
                this.updateUVs();
            };
            return (super.subGeometries);
        }
        override public function clone():Geometry{
            if (this._geomDirty){
                this.updateGeometry();
            };
            if (this._uvDirty){
                this.updateUVs();
            };
            return (super.clone());
        }
        override public function scale(scale:Number):void{
            if (this._geomDirty){
                this.updateGeometry();
            };
            super.scale(scale);
        }
        override public function scaleUV(scaleU:Number=1, scaleV:Number=1):void{
            if (this._uvDirty){
                this.updateUVs();
            };
            super.scaleUV(scaleU, scaleV);
        }
        override public function applyTransformation(transform:Matrix3D):void{
            if (this._geomDirty){
                this.updateGeometry();
            };
            super.applyTransformation(transform);
        }
        protected function buildGeometry(target:SubGeometry):void{
            throw (new AbstractMethodError());
        }
        protected function buildUVs(target:SubGeometry):void{
            throw (new AbstractMethodError());
        }
        protected function invalidateGeometry():void{
            this._geomDirty = true;
        }
        protected function invalidateUVs():void{
            this._uvDirty = true;
        }
        private function updateGeometry():void{
            this.buildGeometry(this._subGeometry);
            this._geomDirty = false;
        }
        private function updateUVs():void{
            this.buildUVs(this._subGeometry);
            this._uvDirty = false;
        }
        override function validate():void{
            if (this._geomDirty){
                this.updateGeometry();
            };
            if (this._uvDirty){
                this.updateUVs();
            };
        }

    }
}//package away3d.primitives 
