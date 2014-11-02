package aze.motion.specials {

    public class EazeSpecial {

        protected var target:Object;
        protected var property:String;
        public var next:EazeSpecial;

        public function EazeSpecial(_arg1:Object, _arg2, _arg3, _arg4:EazeSpecial){
            this.target = _arg1;
            this.property = _arg2;
            this.next = _arg4;
        }
        public function init(_arg1:Boolean):void{
        }
        public function update(_arg1:Number, _arg2:Boolean):void{
        }
        public function dispose():void{
            this.target = null;
            if (this.next){
                this.next.dispose();
            };
            this.next = null;
        }

    }
}//package aze.motion.specials 
