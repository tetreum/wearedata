package mx.core {
    import flash.display.*;
    import flash.geom.*;
    import flash.accessibility.*;
    import flash.events.*;

    public interface IFlexDisplayObject extends IBitmapDrawable, IEventDispatcher {

        function get root():DisplayObject;
        function get stage():Stage;
        function get name():String;
        function set name(_arg1:String):void;
        function get parent():DisplayObjectContainer;
        function get mask():DisplayObject;
        function set mask(_arg1:DisplayObject):void;
        function get visible():Boolean;
        function set visible(_arg1:Boolean):void;
        function get x():Number;
        function set x(_arg1:Number):void;
        function get y():Number;
        function set y(_arg1:Number):void;
        function get scaleX():Number;
        function set scaleX(_arg1:Number):void;
        function get scaleY():Number;
        function set scaleY(_arg1:Number):void;
        function get mouseX():Number;
        function get mouseY():Number;
        function get rotation():Number;
        function set rotation(_arg1:Number):void;
        function get alpha():Number;
        function set alpha(_arg1:Number):void;
        function get width():Number;
        function set width(_arg1:Number):void;
        function get height():Number;
        function set height(_arg1:Number):void;
        function get cacheAsBitmap():Boolean;
        function set cacheAsBitmap(_arg1:Boolean):void;
        function get opaqueBackground():Object;
        function set opaqueBackground(_arg1:Object):void;
        function get scrollRect():Rectangle;
        function set scrollRect(_arg1:Rectangle):void;
        function get filters():Array;
        function set filters(_arg1:Array):void;
        function get blendMode():String;
        function set blendMode(_arg1:String):void;
        function get transform():Transform;
        function set transform(_arg1:Transform):void;
        function get scale9Grid():Rectangle;
        function set scale9Grid(_arg1:Rectangle):void;
        function globalToLocal(_arg1:Point):Point;
        function localToGlobal(_arg1:Point):Point;
        function getBounds(_arg1:DisplayObject):Rectangle;
        function getRect(_arg1:DisplayObject):Rectangle;
        function get loaderInfo():LoaderInfo;
        function hitTestObject(_arg1:DisplayObject):Boolean;
        function hitTestPoint(_arg1:Number, _arg2:Number, _arg3:Boolean=false):Boolean;
        function get accessibilityProperties():AccessibilityProperties;
        function set accessibilityProperties(_arg1:AccessibilityProperties):void;
        function get measuredHeight():Number;
        function get measuredWidth():Number;
        function move(_arg1:Number, _arg2:Number):void;
        function setActualSize(_arg1:Number, _arg2:Number):void;

    }
}//package mx.core 
