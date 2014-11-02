package com.facebook.graph.core {
    import flash.external.*;

    public class FacebookJSBridge {

        public static const NS:String = "FBAS";

        private const script_js:XML;

        public function FacebookJSBridge(){
            this.script_js = <script>
				<![CDATA[
					function() {
			
						FBAS = {
							
							setSWFObjectID: function( swfObjectID ) {																
								FBAS.swfObjectID = swfObjectID;
							},
								
							init: function( opts ) {
								var options = JSON.parse( opts );
								FB.init( options );
								FB.Event.subscribe( 'auth.authResponseChange', function( response ) {
									FBAS.updateSwfAuthResponse( response.authResponse );
								} );
							},
								
							setCanvasAutoResize: function( autoSize, interval ) {
								FB.Canvas.setAutoResize( autoSize, interval );
							},
								
							setCanvasSize: function( width, height ) {
								FB.Canvas.setSize( { width: width, height: height } );
							},
								
							login: function( opts ) {
								FB.login( FBAS.handleUserLogin, JSON.parse( opts ) );
							},
								
							addEventListener: function( event ) {
								FB.Event.subscribe( event, function( response ) {
									FBAS.getSwf().handleJsEvent( event, JSON.stringify( response ) );
								} );
							},
								
							handleUserLogin: function( response ) {
								FBAS.updateSwfAuthResponse( response.authResponse );
							},
								
							logout: function() {
								FB.logout( FBAS.handleUserLogout );
							},
							
							handleUserLogout: function( response ) {
								swf = FBAS.getSwf();
								swf.logout();
							},
								
							ui: function( params ) {
								obj = JSON.parse( params );								
								method = obj.method;
								cb = function( response ) { FBAS.getSwf().uiResponse( JSON.stringify( response ), method ); }
								FB.ui( obj, cb );
							},
							
							getAuthResponse: function() {
								authResponse = FB.getAuthResponse();
								return JSON.stringify( authResponse );
							},
			
							getLoginStatus: function() {
								FB.getLoginStatus( function( response ) {
									if( response.authResponse ) {
										FBAS.updateSwfAuthResponse( response.authResponse );
									} else {
										FBAS.updateSwfAuthResponse( null );
									}
								} );
							},
								
							getSwf: function getSwf() {								
								return document.getElementById( FBAS.swfObjectID );								
							},
							
							updateSwfAuthResponse: function( response ) {								
								swf = FBAS.getSwf();
								
								if( response == null ) {
									swf.authResponseChange( null );
								} else {
									swf.authResponseChange( JSON.stringify( response ) );
								}
							}
						};
					}
				]]>
			</script>
            ;
            super();
            try {
                if (ExternalInterface.available){
                    ExternalInterface.call(this.script_js);
                    ExternalInterface.call("FBAS.setSWFObjectID", ExternalInterface.objectID);
                };
            } catch(error:Error) {
            };
        }
    }
}//package com.facebook.graph.core 
