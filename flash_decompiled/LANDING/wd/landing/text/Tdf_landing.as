package wd.landing.text {
    import flash.events.*;
    import wd.landing.loading.*;
    import flash.utils.*;
    import flash.text.*;

    public class Tdf_landing extends TextField {

        public static const AUTOSIZE_CENTER:String = "center";
        public static const AUTOSIZE_LEFT:String = "left";
        public static const AUTOSIZE_RIGHT:String = "right";

        public static var embedFonts:Boolean = true;

        private const TWEEN_CHAR_SET:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÀÁÂÃÄÅÉÇÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜ0123456789!$%&'()*+,-./:;<=>?@[÷]_`{}·–—‘’“‚”„·£";

        private var timerTween:Timer;
        private var forcedStyle:String = "";
        private var destText:String;

        public function Tdf_landing(_arg1:String, _arg2:String="", _arg3:String="left", _arg4:Boolean=false){
            this.destText = _arg1;
            this.embedFonts = Tdf_landing.embedFonts;
            this.antiAliasType = AntiAliasType.ADVANCED;
            this.selectable = false;
            this.condenseWhite = true;
            this.multiline = true;
            this.wordWrap = true;
            this.autoSize = _arg3;
            this.styleSheet = CssLoading.STYLESHEET;
            this.forcedStyle = _arg2;
            this.htmlText = _arg1;
            if (_arg4){
                this.startTween();
            };
        }
        override public function set x(_arg1:Number):void{
            var _local2:Number = _arg1;
            if (this.autoSize == Tdf_landing.AUTOSIZE_CENTER){
                _local2 = (_local2 - (this.width / 2));
            } else {
                if (this.autoSize == Tdf_landing.AUTOSIZE_RIGHT){
                    _local2 = (_local2 - this.width);
                };
            };
            super.x = _local2;
        }
        public function startTween(_arg1:String=""):void{
            if (_arg1 != ""){
                this.destText = _arg1;
            };
            if (this.timerTween){
                this.timerTween.stop();
                this.timerTween.removeEventListener(TimerEvent.TIMER, this.renderTween);
            };
            this.timerTween = new Timer(20, _arg1.length);
            this.timerTween.addEventListener(TimerEvent.TIMER, this.renderTween);
            this.timerTween.start();
        }
        public function renderTween(_arg1:TimerEvent):void{
            var _local2 = "";
            var _local3:uint;
            while (_local3 < this.destText.length) {
                if (_local3 < this.timerTween.currentCount){
                    _local2 = (_local2 + this.destText.charAt(_local3));
                } else {
                    if (_local3 < (this.timerTween.currentCount + 4)){
                        _local2 = (_local2 + this.TWEEN_CHAR_SET.charAt(Math.floor((Math.random() * this.TWEEN_CHAR_SET.length))));
                    };
                };
                _local3++;
            };
            this.htmlText = _local2;
        }
        override public function get htmlText():String{
            return (super.htmlText);
        }
        override public function set htmlText(_arg1:String):void{
            var _local2:String;
            if (!this.destText){
                this.destText = _arg1;
            };
            if (this.forcedStyle != ""){
                _local2 = this.forcedStyle.split(" ")[0];
                super.htmlText = (((("<p class='" + this.forcedStyle) + "'>") + _arg1) + "</p>");
            } else {
                super.htmlText = (("<p>" + _arg1) + "</p>");
            };
        }
        override public function get text():String{
            return (super.text);
        }
        override public function set text(_arg1:String):void{
            this.htmlText = _arg1;
        }

    }
}//package wd.landing.text 
