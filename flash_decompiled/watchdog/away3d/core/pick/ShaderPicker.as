package away3d.core.pick {
    import flash.geom.*;
    import flash.display.*;
    import away3d.cameras.*;
    import away3d.containers.*;
    import away3d.core.base.*;
    import away3d.core.data.*;
    import away3d.core.managers.*;
    import away3d.core.math.*;
    import away3d.core.traverse.*;
    import away3d.entities.*;
    import flash.display3D.*;
    import flash.display3D.textures.*;
    import com.adobe.utils.*;
    import __AS3__.vec.*;

    public class ShaderPicker implements IPicker {

        private static const MOUSE_SCISSOR_RECT:Rectangle = new Rectangle(0, 0, 1, 1);

        private var _stage3DProxy:Stage3DProxy;
        private var _context:Context3D;
        private var _objectProgram3D:Program3D;
        private var _triangleProgram3D:Program3D;
        private var _bitmapData:BitmapData;
        private var _viewportData:Vector.<Number>;
        private var _boundOffsetScale:Vector.<Number>;
        private var _id:Vector.<Number>;
        private var _interactives:Vector.<IRenderable>;
        private var _interactiveId:uint;
        private var _hitColor:uint;
        private var _projX:Number;
        private var _projY:Number;
        private var _hitRenderable:IRenderable;
        private var _localHitPosition:Vector3D;
        private var _hitUV:Point;
        private var _localHitNormal:Vector3D;
        private var _rayPos:Vector3D;
        private var _rayDir:Vector3D;
        private var _potentialFound:Boolean;

        public function ShaderPicker(){
            this._bitmapData = new BitmapData(1, 1, false, 0);
            this._interactives = new Vector.<IRenderable>();
            this._localHitPosition = new Vector3D();
            this._hitUV = new Point();
            this._localHitNormal = new Vector3D();
            this._rayPos = new Vector3D();
            this._rayDir = new Vector3D();
            super();
            this._id = new Vector.<Number>(4, true);
            this._viewportData = new Vector.<Number>(4, true);
            this._boundOffsetScale = new Vector.<Number>(8, true);
            this._boundOffsetScale[3] = 0;
            this._boundOffsetScale[7] = 1;
        }
        public function getViewCollision(x:Number, y:Number, view:View3D):PickingCollisionVO{
            var collector:EntityCollector = view.entityCollector;
            this._stage3DProxy = view.stage3DProxy;
            if (!(this._stage3DProxy)){
                return (null);
            };
            this._context = this._stage3DProxy._context3D;
            this._viewportData[0] = view.width;
            this._viewportData[1] = view.height;
            this._viewportData[2] = -((this._projX = (((2 * x) / view.width) - 1)));
            this._viewportData[3] = (this._projY = (((2 * y) / view.height) - 1));
            this._potentialFound = false;
            this.draw(collector, null);
            this._stage3DProxy.setSimpleVertexBuffer(0, null, null, 0);
            if (((!(this._context)) || (!(this._potentialFound)))){
                return (null);
            };
            this._context.drawToBitmapData(this._bitmapData);
            this._hitColor = this._bitmapData.getPixel(0, 0);
            if (!(this._hitColor)){
                this._context.present();
                return (null);
            };
            this._hitRenderable = this._interactives[(this._hitColor - 1)];
            var _collisionVO:PickingCollisionVO = this._hitRenderable.sourceEntity.pickingCollisionVO;
            if (this._hitRenderable.shaderPickingDetails){
                this.getHitDetails(view.camera);
                _collisionVO.localPosition = this._localHitPosition;
                _collisionVO.localNormal = this._localHitNormal;
                _collisionVO.uv = this._hitUV;
            } else {
                _collisionVO.localPosition = null;
                _collisionVO.localNormal = null;
                _collisionVO.uv = null;
            };
            return (_collisionVO);
        }
        public function getSceneCollision(position:Vector3D, direction:Vector3D, scene:Scene3D):PickingCollisionVO{
            return (null);
        }
        protected function draw(entityCollector:EntityCollector, target:TextureBase):void{
            var camera:Camera3D = entityCollector.camera;
            this._context.clear(0, 0, 0, 1);
            this._stage3DProxy.scissorRect = MOUSE_SCISSOR_RECT;
            this._interactives.length = (this._interactiveId = 0);
            if (!(this._objectProgram3D)){
                this.initObjectProgram3D();
            };
            this._context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
            this._context.setDepthTest(true, Context3DCompareMode.LESS);
            this._stage3DProxy.setProgram(this._objectProgram3D);
            this._context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, this._viewportData, 1);
            this.drawRenderables(entityCollector.opaqueRenderableHead, camera);
            this.drawRenderables(entityCollector.blendedRenderableHead, camera);
        }
        private function drawRenderables(item:RenderableListItem, camera:Camera3D):void{
            var renderable:IRenderable;
            while (item) {
                renderable = item.renderable;
                if (((!(renderable.sourceEntity.scene)) || (!(renderable.mouseEnabled)))){
                    item = item.next;
                } else {
                    this._potentialFound = true;
                    this._context.setCulling(((renderable.material.bothSides) ? Context3DTriangleFace.NONE : Context3DTriangleFace.BACK));
                    var _local4 = this._interactiveId++;
                    this._interactives[_local4] = renderable;
                    this._id[1] = ((this._interactiveId >> 8) / 0xFF);
                    this._id[2] = ((this._interactiveId & 0xFF) / 0xFF);
                    this._context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, renderable.modelViewProjection, true);
                    this._context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, this._id, 1);
                    this._stage3DProxy.setSimpleVertexBuffer(0, renderable.getVertexBuffer(this._stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, 0);
                    this._context.drawTriangles(renderable.getIndexBuffer(this._stage3DProxy), 0, renderable.numTriangles);
                    item = item.next;
                };
            };
        }
        private function updateRay(camera:Camera3D):void{
            this._rayPos = camera.scenePosition;
            this._rayDir = camera.getRay(this._projX, this._projY);
            this._rayDir.normalize();
        }
        private function initObjectProgram3D():void{
            var vertexCode:String;
            var fragmentCode:String;
            this._objectProgram3D = this._context.createProgram();
            vertexCode = (((("m44 vt0, va0, vc0\t\t\t\n" + "mul vt1.xy, vt0.w, vc4.zw\t\n") + "add vt0.xy, vt0.xy, vt1.xy\t\n") + "mul vt0.xy, vt0.xy, vc4.xy\t\n") + "mov op, vt0\t\n");
            fragmentCode = "mov oc, fc0";
            this._objectProgram3D.upload(new AGALMiniAssembler().assemble(Context3DProgramType.VERTEX, vertexCode), new AGALMiniAssembler().assemble(Context3DProgramType.FRAGMENT, fragmentCode));
        }
        private function initTriangleProgram3D():void{
            var vertexCode:String;
            var fragmentCode:String;
            this._triangleProgram3D = this._context.createProgram();
            vertexCode = ((((((("add vt0, va0, vc5 \t\t\t\n" + "mul vt0, vt0, vc6 \t\t\t\n") + "mov v0, vt0\t\t\t\t\n") + "m44 vt0, va0, vc0\t\t\t\n") + "mul vt1.xy, vt0.w, vc4.zw\t\n") + "add vt0.xy, vt0.xy, vt1.xy\t\n") + "mul vt0.xy, vt0.xy, vc4.xy\t\n") + "mov op, vt0\t\n");
            fragmentCode = "mov oc, v0";
            this._triangleProgram3D.upload(new AGALMiniAssembler().assemble(Context3DProgramType.VERTEX, vertexCode), new AGALMiniAssembler().assemble(Context3DProgramType.FRAGMENT, fragmentCode));
        }
        private function getHitDetails(camera:Camera3D):void{
            this.getApproximatePosition(camera);
            this.getPreciseDetails(camera);
        }
        private function getApproximatePosition(camera:Camera3D):void{
            var col:uint;
            var scX:Number;
            var scY:Number;
            var scZ:Number;
            var offsX:Number;
            var offsY:Number;
            var offsZ:Number;
            var entity:Entity = this._hitRenderable.sourceEntity;
            var localViewProjection:Matrix3D = this._hitRenderable.modelViewProjection;
            if (!(this._triangleProgram3D)){
                this.initTriangleProgram3D();
            };
            scX = (1 / (entity.maxX - entity.minX));
            this._boundOffsetScale[4] = scX;
            scY = (1 / (entity.maxY - entity.minY));
            this._boundOffsetScale[5] = scY;
            scZ = (1 / (entity.maxZ - entity.minZ));
            this._boundOffsetScale[6] = scZ;
            offsX = -(entity.minX);
            this._boundOffsetScale[0] = offsX;
            offsY = -(entity.minY);
            this._boundOffsetScale[1] = offsY;
            offsZ = -(entity.minZ);
            this._boundOffsetScale[2] = offsZ;
            this._stage3DProxy.setProgram(this._triangleProgram3D);
            this._context.clear(0, 0, 0, 0, 1, 0, Context3DClearMask.DEPTH);
            this._context.setScissorRectangle(MOUSE_SCISSOR_RECT);
            this._context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, localViewProjection, true);
            this._context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 5, this._boundOffsetScale, 2);
            this._stage3DProxy.setSimpleVertexBuffer(0, this._hitRenderable.getVertexBuffer(this._stage3DProxy), Context3DVertexBufferFormat.FLOAT_3, 0);
            this._context.drawTriangles(this._hitRenderable.getIndexBuffer(this._stage3DProxy), 0, this._hitRenderable.numTriangles);
            this._context.drawToBitmapData(this._bitmapData);
            col = this._bitmapData.getPixel(0, 0);
            this._localHitPosition.x = ((((col >> 16) & 0xFF) / (scX * 0xFF)) - offsX);
            this._localHitPosition.y = ((((col >> 8) & 0xFF) / (scY * 0xFF)) - offsY);
            this._localHitPosition.z = (((col & 0xFF) / (scZ * 0xFF)) - offsZ);
        }
        private function getPreciseDetails(camera:Camera3D):void{
            var x1:Number;
            var y1:Number;
            var z1:Number;
            var x2:Number;
            var y2:Number;
            var z2:Number;
            var x3:Number;
            var y3:Number;
            var z3:Number;
            var t1:uint;
            var t2:uint;
            var t3:uint;
            var v0x:Number;
            var v0y:Number;
            var v0z:Number;
            var v1x:Number;
            var v1y:Number;
            var v1z:Number;
            var v2x:Number;
            var v2y:Number;
            var v2z:Number;
            var dot00:Number;
            var dot01:Number;
            var dot02:Number;
            var dot11:Number;
            var dot12:Number;
            var s:Number;
            var t:Number;
            var invDenom:Number;
            var u:Number;
            var v:Number;
            var ui1:uint;
            var ui2:uint;
            var ui3:uint;
            var s0x:Number;
            var s0y:Number;
            var s0z:Number;
            var s1x:Number;
            var s1y:Number;
            var s1z:Number;
            var nl:Number;
            var subGeom:SubGeometry = SubMesh(this._hitRenderable).subGeometry;
            var indices:Vector.<uint> = subGeom.indexData;
            var vertices:Vector.<Number> = subGeom.vertexData;
            var len:int = indices.length;
            var i:uint;
            var j:uint = 1;
            var k:uint = 2;
            var uvs:Vector.<Number> = subGeom.UVData;
            var normals:Vector.<Number> = subGeom.faceNormalsData;
            var x:Number = this._localHitPosition.x;
            var y:Number = this._localHitPosition.y;
            var z:Number = this._localHitPosition.z;
            this.updateRay(camera);
            while (i < len) {
                t1 = (indices[i] * 3);
                t2 = (indices[j] * 3);
                t3 = (indices[k] * 3);
                x1 = vertices[t1];
                y1 = vertices[(t1 + 1)];
                z1 = vertices[(t1 + 2)];
                x2 = vertices[t2];
                y2 = vertices[(t2 + 1)];
                z2 = vertices[(t2 + 2)];
                x3 = vertices[t3];
                y3 = vertices[(t3 + 1)];
                z3 = vertices[(t3 + 2)];
                if (!((((((((((((((((x < x1)) && ((x < x2)))) && ((x < x3)))) || ((((((y < y1)) && ((y < y2)))) && ((y < y3)))))) || ((((((z < z1)) && ((z < z2)))) && ((z < z3)))))) || ((((((x > x1)) && ((x > x2)))) && ((x > x3)))))) || ((((((y > y1)) && ((y > y2)))) && ((y > y3)))))) || ((((((z > z1)) && ((z > z2)))) && ((z > z3))))))){
                    v0x = (x3 - x1);
                    v0y = (y3 - y1);
                    v0z = (z3 - z1);
                    v1x = (x2 - x1);
                    v1y = (y2 - y1);
                    v1z = (z2 - z1);
                    v2x = (x - x1);
                    v2y = (y - y1);
                    v2z = (z - z1);
                    dot00 = (((v0x * v0x) + (v0y * v0y)) + (v0z * v0z));
                    dot01 = (((v0x * v1x) + (v0y * v1y)) + (v0z * v1z));
                    dot02 = (((v0x * v2x) + (v0y * v2y)) + (v0z * v2z));
                    dot11 = (((v1x * v1x) + (v1y * v1y)) + (v1z * v1z));
                    dot12 = (((v1x * v2x) + (v1y * v2y)) + (v1z * v2z));
                    invDenom = (1 / ((dot00 * dot11) - (dot01 * dot01)));
                    s = (((dot11 * dot02) - (dot01 * dot12)) * invDenom);
                    t = (((dot00 * dot12) - (dot01 * dot02)) * invDenom);
                    if ((((((s >= 0)) && ((t >= 0)))) && (((s + t) <= 1)))){
                        this.getPrecisePosition(this._hitRenderable.inverseSceneTransform, normals[i], normals[(i + 1)], normals[(i + 2)], x1, y1, z1);
                        v2x = (this._localHitPosition.x - x1);
                        v2y = (this._localHitPosition.y - y1);
                        v2z = (this._localHitPosition.z - z1);
                        s0x = (x2 - x1);
                        s0y = (y2 - y1);
                        s0z = (z2 - z1);
                        s1x = (x3 - x1);
                        s1y = (y3 - y1);
                        s1z = (z3 - z1);
                        this._localHitNormal.x = ((s0y * s1z) - (s0z * s1y));
                        this._localHitNormal.y = ((s0z * s1x) - (s0x * s1z));
                        this._localHitNormal.z = ((s0x * s1y) - (s0y * s1x));
                        nl = (1 / Math.sqrt((((this._localHitNormal.x * this._localHitNormal.x) + (this._localHitNormal.y * this._localHitNormal.y)) + (this._localHitNormal.z * this._localHitNormal.z))));
                        this._localHitNormal.x = (this._localHitNormal.x * nl);
                        this._localHitNormal.y = (this._localHitNormal.y * nl);
                        this._localHitNormal.z = (this._localHitNormal.z * nl);
                        dot02 = (((v0x * v2x) + (v0y * v2y)) + (v0z * v2z));
                        dot12 = (((v1x * v2x) + (v1y * v2y)) + (v1z * v2z));
                        s = (((dot11 * dot02) - (dot01 * dot12)) * invDenom);
                        t = (((dot00 * dot12) - (dot01 * dot02)) * invDenom);
                        ui1 = (indices[i] << 1);
                        ui2 = (indices[j] << 1);
                        ui3 = (indices[k] << 1);
                        u = uvs[ui1];
                        v = uvs[(ui1 + 1)];
                        this._hitUV.x = ((u + (t * (uvs[ui2] - u))) + (s * (uvs[ui3] - u)));
                        this._hitUV.y = ((v + (t * (uvs[(ui2 + 1)] - v))) + (s * (uvs[(ui3 + 1)] - v)));
                        return;
                    };
                };
                i = (i + 3);
                j = (j + 3);
                k = (k + 3);
            };
        }
        private function getPrecisePosition(invSceneTransform:Matrix3D, nx:Number, ny:Number, nz:Number, px:Number, py:Number, pz:Number):void{
            var rx:Number;
            var ry:Number;
            var rz:Number;
            var ox:Number;
            var oy:Number;
            var oz:Number;
            var t:Number;
            var raw:Vector.<Number> = Matrix3DUtils.RAW_DATA_CONTAINER;
            var cx:Number = this._rayPos.x;
            var cy:Number = this._rayPos.y;
            var cz:Number = this._rayPos.z;
            ox = this._rayDir.x;
            oy = this._rayDir.y;
            oz = this._rayDir.z;
            invSceneTransform.copyRawDataTo(raw);
            rx = (((raw[0] * ox) + (raw[4] * oy)) + (raw[8] * oz));
            ry = (((raw[1] * ox) + (raw[5] * oy)) + (raw[9] * oz));
            rz = (((raw[2] * ox) + (raw[6] * oy)) + (raw[10] * oz));
            ox = ((((raw[0] * cx) + (raw[4] * cy)) + (raw[8] * cz)) + raw[12]);
            oy = ((((raw[1] * cx) + (raw[5] * cy)) + (raw[9] * cz)) + raw[13]);
            oz = ((((raw[2] * cx) + (raw[6] * cy)) + (raw[10] * cz)) + raw[14]);
            t = (((((px - ox) * nx) + ((py - oy) * ny)) + ((pz - oz) * nz)) / (((rx * nx) + (ry * ny)) + (rz * nz)));
            this._localHitPosition.x = (ox + (rx * t));
            this._localHitPosition.y = (oy + (ry * t));
            this._localHitPosition.z = (oz + (rz * t));
        }

    }
}//package away3d.core.pick 
