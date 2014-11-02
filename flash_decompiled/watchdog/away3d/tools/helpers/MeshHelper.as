package away3d.tools.helpers {
    import away3d.core.base.*;
    import away3d.tools.utils.*;
    import away3d.entities.*;
    import away3d.containers.*;
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.utils.*;
    import away3d.materials.utils.*;
    import away3d.materials.*;
    import away3d.core.base.data.*;

    public class MeshHelper {

        private static const LIMIT:uint = 196605;

        public static function boundingRadius(mesh:Mesh):Number{
            var radius:* = NaN;
            var mesh:* = mesh;
            try {
                radius = Math.max(((mesh.maxX - mesh.minX) * Object3D(mesh).scaleX), ((mesh.maxY - mesh.minY) * Object3D(mesh).scaleY), ((mesh.maxZ - mesh.minZ) * Object3D(mesh).scaleZ));
            } catch(e:Error) {
                Bounds.getMeshBounds(mesh);
                radius = Math.max(((Bounds.maxX - Bounds.minX) * Object3D(mesh).scaleX), ((Bounds.maxY - Bounds.minY) * Object3D(mesh).scaleY), ((Bounds.maxZ - Bounds.minZ) * Object3D(mesh).scaleZ));
            };
            return ((radius * 0.5));
        }
        public static function boundingRadiusContainer(container:ObjectContainer3D):Number{
            Bounds.getObjectContainerBounds(container);
            var radius:Number = Math.max(((Bounds.maxX - Bounds.minX) * Object3D(container).scaleX), ((Bounds.maxY - Bounds.minY) * Object3D(container).scaleY), ((Bounds.maxZ - Bounds.minZ) * Object3D(container).scaleZ));
            return ((radius * 0.5));
        }
        public static function recenter(mesh:Mesh, keepPosition:Boolean=true):void{
            Bounds.getMeshBounds(mesh);
            var dx:Number = ((Bounds.minX + Bounds.maxX) * 0.5);
            var dy:Number = ((Bounds.minY + Bounds.maxY) * 0.5);
            var dz:Number = ((Bounds.minZ + Bounds.maxZ) * 0.5);
            applyPosition(mesh, -(dx), -(dy), -(dz));
            if (keepPosition){
                mesh.x = (mesh.x - dx);
                mesh.y = (mesh.y - dy);
                mesh.z = (mesh.z - dz);
            };
        }
        public static function recenterContainer(obj:ObjectContainer3D, keepPosition:Boolean=true):void{
            var child:ObjectContainer3D;
            if ((((obj is Mesh)) && ((ObjectContainer3D(obj).numChildren == 0)))){
                recenter(Mesh(obj), keepPosition);
            };
            var i:uint;
            while (i < ObjectContainer3D(obj).numChildren) {
                child = ObjectContainer3D(obj).getChildAt(i);
                recenterContainer(child, keepPosition);
                i++;
            };
        }
        public static function applyRotations(mesh:Mesh):void{
            var vertices:Vector.<Number>;
            var normals:Vector.<Number>;
            var verticesLength:uint;
            var j:uint;
            var yind:uint;
            var zind:uint;
            var subGeom:SubGeometry;
            var updateNormals:Boolean;
            var geometry:Geometry = mesh.geometry;
            var geometries:Vector.<SubGeometry> = geometry.subGeometries;
            var numSubGeoms:int = geometries.length;
            var t:Matrix3D = mesh.transform;
            var holder:Vector3D = new Vector3D();
            var i:uint;
            while (i < numSubGeoms) {
                subGeom = SubGeometry(geometries[i]);
                vertices = subGeom.vertexData;
                normals = subGeom.vertexNormalData;
                verticesLength = vertices.length;
                updateNormals = Boolean((normals.length == verticesLength));
                j = 0;
                while (j < verticesLength) {
                    holder.x = vertices[j];
                    yind = (j + 1);
                    holder.y = vertices[yind];
                    zind = (j + 2);
                    holder.z = vertices[zind];
                    holder = t.deltaTransformVector(holder);
                    vertices[j] = holder.x;
                    vertices[yind] = holder.y;
                    vertices[zind] = holder.z;
                    if (updateNormals){
                        holder.x = normals[j];
                        holder.y = normals[yind];
                        holder.z = normals[zind];
                        holder = t.deltaTransformVector(holder);
                        normals[j] = holder.x;
                        normals[yind] = holder.y;
                        normals[zind] = holder.z;
                    };
                    j = (j + 3);
                };
                subGeom.updateVertexData(vertices);
                if (updateNormals){
                    subGeom.updateVertexNormalData(normals);
                };
                i++;
            };
            mesh.rotationX = (mesh.rotationY = (mesh.rotationZ = 0));
        }
        public static function applyRotationsContainer(obj:ObjectContainer3D):void{
            var child:ObjectContainer3D;
            if ((((obj is Mesh)) && ((ObjectContainer3D(obj).numChildren == 0)))){
                applyRotations(Mesh(obj));
            };
            var i:uint;
            while (i < ObjectContainer3D(obj).numChildren) {
                child = ObjectContainer3D(obj).getChildAt(i);
                applyRotationsContainer(child);
                i++;
            };
        }
        public static function applyScales(mesh:Mesh, scaleX:Number, scaleY:Number, scaleZ:Number, parent:ObjectContainer3D=null):void{
            var vertices:Vector.<Number>;
            var len:uint;
            var j:uint;
            var subGeom:SubGeometry;
            if ((((((scaleX == 1)) && ((scaleY == 1)))) && ((scaleZ == 1)))){
                return;
            };
            if (mesh.animator){
                mesh.scaleX = scaleX;
                mesh.scaleY = scaleY;
                mesh.scaleZ = scaleZ;
                return;
            };
            var geometries:Vector.<SubGeometry> = mesh.geometry.subGeometries;
            var numSubGeoms:int = geometries.length;
            var i:uint;
            while (i < numSubGeoms) {
                subGeom = SubGeometry(geometries[i]);
                vertices = subGeom.vertexData;
                len = vertices.length;
                j = 0;
                while (j < len) {
                    vertices[j] = (vertices[j] * scaleX);
                    vertices[(j + 1)] = (vertices[(j + 1)] * scaleY);
                    vertices[(j + 2)] = (vertices[(j + 2)] * scaleZ);
                    j = (j + 3);
                };
                subGeom.updateVertexData(vertices);
                i++;
            };
            mesh.scaleX = (mesh.scaleY = (mesh.scaleZ = 1));
            if (parent){
                mesh.x = (mesh.x * scaleX);
                mesh.y = (mesh.y * scaleY);
                mesh.z = (mesh.z * scaleZ);
            };
        }
        public static function applyScalesContainer(obj:ObjectContainer3D, scaleX:Number, scaleY:Number, scaleZ:Number, parent:ObjectContainer3D=null):void{
            var child:ObjectContainer3D;
            if ((((obj is Mesh)) && ((ObjectContainer3D(obj).numChildren == 0)))){
                applyScales(Mesh(obj), scaleX, scaleY, scaleZ, obj);
            };
            var i:uint;
            while (i < ObjectContainer3D(obj).numChildren) {
                child = ObjectContainer3D(obj).getChildAt(i);
                applyScalesContainer(child, scaleX, scaleY, scaleZ, obj);
                i++;
            };
        }
        public static function applyPosition(mesh:Mesh, dx:Number, dy:Number, dz:Number):void{
            var vertices:Vector.<Number>;
            var verticesLength:uint;
            var j:uint;
            var subGeom:SubGeometry;
            var geometry:Geometry = mesh.geometry;
            var geometries:Vector.<SubGeometry> = geometry.subGeometries;
            var numSubGeoms:int = geometries.length;
            var i:uint;
            while (i < numSubGeoms) {
                subGeom = SubGeometry(geometries[i]);
                vertices = subGeom.vertexData;
                verticesLength = vertices.length;
                j = 0;
                while (j < verticesLength) {
                    vertices[j] = (vertices[j] + dx);
                    vertices[(j + 1)] = (vertices[(j + 1)] + dy);
                    vertices[(j + 2)] = (vertices[(j + 2)] + dz);
                    j = (j + 3);
                };
                subGeom.updateVertexData(vertices);
                i++;
            };
            mesh.x = (mesh.x - dx);
            mesh.y = (mesh.y - dy);
            mesh.z = (mesh.z - dz);
        }
        public static function clone(mesh:Mesh, newName:String=""):Mesh{
            var geometry:Geometry = mesh.geometry.clone();
            var newMesh:Mesh = new Mesh(geometry, mesh.material);
            newMesh.name = newName;
            return (newMesh);
        }
        public static function invertFacesInContainer(obj:ObjectContainer3D):void{
            var child:ObjectContainer3D;
            if ((((obj is Mesh)) && ((ObjectContainer3D(obj).numChildren == 0)))){
                invertFaces(Mesh(obj));
            };
            var i:uint;
            while (i < ObjectContainer3D(obj).numChildren) {
                child = ObjectContainer3D(obj).getChildAt(i);
                invertFacesInContainer(child);
                i++;
            };
        }
        public static function invertFaces(mesh:Mesh, invertU:Boolean=false):void{
            var indices:Vector.<uint>;
            var normals:Vector.<Number>;
            var uvs:Vector.<Number>;
            var tangents:Vector.<Number>;
            var i:uint;
            var j:uint;
            var ind:uint;
            var indV0:uint;
            var subGeom:SubGeometry;
            var subGeometries:Vector.<SubGeometry> = mesh.geometry.subGeometries;
            var numSubGeoms:uint = subGeometries.length;
            i = 0;
            while (i < numSubGeoms) {
                subGeom = SubGeometry(subGeometries[i]);
                indices = subGeom.indexData;
                normals = subGeom.vertexNormalData;
                tangents = subGeom.vertexTangentData;
                j = 0;
                while (j < indices.length) {
                    indV0 = indices[j];
                    ind = (j + 1);
                    indices[j] = indices[ind];
                    indices[ind] = indV0;
                    j = (j + 3);
                };
                j = 0;
                while (j < normals.length) {
                    normals[j] = (normals[j] * -1);
                    tangents[j] = (tangents[j] * -1);
                    j++;
                };
                subGeom.updateIndexData(indices);
                subGeom.updateVertexNormalData(normals);
                subGeom.updateVertexTangentData(tangents);
                if (invertU){
                    uvs = subGeom.UVData;
                    j = 0;
                    while (j < uvs.length) {
                        uvs[j] = (1 - uvs[j]);
                        j++;
                        j++;
                    };
                    subGeom.updateUVData(uvs);
                };
                i++;
            };
        }
        public static function build(vertices:Vector.<Number>, indices:Vector.<uint>, uvs:Vector.<Number>=null, name:String="", material:MaterialBase=null, shareVertices:Boolean=true, useDefaultMap:Boolean=true):Mesh{
            var uvind:uint;
            var vind:uint;
            var ind:uint;
            var i:uint;
            var j:uint;
            var dShared:Dictionary;
            var subGeom:SubGeometry = new SubGeometry();
            subGeom.autoDeriveVertexNormals = true;
            subGeom.autoDeriveVertexTangents = true;
            var geometry:Geometry = new Geometry();
            geometry.addSubGeometry(subGeom);
            material = ((((!(material)) && (useDefaultMap))) ? DefaultMaterialManager.getDefaultMaterial() : material);
            var m:Mesh = new Mesh(geometry, material);
            if (name != ""){
                m.name = name;
            };
            var nvertices:Vector.<Number> = new Vector.<Number>();
            var nuvs:Vector.<Number> = new Vector.<Number>();
            var nindices:Vector.<uint> = new Vector.<uint>();
            var defaultUVS:Vector.<Number> = Vector.<Number>([0, 1, 0.5, 0, 1, 1, 0.5, 0]);
            var uvid:uint;
            if (shareVertices){
                dShared = new Dictionary();
            };
            var vertex:Vertex = new Vertex();
            i = 0;
            for (;i < indices.length;i++) {
                ind = (indices[i] * 3);
                vertex.x = vertices[ind];
                vertex.y = vertices[(ind + 1)];
                vertex.z = vertices[(ind + 2)];
                if (nvertices.length == LIMIT){
                    subGeom.updateVertexData(nvertices);
                    subGeom.updateIndexData(nindices);
                    subGeom.updateUVData(nuvs);
                    if (shareVertices){
                        dShared = null;
                        dShared = new Dictionary();
                    };
                    subGeom = new SubGeometry();
                    subGeom.autoDeriveVertexNormals = true;
                    subGeom.autoDeriveVertexTangents = true;
                    geometry.addSubGeometry(subGeom);
                    uvid = 0;
                    uvind = uvid;
                    nvertices = new Vector.<Number>();
                    nindices = new Vector.<uint>();
                    nuvs = new Vector.<Number>();
                };
                vind = (nvertices.length / 3);
                uvind = (vind * 2);
                if (shareVertices){
                    if (dShared[vertex.toString()]){
                        nindices[nindices.length] = dShared[vertex.toString()];
                        continue;
                    };
                    dShared[vertex.toString()] = vind;
                };
                nindices[nindices.length] = vind;
                nvertices.push(vertex.x, vertex.y, vertex.z);
                if (((!(uvs)) || ((uvind > (uvs.length - 2))))){
                    nuvs.push(defaultUVS[uvid], defaultUVS[(uvid + 1)]);
                    uvid = (((uvid + 2))>3) ? 0 : uvid = (uvid + 2);
uvid;
                } else {
                    nuvs.push(uvs[uvind], uvs[(uvind + 1)]);
                };
            };
            if (shareVertices){
                dShared = null;
            };
            subGeom.updateVertexData(nvertices);
            subGeom.updateIndexData(nindices);
            subGeom.updateUVData(nuvs);
            return (m);
        }
        public static function splitMesh(mesh:Mesh, disposeSource:Boolean=false):Vector.<Mesh>{
            var vertices:* = null;
            var indices:* = null;
            var uvs:* = null;
            var normals:* = null;
            var tangents:* = null;
            var subGeom:* = null;
            var nGeom:* = null;
            var nSubGeom:* = null;
            var nm:* = null;
            var nMeshMat:* = null;
            var j:* = 0;
            var mesh:* = mesh;
            var disposeSource:Boolean = disposeSource;
            var meshes:* = new Vector.<Mesh>();
            var geometries:* = mesh.geometry.subGeometries;
            var numSubGeoms:* = geometries.length;
            if (numSubGeoms == 1){
                meshes.push(mesh);
                return (meshes);
            };
            j = 0;
            var i:* = 0;
            while (i < numSubGeoms) {
                subGeom = geometries[i];
                vertices = subGeom.vertexData;
                indices = subGeom.indexData;
                uvs = subGeom.UVData;
                try {
                    normals = subGeom.vertexNormalData;
                    subGeom.autoDeriveVertexNormals = false;
                } catch(e:Error) {
                    subGeom.autoDeriveVertexNormals = true;
                    normals = new Vector.<Number>();
                    j = 0;
                    while (j < vertices.length) {
                        j = (j + 1);
                        var _local5:Number = j;
                        normals[_local5] = 0;
                    };
                };
                try {
                    tangents = subGeom.vertexTangentData;
                    subGeom.autoDeriveVertexTangents = false;
                } catch(e:Error) {
                    subGeom.autoDeriveVertexTangents = true;
                    tangents = new Vector.<Number>();
                    j = 0;
                    while (j < vertices.length) {
                        j = (j + 1);
                        _local5 = j;
                        tangents[_local5] = 0;
                    };
                };
                vertices.fixed = false;
                indices.fixed = false;
                uvs.fixed = false;
                normals.fixed = false;
                tangents.fixed = false;
                nGeom = new Geometry();
                nm = new Mesh(nGeom, ((mesh.subMeshes[i].material) ? mesh.subMeshes[i].material : nMeshMat));
                nSubGeom = new SubGeometry();
                nSubGeom.updateVertexData(vertices);
                nSubGeom.updateIndexData(indices);
                nSubGeom.updateUVData(uvs);
                nSubGeom.updateVertexNormalData(normals);
                nSubGeom.updateVertexTangentData(tangents);
                nGeom.addSubGeometry(nSubGeom);
                meshes.push(nm);
                i = (i + 1);
            };
            if (disposeSource){
                mesh = null;
            };
            return (meshes);
        }

    }
}//package away3d.tools.helpers 
