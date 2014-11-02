package away3d.textures {
    import flash.display.*;
    import away3d.tools.utils.*;
    import away3d.materials.utils.*;
    import flash.display3D.textures.*;

    public class BitmapTexture extends Texture2DBase {

        private static var _mipMaps:Array = [];
        private static var _mipMapUses:Array = [];

        private var _bitmapData:BitmapData;
        private var _mipMapHolder:BitmapData;

        public function BitmapTexture(bitmapData:BitmapData){
            super();
            this.bitmapData = bitmapData;
        }
        public function get bitmapData():BitmapData{
            return (this._bitmapData);
        }
        public function set bitmapData(value:BitmapData):void{
            if (value == this._bitmapData){
                return;
            };
            if (!(TextureUtils.isBitmapDataValid(value))){
                throw (new Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048"));
            };
            invalidateContent();
            setSize(value.width, value.height);
            this._bitmapData = value;
            this.setMipMap();
        }
        override protected function uploadContent(texture:TextureBase):void{
            MipmapGenerator.generateMipMaps(this._bitmapData, texture, this._mipMapHolder, true);
        }
        private function setMipMap():void{
            var oldW:uint;
            var oldH:uint;
            var newW:uint;
            var newH:uint;
            newW = this._bitmapData.width;
            newH = this._bitmapData.height;
            if (this._mipMapHolder){
                oldW = this._mipMapHolder.width;
                oldH = this._mipMapHolder.height;
                if ((((oldW == this._bitmapData.width)) && ((oldH == this._bitmapData.height)))){
                    return;
                };
                var _local5 = _mipMapUses[oldW];
                var _local6 = this._mipMapHolder.height;
                var _local7 = (_local5[_local6] - 1);
                _local5[_local6] = _local7;
                if (_local7 == 0){
                    _mipMaps[oldW][oldH].dispose();
                    _mipMaps[oldW][oldH] = null;
                };
            };
            if (!(_mipMaps[newW])){
                _mipMaps[newW] = [];
                _mipMapUses[newW] = [];
            };
            if (!(_mipMaps[newW][newH])){
                this._mipMapHolder = (_mipMaps[newW][newH] = new BitmapData(newW, newH, true));
                _mipMapUses[newW][newH] = 1;
            } else {
                _local5 = _mipMapUses[newW];
                _local6 = newH;
                _local7 = (_local5[_local6] + 1);
                _local5[_local6] = _local7;
                this._mipMapHolder = _mipMaps[newW][newH];
            };
        }

    }
}//package away3d.textures 
