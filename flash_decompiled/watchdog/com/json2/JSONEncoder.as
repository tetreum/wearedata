package com.json2 {
    import flash.utils.*;

    public class JSONEncoder {

        private var jsonString:String;

        public function JSONEncoder(value){
            super();
            this.jsonString = this.convertToString(value);
        }
        public function getString():String{
            return (this.jsonString);
        }
        private function convertToString(value):String{
            if ((value is String)){
                return (this.escapeString((value as String)));
            };
            if ((value is Number)){
                return (((isFinite((value as Number))) ? value.toString() : "null"));
            };
            if ((value is Boolean)){
                return (((value) ? "true" : "false"));
            };
            if ((value is Array)){
                return (this.arrayToString((value as Array)));
            };
            if ((((value is Object)) && (!((value == null))))){
                return (this.objectToString(value));
            };
            return ("null");
        }
        private function escapeString(str:String):String{
            var ch:String;
            var hexCode:String;
            var zeroPad:String;
            var s:String = "";
            var len:Number = str.length;
            var i:int;
            while (i < len) {
                ch = str.charAt(i);
                switch (ch){
                    case "\"":
                        s = (s + "\\\"");
                        break;
                    case "\\":
                        s = (s + "\\\\");
                        break;
                    case "\b":
                        s = (s + "\\b");
                        break;
                    case "\f":
                        s = (s + "\\f");
                        break;
                    case "\n":
                        s = (s + "\\n");
                        break;
                    case "\r":
                        s = (s + "\\r");
                        break;
                    case "\t":
                        s = (s + "\\t");
                        break;
                    default:
                        if (ch < " "){
                            hexCode = ch.charCodeAt(0).toString(16);
                            zeroPad = (((hexCode.length == 2)) ? "00" : "000");
                            s = (s + (("\\u" + zeroPad) + hexCode));
                        } else {
                            s = (s + ch);
                        };
                };
                i++;
            };
            return ((("\"" + s) + "\""));
        }
        private function arrayToString(a:Array):String{
            var s:String = "";
            var length:int = a.length;
            var i:int;
            while (i < length) {
                if (s.length > 0){
                    s = (s + ",");
                };
                s = (s + this.convertToString(a[i]));
                i++;
            };
            return ((("[" + s) + "]"));
        }
        private function objectToString(o:Object):String{
            var value:* = null;
            var key:* = null;
            var v:* = null;
            var o:* = o;
            var s:* = "";
            var classInfo:* = describeType(o);
            if (classInfo.@name.toString() == "Object"){
                for (key in o) {
                    value = o[key];
                    if ((value is Function)){
                    } else {
                        if (s.length > 0){
                            s = (s + ",");
                        };
                        s = (s + ((this.escapeString(key) + ":") + this.convertToString(value)));
                    };
                };
            } else {
                var _local3:int;
                var _local6:int;
                var _local7:* = classInfo..*;
                var _local5 = new XMLList("");
                for each (var _local8 in classInfo..*) {
                    var _local9 = _local8;
                    with (_local9) {
                        if ((((name() == "variable")) || ((((name() == "accessor")) && ((attribute("access").charAt(0) == "r")))))){
                            _local5[_local6] = _local8;
                        };
                    };
                };
                var _local4:* = _local5;
                for each (v in _local5) {
                    if (((v.metadata) && ((v.metadata.(@name == "Transient").length() > 0)))){
                    } else {
                        if (s.length > 0){
                            s = (s + ",");
                        };
                        s = (s + ((this.escapeString(v.@name.toString()) + ":") + this.convertToString(o[v.@name])));
                    };
                };
            };
            return ((("{" + s) + "}"));
        }

    }
}//package com.json2 
