package wd.d3.geom.monuments {
    import away3d.core.base.*;
    import wd.d3.material.*;
    import flash.events.*;
    import __AS3__.vec.*;
    import wd.core.*;
    import away3d.entities.*;

    public class MonumentsMesh extends Mesh {

        private var currentAdd:SubGeometry;
        private var v_offset:uint;
        private var modelScale:Number = 2.3;
        private var meshs:Vector.<Monument>;
        private var city:String;

        public function MonumentsMesh(){
            super(new Geometry(), MaterialProvider.monuments);
        }
        override public function dispose():void{
            var subGeom:SubGeometry;
            var numSubGeoms:uint = geometry.subGeometries.length;
            while (numSubGeoms--) {
                subGeom = geometry.subGeometries[numSubGeoms];
                geometry.removeSubGeometry(subGeom);
                subGeom.dispose();
                subGeom = null;
            };
        }
        public function setCity(city:String):void{
            var l:int;
            this.city = city;
            if (MonumentsProvider.isLoaded){
                this.meshs = MonumentsProvider.getMonumentsByCity(city);
                l = this.meshs.length;
                if (l > 0){
                    this.currentAdd = new SubGeometry();
                    this.openCurrent();
                    geometry.addSubGeometry(this.currentAdd);
                    while (l--) {
                        this.addMonument(this.meshs[l]);
                    };
                    this.closeCurrent();
                };
            } else {
                MonumentsProvider.instance.addEventListener(MonumentsProvider.ON_LOAD, this.onMeshLoaded);
            };
        }
        protected function onMeshLoaded(event:Event):void{
            MonumentsProvider.instance.removeEventListener(MonumentsProvider.ON_LOAD, this.onMeshLoaded);
            this.setCity(this.city);
        }
        private function openCurrent():void{
            this.currentAdd.updateVertexData(new <Number>[]);
            this.currentAdd.updateUVData(new <Number>[]);
            this.currentAdd.updateIndexData(new <uint>[]);
        }
        private function closeCurrent():void{
            this.currentAdd.updateVertexData(this.currentAdd.vertexData);
            this.currentAdd.updateUVData(this.currentAdd.UVData);
            this.currentAdd.updateIndexData(this.currentAdd.indexData);
        }
        private function addMonument(monument:Monument):void{
            if ((((this.currentAdd.numVertices >= (Constants.MAX_SUBGGEOM_BUFFER_SIZE - (monument.mesh.vertices.length / 3)))) || ((this.currentAdd.numTriangles >= (Constants.MAX_SUBGGEOM_BUFFER_SIZE - (monument.mesh.indices.length / 3)))))){
                this.closeCurrent();
                this.currentAdd = new SubGeometry();
                this.openCurrent();
                geometry.addSubGeometry(this.currentAdd);
            };
            this.mergeMonument(monument);
        }
        public function mergeMonument(monument:Monument):void{
            var ind:uint;
            var tmp:Vector.<Number>;
            var l:int;
            var i:int;
            var uv:Number;
            this.v_offset = (this.currentAdd.vertexData.length / 3);
            for each (ind in monument.mesh.indices) {
                this.currentAdd.indexData.push((ind + this.v_offset));
            };
            tmp = new Vector.<Number>();
            monument.matrix.transformVectors(monument.mesh.vertices, tmp);
            l = monument.mesh.vertices.length;
            i = 0;
            while (i < l) {
                this.currentAdd.vertexData.push(tmp[i]);
                i++;
            };
            for each (uv in monument.mesh.uvs) {
                this.currentAdd.UVData.push(uv);
            };
        }

    }
}//package wd.d3.geom.monuments 
