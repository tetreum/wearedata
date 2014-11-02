package wd.d3.geom.segments {
    import __AS3__.vec.*;
    import wd.core.*;
    import flash.geom.*;
    import away3d.containers.*;

    public class Roofs extends ObjectContainer3D {

        public static var instance:Roofs;

        private var sets:Vector.<WireSegmentSetV2>;
        private var current:WireSegmentSetV2;
        private var topcolor:int;
        private var thickness:Number;
        private var bottomColor:int;

        public function Roofs(bottomColor:int=0, topcolor:int=0x707070, thickness:Number=1){
            super();
            this.bottomColor = bottomColor;
            this.thickness = thickness;
            this.topcolor = topcolor;
            instance = this;
            this.sets = new Vector.<WireSegmentSetV2>();
            this.current = new WireSegmentSetV2(bottomColor, thickness);
            this.sets.push(this.current);
            addChild(this.current);
        }
        public function addSegment(s:Vector3D, e:Vector3D):void{
            if ((((this.current.vertexData.length > (Constants.MAX_SUBGGEOM_BUFFER_SIZE - 28))) || ((this.current.indexData.length > (Constants.MAX_SUBGGEOM_BUFFER_SIZE - 6))))){
                this.current = new WireSegmentSetV2(this.bottomColor, this.thickness);
                this.sets.push(this.current);
                addChild(this.current);
            };
            this.current.addSegment(s, e);
        }

    }
}//package wd.d3.geom.segments 
