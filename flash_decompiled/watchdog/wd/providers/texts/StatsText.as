package wd.providers.texts {

    public class StatsText {

        private static var xml:XMLList;

        public function StatsText(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get title():String{
            return (xml.title);
        }
        public static function get incomeText():String{
            return (xml.incomeText);
        }
        public static function get unemploymentText():String{
            return (xml.unemploymentText);
        }
        public static function get sourceQuotation():String{
            return (xml.sourceQuotation);
        }
        public static function get crimeInfractionText():String{
            return (xml.crimeInfractionText);
        }
        public static function get electricityConsumption():String{
            return (xml.electricityConsumption);
        }
        public static function get infoPopinBtn():String{
            return (xml.infoPopinBtn);
        }
        public static function get infoPopinTxtIncome():String{
            return (xml.infoPopinTxtIncome);
        }
        public static function get infoPopinTxtUnemployment():String{
            return (xml.infoPopinTxtUnemployment);
        }
        public static function get infoPopinTxtCrime():String{
            return (xml.infoPopinTxtCrime);
        }
        public static function get infoPopinTxtElectricity():String{
            return (xml.infoPopinTxtElectricity);
        }

    }
}//package wd.providers.texts 
