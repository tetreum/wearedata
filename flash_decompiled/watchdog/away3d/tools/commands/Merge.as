package away3d.tools.commands {
    import away3d.entities.*;
    import away3d.core.base.*;
    import away3d.containers.*;
    import __AS3__.vec.*;
    import flash.geom.*;
    import away3d.materials.*;

    public class Merge {

        private const LIMIT:uint = 196605;

        private var _baseReceiver:Mesh;
        private var _objectSpace:Boolean;
        private var _keepMaterial:Boolean;
        private var _disposeSources:Boolean;
        private var _holder:Vector3D;
        private var _v:Vector3D;
        private var _vn:Vector3D;
        private var _vectorsSource:Vector.<DataSubGeometry>;

        public function Merge(keepMaterial:Boolean=false, disposeSources:Boolean=false, objectSpace:Boolean=false):void{
            super();
            this._keepMaterial = keepMaterial;
            this._disposeSources = disposeSources;
            this._objectSpace = objectSpace;
        }
        public function set disposeSources(b:Boolean):void{
            this._disposeSources = b;
        }
        public function get disposeSources():Boolean{
            return (this._disposeSources);
        }
        public function set keepMaterial(b:Boolean):void{
            this._keepMaterial = b;
        }
        public function get keepMaterial():Boolean{
            return (this._keepMaterial);
        }
        public function set objectSpace(b:Boolean):void{
            this._objectSpace = b;
        }
        public function get objectSpace():Boolean{
            return (this._objectSpace);
        }
        public function applyToContainer(object:ObjectContainer3D, name:String=""):Mesh{
            this.initHolders();
            this._baseReceiver = new Mesh(new Geometry(), null);
            this._baseReceiver.position = object.position;
            this.parseContainer(object);
            this.merge(this._baseReceiver);
            if (name != ""){
                this._baseReceiver.name = name;
            };
            if (this._disposeSources){
                if ((((object is Mesh)) && (Mesh(object).geometry))){
                    Mesh(object).geometry.dispose();
                };
                object = null;
            };
            return (this._baseReceiver);
        }
        public function applyToMeshes(receiver:Mesh, meshes:Vector.<Mesh>):Mesh{
            this.initHolders();
            var i:uint;
            while (i < meshes.length) {
                this.collect(meshes[i]);
                i++;
            };
            this.merge(receiver);
            if (this._disposeSources){
                i = 0;
                while (i < meshes.length) {
                    meshes[i].geometry.dispose();
                    meshes[i] = null;
                    i++;
                };
            };
            return (receiver);
        }
        public function apply(mesh1:Mesh, mesh2:Mesh):void{
            this.initHolders();
            this.collect(mesh2);
            this.merge(mesh1);
        }
        private function initHolders():void{
            this._vectorsSource = new Vector.<DataSubGeometry>();
            this._baseReceiver = null;
            if (((!(this._objectSpace)) && (!(this._v)))){
                this._holder = new Vector3D();
                this._v = new Vector3D();
                this._vn = new Vector3D();
            };
        }
        private function merge(destMesh:Mesh):void{
            var j:uint;
            var i:uint;
            var vecLength:uint;
            var subGeom:SubGeometry;
            var ds:DataSubGeometry;
            var vertices:Vector.<Number>;
            var normals:Vector.<Number>;
            var indices:Vector.<uint>;
            var uvs:Vector.<Number>;
            var nvertices:Vector.<Number>;
            var nindices:Vector.<uint>;
            var nuvs:Vector.<Number>;
            var nnormals:Vector.<Number>;
            var index:uint;
            var indexY:uint;
            var indexZ:uint;
            var indexuv:uint;
            var destDs:DataSubGeometry;
            var rotate:Boolean;
            var geometry:Geometry = destMesh.geometry;
            var geometries:Vector.<SubGeometry> = geometry.subGeometries;
            var numSubGeoms:uint = geometries.length;
            var vectors:Vector.<DataSubGeometry> = new Vector.<DataSubGeometry>();
            if (numSubGeoms == 0){
                subGeom = new SubGeometry();
                subGeom.autoDeriveVertexNormals = true;
                subGeom.autoDeriveVertexTangents = false;
                vertices = new Vector.<Number>();
                normals = new Vector.<Number>();
                indices = new Vector.<uint>();
                uvs = new Vector.<Number>();
                subGeom.updateVertexData(vertices);
                subGeom.updateIndexData(indices);
                subGeom.updateUVData(uvs);
                subGeom.updateVertexNormalData(normals);
                geometry.addSubGeometry(subGeom);
                numSubGeoms = 1;
            };
            i = 0;
            while (i < numSubGeoms) {
                vertices = geometries[i].vertexData;
                normals = geometries[i].vertexNormalData;
                indices = geometries[i].indexData;
                uvs = geometries[i].UVData;
                vertices.fixed = false;
                normals.fixed = false;
                indices.fixed = false;
                uvs.fixed = false;
                ds = new DataSubGeometry();
                ds.vertices = vertices;
                ds.indices = indices;
                ds.uvs = uvs;
                ds.normals = normals;
                ds.material = ((destMesh.subMeshes[i].material) ? destMesh.subMeshes[i].material : destMesh.material);
                ds.subGeometry = SubGeometry(geometries[i]);
                vectors.push(ds);
                i++;
            };
            nvertices = ds.vertices;
            nindices = ds.indices;
            nuvs = ds.uvs;
            nnormals = ds.normals;
            var activeMaterial:MaterialBase = ds.material;
            numSubGeoms = this._vectorsSource.length;
            var scale:Boolean = ((((!((destMesh.scaleX == 1))) || (!((destMesh.scaleY == 1))))) || (!((destMesh.scaleZ == 1))));
            i = 0;
            for (;i < numSubGeoms;i++) {
                ds = this._vectorsSource[i];
                subGeom = ds.subGeometry;
                vertices = ds.vertices;
                normals = ds.normals;
                indices = ds.indices;
                uvs = ds.uvs;
                if (((this._keepMaterial) && (ds.material))){
                    destDs = this.getDestSubgeom(vectors, ds);
                    if (!(destDs)){
                        destDs = this._vectorsSource[i];
                        subGeom = new SubGeometry();
                        destDs.subGeometry = subGeom;
                        if (!(this._objectSpace)){
                            vecLength = destDs.vertices.length;
                            rotate = ((((!((destDs.mesh.rotationX == 0))) || (!((destDs.mesh.rotationY == 0))))) || (!((destDs.mesh.rotationZ == 0))));
                            j = 0;
                            while (j < vecLength) {
                                indexY = (j + 1);
                                indexZ = (indexY + 1);
                                this._v.x = destDs.vertices[j];
                                this._v.y = destDs.vertices[indexY];
                                this._v.z = destDs.vertices[indexZ];
                                if (rotate){
                                    this._vn.x = destDs.normals[j];
                                    this._vn.y = destDs.normals[indexY];
                                    this._vn.z = destDs.normals[indexZ];
                                    this._vn = this.applyRotations(this._vn, destDs.transform);
                                    destDs.normals[j] = this._vn.x;
                                    destDs.normals[indexY] = this._vn.y;
                                    destDs.normals[indexZ] = this._vn.z;
                                };
                                this._v = destDs.transform.transformVector(this._v);
                                if (scale){
                                    destDs.vertices[j] = (this._v.x / destMesh.scaleX);
                                    destDs.vertices[indexY] = (this._v.y / destMesh.scaleY);
                                    destDs.vertices[indexZ] = (this._v.z / destMesh.scaleZ);
                                } else {
                                    destDs.vertices[j] = this._v.x;
                                    destDs.vertices[indexY] = this._v.y;
                                    destDs.vertices[indexZ] = this._v.z;
                                };
                                j = (j + 3);
                            };
                        };
                        vectors.push(destDs);
                        continue;
                    };
                    activeMaterial = destDs.material;
                    nvertices = destDs.vertices;
                    nnormals = destDs.normals;
                    nindices = destDs.indices;
                    nuvs = destDs.uvs;
                };
                vecLength = indices.length;
                rotate = ((((!((ds.mesh.rotationX == 0))) || (!((ds.mesh.rotationY == 0))))) || (!((ds.mesh.rotationZ == 0))));
                j = 0;
                while (j < vecLength) {
                    if (((((nvertices.length + 9) > this.LIMIT)) && (((nindices.length % 3) == 0)))){
                        destDs = new DataSubGeometry();
                        nvertices = (destDs.vertices = new Vector.<Number>());
                        nnormals = (destDs.normals = new Vector.<Number>());
                        nindices = (destDs.indices = new Vector.<uint>());
                        nuvs = (destDs.uvs = new Vector.<Number>());
                        destDs.material = activeMaterial;
                        destDs.subGeometry = new SubGeometry();
                        destDs.transform = ds.transform;
                        destDs.mesh = ds.mesh;
                        ds = destDs;
                        ds.addSub = true;
                        vectors.push(ds);
                    };
                    index = (indices[j] * 3);
                    indexuv = (indices[j] * 2);
                    nindices.push((nvertices.length / 3));
                    indexY = (index + 1);
                    indexZ = (indexY + 1);
                    if (this._objectSpace){
                        nvertices.push(vertices[index], vertices[indexY], vertices[indexZ]);
                    } else {
                        this._v.x = vertices[index];
                        this._v.y = vertices[indexY];
                        this._v.z = vertices[indexZ];
                        if (rotate){
                            this._vn.x = normals[index];
                            this._vn.y = normals[indexY];
                            this._vn.z = normals[indexZ];
                            this._vn = this.applyRotations(this._vn, ds.transform);
                            nnormals.push(this._vn.x, this._vn.y, this._vn.z);
                        };
                        this._v = ds.transform.transformVector(this._v);
                        if (scale){
                            nvertices.push((this._v.x / destMesh.scaleX), (this._v.y / destMesh.scaleY), (this._v.z / destMesh.scaleZ));
                        } else {
                            nvertices.push(this._v.x, this._v.y, this._v.z);
                        };
                    };
                    if (((this._objectSpace) || (!(rotate)))){
                        nnormals.push(normals[index], normals[indexY], normals[indexZ]);
                    };
                    nuvs.push(uvs[indexuv], uvs[(indexuv + 1)]);
                    j++;
                };
            };
            i = 0;
            while (i < vectors.length) {
                ds = vectors[i];
                if (ds.vertices.length == 0){
                } else {
                    subGeom = ds.subGeometry;
                    if (((((ds.normals) && ((ds.normals.length > 0)))) && ((ds.normals.length == ds.vertices.length)))){
                        subGeom.autoDeriveVertexNormals = false;
                        subGeom.updateVertexNormalData(ds.normals);
                    } else {
                        subGeom.autoDeriveVertexNormals = true;
                    };
                    subGeom.updateVertexData(ds.vertices);
                    subGeom.updateIndexData(ds.indices);
                    subGeom.updateUVData(ds.uvs);
                    if (((ds.addSub) || (!(this.isSubGeomAdded(geometry.subGeometries, subGeom))))){
                        geometry.addSubGeometry(subGeom);
                    };
                    if (destMesh.material != ds.material){
                        destMesh.subMeshes[(destMesh.subMeshes.length - 1)].material = ds.material;
                    };
                    if (((this._disposeSources) && (ds.mesh))){
                        if (this._keepMaterial){
                            ds.mesh.geometry.dispose();
                        } else {
                            if (ds.material != destMesh.material){
                                ds.mesh.dispose();
                                if (ds.material){
                                    ds.material.dispose();
                                };
                            };
                        };
                        ds.mesh = null;
                    };
                    ds = null;
                };
                i++;
            };
            i = 0;
            while (i < this._vectorsSource.length) {
                this._vectorsSource[i] = null;
                i++;
            };
            vectors = (this._vectorsSource = null);
            if ((((geometry.subGeometries[0].vertexData.length == 0)) && ((geometry.subGeometries[0].indexData.length == 0)))){
                geometry.removeSubGeometry(geometry.subGeometries[0]);
            };
        }
        private function isSubGeomAdded(subGeometries:Vector.<SubGeometry>, subGeom:SubGeometry):Boolean{
            var i:uint;
            while (i < subGeometries.length) {
                if (subGeometries[i] == subGeom){
                    return (true);
                };
                i++;
            };
            return (false);
        }
        private function collect(m:Mesh):void{
            var ds:DataSubGeometry;
            var geom:Geometry = m.geometry;
            var geoms:Vector.<SubGeometry> = geom.subGeometries;
            if (geoms.length == 0){
                return;
            };
            var i:uint;
            while (i < geoms.length) {
                ds = new DataSubGeometry();
                ds.vertices = SubGeometry(geoms[i]).vertexData.concat();
                ds.indices = SubGeometry(geoms[i]).indexData.concat();
                ds.uvs = SubGeometry(geoms[i]).UVData.concat();
                ds.normals = SubGeometry(geoms[i]).vertexNormalData.concat();
                ds.vertices.fixed = false;
                ds.normals.fixed = false;
                ds.indices.fixed = false;
                ds.uvs.fixed = false;
                ds.material = ((m.subMeshes[i].material) ? m.subMeshes[i].material : m.material);
                ds.subGeometry = SubGeometry(geoms[i]);
                ds.transform = m.transform;
                ds.mesh = m;
                this._vectorsSource.push(ds);
                i++;
            };
        }
        private function getDestSubgeom(v:Vector.<DataSubGeometry>, ds:DataSubGeometry):DataSubGeometry{
            var targetDs:DataSubGeometry;
            var len:uint = (v.length - 1);
            var i:int = len;
            while (i > -1) {
                if (v[i].material == ds.material){
                    targetDs = v[i];
                    return (targetDs);
                };
                i--;
            };
            return (null);
        }
        private function parseContainer(object:ObjectContainer3D):void{
            var child:ObjectContainer3D;
            var i:uint;
            if ((((object is Mesh)) && ((object.numChildren == 0)))){
                this.collect(Mesh(object));
            };
            i = 0;
            while (i < object.numChildren) {
                child = object.getChildAt(i);
                if (child != this._baseReceiver){
                    this.parseContainer(child);
                };
                i++;
            };
        }
        private function applyRotations(v:Vector3D, t:Matrix3D):Vector3D{
            this._holder.x = v.x;
            this._holder.y = v.y;
            this._holder.z = v.z;
            this._holder = t.deltaTransformVector(this._holder);
            v.x = this._holder.x;
            v.y = this._holder.y;
            v.z = this._holder.z;
            return (v);
        }

    }
}//package away3d.tools.commands 

import away3d.entities.*;
import away3d.core.base.*;
import __AS3__.vec.*;
import flash.geom.*;
import away3d.materials.*;

class DataSubGeometry {

    public var uvs:Vector.<Number>;
    public var vertices:Vector.<Number>;
    public var normals:Vector.<Number>;
    public var indices:Vector.<uint>;
    public var subGeometry:SubGeometry;
    public var material:MaterialBase;
    public var transform:Matrix3D;
    public var mesh:Mesh;
    public var addSub:Boolean;

    public function DataSubGeometry(){
    }
}
