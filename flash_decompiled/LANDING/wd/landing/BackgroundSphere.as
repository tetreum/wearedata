package wd.landing {
    import flash.display.*;
    import flash.geom.*;

    public class BackgroundSphere extends Shape {

        public function BackgroundSphere(){
            var _local1:Number = 220;
            var _local2:Matrix = new Matrix();
            var _local3:Array = [10263710, 10263710, 10263710];
            var _local4:Array = [0, 0.15, 0.25];
            var _local5:Array = [191, 250, 0xFF];
            _local2.createGradientBox((2 * _local1), (2 * _local1), 0, -(_local1), -(_local1));
            this.graphics.lineStyle();
            this.graphics.beginGradientFill(GradientType.RADIAL, _local3, _local4, _local5, _local2, SpreadMethod.REFLECT);
            this.graphics.drawCircle(0, 0, _local1);
            this.graphics.endFill();
        }
    }
}//package wd.landing 
