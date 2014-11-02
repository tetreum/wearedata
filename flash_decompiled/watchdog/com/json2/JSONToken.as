package com.json2 {

    public final class JSONToken {

        static const token:JSONToken = new (JSONToken)();
;

        public var type:int;
        public var value:Object;

        public function JSONToken(type:int=-1, value:Object=null){
            super();
            this.type = type;
            this.value = value;
        }
        static function create(type:int=-1, value:Object=null):JSONToken{
            token.type = type;
            token.value = value;
            return (token);
        }

    }
}//package com.json2 
