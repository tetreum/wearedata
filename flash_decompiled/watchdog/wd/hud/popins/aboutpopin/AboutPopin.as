package wd.hud.popins.aboutpopin {
    import wd.providers.texts.*;
    import flash.display.*;
    import wd.hud.popins.textpopin.*;

    public class AboutPopin extends TextPopin {

        public function AboutPopin(){
            super();
            setTitle(AboutText.title);
            setIcon(new Sprite());
            setLine();
            disposeHeader();
            setText(AboutText.text, "aboutPopinText");
        }
    }
}//package wd.hud.popins.aboutpopin 
