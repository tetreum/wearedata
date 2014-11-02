package wd.wq.display {
    import com.adobe.utils.*;
    import flash.display3D.*;
    import wd.wq.textures.*;
    import wd.wq.core.*;
    import __AS3__.vec.*;
    import flash.geom.*;
    import flash.display3D.textures.*;

    public class Image3D {

        private var mTexture:WQConcreteTexture;
        private var mSmoothing:String;
        private var vertices:Vector.<Number>;
        private var vertexbuffer:VertexBuffer3D;
        private var indexbuffer:IndexBuffer3D;
        public var x:Number = 0;
        public var y:Number = 0;
        public var width:Number = 0;
        public var height:Number = 0;
        public var rotation:Number = 0;
        public var scaleX:Number = 1;
        public var scaleY:Number = 1;
        private var _matrix:Matrix3D;
        private var deltay:Number;
        private var deltax:Number;
        private var verticesInit:Vector.<Number>;
        private var lastIsUVA:Boolean = false;

        public function Image3D(texture:WQConcreteTexture){
            this.verticesInit = Vector.<Number>([0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0]);
            super();
            this._matrix = new Matrix3D();
            this.vertices = Vector.<Number>([0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0]);
            this.mTexture = texture;
            this.width = texture.width;
            this.height = texture.height;
            this.mSmoothing = WQTextureSmoothing.NONE;
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
        public static function getProgramName(mipMap:Boolean=false, repeat:Boolean=false, smoothing:String="bilinear"):String{
            var name:String = "image|";
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

        public function setUVA(uvArea:Rectangle, bound:Rectangle):void{
            this.width = 1;
            this.height = 1;
            this.vertices = Vector.<Number>([0, 0, 0, uvArea.x, uvArea.y, 0, bound.height, 0, uvArea.x, (uvArea.y + uvArea.height), bound.width, bound.height, 0, (uvArea.x + uvArea.width), (uvArea.y + uvArea.height), bound.width, 0, 0, (uvArea.x + uvArea.width), uvArea.y]);
            if (this.vertexbuffer != null){
                this.vertexbuffer.dispose();
                this.vertexbuffer = null;
            };
            this.lastIsUVA = true;
        }
        public function getWorldTransform():Matrix3D{
            this._matrix.identity();
            this._matrix.appendScale((this.width * this.scaleX), (this.height * this.scaleY), 1);
            if (this.rotation != 0){
                this._matrix.appendTranslation(this.deltax, this.deltay, 0);
                this._matrix.appendRotation(((this.rotation * 180) / Math.PI), Vector3D.Z_AXIS);
                this._matrix.appendTranslation(-(this.deltax), -(this.deltay), 0);
            };
            this._matrix.appendTranslation(this.x, this.y, 0);
            return (this._matrix);
        }
        public function setTexture(texture:WQConcreteTexture):void{
            this.mTexture = texture;
            this.width = texture.width;
            this.height = texture.height;
        }
        public function setPos(_x:Number, _y:Number):void{
            this.scaleX = 1;
            this.scaleY = 1;
            this.rotation = 0;
            this.vertices = this.verticesInit;
            if (((!((this.vertexbuffer == null))) && (this.lastIsUVA))){
                this.lastIsUVA = false;
                this.vertexbuffer.dispose();
                this.vertexbuffer = null;
            };
            this.x = _x;
            this.y = _y;
        }
        public function setRotation(_x:Number, _y:Number, _r:Number=0):void{
            this.rotation = _r;
            this.deltax = _x;
            this.deltay = _y;
        }
        public function setUV(w:Number, h:Number):void{
            this.width = (this.width * (1 / w));
            this.height = (this.height * (1 / h));
        }
        public function setScale(sx:Number, sy:Number):void{
            this.scaleX = sx;
            this.scaleY = sy;
        }
        private function createVertexBuffer(context:Context3D):void{
            this.vertexbuffer = context.createVertexBuffer(4, 5);
            this.vertexbuffer.uploadFromVector(this.vertices, 0, 4);
        }
        private function createIndexBuffer(context:Context3D):void{
            this.indexbuffer = context.createIndexBuffer(6);
            this.indexbuffer.uploadFromVector(Vector.<uint>([0, 1, 2, 2, 3, 0]), 0, 6);
        }
        public function render(support:WQRenderSupport, nativeTexture:Texture=null):void{
            var programName:String = getProgramName(false, false, "none");
            var context:Context3D = WatchQuads.context;
            if (this.vertexbuffer == null){
                this.createVertexBuffer(context);
            };
            if (this.indexbuffer == null){
                this.createIndexBuffer(context);
            };
            this._matrix = this.getWorldTransform();
            this._matrix.append(support.mvpMatrix);
            support.setDefaultBlendFactors(true);
            context.setProgram(WatchQuads.current.getProgram(programName));
            context.setTextureAt(0, this.mTexture.base);
            context.setVertexBufferAt(0, this.vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
            context.setVertexBufferAt(1, this.vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, this._matrix, true);
            context.drawTriangles(this.indexbuffer, 0, 2);
            context.setTextureAt(0, null);
            context.setVertexBufferAt(0, null);
            context.setVertexBufferAt(1, null);
        }

    }
}//package wd.wq.display 
