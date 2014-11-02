package away3d.primitives.data {
    import flash.geom.*;
    import biga.utils.*;
    import away3d.entities.*;

    public class Segment {

        var _segmentsBase:SegmentSet;
        var _thickness:Number;
        private var _index:uint;
        var _start:Vector3D;
        var _end:Vector3D;
        private var _startColor:uint;
        private var _endColor:uint;
        var _startR:Number;
        var _startG:Number;
        var _startB:Number;
        var _endR:Number;
        var _endG:Number;
        var _endB:Number;

        public function Segment(start:Vector3D, end:Vector3D, anchor:Vector3D, colorStart:uint=0x333333, colorEnd:uint=0x333333, thickness:Number=1):void{
            super();
            anchor = null;
            this._thickness = (thickness * 0.5);
            this._start = start;
            this._end = end;
            this.startColor = colorStart;
            this.endColor = colorEnd;
        }
        public function autoUpdate(thickness:Number=1):void{
            var c:int = GeomUtils.map(Vector3D.distance(this.start, this.end), 0, 250, 0, 0xFFFFFF);
            this.updateSegment(this.start, this.end, null, this._startColor, this.endColor, thickness);
        }
        public function updateSegment(start:Vector3D, end:Vector3D, anchor:Vector3D, colorStart:uint=0x333333, colorEnd:uint=0x333333, thickness:Number=1):void{
            anchor = null;
            this._start = start;
            this._end = end;
            if (this._startColor != colorStart){
                this.startColor = colorStart;
            };
            if (this._endColor != colorEnd){
                this.endColor = colorEnd;
            };
            this._thickness = thickness;
            this.update();
        }
        public function get start():Vector3D{
            return (this._start);
        }
        public function set start(value:Vector3D):void{
            this._start = value;
            this.update();
        }
        public function get end():Vector3D{
            return (this._end);
        }
        public function set end(value:Vector3D):void{
            this._end = value;
            this.update();
        }
        public function get thickness():Number{
            return (this._thickness);
        }
        public function set thickness(value:Number):void{
            this._thickness = (value * 0.5);
            this.update();
        }
        public function get startColor():uint{
            return (this._startColor);
        }
        public function set startColor(color:uint):void{
            this._startR = (((color >> 16) & 0xFF) / 0xFF);
            this._startG = (((color >> 8) & 0xFF) / 0xFF);
            this._startB = ((color & 0xFF) / 0xFF);
            this._startColor = color;
            this.update();
        }
        public function get endColor():uint{
            return (this._endColor);
        }
        public function set endColor(color:uint):void{
            this._endR = (((color >> 16) & 0xFF) / 0xFF);
            this._endG = (((color >> 8) & 0xFF) / 0xFF);
            this._endB = ((color & 0xFF) / 0xFF);
            this._endColor = color;
            this.update();
        }
        function get index():uint{
            return (this._index);
        }
        function set index(ind:uint):void{
            this._index = ind;
        }
        function set segmentsBase(segBase:SegmentSet):void{
            this._segmentsBase = segBase;
        }
        private function update():void{
            if (!(this._segmentsBase)){
                return;
            };
            this._segmentsBase.updateSegment(this);
        }

    }
}//package away3d.primitives.data 
