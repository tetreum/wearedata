package away3d.primitives {
    import away3d.cameras.*;
    import away3d.bounds.*;
    import away3d.errors.*;
    import away3d.primitives.data.*;
    import flash.geom.*;
    import away3d.entities.*;

    public class WireframePrimitiveBase extends SegmentSet {

        private var _geomDirty:Boolean = true;
        private var _color:uint;
        private var _thickness:Number;

        public function WireframePrimitiveBase(color:uint=0xFFFFFF, thickness:Number=1){
            super();
            if (thickness <= 0){
                thickness = 1;
            };
            this._color = color;
            this._thickness = thickness;
            mouseEnabled = (mouseChildren = false);
        }
        public function get color():uint{
            return (this._color);
        }
        public function set color(value:uint):void{
            var numSegments:uint = _segments.length;
            this._color = value;
            var i:int;
            while (i < numSegments) {
                _segments[i].startColor = (_segments[i].endColor = value);
                i++;
            };
        }
        public function get thickness():Number{
            return (this._thickness);
        }
        public function set thickness(value:Number):void{
            var numSegments:uint = _segments.length;
            this._thickness = value;
            var i:int;
            while (i < numSegments) {
                _segments[i].thickness = (_segments[i].thickness = value);
                i++;
            };
        }
        override public function removeAllSegments():void{
            super.removeAllSegments();
        }
        override public function pushModelViewProjection(camera:Camera3D):void{
            if (this._geomDirty){
                this.updateGeometry();
            };
            super.pushModelViewProjection(camera);
        }
        override public function get bounds():BoundingVolumeBase{
            if (this._geomDirty){
                this.updateGeometry();
            };
            return (super.bounds);
        }
        protected function buildGeometry():void{
            throw (new AbstractMethodError());
        }
        protected function invalidateGeometry():void{
            this._geomDirty = true;
            invalidateBounds();
        }
        private function updateGeometry():void{
            this.buildGeometry();
            this._geomDirty = false;
        }
        protected function updateOrAddSegment(index:uint, v0:Vector3D, v1:Vector3D):void{
            var segment:Segment;
            var s:Vector3D;
            var e:Vector3D;
            if (_segments.length > index){
                segment = _segments[index];
                s = segment.start;
                e = segment.end;
                s.x = v0.x;
                s.y = v0.y;
                s.z = v0.z;
                e.x = v1.x;
                e.y = v1.y;
                e.z = v1.z;
                _segments[index].updateSegment(s, e, null, this._color, this._color, this._thickness);
            } else {
                addSegment(new LineSegment(v0.clone(), v1.clone(), this._color, this._color, this._thickness));
            };
        }
        override protected function updateMouseChildren():void{
            _ancestorsAllowMouseEnabled = false;
        }

    }
}//package away3d.primitives 
