package wd.wq.textures {
    import flash.display3D.textures.*;

    public class WQConcreteTexture {

        private var mBase:Texture;
        private var mWidth:int;
        private var mHeight:int;
        private var mLegalWidth:int;
        private var mLegalHeight:int;
        private var mScaleWidth:Number;
        private var mScaleHeight:Number;

        public function WQConcreteTexture(base:Texture, width:int, height:int, legalWidth:int=2, legalHeight:int=2){
            super();
            this.mLegalHeight = legalHeight;
            this.mLegalWidth = legalWidth;
            this.mBase = base;
            this.mWidth = width;
            this.mHeight = height;
            this.mScaleWidth = (this.mWidth / this.mLegalWidth);
            this.mScaleHeight = (this.mHeight / this.mLegalHeight);
        }
        public function get base():Texture{
            return (this.mBase);
        }
        public function get width():Number{
            return (this.mWidth);
        }
        public function get height():Number{
            return (this.mHeight);
        }
        public function get legalWidth():Number{
            return (this.mLegalWidth);
        }
        public function get legalHeight():Number{
            return (this.mLegalHeight);
        }
        public function get scaleWidth():Number{
            return (this.mScaleWidth);
        }
        public function get scaleHeight():Number{
            return (this.mScaleHeight);
        }
        public function dispose():void{
            this.mBase.dispose();
            this.mBase = null;
        }

    }
}//package wd.wq.textures 
