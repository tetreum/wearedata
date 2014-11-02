package wd.hud.mentions {
    import wd.hud.common.text.*;
    import flash.display.*;
    import wd.http.*;
    import wd.providers.texts.*;
    import aze.motion.*;
    import wd.hud.*;

    public class Mentions extends HudElement {

        private var ctn:Sprite;

        public function Mentions(){
            super();
        }
        public function setState(id:uint):void{
            var ti:CustomTextField;
            this.alpha = 1;
            if (((this.ctn) && (this.contains(this.ctn)))){
                this.removeChild(this.ctn);
            };
            this.ctn = new Sprite();
            var ty:uint;
            if (id == DataType.INSTAGRAMS){
                ti = new CustomTextField(DataDetailText.instragramDisclaimer, "mentions");
            };
            if (id == DataType.FOUR_SQUARE){
                ti = new CustomTextField(DataDetailText.fourSquareDisclaimer, "mentions");
            };
            if (id == DataType.TWITTERS){
                ti = new CustomTextField(DataDetailText.twitterDisclaimer, "mentions");
            };
            if (id == DataType.FLICKRS){
                ti = new CustomTextField(DataDetailText.flickrDisclaimer, "mentions");
            };
            if (ti){
                ti.wordWrap = false;
                ti.x = -(ti.width);
                ti.y = ty;
                ty = (ty + ti.height);
                this.ctn.addChild(ti);
                ti.alpha = 0;
                eaze(ti).delay(1).to(1, {alpha:1});
            };
            this.ctn.y = -(this.ctn.height);
            this.addChild(this.ctn);
        }

    }
}//package wd.hud.mentions 
