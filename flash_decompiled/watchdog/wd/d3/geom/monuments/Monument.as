package wd.d3.geom.monuments {
    import flash.geom.*;
    import wd.utils.*;
    import fr.seraf.stage3D.*;

    public class Monument {

        public var mesh:Stage3DData;
        public var lon:Number;
        public var lat:Number;
        public var decalX:Number;
        public var decalY:Number;
        public var decalZ:Number;
        private var rotation:Number;
        public var scale:Number;
        public var center:Point;
        public var matrix:Matrix3D;

        public function Monument(mesh:Stage3DData, props:XML):void{
            this.center = new Point();
            super();
            this.lon = parseFloat(props.@lon);
            this.lat = parseFloat(props.@lat);
            this.decalX = parseFloat(props.@decalX);
            this.decalY = parseFloat(props.@decalY);
            this.decalZ = parseFloat(props.@decalZ);
            this.rotation = parseFloat(props.@rotation);
            this.scale = parseFloat(props.@scale);
            this.center = Locator.REMAP(this.lon, this.lat, this.center);
            this.matrix = new Matrix3D();
            this.matrix.appendScale(this.scale, this.scale, this.scale);
            this.matrix.appendRotation(this.rotation, Vector3D.Y_AXIS);
            this.matrix.appendTranslation((this.center.x + this.decalX), this.decalY, (this.center.y + this.decalZ));
            this.mesh = mesh;
        }
    }
}//package wd.d3.geom.monuments 
