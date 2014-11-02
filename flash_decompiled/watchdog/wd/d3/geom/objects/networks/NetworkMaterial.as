package wd.d3.geom.objects.networks {
    import __AS3__.vec.*;
    import away3d.materials.*;

    public class NetworkMaterial extends MaterialBase {

        private var _thickness:Number;
        private var _screenPass:NetworkPass;

        public function NetworkMaterial(color:int, thickness:Number=1.25):void{
            super();
            this._thickness = thickness;
            addPass((this._screenPass = new NetworkPass(color, thickness)));
            this._screenPass.material = this;
        }
        public function set color(value:int):void{
            this._screenPass.color = Vector.<Number>([(((value >> 16) & 0xFF) / 0xFF), (((value >> 8) & 0xFF) / 0xFF), ((value & 0xFF) / 0xFF), 1]);
        }
        public function set alpha(value:Number):void{
            this._screenPass.color[3] = value;
        }
        public function get alpha():Number{
            return (this._screenPass.color[3]);
        }
        public function get thickness():Number{
            return (this._thickness);
        }
        public function set thickness(value:Number):void{
            this._screenPass.thickness = (this._thickness = value);
        }
        public function set triangleRenderStart(value:Number):void{
            this._screenPass.triangleRenderStart = value;
        }
        public function get triangleRenderStart():Number{
            return (this._screenPass.triangleRenderStart);
        }
        public function set triangleRenderCount(value:Number):void{
            this._screenPass.triangleRenderCount = value;
        }
        public function get triangleRenderCount():Number{
            return (this._screenPass.triangleRenderCount);
        }

    }
}//package wd.d3.geom.objects.networks 
