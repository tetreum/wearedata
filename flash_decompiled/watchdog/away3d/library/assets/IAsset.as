package away3d.library.assets {
    import flash.events.*;

    public interface IAsset extends IEventDispatcher {

        function get name():String;
        function set name(_arg1:String):void;
        function get assetNamespace():String;
        function get assetType():String;
        function get assetFullPath():Array;
        function assetPathEquals(_arg1:String, _arg2:String):Boolean;
        function resetAssetPath(_arg1:String, _arg2:String=null, _arg3:Boolean=true):void;
        function dispose():void;

    }
}//package away3d.library.assets 
