package wd.providers {

    public class MetroLineColors {

        private static var xml:XMLList;

        public function MetroLineColors(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function getColorByName(name:String):int{
            var i:int;
            while (i < xml.length()) {
                if (xml[i].@name == name){
                    return (parseInt(xml[i].@color));
                };
                i++;
            };
            return (-1);
        }
        public static function getIDByName(name:String):int{
            var i:int;
            while (i < xml.length()) {
                if (xml[i].@name == name){
                    return (i);
                };
                i++;
            };
            return (-1);
        }

    }
}//package wd.providers 
