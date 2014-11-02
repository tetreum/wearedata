/**

pushPageview('page');

*/

function pushPageview(pageGA){
	//_gaq.push(['_trackPageview',pageGA]);
    tc_events_2(this,'page',{'URL':pageGA});
}


/**

pushEvent( "'london', 'networks', 'mobile', 0" );

*/

function pushEvent(param)
{

    var array = param.split( ',' );
    //_gaq.push(['_trackEvent', array[ 0 ], array[ 1 ], array[ 2 ], parseInt( array[ 3 ] ) ] );
	tc_events_2(this,'event',{'city':array[ 0 ],'category': array[ 1 ],'data_type':array[ 2 ],'entier':parseInt( array[ 3 ] )});

}



