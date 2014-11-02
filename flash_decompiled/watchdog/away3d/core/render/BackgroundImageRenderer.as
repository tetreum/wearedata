package away3d.core.render {
    import away3d.core.managers.*;
    import flash.display3D.*;
    import __AS3__.vec.*;
    import com.adobe.utils.*;
    import away3d.debug.*;
    import away3d.textures.*;

    public class BackgroundImageRenderer {

        private var _program3d:Program3D;
        private var _texture:Texture2DBase;
        private var _indexBuffer:IndexBuffer3D;
        private var _vertexBuffer:VertexBuffer3D;
        private var _stage3DProxy:Stage3DProxy;

        public function BackgroundImageRenderer(stage3DProxy:Stage3DProxy){
            super();
            this.stage3DProxy = stage3DProxy;
        }
        public function get stage3DProxy():Stage3DProxy{
            return (this._stage3DProxy);
        }
        public function set stage3DProxy(value:Stage3DProxy):void{
            if (value == this._stage3DProxy){
                return;
            };
            this._stage3DProxy = value;
            if (this._vertexBuffer){
                this._vertexBuffer.dispose();
                this._vertexBuffer = null;
                this._program3d.dispose();
                this._program3d = null;
                this._indexBuffer.dispose();
                this._indexBuffer = null;
            };
        }
        private function getVertexCode():String{
            return (("mov op, va0\n" + "mov v0, va1"));
        }
        private function getFragmentCode():String{
            return (("tex ft0, v0, fs0 <2d, linear>\t\n" + "mov oc, ft0"));
        }
        public function dispose():void{
            if (this._vertexBuffer){
                this._vertexBuffer.dispose();
            };
            if (this._program3d){
                this._program3d.dispose();
            };
        }
        public function render():void{
            var context:Context3D = this._stage3DProxy.context3D;
            if (!(context)){
                return;
            };
            if (!(this._vertexBuffer)){
                this.initBuffers(context);
            };
            this._stage3DProxy.setProgram(this._program3d);
            this._stage3DProxy.setTextureAt(0, this._texture.getTextureForStage3D(this._stage3DProxy));
            context.setVertexBufferAt(0, this._vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
            context.setVertexBufferAt(1, this._vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2);
            context.drawTriangles(this._indexBuffer, 0, 2);
            this._stage3DProxy.setSimpleVertexBuffer(0, null, null, 0);
            this._stage3DProxy.setSimpleVertexBuffer(1, null, null, 0);
            this._stage3DProxy.setTextureAt(0, null);
        }
        private function initBuffers(context:Context3D):void{
            this._vertexBuffer = context.createVertexBuffer(4, 4);
            this._program3d = context.createProgram();
            this._indexBuffer = context.createIndexBuffer(6);
            this._indexBuffer.uploadFromVector(Vector.<uint>([2, 1, 0, 3, 2, 0]), 0, 6);
            this._program3d.upload(new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.VERTEX, this.getVertexCode()), new AGALMiniAssembler(Debug.active).assemble(Context3DProgramType.FRAGMENT, this.getFragmentCode()));
            this._vertexBuffer.uploadFromVector(Vector.<Number>([-1, -1, 0, 1, 1, -1, 1, 1, 1, 1, 1, 0, -1, 1, 0, 0]), 0, 4);
        }
        public function get texture():Texture2DBase{
            return (this._texture);
        }
        public function set texture(value:Texture2DBase):void{
            this._texture = value;
        }

    }
}//package away3d.core.render 
