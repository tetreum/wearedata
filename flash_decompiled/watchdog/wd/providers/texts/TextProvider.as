package wd.providers.texts {
    import wd.utils.*;
    import flash.events.*;
    import wd.core.*;

    public class TextProvider extends EventDispatcher {

        private var lo:XMLLoader;

        public function TextProvider(){
            super();
            this.lo = new XMLLoader("texts");
        }
        public function resetLanguage():void{
            this.lo.addEventListener(Event.COMPLETE, this.onComplete);
            this.lo.load(Config.CONTENT_FILE);
        }
        private function onComplete(e:Event):void{
            this.lo.removeEventListener(Event.COMPLETE, this.onComplete);
            var xml:XML = this.lo.xml;
            CommonsText.reset(xml.commons);
            DataDetailText.reset(xml.dataDetail);
            DataFilterText.reset(xml.dataFilter);
            FooterText.reset(xml.footer);
            LiveActivitiesText.reset(xml.liveActivities);
            ShareText.reset(xml.share);
            StatsText.reset(xml.areaStats);
            TutorialText.reset(xml.tutorial);
            DataLabel.reset(xml.dataLabel);
            LegalsText.reset(xml.legals);
            AboutText.reset(xml.about);
            CityTexts.reset(xml.units);
            AidenTexts.reset(xml.aidenMessages);
            dispatchEvent(new Event(Event.COMPLETE));
        }

    }
}//package wd.providers.texts 
