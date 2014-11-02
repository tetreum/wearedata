package com.json2 {

    public class JSONTokenizer {

        private const controlCharsRegExp:RegExp;

        private var strict:Boolean;
        private var obj:Object;
        private var jsonString:String;
        private var loc:int;
        private var ch:String;

        public function JSONTokenizer(s:String, strict:Boolean){
            this.controlCharsRegExp = /[\x00-\x1F]/;
            super();
            this.jsonString = s;
            this.strict = strict;
            this.loc = 0;
            this.nextChar();
        }
        public function getNextToken():JSONToken{
            var _local2:String;
            var _local3:String;
            var _local4:String;
            var _local5:String;
            var token:JSONToken;
            this.skipIgnored();
            switch (this.ch){
                case "{":
                    token = JSONToken.create(JSONTokenType.LEFT_BRACE, this.ch);
                    this.nextChar();
                    break;
                case "}":
                    token = JSONToken.create(JSONTokenType.RIGHT_BRACE, this.ch);
                    this.nextChar();
                    break;
                case "[":
                    token = JSONToken.create(JSONTokenType.LEFT_BRACKET, this.ch);
                    this.nextChar();
                    break;
                case "]":
                    token = JSONToken.create(JSONTokenType.RIGHT_BRACKET, this.ch);
                    this.nextChar();
                    break;
                case ",":
                    token = JSONToken.create(JSONTokenType.COMMA, this.ch);
                    this.nextChar();
                    break;
                case ":":
                    token = JSONToken.create(JSONTokenType.COLON, this.ch);
                    this.nextChar();
                    break;
                case "t":
                    _local2 = ((("t" + this.nextChar()) + this.nextChar()) + this.nextChar());
                    if (_local2 == "true"){
                        token = JSONToken.create(JSONTokenType.TRUE, true);
                        this.nextChar();
                    } else {
                        this.parseError(("Expecting 'true' but found " + _local2));
                    };
                    break;
                case "f":
                    _local3 = (((("f" + this.nextChar()) + this.nextChar()) + this.nextChar()) + this.nextChar());
                    if (_local3 == "false"){
                        token = JSONToken.create(JSONTokenType.FALSE, false);
                        this.nextChar();
                    } else {
                        this.parseError(("Expecting 'false' but found " + _local3));
                    };
                    break;
                case "n":
                    _local4 = ((("n" + this.nextChar()) + this.nextChar()) + this.nextChar());
                    if (_local4 == "null"){
                        token = JSONToken.create(JSONTokenType.NULL, null);
                        this.nextChar();
                    } else {
                        this.parseError(("Expecting 'null' but found " + _local4));
                    };
                    break;
                case "N":
                    _local5 = (("N" + this.nextChar()) + this.nextChar());
                    if (_local5 == "NaN"){
                        token = JSONToken.create(JSONTokenType.NAN, NaN);
                        this.nextChar();
                    } else {
                        this.parseError(("Expecting 'NaN' but found " + _local5));
                    };
                    break;
                case "\"":
                    token = this.readString();
                    break;
                default:
                    if (((this.isDigit(this.ch)) || ((this.ch == "-")))){
                        token = this.readNumber();
                    } else {
                        if (this.ch == ""){
                            token = null;
                        } else {
                            this.parseError((("Unexpected " + this.ch) + " encountered"));
                        };
                    };
            };
            return (token);
        }
        final private function readString():JSONToken{
            var backspaceCount:int;
            var backspaceIndex:int;
            var quoteIndex:int = this.loc;
            do  {
                quoteIndex = this.jsonString.indexOf("\"", quoteIndex);
                if (quoteIndex >= 0){
                    backspaceCount = 0;
                    backspaceIndex = (quoteIndex - 1);
                    while (this.jsonString.charAt(backspaceIndex) == "\\") {
                        backspaceCount++;
                        backspaceIndex--;
                    };
                    if ((backspaceCount & 1) == 0){
                        break;
                    };
                    quoteIndex++;
                } else {
                    this.parseError("Unterminated string literal");
                };
            } while (true);
            var token:JSONToken = JSONToken.create(JSONTokenType.STRING, this.unescapeString(this.jsonString.substr(this.loc, (quoteIndex - this.loc))));
            this.loc = (quoteIndex + 1);
            this.nextChar();
            return (token);
        }
        public function unescapeString(input:String):String{
            var nextSubstringStartPosition:int;
            var escapedChar:String;
            var _local7:String;
            var _local8:int;
            var i:int;
            var possibleHexChar:String;
            if (((this.strict) && (this.controlCharsRegExp.test(input)))){
                this.parseError("String contains unescaped control character (0x00-0x1F)");
            };
            var result:String = "";
            var backslashIndex:int;
            nextSubstringStartPosition = 0;
            var len:int = input.length;
            do  {
                backslashIndex = input.indexOf("\\", nextSubstringStartPosition);
                if (backslashIndex >= 0){
                    result = (result + input.substr(nextSubstringStartPosition, (backslashIndex - nextSubstringStartPosition)));
                    nextSubstringStartPosition = (backslashIndex + 2);
                    escapedChar = input.charAt((backslashIndex + 1));
                    switch (escapedChar){
                        case "\"":
                            result = (result + escapedChar);
                            break;
                        case "\\":
                            result = (result + escapedChar);
                            break;
                        case "n":
                            result = (result + "\n");
                            break;
                        case "r":
                            result = (result + "\r");
                            break;
                        case "t":
                            result = (result + "\t");
                            break;
                        case "u":
                            _local7 = "";
                            _local8 = (nextSubstringStartPosition + 4);
                            if (_local8 > len){
                                this.parseError("Unexpected end of input.  Expecting 4 hex digits after \\u.");
                            };
                            i = nextSubstringStartPosition;
                            while (i < _local8) {
                                possibleHexChar = input.charAt(i);
                                if (!(this.isHexDigit(possibleHexChar))){
                                    this.parseError(("Excepted a hex digit, but found: " + possibleHexChar));
                                };
                                _local7 = (_local7 + possibleHexChar);
                                i++;
                            };
                            result = (result + String.fromCharCode(parseInt(_local7, 16)));
                            nextSubstringStartPosition = _local8;
                            break;
                        case "f":
                            result = (result + "\f");
                            break;
                        case "/":
                            result = (result + "/");
                            break;
                        case "b":
                            result = (result + "\b");
                            break;
                        default:
                            result = (result + ("\\" + escapedChar));
                    };
                } else {
                    result = (result + input.substr(nextSubstringStartPosition));
                    break;
                };
            } while (nextSubstringStartPosition < len);
            return (result);
        }
        final private function readNumber():JSONToken{
            var input:String = "";
            if (this.ch == "-"){
                input = (input + "-");
                this.nextChar();
            };
            if (!(this.isDigit(this.ch))){
                this.parseError("Expecting a digit");
            };
            if (this.ch == "0"){
                input = (input + this.ch);
                this.nextChar();
                if (this.isDigit(this.ch)){
                    this.parseError("A digit cannot immediately follow 0");
                } else {
                    if (((!(this.strict)) && ((this.ch == "x")))){
                        input = (input + this.ch);
                        this.nextChar();
                        if (this.isHexDigit(this.ch)){
                            input = (input + this.ch);
                            this.nextChar();
                        } else {
                            this.parseError("Number in hex format require at least one hex digit after \"0x\"");
                        };
                        while (this.isHexDigit(this.ch)) {
                            input = (input + this.ch);
                            this.nextChar();
                        };
                    };
                };
            } else {
                while (this.isDigit(this.ch)) {
                    input = (input + this.ch);
                    this.nextChar();
                };
            };
            if (this.ch == "."){
                input = (input + ".");
                this.nextChar();
                if (!(this.isDigit(this.ch))){
                    this.parseError("Expecting a digit");
                };
                while (this.isDigit(this.ch)) {
                    input = (input + this.ch);
                    this.nextChar();
                };
            };
            if ((((this.ch == "e")) || ((this.ch == "E")))){
                input = (input + "e");
                this.nextChar();
                if ((((this.ch == "+")) || ((this.ch == "-")))){
                    input = (input + this.ch);
                    this.nextChar();
                };
                if (!(this.isDigit(this.ch))){
                    this.parseError("Scientific notation number needs exponent value");
                };
                while (this.isDigit(this.ch)) {
                    input = (input + this.ch);
                    this.nextChar();
                };
            };
            var num:Number = Number(input);
            if (((isFinite(num)) && (!(isNaN(num))))){
                return (JSONToken.create(JSONTokenType.NUMBER, num));
            };
            this.parseError((("Number " + num) + " is not valid!"));
            return (null);
        }
        final private function nextChar():String{
            return ((this.ch = this.jsonString.charAt(this.loc++)));
        }
        final private function skipIgnored():void{
            var originalLoc:int;
            do  {
                originalLoc = this.loc;
                this.skipWhite();
                this.skipComments();
            } while (originalLoc != this.loc);
        }
        private function skipComments():void{
            if (this.ch == "/"){
                this.nextChar();
                switch (this.ch){
                    case "/":
                        do  {
                            this.nextChar();
                        } while (((!((this.ch == "\n"))) && (!((this.ch == "")))));
                        this.nextChar();
                        break;
                    case "*":
                        this.nextChar();
                        while (true) {
                            if (this.ch == "*"){
                                this.nextChar();
                                if (this.ch == "/"){
                                    this.nextChar();
                                    break;
                                };
                            } else {
                                this.nextChar();
                            };
                            if (this.ch == ""){
                                this.parseError("Multi-line comment not closed");
                            };
                        };
                        break;
                    default:
                        this.parseError((("Unexpected " + this.ch) + " encountered (expecting '/' or '*' )"));
                };
            };
        }
        final private function skipWhite():void{
            while (this.isWhiteSpace(this.ch)) {
                this.nextChar();
            };
        }
        final private function isWhiteSpace(ch:String):Boolean{
            if ((((((((ch == " ")) || ((ch == "\t")))) || ((ch == "\n")))) || ((ch == "\r")))){
                return (true);
            };
            if (((!(this.strict)) && ((ch.charCodeAt(0) == 160)))){
                return (true);
            };
            return (false);
        }
        final private function isDigit(ch:String):Boolean{
            return ((((ch >= "0")) && ((ch <= "9"))));
        }
        final private function isHexDigit(ch:String):Boolean{
            return (((((this.isDigit(ch)) || ((((ch >= "A")) && ((ch <= "F")))))) || ((((ch >= "a")) && ((ch <= "f"))))));
        }
        final public function parseError(message:String):void{
            throw (new JSONParseError(message, this.loc, this.jsonString));
        }

    }
}//package com.json2 
