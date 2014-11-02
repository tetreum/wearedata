package wd.utils {
    import flash.system.*;
    import flash.external.*;
    import flash.net.*;

    public class JsPopup {

        public static function open(url:String, name:String=null, width:int=600, height:int=600, sizeable:Boolean=true, scrollbars:Boolean=true):void{
            var top:int = ((Capabilities.screenResolutionY - height) / 2);
            var left:int = ((Capabilities.screenResolutionX - width) / 2);
            var params:String = ((((((("top=" + top) + ",left=") + left) + ",width=") + width) + ",height=") + height);
            if (sizeable){
                params = (params + ",resizable=yes");
            };
            if (scrollbars){
                params = (params + ",scrollbars=yes");
            };
            if (name == null){
                name = ("pop" + int((Math.random() * 65536)));
            };
            var script:XML =  <![CDATA[
				function(url, name, params) {
					//if (navigator.userAgent.toLowerCase().indexOf("chrome") < 0) {
						return window.open(url, name, params) != null;
					/*}
					else return false;*/
				}
			]]>
            ;
            if (ExternalInterface.available){
                if (!(ExternalInterface.call(script, url, name, params))){
                    navigateToURL(new URLRequest(url));
                };
            } else {
                navigateToURL(new URLRequest(url));
            };
        }

    }
}//package wd.utils 
