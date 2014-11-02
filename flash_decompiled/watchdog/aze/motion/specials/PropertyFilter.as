package aze.motion.specials {
    import aze.motion.*;
    import flash.filters.*;
    import flash.display.*;

    public class PropertyFilter extends EazeSpecial {

        public static var fixedProp:Object = {
            quality:true,
            color:true
        };

        private var properties:Array;
        private var fvalue:BitmapFilter;
        private var start:Object;
        private var delta:Object;
        private var fColor:Object;
        private var startColor:Object;
        private var deltaColor:Object;
        private var removeWhenComplete:Boolean;
        private var isNewFilter:Boolean;
        private var filterClass:Class;

        public function PropertyFilter(target:Object, property, value, next:EazeSpecial){
            var prop:String;
            var val:*;
            super(target, property, value, next);
            this.filterClass = this.resolveFilterClass(property);
            var disp:DisplayObject = DisplayObject(target);
            var current:BitmapFilter = PropertyFilter.getCurrentFilter(this.filterClass, disp, false);
            if (!(current)){
                this.isNewFilter = true;
                current = new this.filterClass();
            };
            this.properties = [];
            this.fvalue = current.clone();
            for (prop in value) {
                val = value[prop];
                if (prop == "remove"){
                    this.removeWhenComplete = val;
                } else {
                    if ((((prop == "color")) && (!(this.isNewFilter)))){
                        this.fColor = {
                            r:((val >> 16) & 0xFF),
                            g:((val >> 8) & 0xFF),
                            b:(val & 0xFF)
                        };
                    };
                    this.fvalue[prop] = val;
                    this.properties.push(prop);
                };
            };
        }
        public static function register():void{
            EazeTween.specialProperties["blurFilter"] = PropertyFilter;
            EazeTween.specialProperties["glowFilter"] = PropertyFilter;
            EazeTween.specialProperties["dropShadowFilter"] = PropertyFilter;
            EazeTween.specialProperties[BlurFilter] = PropertyFilter;
            EazeTween.specialProperties[GlowFilter] = PropertyFilter;
            EazeTween.specialProperties[DropShadowFilter] = PropertyFilter;
        }
        public static function getCurrentFilter(filterClass:Class, disp:DisplayObject, remove:Boolean):BitmapFilter{
            var index:int;
            var filters:Array;
            var filter:BitmapFilter;
            if (disp.filters){
                filters = disp.filters;
                index = 0;
                while (index < filters.length) {
                    if ((filters[index] is filterClass)){
                        if (remove){
                            filter = filters.splice(index, 1)[0];
                            disp.filters = filters;
                            return (filter);
                        };
                        return (filters[index]);
                    };
                    index++;
                };
            };
            return (null);
        }
        public static function addFilter(disp:DisplayObject, filter:BitmapFilter):void{
            var filters:Array = ((disp.filters) || ([]));
            filters.push(filter);
            disp.filters = filters;
        }

        private function resolveFilterClass(property):Class{
            if ((property is Class)){
                return (property);
            };
            switch (property){
                case "blurFilter":
                    return (BlurFilter);
                case "glowFilter":
                    return (GlowFilter);
                case "dropShadowFilter":
                    return (DropShadowFilter);
            };
            return (BlurFilter);
        }
        override public function init(reverse:Boolean):void{
            var begin:BitmapFilter;
            var end:BitmapFilter;
            var curColor:Object;
            var endColor:Object;
            var val:*;
            var prop:String;
            var disp:DisplayObject = DisplayObject(target);
            var current:BitmapFilter = PropertyFilter.getCurrentFilter(this.filterClass, disp, true);
            if (!(current)){
                current = new this.filterClass();
            };
            if (this.fColor){
                val = current["color"];
                curColor = {
                    r:((val >> 16) & 0xFF),
                    g:((val >> 8) & 0xFF),
                    b:(val & 0xFF)
                };
            };
            if (reverse){
                begin = this.fvalue;
                end = current;
                this.startColor = this.fColor;
                endColor = curColor;
            } else {
                begin = current;
                end = this.fvalue;
                this.startColor = curColor;
                endColor = this.fColor;
            };
            this.start = {};
            this.delta = {};
            var i:int;
            for (;i < this.properties.length;i++) {
                prop = this.properties[i];
                val = this.fvalue[prop];
                if ((val is Boolean)){
                    current[prop] = val;
                    this.properties[i] = null;
                } else {
                    if (this.isNewFilter){
                        if ((prop in fixedProp)){
                            current[prop] = val;
                            this.properties[i] = null;
                            continue;
                        };
                        current[prop] = 0;
                    } else {
                        if ((((prop == "color")) && (this.fColor))){
                            this.deltaColor = {
                                r:(endColor.r - this.startColor.r),
                                g:(endColor.g - this.startColor.g),
                                b:(endColor.b - this.startColor.b)
                            };
                            this.properties[i] = null;
                            continue;
                        };
                    };
                    this.start[prop] = begin[prop];
                    this.delta[prop] = (end[prop] - this.start[prop]);
                };
            };
            this.fvalue = null;
            this.fColor = null;
            PropertyFilter.addFilter(disp, begin);
        }
        override public function update(ke:Number, isComplete:Boolean):void{
            var prop:String;
            var disp:DisplayObject = DisplayObject(target);
            var current:BitmapFilter = PropertyFilter.getCurrentFilter(this.filterClass, disp, true);
            if (((this.removeWhenComplete) && (isComplete))){
                disp.filters = disp.filters;
                return;
            };
            if (!(current)){
                current = new this.filterClass();
            };
            var i:int;
            while (i < this.properties.length) {
                prop = this.properties[i];
                if (prop){
                    current[prop] = (this.start[prop] + (ke * this.delta[prop]));
                };
                i++;
            };
            if (this.startColor){
                current["color"] = ((((this.startColor.r + (ke * this.deltaColor.r)) << 16) | ((this.startColor.g + (ke * this.deltaColor.g)) << 8)) | (this.startColor.b + (ke * this.deltaColor.b)));
            };
            PropertyFilter.addFilter(disp, current);
        }
        override public function dispose():void{
            this.filterClass = null;
            this.start = (this.delta = null);
            this.startColor = (this.deltaColor = null);
            this.fvalue = null;
            this.fColor = null;
            this.properties = null;
            super.dispose();
        }

    }
}//package aze.motion.specials 
