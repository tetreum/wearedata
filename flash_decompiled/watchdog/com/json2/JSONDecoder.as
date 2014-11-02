package com.json2 {

    public class JSONDecoder {

        private var strict:Boolean;
        private var value;
        private var tokenizer:JSONTokenizer;
        private var token:JSONToken;

        public function JSONDecoder(s:String, strict:Boolean){
            super();
            this.strict = strict;
            this.tokenizer = new JSONTokenizer(s, strict);
            this.nextToken();
            this.value = this.parseValue();
            if (((strict) && (!((this.nextToken() == null))))){
                this.tokenizer.parseError("Unexpected characters left in input stream");
            };
        }
        public function getValue(){
            return (this.value);
        }
        final private function nextToken():JSONToken{
            return ((this.token = this.tokenizer.getNextToken()));
        }
        final private function nextValidToken():JSONToken{
            this.token = this.tokenizer.getNextToken();
            this.checkValidToken();
            return (this.token);
        }
        final private function checkValidToken():void{
            if (this.token == null){
                this.tokenizer.parseError("Unexpected end of input");
            };
        }
        final private function parseArray():Array{
            var a:Array = new Array();
            this.nextValidToken();
            if (this.token.type == JSONTokenType.RIGHT_BRACKET){
                return (a);
            };
            if (((!(this.strict)) && ((this.token.type == JSONTokenType.COMMA)))){
                this.nextValidToken();
                if (this.token.type == JSONTokenType.RIGHT_BRACKET){
                    return (a);
                };
                this.tokenizer.parseError(("Leading commas are not supported.  Expecting ']' but found " + this.token.value));
            };
            while (true) {
                a.push(this.parseValue());
                this.nextValidToken();
                if (this.token.type == JSONTokenType.RIGHT_BRACKET){
                    return (a);
                };
                if (this.token.type == JSONTokenType.COMMA){
                    this.nextToken();
                    if (!(this.strict)){
                        this.checkValidToken();
                        if (this.token.type == JSONTokenType.RIGHT_BRACKET){
                            return (a);
                        };
                    };
                } else {
                    this.tokenizer.parseError(("Expecting ] or , but found " + this.token.value));
                };
            };
            return (null);
        }
        final private function parseObject():Object{
            var key:String;
            var o:Object = new Object();
            this.nextValidToken();
            if (this.token.type == JSONTokenType.RIGHT_BRACE){
                return (o);
            };
            if (((!(this.strict)) && ((this.token.type == JSONTokenType.COMMA)))){
                this.nextValidToken();
                if (this.token.type == JSONTokenType.RIGHT_BRACE){
                    return (o);
                };
                this.tokenizer.parseError(("Leading commas are not supported.  Expecting '}' but found " + this.token.value));
            };
            while (true) {
                if (this.token.type == JSONTokenType.STRING){
                    key = String(this.token.value);
                    this.nextValidToken();
                    if (this.token.type == JSONTokenType.COLON){
                        this.nextToken();
                        o[key] = this.parseValue();
                        this.nextValidToken();
                        if (this.token.type == JSONTokenType.RIGHT_BRACE){
                            return (o);
                        };
                        if (this.token.type == JSONTokenType.COMMA){
                            this.nextToken();
                            if (!(this.strict)){
                                this.checkValidToken();
                                if (this.token.type == JSONTokenType.RIGHT_BRACE){
                                    return (o);
                                };
                            };
                        } else {
                            this.tokenizer.parseError(("Expecting } or , but found " + this.token.value));
                        };
                    } else {
                        this.tokenizer.parseError(("Expecting : but found " + this.token.value));
                    };
                } else {
                    this.tokenizer.parseError(("Expecting string but found " + this.token.value));
                };
            };
            return (null);
        }
        final private function parseValue():Object{
            this.checkValidToken();
            switch (this.token.type){
                case JSONTokenType.LEFT_BRACE:
                    return (this.parseObject());
                case JSONTokenType.LEFT_BRACKET:
                    return (this.parseArray());
                case JSONTokenType.STRING:
                case JSONTokenType.NUMBER:
                case JSONTokenType.TRUE:
                case JSONTokenType.FALSE:
                case JSONTokenType.NULL:
                    return (this.token.value);
                case JSONTokenType.NAN:
                    if (!(this.strict)){
                        return (this.token.value);
                    };
                    this.tokenizer.parseError(("Unexpected " + this.token.value));
                default:
                    this.tokenizer.parseError(("Unexpected " + this.token.value));
            };
            return (null);
        }

    }
}//package com.json2 
