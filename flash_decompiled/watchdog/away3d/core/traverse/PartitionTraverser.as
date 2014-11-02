package away3d.core.traverse {
    import away3d.core.partition.*;
    import away3d.errors.*;
    import away3d.core.base.*;
    import away3d.lights.*;
    import away3d.entities.*;
    import flash.geom.*;
    import away3d.containers.*;

    public class PartitionTraverser {

        public var scene:Scene3D;
        var _entryPoint:Vector3D;

        public function enterNode(node:NodeBase):Boolean{
            return (true);
        }
        public function leaveNode(node:NodeBase):void{
        }
        public function applySkyBox(renderable:IRenderable):void{
            throw (new AbstractMethodError());
        }
        public function applyRenderable(renderable:IRenderable):void{
            throw (new AbstractMethodError());
        }
        public function applyUnknownLight(light:LightBase):void{
            throw (new AbstractMethodError());
        }
        public function applyDirectionalLight(light:DirectionalLight):void{
            throw (new AbstractMethodError());
        }
        public function applyPointLight(light:PointLight):void{
            throw (new AbstractMethodError());
        }
        public function applyLightProbe(light:LightProbe):void{
            throw (new AbstractMethodError());
        }
        public function applyEntity(entity:Entity):void{
            throw (new AbstractMethodError());
        }
        public function get entryPoint():Vector3D{
            return (this._entryPoint);
        }

    }
}//package away3d.core.traverse 
