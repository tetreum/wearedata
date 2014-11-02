package away3d.core.partition {
    import away3d.entities.*;
    import __AS3__.vec.*;
    import away3d.core.base.*;
    import away3d.core.traverse.*;

    public class MeshNode extends EntityNode {

        private var _mesh:Mesh;

        public function MeshNode(mesh:Mesh){
            super(mesh);
            this._mesh = mesh;
        }
        public function get mesh():Mesh{
            return (this._mesh);
        }
        override public function acceptTraverser(traverser:PartitionTraverser):void{
            var subs:Vector.<SubMesh>;
            var i:uint;
            var len:uint;
            if (traverser.enterNode(this)){
                super.acceptTraverser(traverser);
                subs = this._mesh.subMeshes;
                len = subs.length;
                while (i < len) {
                    var _temp1 = i;
                    i = (i + 1);
                    traverser.applyRenderable(subs[_temp1]);
                };
            };
            traverser.leaveNode(this);
        }

    }
}//package away3d.core.partition 
