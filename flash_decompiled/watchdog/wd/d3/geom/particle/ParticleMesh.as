package wd.d3.geom.particle {
    import away3d.core.base.*;
    import wd.d3.material.*;
    import wd.utils.*;
    import away3d.cameras.*;
    import wd.d3.control.*;
    import __AS3__.vec.*;
    import wd.core.*;
    import flash.geom.*;
    import away3d.entities.*;

    public class ParticleMesh extends Mesh {

        private var currentAdd:SubGeometry;
        private var v_offset:uint;
        private var SIZE2:Number = 5;
        private var area:Rectangle;

        public function ParticleMesh(){
            super(new Geometry(), MaterialProvider.particle);
            this.createParticles();
        }
        public function update(camera:Camera3D):void{
            x = (camera.x - (this.area.width * (camera.x / Locator.WORLD_RECT.width)));
            z = (camera.z - (this.area.height * (camera.z / Locator.WORLD_RECT.height)));
        }
        private function createParticles():void{
            this.currentAdd = new SubGeometry();
            this.openCurrent();
            geometry.addSubGeometry(this.currentAdd);
            this.area = Locator.world_rect.clone();
            var i:int;
            while (i < 10000) {
                this.addParticle((this.area.x + (Math.random() * this.area.width)), ((CameraController.MIN_HEIGHT * 2) + ((Math.random() * CameraController.MAX_HEIGHT) * 0.1)), (this.area.x + (Math.random() * this.area.height)));
                i++;
            };
            this.closeCurrent();
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
        private function addParticle(_x:Number, _y:Number, _z:Number):void{
            if ((((this.currentAdd.numVertices >= (Constants.MAX_SUBGGEOM_BUFFER_SIZE - 20))) || ((this.currentAdd.numTriangles >= (Constants.MAX_SUBGGEOM_BUFFER_SIZE - 4))))){
                this.closeCurrent();
                this.currentAdd = new SubGeometry();
                this.openCurrent();
                geometry.addSubGeometry(this.currentAdd);
            };
            this.v_offset = (this.currentAdd.vertexData.length / 3);
            this.currentAdd.indexData.push((this.v_offset + 2), (this.v_offset + 1), this.v_offset, (this.v_offset + 2), (this.v_offset + 3), (this.v_offset + 1));
            this.currentAdd.UVData.push(0, 0, 1, 0, 0, 1, 1, 1);
            this.currentAdd.vertexData.push((_x - this.SIZE2), _y, (_z - this.SIZE2), (_x + this.SIZE2), _y, (_z - this.SIZE2), (_x - this.SIZE2), _y, (_z + this.SIZE2), (_x + this.SIZE2), _y, (_z + this.SIZE2));
        }

    }
}//package wd.d3.geom.particle 
