package com.facebook.graph.utils {
    import flash.utils.*;

    public class PostRequest {

        public var boundary:String = "-----";
        protected var postData:ByteArray;

        public function PostRequest(){
            super();
            this.createPostData();
        }
        public function createPostData():void{
            this.postData = new ByteArray();
            this.postData.endian = Endian.BIG_ENDIAN;
        }
        public function writePostData(name:String, value:String):void{
            var bytes:String;
            this.writeBoundary();
            this.writeLineBreak();
            bytes = (("Content-Disposition: form-data; name=\"" + name) + "\"");
            var l:uint = bytes.length;
            var i:Number = 0;
            while (i < l) {
                this.postData.writeByte(bytes.charCodeAt(i));
                i++;
            };
            this.writeLineBreak();
            this.writeLineBreak();
            this.postData.writeUTFBytes(value);
            this.writeLineBreak();
        }
        public function writeFileData(filename:String, fileData:ByteArray, contentType:String):void{
            var bytes:String;
            var l:int;
            var i:uint;
            this.writeBoundary();
            this.writeLineBreak();
            bytes = (((("Content-Disposition: form-data; name=\"" + filename) + "\"; filename=\"") + filename) + "\";");
            l = bytes.length;
            i = 0;
            while (i < l) {
                this.postData.writeByte(bytes.charCodeAt(i));
                i++;
            };
            this.postData.writeUTFBytes(filename);
            this.writeQuotationMark();
            this.writeLineBreak();
            bytes = ((contentType) || ("application/octet-stream"));
            l = bytes.length;
            i = 0;
            while (i < l) {
                this.postData.writeByte(bytes.charCodeAt(i));
                i++;
            };
            this.writeLineBreak();
            this.writeLineBreak();
            fileData.position = 0;
            this.postData.writeBytes(fileData, 0, fileData.length);
            this.writeLineBreak();
        }
        public function getPostData():ByteArray{
            this.postData.position = 0;
            return (this.postData);
        }
        public function close():void{
            this.writeBoundary();
            this.writeDoubleDash();
        }
        protected function writeLineBreak():void{
            this.postData.writeShort(3338);
        }
        protected function writeQuotationMark():void{
            this.postData.writeByte(34);
        }
        protected function writeDoubleDash():void{
            this.postData.writeShort(0x2D2D);
        }
        protected function writeBoundary():void{
            this.writeDoubleDash();
            var l:uint = this.boundary.length;
            var i:uint;
            while (i < l) {
                this.postData.writeByte(this.boundary.charCodeAt(i));
                i++;
            };
        }

    }
}//package com.facebook.graph.utils 
