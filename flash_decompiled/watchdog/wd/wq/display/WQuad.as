package wd.wq.display {
    import com.adobe.utils.*;
    import flash.display3D.*;
    import wd.wq.textures.*;
    import wd.wq.core.*;
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.display3D.textures.*;

    public class WQuad {

        private static var ID:int = 0;

        private var _id:int;
        private var mTexture:WQConcreteTexture;
        private var mSmoothing:String;
        private var vertices:Vector.<Number>;
        private var indices:Vector.<uint>;
        private var vertexbuffer:VertexBuffer3D;
        private var indexbuffer:IndexBuffer3D;
        private var vindex:int = 0;
        private var iindex:int = 0;
        private var _matrix:Matrix3D;
        private var programName:String;
        private var context:Context3D;
        private var clearEachFrame:Boolean;

        public function WQuad(texture:WQConcreteTexture, clearEachFrame:Boolean=false){
            this.vertices = new Vector.<Number>();
            this.indices = new Vector.<uint>();
            this._matrix = new Matrix3D();
            super();
            this.clearEachFrame = clearEachFrame;
            this.mTexture = texture;
            this.mSmoothing = WQTextureSmoothing.NONE;
            this.programName = getProgramName();
            this.context = WatchQuads.context;
            this._id = ID++;
        }
        public static function registerPrograms(target:WatchQuads):void{
            var repeat:Boolean;
            var mipmap:Boolean;
            var smoothing:String;
            var options:Array;
            var vertexProgramCode:String = ("m44 op, va0, vc0  \n" + "mov v0, va1");
            var fragmentProgramCode:String = "tex oc, v0, fs0 <???> \n";
            var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
            var fragmentProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            var smoothingTypes:Array = [WQTextureSmoothing.NONE, WQTextureSmoothing.BILINEAR, WQTextureSmoothing.TRILINEAR];
            for each (repeat in [true, false]) {
                for each (mipmap in [true, false]) {
                    for each (smoothing in smoothingTypes) {
                        options = ["2d", ((repeat) ? "repeat" : "clamp")];
                        if (smoothing == WQTextureSmoothing.NONE){
                            options.push("nearest", ((mipmap) ? "mipnearest" : "mipnone"));
                        } else {
                            if (smoothing == WQTextureSmoothing.BILINEAR){
                                options.push("linear", ((mipmap) ? "mipnearest" : "mipnone"));
                            } else {
                                options.push("linear", ((mipmap) ? "miplinear" : "mipnone"));
                            };
                        };
                        fragmentProgramAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentProgramCode.replace("???", options.join()));
                        target.registerProgram(getProgramName(mipmap, repeat, smoothing), vertexProgramAssembler.agalcode, fragmentProgramAssembler.agalcode);
                    };
                };
            };
        }
        public static function getProgramName(mipMap:Boolean=false, repeat:Boolean=false, smoothing:String="none"):String{
            var name:String = "quad|";
            if (!(mipMap)){
                name = (name + "N");
            };
            if (repeat){
                name = (name + "R");
            };
            if (smoothing != WQTextureSmoothing.BILINEAR){
                name = (name + smoothing.charAt(0));
            };
            return (name);
        }

        public function set texture(texture:WQConcreteTexture):void{
            if (this.mTexture != null){
                this.mTexture.dispose();
                this.mTexture = null;
            };
            this.mTexture = texture;
        }
        public function get id():int{
            return (this._id);
        }
        public function add(x:Number, y:Number, w:Number, h:Number, uvxStart:Number=0, uvyStart:Number=0, uvxEnd:Number=1, uvyEnd:Number=1):void{
            this.vindex = this.vertices.length;
            var _local9 = this.vindex++;
            this.vertices[_local9] = x;
            var _local10 = this.vindex++;
            this.vertices[_local10] = y;
            var _local11 = this.vindex++;
            this.vertices[_local11] = 0;
            var _local12 = this.vindex++;
            this.vertices[_local12] = uvxStart;
            var _local13 = this.vindex++;
            this.vertices[_local13] = uvyStart;
            var _local14 = this.vindex++;
            this.vertices[_local14] = x;
            var _local15 = this.vindex++;
            this.vertices[_local15] = (y + h);
            var _local16 = this.vindex++;
            this.vertices[_local16] = 0;
            var _local17 = this.vindex++;
            this.vertices[_local17] = uvxStart;
            var _local18 = this.vindex++;
            this.vertices[_local18] = uvyEnd;
            var _local19 = this.vindex++;
            this.vertices[_local19] = (x + w);
            var _local20 = this.vindex++;
            this.vertices[_local20] = (y + h);
            var _local21 = this.vindex++;
            this.vertices[_local21] = 0;
            var _local22 = this.vindex++;
            this.vertices[_local22] = uvxEnd;
            var _local23 = this.vindex++;
            this.vertices[_local23] = uvyEnd;
            var _local24 = this.vindex++;
            this.vertices[_local24] = (x + w);
            var _local25 = this.vindex++;
            this.vertices[_local25] = y;
            var _local26 = this.vindex++;
            this.vertices[_local26] = 0;
            var _local27 = this.vindex++;
            this.vertices[_local27] = uvxEnd;
            var _local28 = this.vindex++;
            this.vertices[_local28] = uvyStart;
            this.vindex = ((this.vertices.length / 5) - 4);
            this.indices.push(this.vindex, (this.vindex + 1), (this.vindex + 2), (this.vindex + 2), (this.vindex + 3), this.vindex);
            this.iindex = this.indices.length;
            this.vindex = (this.vertices.length / 5);
        }
        public function clear():void{
            this.vertices.length = 0;
            this.vindex = 0;
            this.indices.length = 0;
            this.iindex = 0;
            this.vertices = new Vector.<Number>();
            this.indices = new Vector.<uint>();
        }
        private function createVertexBuffer(context:Context3D):void{
            if (this.vertexbuffer != null){
                this.vertexbuffer.dispose();
                this.vertexbuffer = null;
            };
            this.vertexbuffer = context.createVertexBuffer(this.vindex, 5);
            this.vertexbuffer.uploadFromVector(this.vertices, 0, this.vindex);
        }
        private function createIndexBuffer(context:Context3D):void{
            if (this.indexbuffer != null){
                this.indexbuffer.dispose();
                this.indexbuffer = null;
            };
            this.indexbuffer = context.createIndexBuffer(this.iindex);
            this.indexbuffer.uploadFromVector(this.indices, 0, this.iindex);
        }
        public function getWorldTransform():Matrix3D{
            this._matrix.identity();
            return (this._matrix);
        }
        public function render(support:WQRenderSupport, nativeTexture:Texture=null):void{
            if (this.vertices.length == 0){
                return;
            };
            var context:Context3D = WatchQuads.context;
            this.createVertexBuffer(context);
            this.createIndexBuffer(context);
            support.setDefaultBlendFactors(true);
            context.setProgram(WatchQuads.current.getProgram(this.programName));
            context.setDepthTest(false, Context3DCompareMode.ALWAYS);
            context.setCulling(Context3DTriangleFace.NONE);
            context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            context.setTextureAt(0, this.mTexture.base);
            context.setVertexBufferAt(0, this.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            context.setVertexBufferAt(1, this.vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix, true);
            context.drawTriangles(this.indexbuffer, 0, (this.indices.length / 3));
            context.setTextureAt(0, null);
            context.setVertexBufferAt(0, null);
            context.setVertexBufferAt(1, null);
            if (this.clearEachFrame){
                this.clear();
            };
        }

    }
}//package wd.wq.display 
