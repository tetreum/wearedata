package wd.hud.common.text {
    import flash.text.*;
    import wd.core.*;
    import flash.events.*;
    import flash.utils.*;

    public class CustomTextField extends TextField {

        public static const AUTOSIZE_CENTER:String = "center";
        public static const AUTOSIZE_LEFT:String = "left";
        public static const AUTOSIZE_RIGHT:String = "right";

        public static var embedFonts:Boolean = true;

        private const TWEEN_CHAR_SET:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÀÁÂÃÄÅÉÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜ0123456789!$%&'()*+,-./:;<=>?@[÷]_`{}·–—‘’“‚”„·£";

        private var timerTween:Timer;
        private var forcedStyle:String = "";
        private var destText:String;

        public function CustomTextField(txt:String, forceStyle:String="", autoSize:String="left", autoStartTween:Boolean=false){
            super();
            this.destText = txt;
            this.embedFonts = CustomTextField.embedFonts;
            this.antiAliasType = AntiAliasType.ADVANCED;
            this.selectable = false;
            this.condenseWhite = true;
            this.multiline = true;
            this.wordWrap = true;
            this.autoSize = autoSize;
            this.styleSheet = Config.STYLESHEET;
            this.forcedStyle = forceStyle;
            this.htmlText = txt;
            if (autoStartTween){
                this.startTween();
            };
        }
        override public function set x(val:Number):void{
            var xv:Number = val;
            if (this.autoSize == CustomTextField.AUTOSIZE_CENTER){
                xv = (xv - (this.width / 2));
            } else {
                if (this.autoSize == CustomTextField.AUTOSIZE_RIGHT){
                    xv = (xv - this.width);
                };
            };
            super.x = xv;
        }
        public function startTween(destText:String=""):void{
            if (destText != ""){
                this.destText = destText;
            };
            if (this.timerTween){
                this.timerTween.stop();
                this.timerTween.removeEventListener(TimerEvent.TIMER, this.renderTween);
            };
            this.timerTween = new Timer(20, destText.length);
            this.timerTween.addEventListener(TimerEvent.TIMER, this.renderTween);
            this.timerTween.start();
        }
        public function renderTween(e:TimerEvent):void{
            var t:String = "";
            var i:uint;
            while (i < this.destText.length) {
                if (i < this.timerTween.currentCount){
                    t = (t + this.destText.charAt(i));
                } else {
                    if (i < (this.timerTween.currentCount + 4)){
                        t = (t + this.TWEEN_CHAR_SET.charAt(Math.floor((Math.random() * this.TWEEN_CHAR_SET.length))));
                    };
                };
                i++;
            };
            this.htmlText = t;
        }
        override public function get htmlText():String{
            return (super.htmlText);
        }
        override public function set htmlText(value:String):void{
            var closeTag:String;
            if (!(this.destText)){
                this.destText = value;
            };
            if (this.forcedStyle != ""){
                closeTag = this.forcedStyle.split(" ")[0];
                super.htmlText = (((("<p class='" + this.forcedStyle) + "'>") + value) + "</p>");
            } else {
                super.htmlText = (("<p>" + value) + "</p>");
            };
        }
        override public function get text():String{
            return (super.text);
        }
        override public function set text(value:String):void{
            this.htmlText = value;
        }

    }
}//package wd.hud.common.text 
