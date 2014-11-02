package away3d.extrusions {
    import __AS3__.vec.*;
    import away3d.core.base.*;
    import away3d.materials.*;
    import flash.geom.*;
    import away3d.materials.utils.*;
    import away3d.tools.helpers.*;
    import away3d.bounds.*;
    import away3d.core.base.data.*;
    import away3d.entities.*;

    public class LatheExtrude extends Mesh {

        public static const X_AXIS:String = "x";
        public static const Y_AXIS:String = "y";
        public static const Z_AXIS:String = "z";

        private const EPS:Number = 0.0001;
        private const LIMIT:uint = 196605;
        private const MAXRAD:Number = 1.2;

        private var _profile:Vector.<Vector3D>;
        private var _lastProfile:Vector.<Vector3D>;
        private var _keepLastProfile:Boolean;
        private var _axis:String;
        private var _revolutions:Number;
        private var _subdivision:uint;
        private var _offsetRadius:Number;
        private var _materials:MultipleMaterials;
        private var _coverAll:Boolean;
        private var _flip:Boolean;
        private var _centerMesh:Boolean;
        private var _thickness:Number;
        private var _preciseThickness:Boolean;
        private var _ignoreSides:String;
        private var _smoothSurface:Boolean;
        private var _tweek:Object;
        private var _varr:Vector.<Vector3D>;
        private var _varr2:Vector.<Vector3D>;
        private var _uvarr:Vector.<UV>;
        private var _startRotationOffset:Number = 0;
        private var _geomDirty:Boolean = true;
        private var _subGeometry:SubGeometry;
        private var _MaterialsSubGeometries:Vector.<SubGeometryList>;
        private var _maxIndProfile:uint;
        private var _uva:UV;
        private var _uvb:UV;
        private var _uvc:UV;
        private var _uvd:UV;
        private var _va:Vector3D;
        private var _vb:Vector3D;
        private var _vc:Vector3D;
        private var _vd:Vector3D;
        private var _uvs:Vector.<Number>;
        private var _vertices:Vector.<Number>;
        private var _indices:Vector.<uint>;
        private var _normals:Vector.<Number>;
        private var _normalTmp:Vector3D;
        private var _normal0:Vector3D;
        private var _normal1:Vector3D;
        private var _normal2:Vector3D;

        public function LatheExtrude(material:MaterialBase=null, profile:Vector.<Vector3D>=null, axis:String="y", revolutions:Number=1, subdivision:uint=10, coverall:Boolean=true, centerMesh:Boolean=false, flip:Boolean=false, thickness:Number=0, preciseThickness:Boolean=true, offsetRadius:Number=0, materials:MultipleMaterials=null, ignoreSides:String="", tweek:Object=null, smoothSurface:Boolean=true){
            this._MaterialsSubGeometries = new Vector.<SubGeometryList>();
            var geom:Geometry = new Geometry();
            this._subGeometry = new SubGeometry();
            if (((((!(material)) && (materials))) && (materials.front))){
                material = materials.front;
            };
            super(geom, material);
            this._profile = profile;
            this._axis = axis;
            this._revolutions = revolutions;
            this._subdivision = ((subdivision)<3) ? 3 : subdivision;
            this._offsetRadius = offsetRadius;
            this._materials = materials;
            this._coverAll = coverall;
            this._flip = flip;
            this._centerMesh = centerMesh;
            this._thickness = Math.abs(thickness);
            this._preciseThickness = preciseThickness;
            this._ignoreSides = ignoreSides;
            this._tweek = tweek;
            this._smoothSurface = smoothSurface;
        }
        public function get profile():Vector.<Vector3D>{
            return (this._profile);
        }
        public function set profile(val:Vector.<Vector3D>):void{
            if (val.length > 1){
                this._profile = val;
                this.invalidateGeometry();
            } else {
                throw (new Error("LatheExtrude error: the profile Vector.<Vector3D> must hold a mimimun of 2 vector3D's"));
            };
        }
        public function get startRotationOffset():Number{
            return (this._startRotationOffset);
        }
        public function set startRotationOffset(val:Number):void{
            this._startRotationOffset = val;
        }
        public function get axis():String{
            return (this._axis);
        }
        public function set axis(val:String):void{
            if (this._axis == val){
                return;
            };
            this._axis = val;
            this.invalidateGeometry();
        }
        public function get revolutions():Number{
            return (this._revolutions);
        }
        public function set revolutions(val:Number):void{
            if (this._revolutions == val){
                return;
            };
            this._revolutions = ((this._revolutions)>0.001) ? this._revolutions : 0.001;
            this._revolutions = val;
            this.invalidateGeometry();
        }
        public function get subdivision():uint{
            return (this._subdivision);
        }
        public function set subdivision(val:uint):void{
            val = ((val)<3) ? 3 : val;
            if (this._subdivision == val){
                return;
            };
            this._subdivision = val;
            this.invalidateGeometry();
        }
        public function get offsetRadius():Number{
            return (this._offsetRadius);
        }
        public function set offsetRadius(val:Number):void{
            if (this._offsetRadius == val){
                return;
            };
            this._offsetRadius = val;
            this.invalidateGeometry();
        }
        public function get materials():MultipleMaterials{
            return (this._materials);
        }
        public function set materials(val:MultipleMaterials):void{
            this._materials = val;
            if (((this._materials.front) && (!((this.material == this._materials.front))))){
                this.material = this._materials.front;
            };
            this.invalidateGeometry();
        }
        public function get coverAll():Boolean{
            return (this._coverAll);
        }
        public function set coverAll(val:Boolean):void{
            if (this._coverAll == val){
                return;
            };
            this._coverAll = val;
            this.invalidateGeometry();
        }
        public function get flip():Boolean{
            return (this._flip);
        }
        public function set flip(val:Boolean):void{
            if (this._flip == val){
                return;
            };
            this._flip = val;
            this.invalidateGeometry();
        }
        public function get smoothSurface():Boolean{
            return (this._smoothSurface);
        }
        public function set smoothSurface(val:Boolean):void{
            if (this._smoothSurface == val){
                return;
            };
            this._smoothSurface = val;
            this._geomDirty = true;
        }
        public function get keepLastProfile():Boolean{
            return (this._keepLastProfile);
        }
        public function set keepLastProfile(val:Boolean):void{
            if (this._keepLastProfile == val){
                return;
            };
            this._keepLastProfile = val;
        }
        public function get lastProfile():Vector.<Vector3D>{
            if (((this.keepLastProfile) && (!(this._lastProfile)))){
                this.buildExtrude();
            };
            return (this._lastProfile);
        }
        public function get preciseThickness():Boolean{
            return (this._preciseThickness);
        }
        public function set preciseThickness(val:Boolean):void{
            if (this._preciseThickness == val){
                return;
            };
            this._preciseThickness = val;
            this.invalidateGeometry();
        }
        public function get centerMesh():Boolean{
            return (this._centerMesh);
        }
        public function set centerMesh(val:Boolean):void{
            if (this._centerMesh == val){
                return;
            };
            this._centerMesh = val;
            if (((this._centerMesh) && ((this._subGeometry.vertexData.length > 0)))){
                MeshHelper.recenter(this);
            } else {
                this.invalidateGeometry();
            };
        }
        public function get thickness():Number{
            return (this._thickness);
        }
        public function set thickness(val:Number):void{
            if (this._thickness == val){
                return;
            };
            this._thickness = ((val)>0) ? val : this._thickness;
            this.invalidateGeometry();
        }
        public function get ignoreSides():String{
            return (this._ignoreSides);
        }
        public function set ignoreSides(val:String):void{
            this._ignoreSides = val;
            this.invalidateGeometry();
        }
        public function get tweek():Object{
            return (this._tweek);
        }
        public function set tweek(val:Object):void{
            this._tweek = val;
            this.invalidateGeometry();
        }
        override public function get bounds():BoundingVolumeBase{
            if (this._geomDirty){
                this.buildExtrude();
            };
            return (super.bounds);
        }
        override public function get geometry():Geometry{
            if (this._geomDirty){
                this.buildExtrude();
            };
            return (super.geometry);
        }
        override public function get subMeshes():Vector.<SubMesh>{
            if (this._geomDirty){
                this.buildExtrude();
            };
            return (super.subMeshes);
        }
        private function closeTopBottom(ptLength:int, renderSide:RenderSide):void{
            var va:Vector3D;
            var vb:Vector3D;
            var vc:Vector3D;
            var vd:Vector3D;
            var i:uint;
            var j:uint;
            var a:Number;
            var b:Number;
            var total:uint = (this._varr.length - ptLength);
            this._uva.u = (this._uvb.u = 0);
            this._uvc.u = (this._uvd.u = 1);
            i = 0;
            while (i < total) {
                if (i != 0){
                    if (this._coverAll){
                        a = (i / total);
                        b = ((i + ptLength) / total);
                        this._uva.v = a;
                        this._uvb.v = b;
                        this._uvc.v = b;
                        this._uvd.v = a;
                    } else {
                        this._uva.v = 0;
                        this._uvb.v = 1;
                        this._uvc.v = 1;
                        this._uvd.v = 0;
                    };
                    if (renderSide.top){
                        va = this._varr[i];
                        vb = this._varr[(i + ptLength)];
                        vc = this._varr2[(i + ptLength)];
                        vd = this._varr2[i];
                        if (this._flip){
                            this.addFace(vb, va, vc, this._uvb, this._uva, this._uvc, 4);
                            this.addFace(vc, va, vd, this._uvc, this._uva, this._uvd, 4);
                        } else {
                            this.addFace(va, vb, vc, this._uva, this._uvb, this._uvc, 4);
                            this.addFace(va, vc, vd, this._uva, this._uvc, this._uvd, 4);
                        };
                    };
                    if (renderSide.bottom){
                        j = ((i + ptLength) - 1);
                        va = this._varr[j];
                        vb = this._varr[(j + ptLength)];
                        vc = this._varr2[(j + ptLength)];
                        vd = this._varr2[j];
                        if (this._flip){
                            this.addFace(va, vb, vc, this._uva, this._uvb, this._uvc, 5);
                            this.addFace(va, vc, vd, this._uva, this._uvc, this._uvd, 5);
                        } else {
                            this.addFace(vb, va, vc, this._uvb, this._uva, this._uvc, 5);
                            this.addFace(vc, va, vd, this._uvc, this._uva, this._uvd, 5);
                        };
                    };
                };
                i = (i + ptLength);
            };
        }
        private function closeSides(ptLength:uint, renderSide:RenderSide):void{
            var va:Vector3D;
            var vb:Vector3D;
            var vc:Vector3D;
            var vd:Vector3D;
            var i:uint;
            var j:uint;
            var a:Number;
            var b:Number;
            var total:uint = (this._varr.length - ptLength);
            var iter:int = (ptLength - 1);
            var step:Number = ((((this._preciseThickness) && (((ptLength % 2) == 0)))) ? (1 / iter) : (1 / ptLength));
            i = 0;
            while (i < iter) {
                if (this._coverAll){
                    a = (i * step);
                    b = (a + step);
                    this._uva.v = (1 - a);
                    this._uvb.v = (1 - b);
                    this._uvc.v = (1 - b);
                    this._uvd.v = (1 - a);
                } else {
                    this._uva.v = 0;
                    this._uvb.v = 1;
                    this._uvc.v = 1;
                    this._uvd.v = 0;
                };
                if (renderSide.left){
                    va = this._varr[(i + 1)];
                    vb = this._varr[i];
                    vc = this._varr2[i];
                    vd = this._varr2[(i + 1)];
                    this._uva.u = (this._uvb.u = 0);
                    this._uvc.u = (this._uvd.u = 1);
                    if (this._flip){
                        this.addFace(vb, va, vc, this._uvb, this._uva, this._uvc, 2);
                        this.addFace(vc, va, vd, this._uvc, this._uva, this._uvd, 2);
                    } else {
                        this.addFace(va, vb, vc, this._uva, this._uvb, this._uvc, 2);
                        this.addFace(va, vc, vd, this._uva, this._uvc, this._uvd, 2);
                    };
                };
                if (renderSide.right){
                    j = (total + i);
                    va = this._varr[(j + 1)];
                    vb = this._varr[j];
                    vc = this._varr2[j];
                    vd = this._varr2[(j + 1)];
                    this._uva.u = (this._uvb.u = 1);
                    this._uvc.u = (this._uvd.u = 0);
                    if (this._flip){
                        this.addFace(va, vb, vc, this._uva, this._uvb, this._uvc, 3);
                        this.addFace(va, vc, vd, this._uva, this._uvc, this._uvd, 3);
                    } else {
                        this.addFace(vb, va, vc, this._uvb, this._uva, this._uvc, 3);
                        this.addFace(vc, va, vd, this._uvc, this._uva, this._uvd, 3);
                    };
                };
                i++;
            };
        }
        private function generate(vectors:Vector.<Vector3D>, axis:String, tweek:Object, render:Boolean=true, id:uint=0):void{
            var j:uint;
            var tmpVecs:Vector.<Vector3D>;
            var uvu:Number;
            var uvv:Number;
            var i:uint;
            var index:int;
            var inc:int;
            var loop:int;
            var va:Vector3D;
            var vb:Vector3D;
            var vc:Vector3D;
            var vd:Vector3D;
            var uva:UV;
            var uvb:UV;
            var uvc:UV;
            var uvd:UV;
            var uvind:uint;
            var vind:uint;
            var iter:int;
            if (!(tweek)){
                tweek = {};
            };
            if (((isNaN(tweek[X_AXIS])) || (!(tweek[X_AXIS])))){
                tweek[X_AXIS] = 0;
            };
            if (((isNaN(tweek[Y_AXIS])) || (!(tweek[Y_AXIS])))){
                tweek[Y_AXIS] = 0;
            };
            if (((isNaN(tweek[Z_AXIS])) || (!(tweek[Z_AXIS])))){
                tweek[Z_AXIS] = 0;
            };
            if (((isNaN(tweek["radius"])) || (!(tweek["radius"])))){
                tweek["radius"] = 0;
            };
            var angle:Number = this._startRotationOffset;
            var step:Number = (360 / this._subdivision);
            var tweekX:Number = 0;
            var tweekY:Number = 0;
            var tweekZ:Number = 0;
            var tweekradius:Number = 0;
            var tweekrotation:Number = 0;
            var aRads:Array = [];
            if (!(this._varr)){
                this._varr = new Vector.<Vector3D>();
            };
            i = 0;
            while (i < vectors.length) {
                this._varr.push(new Vector3D(vectors[i].x, vectors[i].y, vectors[i].z));
                this._uvarr.push(new UV(0, (1 % i)));
                i++;
            };
            var offsetradius:Number = -(this._offsetRadius);
            var factor:Number = 0;
            var stepm:Number = (360 * this._revolutions);
            var lsub:Number = ((this._revolutions)<1) ? this._subdivision : (this._subdivision * this._revolutions);
            if (this._revolutions < 1){
                step = (step * this._revolutions);
            };
            i = 0;
            while (i <= lsub) {
                tmpVecs = new Vector.<Vector3D>();
                tmpVecs = vectors.concat();
                j = 0;
                while (j < tmpVecs.length) {
                    factor = ((this._revolutions - 1) / (this._varr.length + 1));
                    if (tweek[X_AXIS] != 0){
                        tweekX = (tweekX + ((tweek[X_AXIS] * factor) / this._revolutions));
                    };
                    if (tweek[Y_AXIS] != 0){
                        tweekY = (tweekY + ((tweek[Y_AXIS] * factor) / this._revolutions));
                    };
                    if (tweek[Z_AXIS] != 0){
                        tweekZ = (tweekZ + ((tweek[Z_AXIS] * factor) / this._revolutions));
                    };
                    if (tweek.radius != 0){
                        tweekradius = (tweekradius + (tweek.radius / (this._varr.length + 1)));
                    };
                    if (tweek.rotation != 0){
                        tweekrotation = (tweekrotation + (360 / (tweek.rotation * this._subdivision)));
                    };
                    if (this._axis == X_AXIS){
                        if (i == 0){
                            aRads[j] = (offsetradius - Math.abs(tmpVecs[j].z));
                        };
                        tmpVecs[j].z = (Math.cos(((-(angle) / 180) * Math.PI)) * (aRads[j] + tweekradius));
                        tmpVecs[j].y = (Math.sin(((angle / 180) * Math.PI)) * (aRads[j] + tweekradius));
                        if (i == 0){
                            this._varr[j].z = (this._varr[j].z + tmpVecs[j].z);
                            this._varr[j].y = (this._varr[j].y + tmpVecs[j].y);
                        };
                    } else {
                        if (this._axis == Y_AXIS){
                            if (i == 0){
                                aRads[j] = (offsetradius - Math.abs(tmpVecs[j].x));
                            };
                            tmpVecs[j].x = (Math.cos(((-(angle) / 180) * Math.PI)) * (aRads[j] + tweekradius));
                            tmpVecs[j].z = (Math.sin(((angle / 180) * Math.PI)) * (aRads[j] + tweekradius));
                            if (i == 0){
                                this._varr[j].x = tmpVecs[j].x;
                                this._varr[j].z = tmpVecs[j].z;
                            };
                        } else {
                            if (i == 0){
                                aRads[j] = (offsetradius - Math.abs(tmpVecs[j].y));
                            };
                            tmpVecs[j].x = (Math.cos(((-(angle) / 180) * Math.PI)) * (aRads[j] + tweekradius));
                            tmpVecs[j].y = (Math.sin(((angle / 180) * Math.PI)) * (aRads[j] + tweekradius));
                            if (i == 0){
                                this._varr[j].x = tmpVecs[j].x;
                                this._varr[j].y = tmpVecs[j].y;
                            };
                        };
                    };
                    tmpVecs[j].x = (tmpVecs[j].x + tweekX);
                    tmpVecs[j].y = (tmpVecs[j].y + tweekY);
                    tmpVecs[j].z = (tmpVecs[j].z + tweekZ);
                    this._varr.push(new Vector3D(tmpVecs[j].x, tmpVecs[j].y, tmpVecs[j].z));
                    if (this._coverAll){
                        uvu = (angle / stepm);
                    } else {
                        uvu = (((i % 2))==0) ? 0 : 1;
                    };
                    uvv = (j / (this._profile.length - 1));
                    this._uvarr.push(new UV(uvu, uvv));
                    j++;
                };
                angle = (angle + step);
                i++;
            };
            if (render){
                inc = vectors.length;
                loop = (this._varr.length - inc);
                iter = (inc - 1);
                i = 0;
                while (i < loop) {
                    index = 0;
                    j = 0;
                    while (j < iter) {
                        if (i > 0){
                            uvind = (i + index);
                            vind = uvind;
                            uva = this._uvarr[(uvind + 1)];
                            uvb = this._uvarr[uvind];
                            uvc = this._uvarr[(uvind + inc)];
                            uvd = this._uvarr[((uvind + inc) + 1)];
                            if ((((((this._revolutions == 1)) && (((i + inc) == loop)))) && ((this._tweek == null)))){
                                va = this._varr[(vind + 1)];
                                vb = this._varr[vind];
                                vc = this._varr[(vind + inc)];
                                vd = this._varr[((vind + inc) + 1)];
                            } else {
                                va = this._varr[(vind + 1)];
                                vb = this._varr[vind];
                                vc = this._varr[(vind + inc)];
                                vd = this._varr[((vind + inc) + 1)];
                            };
                            if (this._flip){
                                if (id == 1){
                                    this._uva.u = (1 - uva.u);
                                    this._uva.v = uva.v;
                                    this._uvb.u = (1 - uvb.u);
                                    this._uvb.v = uvb.v;
                                    this._uvc.u = (1 - uvc.u);
                                    this._uvc.v = uvc.v;
                                    this._uvd.u = (1 - uvd.u);
                                    this._uvd.v = uvd.v;
                                    this.addFace(va, vb, vc, this._uva, this._uvb, this._uvc, id);
                                    this.addFace(va, vc, vd, this._uva, this._uvc, this._uvd, id);
                                } else {
                                    this.addFace(vb, va, vc, uvb, uva, uvc, id);
                                    this.addFace(vc, va, vd, uvc, uva, uvd, id);
                                };
                            } else {
                                if (id == 1){
                                    this._uva.u = uva.u;
                                    this._uva.v = (1 - uva.v);
                                    this._uvb.u = uvb.u;
                                    this._uvb.v = (1 - uvb.v);
                                    this._uvc.u = uvc.u;
                                    this._uvc.v = (1 - uvc.v);
                                    this._uvd.u = uvd.u;
                                    this._uvd.v = (1 - uvd.v);
                                    this.addFace(vb, va, vc, this._uvb, this._uva, this._uvc, id);
                                    this.addFace(vc, va, vd, this._uvc, this._uva, this._uvd, id);
                                } else {
                                    this.addFace(va, vb, vc, uva, uvb, uvc, id);
                                    this.addFace(va, vc, vd, uva, uvc, uvd, id);
                                };
                            };
                        };
                        index++;
                        j++;
                    };
                    i = (i + inc);
                };
            };
        }
        private function buildExtrude():void{
            var i:uint;
            var aListsides:Array;
            var renderSide:RenderSide;
            var prop1:String;
            var prop2:String;
            var prop3:String;
            var lines:Array;
            var points:FourPoints;
            var vector:Vector3D;
            var vector2:Vector3D;
            var vector3:Vector3D;
            var vector4:Vector3D;
            var profileFront:Vector.<Vector3D>;
            var profileBack:Vector.<Vector3D>;
            var tmprofile1:Vector.<Vector3D>;
            var tmprofile2:Vector.<Vector3D>;
            var halft:Number;
            var val:Number;
            var sglist:SubGeometryList;
            var sg:SubGeometry;
            if (!(this._profile)){
                throw (new Error("LatheExtrude error: No profile Vector.<Vector3D> set"));
            };
            this._MaterialsSubGeometries = null;
            this._geomDirty = false;
            this.initHolders();
            this._maxIndProfile = (this._profile.length * 9);
            if (this._profile.length > 1){
                if (this._thickness != 0){
                    aListsides = ["top", "bottom", "right", "left", "front", "back"];
                    renderSide = new RenderSide();
                    i = 0;
                    while (i < aListsides.length) {
                        renderSide[aListsides[i]] = (this._ignoreSides.indexOf(aListsides[i]) == -1);
                        i++;
                    };
                    this._varr = new Vector.<Vector3D>();
                    this._varr2 = new Vector.<Vector3D>();
                    if (this._preciseThickness){
                        switch (this._axis){
                            case X_AXIS:
                                prop1 = X_AXIS;
                                prop2 = Z_AXIS;
                                prop3 = Y_AXIS;
                                break;
                            case Y_AXIS:
                                prop1 = Y_AXIS;
                                prop2 = X_AXIS;
                                prop3 = Z_AXIS;
                                break;
                            case Z_AXIS:
                                prop1 = Z_AXIS;
                                prop2 = Y_AXIS;
                                prop3 = X_AXIS;
                        };
                        lines = this.buildThicknessPoints(this._profile, this.thickness, prop1, prop2);
                        profileFront = new Vector.<Vector3D>();
                        profileBack = new Vector.<Vector3D>();
                        i = 0;
                        while (i < lines.length) {
                            points = lines[i];
                            vector = new Vector3D();
                            vector2 = new Vector3D();
                            if (i == 0){
                                vector[prop1] = points.pt2.x;
                                vector[prop2] = points.pt2.y;
                                vector[prop3] = this._profile[0][prop3];
                                profileFront.push(vector);
                                vector2[prop1] = points.pt1.x;
                                vector2[prop2] = points.pt1.y;
                                vector2[prop3] = this._profile[0][prop3];
                                profileBack.push(vector2);
                                if (lines.length == 1){
                                    vector3 = new Vector3D();
                                    vector4 = new Vector3D();
                                    vector3[prop1] = points.pt4.x;
                                    vector3[prop2] = points.pt4.y;
                                    vector3[prop3] = this._profile[0][prop3];
                                    profileFront.push(vector3);
                                    vector4[prop1] = points.pt3.x;
                                    vector4[prop2] = points.pt3.y;
                                    vector4[prop3] = this._profile[0][prop3];
                                    profileBack.push(vector4);
                                };
                            } else {
                                if (i == (lines.length - 1)){
                                    vector[prop1] = points.pt2.x;
                                    vector[prop2] = points.pt2.y;
                                    vector[prop3] = this._profile[i][prop3];
                                    profileFront.push(vector);
                                    vector2[prop1] = points.pt1.x;
                                    vector2[prop2] = points.pt1.y;
                                    vector2[prop3] = this._profile[i][prop3];
                                    profileBack.push(vector2);
                                    vector3 = new Vector3D();
                                    vector4 = new Vector3D();
                                    vector3[prop1] = points.pt4.x;
                                    vector3[prop2] = points.pt4.y;
                                    vector3[prop3] = this._profile[i][prop3];
                                    profileFront.push(vector3);
                                    vector4[prop1] = points.pt3.x;
                                    vector4[prop2] = points.pt3.y;
                                    vector4[prop3] = this._profile[i][prop3];
                                    profileBack.push(vector4);
                                } else {
                                    vector[prop1] = points.pt2.x;
                                    vector[prop2] = points.pt2.y;
                                    vector[prop3] = this._profile[i][prop3];
                                    profileFront.push(vector);
                                    vector2[prop1] = points.pt1.x;
                                    vector2[prop2] = points.pt1.y;
                                    vector2[prop3] = this._profile[i][prop3];
                                    profileBack.push(vector2);
                                };
                            };
                            i++;
                        };
                        this.generate(profileFront, this._axis, this._tweek, renderSide.front, 0);
                        this._varr2 = this._varr2.concat(this._varr);
                        this._varr = new Vector.<Vector3D>();
                        this.generate(profileBack, this._axis, this._tweek, renderSide.back, 1);
                    } else {
                        tmprofile1 = new Vector.<Vector3D>();
                        tmprofile2 = new Vector.<Vector3D>();
                        halft = (this._thickness * 0.5);
                        i = 0;
                        while (i < this._profile.length) {
                            switch (this._axis){
                                case X_AXIS:
                                    val = ((this._profile[i].z)<0) ? halft : -(halft);
                                    tmprofile1.push(new Vector3D(this._profile[i].x, this._profile[i].y, (this._profile[i].z - val)));
                                    tmprofile2.push(new Vector3D(this._profile[i].x, this._profile[i].y, (this._profile[i].z + val)));
                                    break;
                                case Y_AXIS:
                                    val = ((this._profile[i].x)<0) ? halft : -(halft);
                                    tmprofile1.push(new Vector3D((this._profile[i].x - val), this._profile[i].y, this._profile[i].z));
                                    tmprofile2.push(new Vector3D((this._profile[i].x + val), this._profile[i].y, this._profile[i].z));
                                    break;
                                case Z_AXIS:
                                    val = ((this._profile[i].y)<0) ? halft : -(halft);
                                    tmprofile1.push(new Vector3D(this._profile[i].x, (this._profile[i].y - val), this._profile[i].z));
                                    tmprofile2.push(new Vector3D(this._profile[i].x, (this._profile[i].y + val), this._profile[i].z));
                            };
                            i++;
                        };
                        this.generate(tmprofile1, this._axis, this._tweek, renderSide.front, 0);
                        this._varr2 = this._varr2.concat(this._varr);
                        this._varr = new Vector.<Vector3D>();
                        this.generate(tmprofile2, this._axis, this._tweek, renderSide.back, 1);
                    };
                    this.closeTopBottom(this._profile.length, renderSide);
                    if (this._revolutions != 1){
                        this.closeSides(this._profile.length, renderSide);
                    };
                } else {
                    this.generate(this._profile, this._axis, this._tweek);
                };
            } else {
                throw (new Error("LatheExtrude error: the profile Vector.<Vector3D> must hold a mimimun of 2 vector3D's"));
            };
            if (this._vertices.length > 0){
                this._subGeometry.updateVertexData(this._vertices);
                this._subGeometry.updateIndexData(this._indices);
                this._subGeometry.updateUVData(this._uvs);
                if (this._smoothSurface){
                    this._subGeometry.updateVertexNormalData(this._normals);
                };
                this.geometry.addSubGeometry(this._subGeometry);
            };
            if (((this._MaterialsSubGeometries) && ((this._MaterialsSubGeometries.length > 0)))){
                i = 1;
                while (i < 6) {
                    sglist = this._MaterialsSubGeometries[i];
                    sg = sglist.subGeometry;
                    if (((sg) && ((sglist.vertices.length > 0)))){
                        this.geometry.addSubGeometry(sg);
                        this.subMeshes[(this.subMeshes.length - 1)].material = sglist.material;
                        sg.updateVertexData(sglist.vertices);
                        sg.updateIndexData(sglist.indices);
                        sg.updateUVData(sglist.uvs);
                        if (this._smoothSurface){
                            sg.updateVertexNormalData(sglist.normals);
                        };
                    };
                    i++;
                };
            };
            if (this._keepLastProfile){
                this._lastProfile = this._varr.splice((this._varr.length - this._profile.length), this._profile.length);
            } else {
                this._lastProfile = null;
            };
            this._varr = (this._varr2 = null);
            this._uvarr = null;
            if (this._centerMesh){
                MeshHelper.recenter(this);
            };
        }
        private function calcNormal(v0:Vector3D, v1:Vector3D, v2:Vector3D):void{
            var dx1:Number = (v2.x - v0.x);
            var dy1:Number = (v2.y - v0.y);
            var dz1:Number = (v2.z - v0.z);
            var dx2:Number = (v1.x - v0.x);
            var dy2:Number = (v1.y - v0.y);
            var dz2:Number = (v1.z - v0.z);
            var cx:Number = ((dz1 * dy2) - (dy1 * dz2));
            var cy:Number = ((dx1 * dz2) - (dz1 * dx2));
            var cz:Number = ((dy1 * dx2) - (dx1 * dy2));
            var d:Number = (1 / Math.sqrt((((cx * cx) + (cy * cy)) + (cz * cz))));
            this._normal0.x = (this._normal1.x = (this._normal2.x = (cx * d)));
            this._normal0.y = (this._normal1.y = (this._normal2.y = (cy * d)));
            this._normal0.z = (this._normal1.z = (this._normal2.z = (cz * d)));
        }
        private function addFace(v0:Vector3D, v1:Vector3D, v2:Vector3D, uv0:UV, uv1:UV, uv2:UV, subGeomInd:uint):void{
            var subGeom:SubGeometry;
            var uvs:Vector.<Number>;
            var normals:Vector.<Number>;
            var vertices:Vector.<Number>;
            var indices:Vector.<uint>;
            var bv0:Boolean;
            var bv1:Boolean;
            var bv2:Boolean;
            var ind0:uint;
            var ind1:uint;
            var ind2:uint;
            var uvind:uint;
            var uvindV:uint;
            var vind:uint;
            var vindy:uint;
            var vindz:uint;
            var ind:uint;
            var indlength:uint;
            var ab:Number;
            var back:Number;
            var limitBack:uint;
            var i:uint;
            if ((((((subGeomInd > 0)) && (this._MaterialsSubGeometries))) && ((this._MaterialsSubGeometries.length > 0)))){
                subGeom = this._MaterialsSubGeometries[subGeomInd].subGeometry;
                uvs = this._MaterialsSubGeometries[subGeomInd].uvs;
                vertices = this._MaterialsSubGeometries[subGeomInd].vertices;
                indices = this._MaterialsSubGeometries[subGeomInd].indices;
                normals = this._MaterialsSubGeometries[subGeomInd].normals;
            } else {
                subGeom = this._subGeometry;
                uvs = this._uvs;
                vertices = this._vertices;
                indices = this._indices;
                normals = this._normals;
            };
            if ((vertices.length + 9) > this.LIMIT){
                subGeom.updateVertexData(vertices);
                subGeom.updateIndexData(indices);
                subGeom.updateUVData(uvs);
                if (this._smoothSurface){
                    subGeom.updateVertexNormalData(normals);
                };
                this.geometry.addSubGeometry(subGeom);
                if ((((((subGeomInd > 0)) && (this._MaterialsSubGeometries))) && (this._MaterialsSubGeometries[subGeomInd].subGeometry))){
                    this.subMeshes[(this.subMeshes.length - 1)].material = this._MaterialsSubGeometries[subGeomInd].material;
                };
                subGeom = new SubGeometry();
                subGeom.autoDeriveVertexTangents = true;
                if (((this._MaterialsSubGeometries) && ((this._MaterialsSubGeometries.length > 0)))){
                    this._MaterialsSubGeometries[subGeomInd].subGeometry = subGeom;
                    uvs = new Vector.<Number>();
                    vertices = new Vector.<Number>();
                    indices = new Vector.<uint>();
                    normals = new Vector.<Number>();
                    this._MaterialsSubGeometries[subGeomInd].uvs = uvs;
                    this._MaterialsSubGeometries[subGeomInd].indices = indices;
                    if (this._smoothSurface){
                        this._MaterialsSubGeometries[subGeomInd].normals = normals;
                    } else {
                        subGeom.autoDeriveVertexNormals = true;
                    };
                    if (subGeomInd == 0){
                        this._subGeometry = subGeom;
                        this._uvs = uvs;
                        this._vertices = vertices;
                        this._indices = indices;
                        this._normals = normals;
                    };
                } else {
                    this._subGeometry = subGeom;
                    this._uvs = new Vector.<Number>();
                    this._vertices = new Vector.<Number>();
                    this._indices = new Vector.<uint>();
                    this._normals = new Vector.<Number>();
                    uvs = this._uvs;
                    vertices = this._vertices;
                    indices = this._indices;
                    normals = this._normals;
                };
            };
            if (this._smoothSurface){
                indlength = indices.length;
                this.calcNormal(v0, v1, v2);
                if (indlength > 0){
                    back = (indlength - this._maxIndProfile);
                    limitBack = ((back)<0) ? 0 : back;
                    i = (indlength - 1);
                    for (;i > limitBack;i--) {
                        ind = indices[i];
                        vind = (ind * 3);
                        vindy = (vind + 1);
                        vindz = (vind + 2);
                        uvind = (ind * 2);
                        uvindV = (uvind + 1);
                        if (((((bv0) && (bv1))) && (bv2))){
                            break;
                        };
                        if (((((((!(bv0)) && ((vertices[vind] == v0.x)))) && ((vertices[vindy] == v0.y)))) && ((vertices[vindz] == v0.z)))){
                            this._normalTmp.x = normals[vind];
                            this._normalTmp.y = normals[vindy];
                            this._normalTmp.z = normals[vindz];
                            ab = Vector3D.angleBetween(this._normalTmp, this._normal0);
                            if (ab < this.MAXRAD){
                                this._normal0.x = ((this._normalTmp.x + this._normal0.x) * 0.5);
                                this._normal0.y = ((this._normalTmp.y + this._normal0.y) * 0.5);
                                this._normal0.z = ((this._normalTmp.z + this._normal0.z) * 0.5);
                                if ((((uvs[uvind] == uv0.u)) && ((uvs[uvindV] == uv0.v)))){
                                    bv0 = true;
                                    ind0 = ind;
                                    continue;
                                };
                            };
                        };
                        if (((((((!(bv1)) && ((vertices[vind] == v1.x)))) && ((vertices[vindy] == v1.y)))) && ((vertices[vindz] == v1.z)))){
                            this._normalTmp.x = normals[vind];
                            this._normalTmp.y = normals[vindy];
                            this._normalTmp.z = normals[vindz];
                            ab = Vector3D.angleBetween(this._normalTmp, this._normal1);
                            if (ab < this.MAXRAD){
                                this._normal1.x = ((this._normalTmp.x + this._normal1.x) * 0.5);
                                this._normal1.y = ((this._normalTmp.y + this._normal1.y) * 0.5);
                                this._normal1.z = ((this._normalTmp.z + this._normal1.z) * 0.5);
                                if ((((uvs[uvind] == uv1.u)) && ((uvs[uvindV] == uv1.v)))){
                                    bv1 = true;
                                    ind1 = ind;
                                    continue;
                                };
                            };
                        };
                        if (((((((!(bv2)) && ((vertices[vind] == v2.x)))) && ((vertices[vindy] == v2.y)))) && ((vertices[vindz] == v2.z)))){
                            this._normalTmp.x = normals[vind];
                            this._normalTmp.y = normals[vindy];
                            this._normalTmp.z = normals[vindz];
                            ab = Vector3D.angleBetween(this._normalTmp, this._normal2);
                            if (ab < this.MAXRAD){
                                this._normal2.x = ((this._normalTmp.x + this._normal2.x) * 0.5);
                                this._normal2.y = ((this._normalTmp.y + this._normal2.y) * 0.5);
                                this._normal2.z = ((this._normalTmp.z + this._normal2.z) * 0.5);
                                if ((((uvs[uvind] == uv2.u)) && ((uvs[uvindV] == uv2.v)))){
                                    bv2 = true;
                                    ind2 = ind;
                                };
                            };
                        };
                    };
                };
            };
            if (!(bv0)){
                ind0 = (vertices.length / 3);
                vertices.push(v0.x, v0.y, v0.z);
                uvs.push(uv0.u, uv0.v);
                if (this._smoothSurface){
                    normals.push(this._normal0.x, this._normal0.y, this._normal0.z);
                };
            };
            if (!(bv1)){
                ind1 = (vertices.length / 3);
                vertices.push(v1.x, v1.y, v1.z);
                uvs.push(uv1.u, uv1.v);
                if (this._smoothSurface){
                    normals.push(this._normal1.x, this._normal1.y, this._normal1.z);
                };
            };
            if (!(bv2)){
                ind2 = (vertices.length / 3);
                vertices.push(v2.x, v2.y, v2.z);
                uvs.push(uv2.u, uv2.v);
                if (this._smoothSurface){
                    normals.push(this._normal2.x, this._normal2.y, this._normal2.z);
                };
            };
            indices.push(ind0, ind1, ind2);
        }
        private function initHolders():void{
            this._uvarr = new Vector.<UV>();
            this._uva = new UV(0, 0);
            this._uvb = new UV(0, 0);
            this._uvc = new UV(0, 0);
            this._uvd = new UV(0, 0);
            this._va = new Vector3D(0, 0, 0);
            this._vb = new Vector3D(0, 0, 0);
            this._vc = new Vector3D(0, 0, 0);
            this._vd = new Vector3D(0, 0, 0);
            this._uvs = new Vector.<Number>();
            this._vertices = new Vector.<Number>();
            this._indices = new Vector.<uint>();
            this._normals = new Vector.<Number>();
            if (this._smoothSurface){
                this._normal0 = new Vector3D(0, 0, 0);
                this._normal1 = new Vector3D(0, 0, 0);
                this._normal2 = new Vector3D(0, 0, 0);
                this._normalTmp = new Vector3D(0, 0, 0);
            } else {
                this._subGeometry.autoDeriveVertexNormals = true;
            };
            this._subGeometry.autoDeriveVertexTangents = true;
            if (((this._materials) && ((this._thickness > 0)))){
                this.initSubGeometryList();
            };
        }
        private function buildThicknessPoints(aPoints:Vector.<Vector3D>, thickness:Number, prop1:String, prop2:String):Array{
            var i:int;
            var pointResult:FourPoints;
            var fourPoints:FourPoints;
            var anchorFP:FourPoints;
            var anchors:Array = [];
            var lines:Array = [];
            i = 0;
            while (i < (aPoints.length - 1)) {
                if ((((aPoints[i][prop1] == 0)) && ((aPoints[i][prop2] == 0)))){
                    aPoints[i][prop1] = this.EPS;
                };
                if (((!((aPoints[(i + 1)][prop2] == null))) && ((aPoints[i][prop2] == aPoints[(i + 1)][prop2])))){
                    aPoints[(i + 1)][prop2] = (aPoints[(i + 1)][prop2] + this.EPS);
                };
                if (((!((aPoints[i][prop1] == null))) && ((aPoints[i][prop1] == aPoints[(i + 1)][prop1])))){
                    aPoints[(i + 1)][prop1] = (aPoints[(i + 1)][prop1] + this.EPS);
                };
                anchors.push(this.defineAnchors(aPoints[i], aPoints[(i + 1)], thickness, prop1, prop2));
                i++;
            };
            var totallength:int = anchors.length;
            if (totallength > 1){
                i = 0;
                while (i < totallength) {
                    if (i < totallength){
                        pointResult = this.defineLines(i, anchors[i], anchors[(i + 1)], lines);
                    } else {
                        pointResult = this.defineLines(i, anchors[i], anchors[(i - 1)], lines);
                    };
                    if (pointResult != null){
                        lines.push(pointResult);
                    };
                    i++;
                };
            } else {
                fourPoints = new FourPoints();
                anchorFP = anchors[0];
                fourPoints.pt1 = anchorFP.pt1;
                fourPoints.pt2 = anchorFP.pt2;
                fourPoints.pt3 = anchorFP.pt3;
                fourPoints.pt4 = anchorFP.pt4;
                lines = [fourPoints];
            };
            return (lines);
        }
        private function defineLines(index:int, point1:FourPoints, point2:FourPoints=null, lines:Array=null):FourPoints{
            var tmppt:FourPoints;
            var fourPoints:FourPoints = new FourPoints();
            if (point2 == null){
                tmppt = lines[(index - 1)];
                fourPoints.pt1 = tmppt.pt3;
                fourPoints.pt2 = tmppt.pt4;
                fourPoints.pt3 = point1.pt3;
                fourPoints.pt4 = point1.pt4;
                return (fourPoints);
            };
            var line1:Line = this.buildObjectLine(point1.pt1.x, point1.pt1.y, point1.pt3.x, point1.pt3.y);
            var line2:Line = this.buildObjectLine(point1.pt2.x, point1.pt2.y, point1.pt4.x, point1.pt4.y);
            var line3:Line = this.buildObjectLine(point2.pt1.x, point2.pt1.y, point2.pt3.x, point2.pt3.y);
            var line4:Line = this.buildObjectLine(point2.pt2.x, point2.pt2.y, point2.pt4.x, point2.pt4.y);
            var cross1:Point = this.lineIntersect(line3, line1);
            var cross2:Point = this.lineIntersect(line2, line4);
            if (((!((cross1 == null))) && (!((cross2 == null))))){
                if (index == 0){
                    fourPoints.pt1 = point1.pt1;
                    fourPoints.pt2 = point1.pt2;
                    fourPoints.pt3 = cross1;
                    fourPoints.pt4 = cross2;
                    return (fourPoints);
                };
                tmppt = lines[(index - 1)];
                fourPoints.pt1 = tmppt.pt3;
                fourPoints.pt2 = tmppt.pt4;
                fourPoints.pt3 = cross1;
                fourPoints.pt4 = cross2;
                return (fourPoints);
            };
            return (null);
        }
        private function defineAnchors(base:Vector3D, baseEnd:Vector3D, thickness:Number, prop1:String, prop2:String):FourPoints{
            var angle:Number = ((Math.atan2((base[prop2] - baseEnd[prop2]), (base[prop1] - baseEnd[prop1])) * 180) / Math.PI);
            angle = (angle - 270);
            var angle2:Number = (angle + 180);
            var fourPoints:FourPoints = new FourPoints();
            fourPoints.pt1 = new Point(base[prop1], base[prop2]);
            fourPoints.pt2 = new Point(base[prop1], base[prop2]);
            fourPoints.pt3 = new Point(baseEnd[prop1], baseEnd[prop2]);
            fourPoints.pt4 = new Point(baseEnd[prop1], baseEnd[prop2]);
            var radius:Number = (thickness * 0.5);
            fourPoints.pt1.x = (fourPoints.pt1.x + (Math.cos(((-(angle) / 180) * Math.PI)) * radius));
            fourPoints.pt1.y = (fourPoints.pt1.y + (Math.sin(((angle / 180) * Math.PI)) * radius));
            fourPoints.pt2.x = (fourPoints.pt2.x + (Math.cos(((-(angle2) / 180) * Math.PI)) * radius));
            fourPoints.pt2.y = (fourPoints.pt2.y + (Math.sin(((angle2 / 180) * Math.PI)) * radius));
            fourPoints.pt3.x = (fourPoints.pt3.x + (Math.cos(((-(angle) / 180) * Math.PI)) * radius));
            fourPoints.pt3.y = (fourPoints.pt3.y + (Math.sin(((angle / 180) * Math.PI)) * radius));
            fourPoints.pt4.x = (fourPoints.pt4.x + (Math.cos(((-(angle2) / 180) * Math.PI)) * radius));
            fourPoints.pt4.y = (fourPoints.pt4.y + (Math.sin(((angle2 / 180) * Math.PI)) * radius));
            return (fourPoints);
        }
        private function buildObjectLine(origX:Number, origY:Number, endX:Number, endY:Number):Line{
            var line:Line = new Line();
            line.ax = origX;
            line.ay = origY;
            line.bx = (endX - origX);
            line.by = (endY - origY);
            return (line);
        }
        private function lineIntersect(Line1:Line, Line2:Line):Point{
            Line1.bx = ((Line1.bx)==0) ? this.EPS : Line1.bx;
            Line2.bx = ((Line2.bx)==0) ? this.EPS : Line2.bx;
            var a1:Number = (Line1.by / Line1.bx);
            var b1:Number = (Line1.ay - (a1 * Line1.ax));
            var a2:Number = (Line2.by / Line2.bx);
            var b2:Number = (Line2.ay - (a2 * Line2.ax));
            var nzero:Number = (((a1 - a2))==0) ? this.EPS : (a1 - a2);
            var ptx:Number = ((b2 - b1) / nzero);
            var pty:Number = ((a1 * ptx) + b1);
            if (((isFinite(ptx)) && (isFinite(pty)))){
                return (new Point(ptx, pty));
            };
            trace("infinity");
            return (null);
        }
        private function invalidateGeometry():void{
            this._geomDirty = true;
            invalidateBounds();
        }
        private function initSubGeometryList():void{
            var i:uint;
            var sglist:SubGeometryList;
            var sg:SubGeometry;
            var prop:String;
            if (!(this._MaterialsSubGeometries)){
                this._MaterialsSubGeometries = new Vector.<SubGeometryList>();
            };
            i = 0;
            while (i < 6) {
                sglist = new SubGeometryList();
                this._MaterialsSubGeometries.push(sglist);
                sglist.id = i;
                if (i == 0){
                    sglist.subGeometry = this._subGeometry;
                    sglist.uvs = this._uvs;
                    sglist.vertices = this._vertices;
                    sglist.indices = this._indices;
                    sglist.normals = this._normals;
                } else {
                    sglist.uvs = new Vector.<Number>();
                    sglist.vertices = new Vector.<Number>();
                    sglist.indices = new Vector.<uint>();
                    sglist.normals = new Vector.<Number>();
                };
                i++;
            };
            i = 1;
            while (i < 6) {
                switch (i){
                    case 1:
                        prop = "back";
                        break;
                    case 2:
                        prop = "left";
                        break;
                    case 3:
                        prop = "right";
                        break;
                    case 4:
                        prop = "top";
                        break;
                    case 5:
                        prop = "bottom";
                        break;
                    default:
                        prop = "front";
                };
                if (((this._materials[prop]) && ((this._MaterialsSubGeometries[i].subGeometry == null)))){
                    sglist = this._MaterialsSubGeometries[i];
                    sg = new SubGeometry();
                    sglist.material = this._materials[prop];
                    sglist.subGeometry = sg;
                    sg.autoDeriveVertexNormals = true;
                    sg.autoDeriveVertexTangents = true;
                };
                i++;
            };
        }

    }
}//package away3d.extrusions 

import __AS3__.vec.*;
import away3d.core.base.*;
import away3d.materials.*;
import flash.geom.*;

class SubGeometryList {

    public var id:uint;
    public var uvs:Vector.<Number>;
    public var vertices:Vector.<Number>;
    public var normals:Vector.<Number>;
    public var indices:Vector.<uint>;
    public var subGeometry:SubGeometry;
    public var material:MaterialBase;

    public function SubGeometryList(){
    }
}
class RenderSide {

    public var top:Boolean;
    public var bottom:Boolean;
    public var right:Boolean;
    public var left:Boolean;
    public var front:Boolean;
    public var back:Boolean;

    public function RenderSide(){
    }
}
class Line {

    public var ax:Number;
    public var ay:Number;
    public var bx:Number;
    public var by:Number;

    public function Line(){
    }
}
class FourPoints {

    public var pt1:Point;
    public var pt2:Point;
    public var pt3:Point;
    public var pt4:Point;

    public function FourPoints(){
    }
}
