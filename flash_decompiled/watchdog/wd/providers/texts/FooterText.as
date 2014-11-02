package wd.providers.texts {

    public class FooterText {

        private static var xml:XMLList;

        public function FooterText(xml:XMLList){
            super();
            reset(xml);
        }
        public static function reset(value:XMLList):void{
            xml = value;
        }
        public static function get cities():String{
            return (xml.cities);
        }
        public static function get paris():String{
            return (xml.paris);
        }
        public static function get berlin():String{
            return (xml.berlin);
        }
        public static function get london():String{
            return (xml.london);
        }
        public static function get share():String{
            return (xml.share);
        }
        public static function get about():String{
            return (xml.about);
        }
        public static function get legals():String{
            return (xml.legals);
        }
        public static function get help():String{
            return (xml.help);
        }
        public static function get languages():String{
            return (xml.languages);
        }
        public static function get sound():String{
            return (xml.sound);
        }
        public static function get onOff():String{
            return (xml.onOff);
        }
        public static function get fullscreen():String{
            return (xml.fullscreen);
        }
        public static function get ubisoft():String{
            return (xml.ubisoft);
        }
        public static function get watchdogs():String{
            return (xml.watchdogs);
        }
        public static function get ubisoft_link():String{
            return (xml.ubisoft_link);
        }
        public static function get watchdogs_link():String{
            return (xml.watchdogs_link);
        }
        public static function get helpNavigationText():String{
            return (xml.helpNavigationText);
        }
        public static function get search():String{
            if (xml == null){
                return ("recherche");
            };
            return (xml.search);
        }
        public static function get searchFieldContent():String{
            return (xml.searchFieldContent);
        }
        public static function get hq():String{
            return (xml.HQ);
        }
        public static function get lq():String{
            return (xml.LQ);
        }

    }
}//package wd.providers.texts 
