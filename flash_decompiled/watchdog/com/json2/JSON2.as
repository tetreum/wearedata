package com.json2 {

    public final class JSON2 {

        public static function encode(o:Object):String{
            return (new JSONEncoder(o).getString());
        }
        public static function decode(s:String, strict:Boolean=true){
            return (new JSONDecoder(s, strict).getValue());
        }

    }
}//package com.json2 
