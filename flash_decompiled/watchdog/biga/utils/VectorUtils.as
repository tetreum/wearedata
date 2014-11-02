package biga.utils {
    import __AS3__.vec.*;
    import flash.utils.*;

    public class VectorUtils {

        public static function backwardsAverageWindow(values:Vector.<Number>, start:uint, valuesPerFrame:uint=0x0400, windowSize:uint=43):Vector.<Number>{
            var sum:Number;
            var min:int;
            var max:int;
            var j:int;
            if (windowSize == 1){
                return (values);
            };
            var tmp:Vector.<Number> = new Vector.<Number>(valuesPerFrame);
            var startPos:uint = Math.max(0, ((start * valuesPerFrame) - (valuesPerFrame * windowSize)));
            var endPos:uint = Math.min((values.length - valuesPerFrame), (start * valuesPerFrame));
            var i:int = startPos;
            while (i < endPos) {
                j = 0;
                while (j < valuesPerFrame) {
                    tmp[j] = (tmp[j] + (values[(i + j)] / windowSize));
                    j++;
                };
                i = (i + valuesPerFrame);
            };
            return (tmp);
        }
        public static function byteArrayToVector(ba:ByteArray, minMax:Array=null):Vector.<Number>{
            var tmp:Vector.<Number> = new Vector.<Number>();
            ba.position = 0;
            while (ba.bytesAvailable > 0) {
                if (minMax == null){
                    tmp.push(ba.readFloat());
                } else {
                    tmp.push(map(ba.readFloat(), -1, 1, minMax[0], minMax[1]));
                };
            };
            ba.position = 0;
            return (tmp);
        }
        public static function averageWindow(values:Vector.<Number>, windowSize:uint):Vector.<Number>{
            var sum:Number;
            var min:int;
            var max:int;
            var j:int;
            if (windowSize == 1){
                return (values);
            };
            var tmp:Vector.<Number> = values.concat();
            if ((windowSize % 2) == 0){
                windowSize++;
            };
            var halfWindow:uint = ((windowSize - 1) / 2);
            var i:int;
            while (i < values.length) {
                tmp[i] = 0;
                min = Math.max(0, (i - halfWindow));
                max = Math.min((values.length - 1), (i + halfWindow));
                j = min;
                while (j <= max) {
                    tmp[i] = (tmp[i] + (values[j] / windowSize));
                    j++;
                };
                i++;
            };
            return (tmp);
        }
        public static function createBins(values:Vector.<Number>, binSize:uint):Vector.<Vector.<Number>>{
            var bin:Vector.<Number>;
            var j:int;
            var tmp:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
            var i:int;
            while (i < (values.length / binSize)) {
                bin = new Vector.<Number>();
                j = (i * binSize);
                while (j < ((i + 1) * binSize)) {
                    if (j < values.length){
                        bin.push(values[j]);
                    } else {
                        if (bin.length > 0){
                            tmp.push(bin);
                        };
                        return (tmp);
                    };
                    j++;
                };
                tmp.push(bin);
                i++;
            };
            return (tmp);
        }
        public static function toFixed(values:Vector.<Number>, fixedValue:int=2):Vector.<Number>{
            var i:int;
            while (i < values.length) {
                values[i] = Number(values[i].toFixed(fixedValue));
                i++;
            };
            return (values);
        }
        public static function sum(values:Vector.<Number>):Number{
            var n:Number;
            var sum:Number = 0;
            for each (n in values) {
                sum = (sum + n);
            };
            return (sum);
        }
        public static function rootMeanSquare(values:Vector.<Number>):Number{
            var n:Number;
            var sum:Number = 0;
            for each (n in values) {
                sum = (sum + (n * n));
            };
            return (Math.sqrt((sum / values.length)));
        }
        public static function median(values:Vector.<Number>):Number{
            if (values.length == 0){
                return (NaN);
            };
            values.sort(medianSort);
            var mid:int = (values.length * 0.5);
            if ((values.length % 2) == 1){
                return (values[mid]);
            };
            return (((values[(mid - 1)] + values[mid]) * 0.5));
        }
        private static function medianSort(a:Number, b:Number):Number{
            return ((a - b));
        }
        public static function averageSum(values:Vector.<Number>, length:Number=1):Vector.<Number>{
            var binSum:Number;
            var bins:Vector.<Vector.<Number>>;
            var bin:Vector.<Number>;
            var tmp:Vector.<Number> = new Vector.<Number>();
            if (length == 1){
                binSum = sum(values);
                tmp.push((binSum / values.length));
            } else {
                bins = createBins(values, length);
                for each (bin in bins) {
                    binSum = sum(bin);
                    tmp.push((binSum / bin.length));
                };
            };
            return (tmp);
        }
        public static function averageRms(values:Vector.<Number>, length:Number=1):Vector.<Number>{
            var binSum:Number;
            var bins:Vector.<Vector.<Number>>;
            var bin:Vector.<Number>;
            var tmp:Vector.<Number> = new Vector.<Number>();
            if (length == 1){
                binSum = rootMeanSquare(values);
                tmp.push((binSum / values.length));
            } else {
                bins = createBins(values, length);
                for each (bin in bins) {
                    binSum = rootMeanSquare(bin);
                    tmp.push((binSum / bin.length));
                };
            };
            return (tmp);
        }
        public static function normallizeMinMax(values:Vector.<Number>):Vector.<Number>{
            var tmp:Vector.<Number> = new Vector.<Number>();
            var min:Number = Number.POSITIVE_INFINITY;
            var max:Number = Number.NEGATIVE_INFINITY;
            var i:int;
            while (i < values.length) {
                if (values[i] < min){
                    min = values[i];
                };
                if (values[i] > max){
                    max = values[i];
                };
                i++;
            };
            i = 0;
            while (i < values.length) {
                tmp.push(map(values[i], min, max, 0, 1));
                i++;
            };
            return (tmp);
        }
        public static function normallizeAbsolute(values:Vector.<Number>):Vector.<Number>{
            var tmp:Vector.<Number> = new Vector.<Number>();
            var sum:Number = 0;
            var i:int;
            while (i < values.length) {
                sum = (sum + values[i]);
                i++;
            };
            var div:Number = (1 / sum);
            i = 0;
            while (i < values.length) {
                tmp.push((values[i] * div));
                i++;
            };
            return (tmp);
        }
        public static function localMaximum(values:Vector.<Number>):Vector.<Number>{
            var tmp:Vector.<Number> = new Vector.<Number>();
            var max:Number = max(values);
            var div:Number = (1 / max);
            var i:int;
            while (i < values.length) {
                tmp.push((values[i] * div));
                i++;
            };
            return (tmp);
        }
        public static function max(values:Vector.<Number>):Number{
            var max:Number = Number.NEGATIVE_INFINITY;
            var i:int;
            while (i < values.length) {
                if (values[i] > max){
                    max = values[i];
                };
                i++;
            };
            return (max);
        }
        public static function min(values:Vector.<Number>):Number{
            var min:Number = Number.POSITIVE_INFINITY;
            var i:int;
            while (i < values.length) {
                if (values[i] < min){
                    min = values[i];
                };
                i++;
            };
            return (min);
        }
        public static function compress(values:Vector.<Number>, length:uint):Vector.<Number>{
            var i:Number;
            var diff:uint;
            var tmp:Vector.<Number> = new Vector.<Number>();
            if (values.length == 1){
                i = length;
                while (i--) {
                    tmp.push(values[0]);
                };
                return (tmp);
            };
            var inputLength:uint = (values.length - 2);
            var outputLength:uint = (length - 2);
            tmp.push(values[0]);
            i = 0;
            var j:int;
            while (j < inputLength) {
                diff = (((i + 1) * inputLength) - ((j + 1) * outputLength));
                if (diff < (inputLength / 2)){
                    i++;
                    var _temp1 = j;
                    j = (j + 1);
                    tmp.push(values[_temp1]);
                } else {
                    j++;
                };
            };
            tmp.push(values[(inputLength + 1)]);
            return (tmp);
        }
        public static function compress2D(u:Vector.<Number>, v:Vector.<Number>, length0:uint, length1:uint):Vector.<Number>{
            var j:int;
            var _u:Vector.<Number> = compress(u, length0);
            var _v:Vector.<Number> = compress(v, length1);
            var tmp:Vector.<Number> = new Vector.<Number>();
            var i:int;
            while (i < length0) {
                j = 0;
                while (j < length1) {
                    tmp.push(_u[i], _v[j]);
                    j++;
                };
                i++;
            };
            return (tmp);
        }
        public static function compress3D(u:Vector.<Number>, v:Vector.<Number>, w:Vector.<Number>, length0:uint, length1:uint, length2:uint):Vector.<Number>{
            var j:int;
            var k:int;
            var _u:Vector.<Number> = compress(u, length0);
            var _v:Vector.<Number> = compress(v, length1);
            var _w:Vector.<Number> = compress(w, length2);
            var tmp:Vector.<Number> = new Vector.<Number>();
            var i:int;
            while (i < length0) {
                j = 0;
                while (j < length1) {
                    k = 0;
                    while (k < length2) {
                        tmp.push(_u[i], _v[j], _w[k]);
                        k++;
                    };
                    j++;
                };
                i++;
            };
            return (tmp);
        }
        public static function expandColors(values:Vector.<uint>, length:uint, loop:Boolean=false):Vector.<uint>{
            var i:Number;
            var val0:Number;
            var val1:Number;
            var delta:Number;
            var j:Number;
            var tmp:Vector.<uint> = new Vector.<uint>();
            if (values.length == 1){
                i = length;
                while (i--) {
                    tmp.push(values[0]);
                };
                return (tmp);
            };
            if (loop){
                values.push(values[0]);
            };
            var step:Number = (1 / ((values.length - 1) / length));
            i = 0;
            while (i < (length - 1)) {
                val0 = values[int((i / step))];
                val1 = values[(int((i / step)) + 1)];
                delta = (((i + step))>length) ? (length - i) : step;
                j = 0;
                while (j < delta) {
                    tmp.push(((((0xFF << 24) | (lrp((j / delta), ((val0 >> 16) & 0xFF), ((val1 >> 16) & 0xFF)) << 16)) | (lrp((j / delta), ((val0 >> 8) & 0xFF), ((val1 >> 8) & 0xFF)) << 8)) | lrp((j / delta), (val0 & 0xFF), (val1 & 0xFF))));
                    j++;
                };
                i = (i + step);
            };
            while (tmp.length < length) {
                tmp.push(values[(values.length - 1)]);
            };
            if (loop){
                values.pop();
            };
            return (tmp);
        }
        public static function expand(values:Vector.<Number>, length:uint, lerp:Boolean=true):Vector.<Number>{
            var i:Number;
            var id0:int;
            var id1:int;
            var _t:Number;
            var delta:Number;
            var tmp:Vector.<Number> = new Vector.<Number>();
            if (values.length == 1){
                i = length;
                while (i--) {
                    tmp.push(values[0]);
                };
                return (tmp);
            };
            var step:Number = (1 / length);
            tmp.push(values[0]);
            var t:Number = step;
            while (t < (1 - step)) {
                if (lerp){
                    id0 = int(((values.length - 1) * t));
                    id1 = (id0 + 1);
                    delta = (1 / (values.length - 1));
                    _t = ((t - (id0 * delta)) / delta);
                    tmp.push(lrp(_t, values[id0], values[id1]));
                } else {
                    id0 = int((values.length * t));
                    tmp.push(values[id0]);
                };
                t = (t + step);
            };
            tmp.push(values[(values.length - 1)]);
            return (tmp);
        }
        public static function expand2D(u:Vector.<Number>, v:Vector.<Number>, length0:uint, length1:uint):Vector.<Number>{
            var j:int;
            var _u:Vector.<Number> = expand(u, length0);
            var _v:Vector.<Number> = expand(v, length1);
            var tmp:Vector.<Number> = new Vector.<Number>();
            var i:int;
            while (i < length0) {
                j = 0;
                while (j < length1) {
                    tmp.push(_u[i], _v[j]);
                    j++;
                };
                i++;
            };
            return (tmp);
        }
        public static function expand3D(u:Vector.<Number>, v:Vector.<Number>, w:Vector.<Number>, length0:uint, length1:uint, length2:uint):Vector.<Number>{
            var j:int;
            var k:int;
            var _u:Vector.<Number> = expand(u, length0);
            var _v:Vector.<Number> = expand(v, length1);
            var _w:Vector.<Number> = expand(w, length2);
            var tmp:Vector.<Number> = new Vector.<Number>();
            var i:int;
            while (i < length0) {
                j = 0;
                while (j < length1) {
                    k = 0;
                    while (k < length2) {
                        tmp.push(_u[i], _v[j], _w[k]);
                        k++;
                    };
                    j++;
                };
                i++;
            };
            return (tmp);
        }
        public static function nrm(t:Number, min:Number, max:Number):Number{
            return (((t - min) / (max - min)));
        }
        public static function lrp(t:Number, min:Number, max:Number):Number{
            return ((min + ((max - min) * t)));
        }
        public static function map(t:Number, mi0:Number, ma0:Number, mi1:Number, ma1:Number):Number{
            return (lrp(nrm(t, mi0, ma0), mi1, ma1));
        }
        public static function interpolateColorsCompact(a:int, b:int, lerp:Number):int{
            var MASK1:int = 0xFF00FF;
            var MASK2:int = 0xFF00;
            var f2:int = (0x0100 * lerp);
            var f1:int = (0x0100 - f2);
            return (((((((a & MASK1) * f1) + ((b & MASK1) * f2)) >> 8) & MASK1) | (((((a & MASK2) * f1) + ((b & MASK2) * f2)) >> 8) & MASK2)));
        }

    }
}//package biga.utils 
