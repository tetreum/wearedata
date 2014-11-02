package wd.hud.popins {
    import flash.display.*;
    import wd.hud.popins.helppopin.*;

    public class HelpPopin extends Popin {

        public function HelpPopin(){
            super();
            setIcon(new Sprite());
            setLine();
            disposeHeader();
            var wrap:HelpPopinWrapper = new HelpPopinWrapper();
            wrap.x = 20;
            wrap.y = line.y;
            this.addChild(wrap);
        }
    }
}//package wd.hud.popins 
