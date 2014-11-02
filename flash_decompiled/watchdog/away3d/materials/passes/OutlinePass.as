package away3d.materials.passes {
    import __AS3__.vec.*;
    import flash.display3D.*;
    import flash.utils.*;
    import away3d.entities.*;
    import away3d.core.managers.*;
    import away3d.cameras.*;
    import away3d.core.base.*;
    import away3d.materials.lightpickers.*;

    public class OutlinePass extends MaterialPassBase {

        private var _outlineColor:uint;
        private var _colorData:Vector.<Number>;
        private var _offsetData:Vector.<Number>;
        private var _showInnerLines:Boolean;
        private var _outlineMeshes:Dictionary;
        private var _dedicatedMeshes:Boolean;

        public function OutlinePass(outlineColor:uint=0, outlineSize:Number=20, showInnerLines:Boolean=true, dedicatedMeshes:Boolean=false){
            super();
            mipmap = false;
            this._colorData = new Vector.<Number>(4, true);
            this._colorData[3] = 1;
            this._offsetData = new Vector.<Number>(4, true);
            this.outlineColor = outlineColor;
            this.outlineSize = outlineSize;
            _defaultCulling = Context3DTriangleFace.FRONT;
            _numUsedStreams = 2;
            _numUsedVertexConstants = 6;
            this._showInnerLines = showInnerLines;
            this._dedicatedMeshes = dedicatedMeshes;
            if (dedicatedMeshes){
                this._outlineMeshes = new Dictionary();
            };
            _animatableAttributes = ["va0", "va1"];
            _animationTargetRegisters = ["vt0", "vt1"];
        }
        public function clearDedicatedMesh(mesh:Mesh):void{
            var i:int;
            if (this._dedicatedMeshes){
                i = 0;
                while (i < mesh.subMeshes.length) {
                    this.disposeDedicated(mesh.subMeshes[i]);
                    i++;
                };
            };
        }
        private function disposeDedicated(keySubMesh:Object):void{
            var mesh:Mesh;
            mesh = Mesh(this._dedicatedMeshes[keySubMesh]);
            mesh.geometry.dispose();
            mesh.dispose();
            delete this._dedicatedMeshes[keySubMesh];
        }
        override public function dispose():void{
            var key:Object;
            super.dispose();
            if (this._dedicatedMeshes){
                for (key in this._outlineMeshes) {
                    this.disposeDedicated(key);
                };
            };
        }
        public function get showInnerLines():Boolean{
            return (this._showInnerLines);
        }
        public function set showInnerLines(value:Boolean):void{
            this._showInnerLines = value;
        }
        public function get outlineColor():uint{
            return (this._outlineColor);
        }
        public function set outlineColor(value:uint):void{
            this._outlineColor = value;
            this._colorData[0] = (((value >> 16) & 0xFF) / 0xFF);
            this._colorData[1] = (((value >> 8) & 0xFF) / 0xFF);
            this._colorData[2] = ((value & 0xFF) / 0xFF);
        }
        public function get outlineSize():Number{
            return (this._offsetData[0]);
        }
        public function set outlineSize(value:Number):void{
            this._offsetData[0] = value;
        }
        override function getVertexCode(code:String):String{
            code = (code + (((("mul vt7, vt1, vc5.x\n" + "add vt7, vt7, vt0\n") + "mov vt7.w, vt0.w\n") + "m44 vt7, vt7, vc0\t\t\n") + "mul op, vt7, vc4\n"));
            return (code);
        }
        override function getFragmentCode():String{
            return ("mov oc, fc0\n");
        }
        override function activate(stage3DProxy:Stage3DProxy, camera:Camera3D, textureRatioX:Number, textureRatioY:Number):void{
            var context:Context3D = stage3DProxy._context3D;
            super.activate(stage3DProxy, camera, textureRatioX, textureRatioY);
            if (!(this._showInnerLines)){
                context.setDepthTest(false, Context3DCompareMode.LESS);
            };
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._colorData, 1);
            context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, this._offsetData, 1);
        }
        override function deactivate(stage3DProxy:Stage3DProxy):void{
            super.deactivate(stage3DProxy);
            if (!(this._showInnerLines)){
                stage3DProxy._context3D.setDepthTest(true, Context3DCompareMode.LESS);
            };
        }
        override function render(renderable:IRenderable, stage3DProxy:Stage3DProxy, camera:Camera3D, lightPicker:LightPickerBase):void{
            var mesh:Mesh;
            var dedicatedRenderable:IRenderable;
            var context:Context3D;
            if (this._dedicatedMeshes){
                mesh = (this._outlineMeshes[renderable] = ((this._outlineMeshes[renderable]) || (this.createDedicatedMesh(SubMesh(renderable).subGeometry))));
                dedicatedRenderable = mesh.subMeshes[0];
                context = stage3DProxy._context3D;
                context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, renderable.modelViewProjection, true);
                stage3DProxy.setSimpleVertexBuffer(0, dedicatedRenderable.getVertexBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, dedicatedRenderable.vertexBufferOffset);
                stage3DProxy.setSimpleVertexBuffer(1, dedicatedRenderable.getVertexNormalBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, dedicatedRenderable.normalBufferOffset);
                context.drawTriangles(dedicatedRenderable.getIndexBuffer(stage3DProxy), 0, dedicatedRenderable.numTriangles);
            } else {
                stage3DProxy.setSimpleVertexBuffer(1, renderable.getVertexNormalBuffer(stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, renderable.normalBufferOffset);
                super.render(renderable, stage3DProxy, camera, lightPicker);
            };
        }
        private function createDedicatedMesh(source:SubGeometry):Mesh{
            var index:int;
            var x:Number;
            var y:Number;
            var z:Number;
            var key:String;
            var indexCount:int;
            var vertexCount:int;
            var maxIndex:int;
            var mesh:Mesh = new Mesh(new Geometry(), null);
            var dest:SubGeometry = new SubGeometry();
            var indexLookUp:Array = [];
            var srcIndices:Vector.<uint> = source.indexData;
            var srcVertices:Vector.<Number> = source.vertexData;
            var dstIndices:Vector.<uint> = new Vector.<uint>();
            var dstVertices:Vector.<Number> = new Vector.<Number>();
            var len:int = srcIndices.length;
            var i:int;
            while (i < len) {
                index = (srcIndices[i] * 3);
                x = srcVertices[index];
                y = srcVertices[(index + 1)];
                z = srcVertices[(index + 2)];
                key = ((((x.toPrecision(5) + "/") + y.toPrecision(5)) + "/") + z.toPrecision(5));
                if (indexLookUp[key]){
                    index = (indexLookUp[key] - 1);
                } else {
                    index = (vertexCount / 3);
                    indexLookUp[key] = (index + 1);
                    var _temp1 = vertexCount;
                    vertexCount = (vertexCount + 1);
                    var _local19 = _temp1;
                    dstVertices[_local19] = x;
                    var _temp2 = vertexCount;
                    vertexCount = (vertexCount + 1);
                    var _local20 = _temp2;
                    dstVertices[_local20] = y;
                    var _temp3 = vertexCount;
                    vertexCount = (vertexCount + 1);
                    var _local21 = _temp3;
                    dstVertices[_local21] = z;
                };
                if (index > maxIndex){
                    maxIndex = index;
                };
                var _temp4 = indexCount;
                indexCount = (indexCount + 1);
                _local19 = _temp4;
                dstIndices[_local19] = index;
                i++;
            };
            dest.autoDeriveVertexNormals = true;
            dest.updateVertexData(dstVertices);
            dest.updateIndexData(dstIndices);
            mesh.geometry.addSubGeometry(dest);
            return (mesh);
        }

    }
}//package away3d.materials.passes 
