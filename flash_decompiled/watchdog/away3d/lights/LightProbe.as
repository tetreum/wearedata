package away3d.lights {
    import away3d.textures.*;
    import away3d.core.partition.*;
    import away3d.bounds.*;
    import away3d.core.base.*;
    import flash.geom.*;

    public class LightProbe extends LightBase {

        private var _diffuseMap:CubeTextureBase;
        private var _specularMap:CubeTextureBase;

        public function LightProbe(diffuseMap:CubeTextureBase, specularMap:CubeTextureBase=null){
            super();
            this._diffuseMap = diffuseMap;
            this._specularMap = specularMap;
        }
        override protected function createEntityPartitionNode():EntityNode{
            return (new LightProbeNode(this));
        }
        public function get diffuseMap():CubeTextureBase{
            return (this._diffuseMap);
        }
        public function set diffuseMap(value:CubeTextureBase):void{
            this._diffuseMap = value;
        }
        public function get specularMap():CubeTextureBase{
            return (this._specularMap);
        }
        public function set specularMap(value:CubeTextureBase):void{
            this._specularMap = value;
        }
        override protected function updateBounds():void{
            _boundsInvalid = false;
        }
        override protected function getDefaultBoundingVolume():BoundingVolumeBase{
            return (new NullBounds());
        }
        override function getObjectProjectionMatrix(renderable:IRenderable, target:Matrix3D=null):Matrix3D{
            throw (new Error("Object projection matrices are not supported for LightProbe objects!"));
        }

    }
}//package away3d.lights 
