package com.adobe.images {
    import flash.utils.*;
    import flash.display.*;
    import flash.geom.*;

    public class PNGEncoder {

        private static var crcTable:Array;
        private static var crcTableComputed:Boolean = false;

        public static function encode(img:BitmapData):ByteArray{
            var p:uint;
            var j:int;
            var png:ByteArray = new ByteArray();
            png.writeUnsignedInt(2303741511);
            png.writeUnsignedInt(218765834);
            var IHDR:ByteArray = new ByteArray();
            IHDR.writeInt(img.width);
            IHDR.writeInt(img.height);
            IHDR.writeUnsignedInt(134610944);
            IHDR.writeByte(0);
            writeChunk(png, 1229472850, IHDR);
            var IDAT:ByteArray = new ByteArray();
            var i:int;
            while (i < img.height) {
                IDAT.writeByte(0);
                if (!(img.transparent)){
                    j = 0;
                    while (j < img.width) {
                        p = img.getPixel(j, i);
                        IDAT.writeUnsignedInt(uint((((p & 0xFFFFFF) << 8) | 0xFF)));
                        j++;
                    };
                } else {
                    j = 0;
                    while (j < img.width) {
                        p = img.getPixel32(j, i);
                        IDAT.writeUnsignedInt(uint((((p & 0xFFFFFF) << 8) | (p >>> 24))));
                        j++;
                    };
                };
                i++;
            };
            IDAT.compress();
            writeChunk(png, 1229209940, IDAT);
            writeChunk(png, 1229278788, null);
            return (png);
        }
        private static function writeChunk(png:ByteArray, type:uint, data:ByteArray):void{
            var c:uint;
            var n:uint;
            var k:uint;
            if (!(crcTableComputed)){
                crcTableComputed = true;
                crcTable = [];
                n = 0;
                while (n < 0x0100) {
                    c = n;
                    k = 0;
                    while (k < 8) {
                        if ((c & 1)){
                            c = uint((uint(3988292384) ^ uint((c >>> 1))));
                        } else {
                            c = uint((c >>> 1));
                        };
                        k++;
                    };
                    crcTable[n] = c;
                    n++;
                };
            };
            var len:uint;
            if (data != null){
                len = data.length;
            };
            png.writeUnsignedInt(len);
            var p:uint = png.position;
            png.writeUnsignedInt(type);
            if (data != null){
                png.writeBytes(data);
            };
            var e:uint = png.position;
            png.position = p;
            c = 0xFFFFFFFF;
            var i:int;
            while (i < (e - p)) {
                c = uint((crcTable[((c ^ png.readUnsignedByte()) & uint(0xFF))] ^ uint((c >>> 8))));
                i++;
            };
            c = uint((c ^ uint(0xFFFFFFFF)));
            png.position = e;
            png.writeUnsignedInt(c);
        }

    }
}//package com.adobe.images 
