package {
    import flash.display.*;

    public dynamic class HelpPopinContent extends MovieClip {

        public var scrollbar:ScrollBar;
        public var masque:mcMaskHelp;
        public var contenu:help_content;

        public function HelpPopinContent(){
            addFrameScript(0, this.frame1);
        }
        function frame1(){
            this.masque.cacheAsBitmap = true;
            this.contenu.cacheAsBitmap = true;
            this.contenu.mask = this.masque;
        }

    }
}//package 
