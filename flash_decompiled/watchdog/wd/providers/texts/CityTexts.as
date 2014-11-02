package wd.providers.texts {

    public class CityTexts {

        private static var xml:XMLList;
        private static var xmlUnits:XML;

        public function CityTexts(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function resetUnits(value:XML):void{
            xmlUnits = value;
        }
        public static function get electricityConsumptionUnit():String{
            return (getUnit("electricityConsumption"));
        }
        public static function get metroTrainFrequencyUnit():String{
            return (getUnit("metroTrainFrequency"));
        }
        public static function get metroCommutersFrequencyUnit():String{
            return (getUnit("metroCommutersFrequency"));
        }
        public static function get electroMagneticFieldsLevelUnit():String{
            return (getUnit("electroMagneticFieldsLevel"));
        }
        public static function get adConsumerExposedUnit():String{
            return (getUnit("adConsumerExposed"));
        }
        public static function get electricityConsumptionLabel():String{
            return (getLabel("electricityConsumption"));
        }
        public static function get metroTrainFrequencyLabel():String{
            return (getLabel("metroTrainFrequency"));
        }
        public static function get metroCommutersFrequencyLabel():String{
            return (getLabel("metroCommutersFrequency"));
        }
        public static function get electroMagneticFieldsLevelLabel():String{
            return (getLabel("electroMagneticFieldsLevel"));
        }
        public static function get adConsumerExposedLabel():String{
            return (getLabel("adConsumerExposed"));
        }
        public static function get perMonth():String{
            return (xml.perMonth);
        }
        public static function get perYear():String{
            return (xml.perYear);
        }
        public static function get perCent():String{
            return (xml.perCent);
        }
        public static function get perThousand():String{
            return (xml.perThousand);
        }
        public static function get perDay():String{
            return (xml.perDay);
        }
        public static function getUnit(nodeName:String):String{
            var r:String = "";
            if (((((xmlUnits[nodeName]) && (!((xmlUnits[nodeName].@unit == ""))))) && (xml[xmlUnits[nodeName].@unit]))){
                r = xml[xmlUnits[nodeName].@unit];
            };
            return (r);
        }
        public static function getLabel(nodeName:String):String{
            var r:String = "";
            trace(((((((("getLabel(" + nodeName) + "):") + xmlUnits[nodeName]) + "@label:") + xmlUnits[nodeName].@label) + " : ") + xml[xmlUnits[nodeName].@label]));
            if (((((xmlUnits[nodeName]) && (!((xmlUnits[nodeName].@label == ""))))) && (xml[xmlUnits[nodeName].@label]))){
                r = xml[xmlUnits[nodeName].@label];
            };
            trace(("r:" + r));
            return (r);
        }

    }
}//package wd.providers.texts 
