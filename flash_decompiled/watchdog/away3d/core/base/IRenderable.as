package away3d.core.base {
    import flash.geom.*;
    import flash.display3D.*;
    import away3d.core.managers.*;
    import away3d.entities.*;
    import __AS3__.vec.*;

    public interface IRenderable extends IMaterialOwner {

        function get sceneTransform():Matrix3D;
        function get inverseSceneTransform():Matrix3D;
        function get modelViewProjection():Matrix3D;
        function getModelViewProjectionUnsafe():Matrix3D;
        function get zIndex():Number;
        function get mouseEnabled():Boolean;
        function getVertexBuffer(_arg1:Stage3DProxy):VertexBuffer3D;
        function getCustomBuffer(_arg1:Stage3DProxy):VertexBuffer3D;
        function getUVBuffer(_arg1:Stage3DProxy):VertexBuffer3D;
        function getSecondaryUVBuffer(_arg1:Stage3DProxy):VertexBuffer3D;
        function getVertexNormalBuffer(_arg1:Stage3DProxy):VertexBuffer3D;
        function getVertexTangentBuffer(_arg1:Stage3DProxy):VertexBuffer3D;
        function getIndexBuffer(_arg1:Stage3DProxy):IndexBuffer3D;
        function getIndexBuffer2(_arg1:Stage3DProxy):IndexBuffer3D;
        function get numTriangles():uint;
        function get numTriangles2():uint;
        function get sourceEntity():Entity;
        function get castsShadows():Boolean;
        function get vertexData():Vector.<Number>;
        function get indexData():Vector.<uint>;
        function get UVData():Vector.<Number>;
        function get uvTransform():Matrix;
        function get vertexBufferOffset():int;
        function get normalBufferOffset():int;
        function get tangentBufferOffset():int;
        function get UVBufferOffset():int;
        function get secondaryUVBufferOffset():int;
        function get shaderPickingDetails():Boolean;

    }
}//package away3d.core.base 
