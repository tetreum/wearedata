package away3d.core.base {
    import __AS3__.vec.*;
    import flash.geom.*;
    import away3d.library.assets.*;
    import away3d.events.*;

    public class Geometry extends NamedAssetBase implements IAsset {

        private var _subGeometries:Vector.<SubGeometry>;

        public function Geometry(){
            super();
            this._subGeometries = new Vector.<SubGeometry>();
        }
        public function applyTransformation(transform:Matrix3D):void{
            var len:uint = this._subGeometries.length;
            var i:int;
            while (i < len) {
                this._subGeometries[i].applyTransformation(transform);
                i++;
            };
        }
        public function get assetType():String{
            return (AssetType.GEOMETRY);
        }
        public function get subGeometries():Vector.<SubGeometry>{
            return (this._subGeometries);
        }
        public function addSubGeometry(subGeometry:SubGeometry):void{
            this._subGeometries.push(subGeometry);
            subGeometry.parentGeometry = this;
            if (hasEventListener(GeometryEvent.SUB_GEOMETRY_ADDED)){
                dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_ADDED, subGeometry));
            };
            this.invalidateBounds(subGeometry);
        }
        public function removeSubGeometry(subGeometry:SubGeometry):void{
            this._subGeometries.splice(this._subGeometries.indexOf(subGeometry), 1);
            subGeometry.parentGeometry = null;
            if (hasEventListener(GeometryEvent.SUB_GEOMETRY_REMOVED)){
                dispatchEvent(new GeometryEvent(GeometryEvent.SUB_GEOMETRY_REMOVED, subGeometry));
            };
            this.invalidateBounds(subGeometry);
        }
        public function clone():Geometry{
            var clone:Geometry = new Geometry();
            var len:uint = this._subGeometries.length;
            var i:int;
            while (i < len) {
                clone.addSubGeometry(this._subGeometries[i].clone());
                i++;
            };
            return (clone);
        }
        public function scale(scale:Number):void{
            var numSubGeoms:uint = this._subGeometries.length;
            var i:uint;
            while (i < numSubGeoms) {
                this._subGeometries[i].scale(scale);
                i++;
            };
        }
        public function dispose():void{
            var subGeom:SubGeometry;
            var numSubGeoms:uint = this._subGeometries.length;
            var i:uint;
            while (i < numSubGeoms) {
                subGeom = this._subGeometries[0];
                this.removeSubGeometry(subGeom);
                subGeom.dispose();
                i++;
            };
        }
        public function scaleUV(scaleU:Number=1, scaleV:Number=1):void{
            var numSubGeoms:uint = this._subGeometries.length;
            var i:uint;
            while (i < numSubGeoms) {
                this._subGeometries[i].scaleUV(scaleU, scaleV);
                i++;
            };
        }
        function validate():void{
        }
        function invalidateBounds(subGeom:SubGeometry):void{
            if (hasEventListener(GeometryEvent.BOUNDS_INVALID)){
                dispatchEvent(new GeometryEvent(GeometryEvent.BOUNDS_INVALID, subGeom));
            };
        }

    }
}//package away3d.core.base 
