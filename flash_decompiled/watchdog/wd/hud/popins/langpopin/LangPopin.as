package wd.hud.popins.langpopin {
    import wd.providers.texts.*;
    import flash.display.*;
    import wd.core.*;
    import flash.net.*;
    import wd.utils.*;
    import flash.events.*;
    import wd.hud.popins.*;

    public class LangPopin extends Popin {

        public function LangPopin(){
            var lang:XML;
            var item:LangItem;
            LangItem.ICONS["en-EN"] = new FlagENenAsset();
            LangItem.ICONS["fr-FR"] = new FlagFRfrAsset();
            LangItem.ICONS["ru-RU"] = new FlagRUruAsset();
            LangItem.ICONS["pl-PL"] = new FlagPLplAsset();
            LangItem.ICONS["sw-SW"] = new FlagSWswAsset();
            LangItem.ICONS["it-IT"] = new FlagITitAsset();
            LangItem.ICONS["jp-JP"] = new FlagJPjpAsset();
            LangItem.ICONS["nl-NL"] = new FlagNLnlAsset();
            LangItem.ICONS["de-DE"] = new FlagDEdeAsset();
            LangItem.ICONS["es-ES"] = new FlagESesAsset();
            super();
            setTitle(FooterText.languages);
            setIcon(new Sprite());
            setLine();
            disposeHeader();
            var l:uint;
            var c:uint;
            for each (lang in Config.XML_LANG_MENU.lang) {
                item = new LangItem(lang.label, this.clickHandler, lang.@locale);
                item.x = (ICON_WIDTH + (c * 214));
                item.y = ((line.y + 30) + (l * 28));
                this.addChild(item);
                addTweenInItem([item]);
                l++;
                if (l == 5){
                    l = 0;
                    c++;
                };
            };
        }
        public function clickHandler(e:Event):void{
            navigateToURL(new URLRequest(URLFormater.changeLanguageUrl(e.target.locale)), "_self");
        }

    }
}//package wd.hud.popins.langpopin 

import flash.display.*;
import flash.events.*;
import flash.utils.*;
import wd.hud.common.text.*;

class LangItem extends Sprite {

    public static var ICONS:Dictionary = new Dictionary();

    private var label:CustomTextField;
    private var bg:Shape;
    public var locale:String;

    public function LangItem(label:String, clickFunc:Function, locale:String){
        super();
        this.locale = locale;
        var iconName:String = (("Flag" + locale.replace("-", "_")) + "Asset");
        trace(((("iconName :" + iconName) + "   ") + "FlagENenAsset"));
        var icon:Sprite = ICONS[locale];
        this.addChild(icon);
        this.label = new CustomTextField(label.toUpperCase(), "langPopinItem");
        if ((((locale == "ru-RU")) || ((locale == "jp-JP")))){
            this.label.embedFonts = false;
        };
        this.label.wordWrap = false;
        this.label.x = (icon.width + 10);
        this.addChild(this.label);
        this.buttonMode = true;
        this.mouseChildren = false;
        this.addEventListener(MouseEvent.CLICK, clickFunc);
    }
}
