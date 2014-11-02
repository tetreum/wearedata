package away3d.tools.utils {
    import flash.geom.*;
    import away3d.entities.*;
    import away3d.containers.*;
    import __AS3__.vec.*;

    public class Bounds {

        private static var _minX:Number;
        private static var _minY:Number;
        private static var _minZ:Number;
        private static var _maxX:Number;
        private static var _maxY:Number;
        private static var _maxZ:Number;
        private static var _defaultPosition:Vector3D = new Vector3D(0, 0, 0);

        public static function getMeshBounds(mesh:Mesh):void{
            reset();
            parseMeshBounds(mesh);
        }
        public static function getObjectContainerBounds(container:ObjectContainer3D):void{
            reset();
            parseObjectContainerBounds(container);
        }
        public static function getVerticesVectorBounds(vertices:Vector.<Number>):void{
            var x:Number;
            var y:Number;
            var z:Number;
            reset();
            var l:uint = vertices.length;
            if ((l % 3) != 0){
                return;
            };
            var i:uint;
            while (i < l) {
                x = vertices[i];
                y = vertices[(i + 1)];
                z = vertices[(i + 2)];
                if (x < _minX){
                    _minX = x;
                };
                if (x > _maxX){
                    _maxX = x;
                };
                if (y < _minY){
                    _minY = y;
                };
                if (y > _maxY){
                    _maxY = y;
                };
                if (z < _minZ){
                    _minZ = z;
                };
                if (z > _maxZ){
                    _maxZ = z;
                };
                i = (i + 3);
            };
        }
        public static function get minX():Number{
            return (_minX);
        }
        public static function get minY():Number{
            return (_minY);
        }
        public static function get minZ():Number{
            return (_minZ);
        }
        public static function get maxX():Number{
            return (_maxX);
        }
        public static function get maxY():Number{
            return (_maxY);
        }
        public static function get maxZ():Number{
            return (_maxZ);
        }
        public static function get width():Number{
            return ((_maxX - _minX));
        }
        public static function get height():Number{
            return ((_maxY - _minY));
        }
        public static function get depth():Number{
            return ((_maxZ - _minZ));
        }
        private static function reset():void{
            _minX = (_minY = (_minZ = Infinity));
            _maxX = (_maxY = (_maxZ = -(Infinity)));
            _defaultPosition.x = 0;
            _defaultPosition.y = 0;
            _defaultPosition.z = 0;
        }
        private static function parseObjectContainerBounds(obj:ObjectContainer3D):void{
            var child:ObjectContainer3D;
            if ((((obj is Mesh)) && ((obj.numChildren == 0)))){
                parseMeshBounds(Mesh(obj), obj.position);
            };
            var i:uint;
            while (i < obj.numChildren) {
                child = obj.getChildAt(i);
                parseObjectContainerBounds(ObjectContainer3D(child));
                i++;
            };
        }
        private static function parseMeshBounds(m:Mesh, position:Vector3D=null):void{
            var offsetPosition:* = null;
            var x:* = NaN;
            var y:* = NaN;
            var z:* = NaN;
            var geometries:* = null;
            var numSubGeoms:* = 0;
            var subGeom:* = null;
            var vertices:* = null;
            var j:* = 0;
            var vecLength:* = 0;
            var i:* = 0;
            var m:* = m;
            var position = position;
            offsetPosition = ((position) || (_defaultPosition));
            try {
                x = offsetPosition.x;
                y = offsetPosition.y;
                z = offsetPosition.z;
                if ((x + m.minX) < _minX){
                    _minX = (x + m.minX);
                };
                if ((x + m.maxX) > _maxX){
                    _maxX = (x + m.maxX);
                };
                if ((y + m.minY) < _minY){
                    _minY = (y + m.minY);
                };
                if ((y + m.maxY) > _maxY){
                    _maxY = (y + m.maxY);
                };
                if ((z + m.minZ) < _minZ){
                    _minZ = (z + m.minZ);
                };
                if ((z + m.maxZ) > _maxZ){
                    _maxZ = (z + m.maxZ);
                };
                if (m.scaleX != 1){
                    _minX = (_minX * m.scaleX);
                    _maxX = (_maxX * m.scaleX);
                };
                if (m.scaleY != 1){
                    _minY = (_minY * m.scaleY);
                    _maxY = (_maxY * m.scaleY);
                };
                if (m.scaleZ != 1){
                    _minZ = (_minZ * m.scaleZ);
                    _maxZ = (_maxZ * m.scaleZ);
                };
            } catch(e:Error) {
                geometries = m.geometry.subGeometries;
                numSubGeoms = geometries.length;
                i = 0;
                while (i < numSubGeoms) {
                    subGeom = geometries[i];
                    vertices = subGeom.vertexData;
                    vecLength = vertices.length;
                    j = 0;
                    while (j < vecLength) {
                        x = ((vertices[j] * m.scaleX) + offsetPosition.x);
                        y = ((vertices[(j + 1)] * m.scaleY) + offsetPosition.y);
                        z = ((vertices[(j + 2)] * m.scaleZ) + offsetPosition.z);
                        if (x < _minX){
                            _minX = x;
                        };
                        if (x > _maxX){
                            _maxX = x;
                        };
                        if (y < _minY){
                            _minY = y;
                        };
                        if (y > _maxY){
                            _maxY = y;
                        };
                        if (z < _minZ){
                            _minZ = z;
                        };
                        if (z > _maxZ){
                            _maxZ = z;
                        };
                        j = (j + 3);
                    };
                    i = (i + 1);
                };
            };
        }

    }
}//package away3d.tools.utils 
