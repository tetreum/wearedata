<?php

require_once dirname(__FILE__) . '/ClassLoader.php';

/* 
 * main entry point (gateway) for service calls. instanciates the gateway class and uses it to handle the call.
 * 
 * @package Amfphp
 * @author Ariel Sommeria-klein
 */
$gateway = Amfphp_Core_HttpRequestGatewayFactory::createGateway();

//use this to change the current folder to the services folder. Be careful of the case.
//This was done in 1.9 and can be used to support relative includes, and should be used when upgrading from 1.9 to 2.0 if you use relative includes
//chdir(dirname(__FILE__) . '/Services');

$gateway->service();
$gateway->output();
die();
?>

amfserver.php (WatchDog.getMetro)

	Content Object
		+timespent String 0.36 sec
		+time String 13:30:17
		+station Array
			-id String (ex: 34)(mateixa id que la clau de l'array)
			-ref String (ex: 45656)
			-passengers String (ex 1008)

		+line Array
		+trips Array
			-[0] String(ex: 1393958362|5|13:36:00|120|2058569149|10013094370912363|49)
			-[1] String(ex: 1065328272|12|13:38:00|60|2011584683|14613647260942701|44)

amfserver.php (WatchDog.connected)

	Content boolean

amfserver.php (WatchDog.getVeloStation)

	Content Mixed Array
		+bicycles	Array
			[0] Mixed Array
				-id String (ex 345)
				-tags Mixed Array
					.timestamp	Number	1372504985
					.updated	String	29/06/2013 | 13 h 23 m 05 s
					.available	String	22
					free	String	0
		+item_count	Integer	26
		+nb_page	Number	1
		+current_page	Integer	1
		+next_page	Null	
	
amfserver.php (WatchDog.getRails)

	Content Mixed Array
		+rails Mixed Array
			id	String	175225
			ref	String	140284206
			lat	String	51.494888
			lng	String	-0.143779
			vertex	String	-0.144171,51.494350,-0.143598,51.495136,-0.143568,51.495178
		+item_count	Integer	26
		+nb_page	Number	1
		+current_page	Integer	1
		+next_page	Null
		
amfserver.php (WatchDog.getParcs)

	+parcs Array
		-id	String	148086
		-ref	String	113115230
		-lat	String	51.496918
		-lng	String	-0.134264
		-index	Array	
			[0]	Integer	0
			[1]	Integer	1
			[2]	Integer	2
			[3]	Integer	0
			[4]	Integer	2
			[5]	Integer	3
		-vertex	Array	
			[0]	String	-0.134352
			[1]	Integer	0
	+item_count	Integer	26
	+nb_page	Number	1
	+current_page	Integer	1
	+next_page	Null

amfserver.php (WatchDog.getAtms)

	+atms	Array	
	[0]	Mixed Array	
		-id	String	20109
		-height	String	0.000000
		-lat	String	51.496902
		-lng	String	-0.135599
		-tags	Mixed Array	
			.name	String	Barclays
			.amenity	String	bank
	+item_count	Integer	26
	+nb_page	Number	1
	+current_page	Integer	1
	+next_page	Null

amfserver.php (WatchDog.getBuildings)
	+buildings	Array	
		[0]	Mixed Array	
		-id	String	1429401
		-complete	String	1
		-type	String	building
		-index	Array	
		vertex	Array	
		-height	String	0.000000
		-lat	String	51.497124
		-lng	String	-0.136107
		-tags	Mixed Array	
			.name	String	House of Fraser

amfserver.php (WatchDog.getCameras)

	+cameras
		[0]	Mixed Array	
			-id	String	55338
			-lat	String	51.512535
			-lng	String	-0.105389
			-tags	Mixed Array	
				.name	String	City of London Police
				.man_made	String	surveillance
				.surveillance	String	outdoor

amfserver.php (WatchDog.getElectromagnicals)


amfserver.php (WatchDog.getFlickrs)

	+flickrs	Array	
		[0]	Mixed Array	
			-id	String	76913352
			-lat	String	51.513683
			-lng	String	-0.099434
			-infos	String	<b>aperturismo (35034350889@N01)</b> - 27/06/2013 17:40<br/><img src=http://farm3.staticflickr.com/2893/9153059046_3f7ca1f6dc_z.jpg width=612 height=612>
			-tags	Mixed Array	
				.id	String	9153059046
				.owner	String	35034350889@N01
				.ownername	String	aperturismo
				.dateupload	String	1372347651
				.url_s	String	http://farm3.staticflickr.com/2893/9153059046_3f7ca1f6dc_z.jpg
				.width_s	String	612
				.height_s	String Reference	612

amfserver.php (WatchDog.getVenues)

	+places	Array	
		[0]	Mixed Array	
			-id	String	76802978
			-lat	String	51.512001
			-lng	String	-0.103683
			-name	String	The Black Friar
			-mayor	Mixed Array	
				user	String	Andrew G.
				userid	String	53995157
				count	Integer	3
				photo	String	https://irs2.4sqi.net/img/user/32x32/DGR3GKPQYYF0N1P1.jpg
			-tags	Mixed Array	
				.id	String	4ac518baf964a520d5a120e3
				.name	String Reference	The Black Friar
				.url	String	https://foursquare.com/v/the-black-friar/4ac518baf964a520d5a120e3
				.address	String	174 Queen Victoria St. - EC4V 4EG London - Greater London
				.categories	Array	
					[0]	Mixed Array	
						name	String	Pub
						icon	String	https://foursquare.com/img/categories_v2/nightlife/pub_32.png
				.checkins	Integer	1870
				.users	Integer	1377
				.likes	String	19 likes
				.rating	Number	8,74
				.photo	Mixed Array	
					width	Integer	540
					height	Integer	720
					url	String	https://irs2.4sqi.net/img/general/540x720/NJ9MIJ2h2bziZ7zbo5fw_nnzyOwdTACqkv_f-ZKi3uU.jpg
					user	String	Kieren M.
					userid	String	77607
				.description	String	
				.createdat	String	1254430906
				.shorturl	String	http://4sq.com/8Yxjf9
				.mayor	Mixed Array	
					user	String Reference	Andrew G.
					userid	String Reference	53995157
					count	Integer	3
					photo	String Reference	https://irs2.4sqi.net/img/user/32x32/DGR3GKPQYYF0N1P1.jpg

amfserver.php (WatchDog.getInstagrams)

	+instagrams	Array	
		[0]	Mixed Array	
			-id	String	76910303
			-lat	String	51.513668
			-lng	String	-0.101000
			-infos	String	<img src=http://images.ak.instagram.com/profiles/profile_36523432_75sq_1370162926.jpg width=30><b>alejandropachecosanchez</b> - 27/06/2013 11:52<br/>Dry ice<br/><img src='http://distilleryimage7.s3.amazonaws.com/5536bc94df0f11e280e022000ae9027c_5.jpg' width='612' height='612'>
			-tags	Mixed Array	
				.id	String	487434751715944171_36523432
				.profile_picture	String	http://images.ak.instagram.com/profiles/profile_36523432_75sq_1370162926.jpg
				.full_name	String	alejandropachecosanchez
				.username	String Reference	alejandropachecosanchez
				.userid	String	36523432
				.created_time	String	1372326772
				.caption	String	Dry ice
				.link	String	http://instagram.com/p/bDt1L7Nabr/
				.likes	Integer	0
				.comments	Integer	0
				.thumbnail	String	http://distilleryimage7.s3.amazonaws.com/5536bc94df0f11e280e022000ae9027c_5.jpg
				.picture	String	http://distilleryimage7.s3.amazonaws.com/5536bc94df0f11e280e022000ae9027c_7.jpg
				.width	Integer	612
				.height	Integer	612

amfserver.php (WatchDog.getAntennas)

	+antennas	Array	
		[0]	Mixed Array	
			-id	String	119157
			-lat	String	51.513897
			-lng	String	-0.102337
			-tags	Mixed Array	
				.ref	String	TQ3177781148
				.height	String	4
				.operator	String	GSM 900 / UMTS

amfserver.php (WatchDog.getRadars)
	
	+radars	Array	
		[0]	Mixed Array	
			-id	String	131162
			-lat	String	51.510986
			-lng	String	-0.095612
			-tags	Mixed Array	
				.name	Null	

amfserver.php (WatchDog.getToilets)

	+toilets	Array	
		[0]	Mixed Array	
			-id	String	56087
			-lat	String	51.514313
			-lng	String	-0.099343
			-tags	Array	
				.name	String	Paul's Walk
				.fee	String	yes
				.wheelchair	String	no
				.operator	String	Camden Council

amfserver.php (WatchDog.getSignals)

	+signals	Array	
		[0]	Mixed Array	
			-id	String	13903
			-height	String	0.000000
			-lat	String	51.514153
			-lng	String	-0.104387
			-tags	Mixed Array	
				.name	String	Ludgate Circus
				.highway	String	traffic_signals
				.crossing	String	island

amfserver.php (WatchDog.getTweets)

	+twitters	Array	
		[0]	Mixed Array	
			-id	String	76870662
			-lat	String	51.512283
			-lng	String	-0.102589
			-infos	String	<img src=http://a0.twimg.com/profile_images/1822998341/Amy_Kean2_normal.jpg width=30><b>Amy Charlotte Kean</b> - 29/06/2013 11:47<br/>@TommyCasswell Hahahaha.
			-tags	Mixed Array	
				.id	String	350913328496918529
				.profile_picture	String	http://a0.twimg.com/profile_images/1822998341/Amy_Kean2_normal.jpg
				.pseudo	String	keano81
				.full_name	String	Amy Charlotte Kean
				.from_user_id	String	16932797
				.created_time	Number	1372499231
				.caption	String	@TommyCasswell Hahahaha.
				.source	String	<a href="http://twitter.com/download/iphone" rel="nofollow">Twitter for iPhone</a>

amfserver.php (WatchDog.getStatistics)

	+id	String	81
	+ref	String	London Borough of Islington
	+tags	Object	
		-display	String	Islington
		-unemployment	String	9,8
		-inhabitants	String	206 100
		-salary_monthly	String	4 400
		-births	String	2 792
		-births_thousand	String	13,55
		-deaths	String	1 152
		-deaths_thousand	String	5,59
		-jobs	String	201 000
		-crimes_thousand	String	139
		-electricity	String	1 221 535

amfserver.php (WatchDog.Helo)

	boolean true

amfserver.php (WatchDog.getDistrict)

	[0]	Object	
		-id	String	53413
		-name	String	London Borough of Lambeth
		-vertex	String	51.467613,-0.15061900000000605,51.470467,-0.14324099999998907,51.470062,-0.1426770000000488,51.473091,-0.13691800000003695,51.472706,-0.1359099999999671,51.473644,-0.13448600000003808,51.474285,-0.13523099999997612,51.481182,-0.12994800000001305,51.482021,-0.12749600000006467,51.484467,-0.12636399999996684,51.484722,-0.12772700000004988,51.485603,-0.1290799999999308,51.495007,-0.12270399999999881,51.506012,-0.1205489999999827,51.508522,-0.11745799999994233,51.509632,-0.10914100000002236,51.506908,-0.10817599999995764,51.507065,-0.10736399999996138,51.504253,-0.10656599999992977,51.503372,-0.10639600000001792,51.50201,-0.10598700000002736,51.500347,-0.10835399999996298,51.496777,-0.11029499999995096,51.496449,-0.1114430000000084,51.495373,-0.11050699999998415,51.49332,-0.10479399999996986,51.49118,-0.10316000000000258,51.485744,-0.1082810000000336,51.48489,-0.10635800000000017,51.483521,-0.10682299999996303,51.480904,-0.10408600000005208,51.480206,-0.10806800000000294,51.476646,-0.10016999999993459,51.474213,-0.1005729999999403,51.469879,-0.09599800000000869,51.472015,-0.09302400000001398,51.465733,-0.09010599999999158,51.461033,-0.09232799999995223,51.457165,-0.09620199999994838,51.453777,-0.1011630000000423,51.450306,-0.10032200000000557,51.445461,-0.09509700000000976,51.439598,-0.09225800000001527,51.429001,-0.08768099999997503,51.428425,-0.08585600000003524,51.427662,-0.08579499999996187,51.423,-0.08347700000001623,51.423309,-0.0816939999999704,51.421848,-0.08089700000004996,51.422108,-0.07982900000001791,51.419991,-0.0785600000000386,51.41967,-0.08009200000003602,51.41967,-0.08333400000003621,51.41927,-0.08586400000001504,51.420547,-0.08904800000004798,51.422539,-0.09273400000006404,51.422577,-0.1057980000000498,51.42292,-0.11302699999998822,51.420578,-0.11571500000002288,51.418568,-0.12002200000006269,51.414917,-0.12312299999996412,51.414612,-0.12407400000006419,51.412632,-0.1257860000000619,51.412491,-0.12742800000000898,51.411999,-0.1278700000000299,51.41235,-0.13378099999999904,51.41098,-0.13407200000006014,51.413155,-0.14302999999995336,51.412388,-0.14486999999996897,51.412868,-0.1480900000000247,51.415348,-0.14434800000003634,51.415798,-0.14500999999995656,51.421104,-0.13785200000006625,51.425282,-0.13892599999996946,51.430454,-0.1383819999999787,51.430256,-0.13533200000006218,51.433826,-0.13645599999995284,51.433777,-0.1378580000000511,51.435444,-0.13969799999995303,51.437019,-0.13991299999997864,51.438824,-0.13750400000003538,51.440262,-0.13704699999993863,51.442005,-0.13590399999998226,51.441704,-0.13904200000001765,51.441837,-0.14362099999993916,51.445961,-0.14558899999997266,51.448704,-0.14464799999996103,51.450966,-0.14232800000002044,51.452339,-0.14773000000002412,51.457912,-0.1486649999999372,51.459362,-0.14939000000003944,51.461708,-0.1499300000000403,51.465885,-0.15123100000005252
	[1]	Object	
		-id	String	131019
		-name	String	Royal Borough of Kensington and Chelsea
		-vertex	String	51.530354,-0.22850300000004609,51.529919,-0.22768500000006497,51.530136,-0.22501699999997982,51.52914,-0.22071500000004107,51.527828,-0.21581500000002052,51.526718,-0.2155729999999494,51.526756,-0.2112610000000359,51.525944,-0.20617800000002262,51.523315,-0.20355799999992996,51.522346,-0.2015559999999823,51.52071,-0.2006340000000364,51.520573,-0.20371499999998832,51.517799,-0.2014880000000403,51.517979,-0.20074799999997595,51.516777,-0.1998949999999695,51.514549,-0.19920799999999872,51.515034,-0.1950729999999794,51.511692,-0.19365500000003522,51.511814,-0.1929850000000215,51.509869,-0.19214399999998477,51.510178,-0.18793400000004112,51.501793,-0.18425899999999729,51.501461,-0.18033600000001115,51.49778,-0.17957100000000992,51.49902,-0.16841499999998177,51.498299,-0.16764399999999569,51.498695,-0.16550600000005034,51.499241,-0.16580399999998008,51.50013,-0.16285800000002837,51.502232,-0.15859999999997854,51.49902,-0.15787399999999252,51.497513,-0.15604800000005525,51.493855,-0.15501500000004853,51.493202,-0.15598999999997432,51.491962,-0.15481799999997747,51.491451,-0.15582100000005994,51.489037,-0.15491799999995237,51.485485,-0.15000399999996716,51.484528,-0.1502699999999777,51.481686,-0.17092800000000352,51.48019,-0.17494799999997213,51.477554,-0.17781600000000708,51.477222,-0.18264899999996942,51.487373,-0.19598799999994299,51.488064,-0.19822199999998702,51.493252,-0.20309399999996458,51.496021,-0.20800099999996746,51.499847,-0.21306300000003375,51.506145,-0.21799099999998361,51.506401,-0.2159639999999854,51.507519,-0.21586200000001554,51.507648,-0.21520299999997405,51.51038,-0.21724599999993188,51.510231,-0.21805300000005445,51.509758,-0.21788900000001377,51.509575,-0.21928600000001097,51.515915,-0.22292800000002444,51.521095,-0.22830199999998513,51.521935,-0.22681999999997515,51.524796,-0.22662000000002536,51.524792,-0.22719499999993786

amfserver.php (WatchDog.getPlaces)

	+places	Array	
		[0]	Mixed Array	
			-id	String	56965063
			-lat	String	51.507725
			-lng	String	-0.127962
			-name	String	Trafalgar's Square
			-tags	Mixed Array	
				.name	String Reference	Trafalgar's Square

amfserver.php (WatchDog.getRivers)
rivers
	id	String	137694
	ref	String	201307381
	lat	String	51.582890
	lng	String	-0.223210
	index	Array	
		[0]	Integer	9
	vertex	Array	
		[0]	String	-0.223261
		[1]	Integer	0
		
amfserver.php (WatchDog.search)

An array of any previously object type