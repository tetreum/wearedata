package aze.motion.specials {
    import aze.motion.*;
    import flash.filters.*;
    import flash.display.*;

    public class PropertyColorMatrix extends EazeSpecial {

        private var removeWhenComplete:Boolean;
        private var colorMatrix:ColorMatrix;
        private var delta:Array;
        private var start:Array;
        private var temp:Array;

        public function PropertyColorMatrix(target:Object, property, value, next:EazeSpecial){
            var tint:uint;
            super(target, property, value, next);
            this.colorMatrix = new ColorMatrix();
            if (value.brightness){
                this.colorMatrix.adjustBrightness((value.brightness * 0xFF));
            };
            if (value.contrast){
                this.colorMatrix.adjustContrast(value.contrast);
            };
            if (value.hue){
                this.colorMatrix.adjustHue(value.hue);
            };
            if (value.saturation){
                this.colorMatrix.adjustSaturation((value.saturation + 1));
            };
            if (value.colorize){
                tint = ((("tint" in value)) ? uint(value.tint) : 0xFFFFFF);
                this.colorMatrix.colorize(tint, value.colorize);
            };
            this.removeWhenComplete = value.remove;
        }
        public static function register():void{
            EazeTween.specialProperties["colorMatrixFilter"] = PropertyColorMatrix;
            EazeTween.specialProperties[ColorMatrixFilter] = PropertyColorMatrix;
        }

        override public function init(reverse:Boolean):void{
            var begin:Array;
            var end:Array;
            var disp:DisplayObject = DisplayObject(target);
            var current:ColorMatrixFilter = (PropertyFilter.getCurrentFilter(ColorMatrixFilter, disp, true) as ColorMatrixFilter);
            if (!(current)){
                current = new ColorMatrixFilter();
            };
            if (reverse){
                end = current.matrix;
                begin = this.colorMatrix.matrix;
            } else {
                end = this.colorMatrix.matrix;
                begin = current.matrix;
            };
            this.delta = new Array(20);
            var i:int;
            while (i < 20) {
                this.delta[i] = (end[i] - begin[i]);
                i++;
            };
            this.start = begin;
            this.temp = new Array(20);
            PropertyFilter.addFilter(disp, new ColorMatrixFilter(begin));
        }
        override public function update(ke:Number, isComplete:Boolean):void{
            var disp:DisplayObject = DisplayObject(target);
            (PropertyFilter.getCurrentFilter(ColorMatrixFilter, disp, true) as ColorMatrixFilter);
            if (((this.removeWhenComplete) && (isComplete))){
                disp.filters = disp.filters;
                return;
            };
            var i:int;
            while (i < 20) {
                this.temp[i] = (this.start[i] + (ke * this.delta[i]));
                i++;
            };
            PropertyFilter.addFilter(disp, new ColorMatrixFilter(this.temp));
        }
        override public function dispose():void{
            this.colorMatrix = null;
            this.delta = null;
            this.start = null;
            this.temp = null;
            super.dispose();
        }

    }
}//package aze.motion.specials 

import flash.filters.*;

class ColorMatrix {

    private static const LUMA_R:Number = 0.212671;
    private static const LUMA_G:Number = 0.71516;
    private static const LUMA_B:Number = 0.072169;
    private static const LUMA_R2:Number = 0.3086;
    private static const LUMA_G2:Number = 0.6094;
    private static const LUMA_B2:Number = 0.082;
    private static const ONETHIRD:Number = 0.333333333333333;
    private static const IDENTITY:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
    private static const RAD:Number = 0.0174532925199433;

    public var matrix:Array;

    public function ColorMatrix(mat:Object=null){
        super();
        if ((mat is ColorMatrix)){
            this.matrix = mat.matrix.concat();
        } else {
            if ((mat is Array)){
                this.matrix = mat.concat();
            } else {
                this.reset();
            };
        };
    }
    public function reset():void{
        this.matrix = IDENTITY.concat();
    }
    public function adjustSaturation(s:Number):void{
        var sInv:Number;
        var irlum:Number;
        var iglum:Number;
        var iblum:Number;
        sInv = (1 - s);
        irlum = (sInv * LUMA_R);
        iglum = (sInv * LUMA_G);
        iblum = (sInv * LUMA_B);
        this.concat([(irlum + s), iglum, iblum, 0, 0, irlum, (iglum + s), iblum, 0, 0, irlum, iglum, (iblum + s), 0, 0, 0, 0, 0, 1, 0]);
    }
    public function adjustContrast(r:Number, g:Number=NaN, b:Number=NaN):void{
        if (isNaN(g)){
            g = r;
        };
        if (isNaN(b)){
            b = r;
        };
        r = (r + 1);
        g = (g + 1);
        b = (b + 1);
        this.concat([r, 0, 0, 0, (128 * (1 - r)), 0, g, 0, 0, (128 * (1 - g)), 0, 0, b, 0, (128 * (1 - b)), 0, 0, 0, 1, 0]);
    }
    public function adjustBrightness(r:Number, g:Number=NaN, b:Number=NaN):void{
        if (isNaN(g)){
            g = r;
        };
        if (isNaN(b)){
            b = r;
        };
        this.concat([1, 0, 0, 0, r, 0, 1, 0, 0, g, 0, 0, 1, 0, b, 0, 0, 0, 1, 0]);
    }
    public function adjustHue(degrees:Number):void{
        degrees = (degrees * RAD);
        var cos:Number = Math.cos(degrees);
        var sin:Number = Math.sin(degrees);
        this.concat([((LUMA_R + (cos * (1 - LUMA_R))) + (sin * -(LUMA_R))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * -(LUMA_G))), ((LUMA_B + (cos * -(LUMA_B))) + (sin * (1 - LUMA_B))), 0, 0, ((LUMA_R + (cos * -(LUMA_R))) + (sin * 0.143)), ((LUMA_G + (cos * (1 - LUMA_G))) + (sin * 0.14)), ((LUMA_B + (cos * -(LUMA_B))) + (sin * -0.283)), 0, 0, ((LUMA_R + (cos * -(LUMA_R))) + (sin * -((1 - LUMA_R)))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * LUMA_G)), ((LUMA_B + (cos * (1 - LUMA_B))) + (sin * LUMA_B)), 0, 0, 0, 0, 0, 1, 0]);
    }
    public function colorize(rgb:int, amount:Number=1):void{
        var r:Number;
        var g:Number;
        var b:Number;
        var inv_amount:Number;
        r = (((rgb >> 16) & 0xFF) / 0xFF);
        g = (((rgb >> 8) & 0xFF) / 0xFF);
        b = ((rgb & 0xFF) / 0xFF);
        inv_amount = (1 - amount);
        this.concat([(inv_amount + ((amount * r) * LUMA_R)), ((amount * r) * LUMA_G), ((amount * r) * LUMA_B), 0, 0, ((amount * g) * LUMA_R), (inv_amount + ((amount * g) * LUMA_G)), ((amount * g) * LUMA_B), 0, 0, ((amount * b) * LUMA_R), ((amount * b) * LUMA_G), (inv_amount + ((amount * b) * LUMA_B)), 0, 0, 0, 0, 0, 1, 0]);
    }
    public function get filter():ColorMatrixFilter{
        return (new ColorMatrixFilter(this.matrix));
    }
    public function concat(mat:Array):void{
        var x:int;
        var y:int;
        var temp:Array = [];
        var i:int;
        y = 0;
        while (y < 4) {
            x = 0;
            while (x < 5) {
                temp[int((i + x))] = (((((Number(mat[i]) * Number(this.matrix[x])) + (Number(mat[int((i + 1))]) * Number(this.matrix[int((x + 5))]))) + (Number(mat[int((i + 2))]) * Number(this.matrix[int((x + 10))]))) + (Number(mat[int((i + 3))]) * Number(this.matrix[int((x + 15))]))) + (((x == 4)) ? Number(mat[int((i + 4))]) : 0));
                x++;
            };
            i = (i + 5);
            y++;
        };
        this.matrix = temp;
    }

}
