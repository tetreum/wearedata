package away3d.core.data {
    import __AS3__.vec.*;

    public class EntityListItemPool {

        private var _pool:Vector.<EntityListItem>;
        private var _index:int;
        private var _poolSize:int;

        public function EntityListItemPool(){
            super();
            this._pool = new Vector.<EntityListItem>();
        }
        public function getItem():EntityListItem{
            var item:EntityListItem;
            if (this._index == this._poolSize){
                item = new EntityListItem();
                var _local2 = this._index++;
                this._pool[_local2] = item;
                this._poolSize++;
            } else {
                item = this._pool[this._index++];
            };
            return (item);
        }
        public function freeAll():void{
            this._index = 0;
        }
        public function dispose():void{
            this._pool.length = 0;
        }

    }
}//package away3d.core.data 
