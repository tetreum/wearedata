<?php

function pre_print()
{
	echo'<pre>';
	$args = func_get_args();
	
	foreach($args as $var)
	{
		if($var==null || $var==''){
			var_dump($var);
		}elseif(is_array($var) || is_object($var)){
			print_r($var);
		}else{
			echo $var;
		}
		echo '<br>';
	}
	
	echo'</pre>';
}


require_once dirname(__FILE__) . '/ClassLoader.php';

$decoder=new Amfphp_Core_Amf_Deserializer();
$decoded=$decoder->deserialize(array(),array(),file_get_contents('test.sql'));

$decoded=$decoded->messages[0]->data;

echo json_encode($decoded);

//pre_print($decoded);

?>