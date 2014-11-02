package away3d.animators.nodes {
    import flash.geom.*;
    import away3d.library.assets.*;
    import away3d.errors.*;

    public class AnimationNodeBase extends NamedAssetBase implements IAsset {

        private var _startTime:int = 0;
        protected var _time:int;
        protected var _totalDuration:uint = 0;
        protected var _rootDelta:Vector3D;
        protected var _rootDeltaDirty:Boolean = true;
        protected var _looping:Boolean = true;

        public function AnimationNodeBase(){
            this._rootDelta = new Vector3D();
            super();
        }
        public function get looping():Boolean{
            return (this._looping);
        }
        public function set looping(value:Boolean):void{
            if (this._looping == value){
                return;
            };
            this._looping = value;
            this.updateLooping();
        }
        public function get rootDelta():Vector3D{
            if (this._rootDeltaDirty){
                this.updateRootDelta();
            };
            return (this._rootDelta);
        }
        public function reset(time:int):void{
            if (!(this._looping)){
                this._startTime = time;
            };
            this.update(time);
            this.updateRootDelta();
        }
        public function update(time:int):void{
            if (((!(this._looping)) && ((time > (this._startTime + this._totalDuration))))){
                time = (this._startTime + this._totalDuration);
            };
            if (this._time == (time - this._startTime)){
                return;
            };
            this.updateTime((time - this._startTime));
        }
        public function dispose():void{
        }
        public function get assetType():String{
            return (AssetType.ANIMATION_NODE);
        }
        protected function updateRootDelta():void{
            throw (new AbstractMethodError());
        }
        protected function updateTime(time:int):void{
            this._time = time;
            this._rootDeltaDirty = true;
        }
        protected function updateLooping():void{
            this.updateTime(this._time);
        }

    }
}//package away3d.animators.nodes 
