package wd.hud.popins.datapopins {
    import flash.xml.*;
    import flash.display.*;
    import wd.hud.items.datatype.*;
    import flash.net.*;
    import flash.events.*;
    import wd.hud.common.text.*;
    import wd.utils.*;
    import wd.providers.texts.*;
    import flash.geom.*;

    public class InstagramPopin extends DataPopin {

        private var imgLoader:URLLoader;
        private var img:Loader;
        private var footer:Sprite;
        private var profileLink:String;
        private var link:String;
        private var imgContainer:Sprite;
        private var miniLoader:MiniLoaderAsset;

        public function InstagramPopin(data:Object){
            var comment:Sprite;
            super(data);
            var idata:InstagramTrackerData = (tdata as InstagramTrackerData);
            this.imgLoader = new URLLoader();
            this.imgLoader.dataFormat = "binary";
            this.profileLink = (("http://instagram.com/" + idata.name) + "/");
            this.link = idata.link;
            this.imgContainer = new Sprite();
            this.imgContainer.y = (line.y + 10);
            if (idata.picture != null){
                this.imgLoader.load(new URLRequest(idata.picture));
                this.imgLoader.addEventListener(ProgressEvent.PROGRESS, this.imgLoaderProgress);
                this.imgLoader.addEventListener(IOErrorEvent.IO_ERROR, this.imgLoaderIoError);
                this.imgLoader.addEventListener(Event.COMPLETE, this.imgLoaderComplete);
            };
            addTweenInItem([this.imgContainer]);
            this.footer = new Sprite();
            var t:String = idata.title;
            var txt1:CustomTextField = new CustomTextField(StringUtils.htmlDecode(t), "instPopinImageTitle");
            txt1.wordWrap = false;
            if (txt1.width > 300){
                txt1.wordWrap = true;
                txt1.width = 300;
            };
            this.footer.addChild(txt1);
            txt1.y = (-(txt1.height) / 2);
            var txtDate:CustomTextField = new CustomTextField(getUnixDate(int(idata.time)), "instPopinImagePlace");
            txtDate.wordWrap = false;
            txtDate.x = txt1.x;
            txtDate.y = (txt1.y + txt1.height);
            this.footer.addChild(txtDate);
            var img:Sprite = new InstagramPopinLocAsset();
            this.footer.addChild(img);
            img.x = ((txt1.x + txt1.width) + 10);
            img.y = (-(img.height) / 2);
            var txt2:CustomTextField = new CustomTextField(CommonsText[Locator.CITY], "instPopinImagePlace");
            txt2.wordWrap = false;
            txt2.x = ((img.x + img.width) + 3);
            txt2.y = (-(txt2.height) / 2);
            this.footer.addChild(txt2);
            comment = new InstagramPopinCommentAsset();
            comment.buttonMode = true;
            comment.addEventListener(MouseEvent.CLICK, this.gotoLink);
            this.footer.addChild(comment);
            comment.x = ((POPIN_WIDTH - comment.width) - ICON_WIDTH);
            comment.y = (-(comment.height) / 2);
            var like:Sprite = new InstagramPopinLikeAsset();
            like.buttonMode = true;
            like.addEventListener(MouseEvent.CLICK, this.gotoLink);
            this.footer.addChild(like);
            like.x = ((((POPIN_WIDTH - comment.width) - like.width) - ICON_WIDTH) - 5);
            like.y = (-(like.height) / 2);
            var imgSize:Rectangle = this.getImageSize(idata.width, idata.height);
            this.imgContainer.x = (ICON_WIDTH + (((POPIN_WIDTH - ICON_WIDTH) - imgSize.width) / 2));
            var sh:Shape = new Shape();
            sh.graphics.beginFill(0, 0.5);
            sh.graphics.drawRect(0, 0, imgSize.width, imgSize.height);
            this.imgContainer.addChild(sh);
            this.addChild(this.imgContainer);
            this.miniLoader = new MiniLoaderAsset();
            this.miniLoader.x = (this.imgContainer.width / 2);
            this.miniLoader.y = (this.imgContainer.height / 2);
            this.imgContainer.addChild(this.miniLoader);
            this.footer.x = ICON_WIDTH;
            this.addChild(this.footer);
            this.footer.y = (((this.imgContainer.y + this.imgContainer.height) + (this.footer.height / 2)) + 10);
            addTweenInItem([this.footer]);
        }
        public static function htmlUnescape(str:String):String{
            return (new XMLDocument(str).firstChild.nodeValue);
        }
        public static function htmlEscape(str:String):String{
            return (XML(new XMLNode(XMLNodeType.TEXT_NODE, str)).toXMLString());
        }

        override protected function setTitle(str:String):void{
            super.setTitle(str);
            titleCtn.addEventListener(MouseEvent.CLICK, this.gotoProfile);
            titleCtn.buttonMode = true;
            titleCtn.mouseChildren = false;
        }
        private function gotoProfile(e:Event):void{
            navigateToURL(new URLRequest(this.profileLink), "_blank");
        }
        private function gotoLink(e:Event):void{
            navigateToURL(new URLRequest(this.link), "_blank");
        }
        private function imgLoaderProgress(e:Event):void{
            trace(e.toString());
        }
        private function imgLoaderIoError(e:Event):void{
            trace(e.toString());
        }
        private function imgLoaderComplete(e:Event):void{
            this.img = new Loader();
            this.img.loadBytes(e.target.data);
            this.imgContainer.addChild(this.img);
            this.img.contentLoaderInfo.addEventListener(Event.INIT, this.posImage);
            trace(("img.width:" + this.img.width));
        }
        private function getImageSize(w:uint, h:uint):Rectangle{
            var r:Rectangle = new Rectangle(0, 0, w, h);
            if (w > (POPIN_WIDTH - ICON_WIDTH)){
                r.width = (POPIN_WIDTH - ICON_WIDTH);
                r.height = ((h * r.width) / w);
            };
            if (r.height > (POPIN_WIDTH - ICON_WIDTH)){
                r.height = (POPIN_WIDTH - ICON_WIDTH);
                r.width = ((w * r.height) / h);
            };
            return (r);
        }
        private function posImage(e:Event):void{
            (this.img.content as Bitmap).smoothing = true;
            var size:Rectangle = this.getImageSize(this.img.width, this.img.height);
            this.img.width = size.width;
            this.img.height = size.height;
            this.imgContainer.x = (ICON_WIDTH + (((POPIN_WIDTH - ICON_WIDTH) - this.imgContainer.width) / 2));
            this.imgContainer.addEventListener(MouseEvent.CLICK, this.gotoLink);
            this.imgContainer.buttonMode = true;
            this.imgContainer.mouseChildren = false;
        }
        override protected function get titleData():String{
            return ((((StringUtils.htmlDecode((tdata as InstagramTrackerData).name) + " <span class=\"instPopinSuTitle\">") + DataDetailText.instagramHasPostedAnewPic) + "</i>"));
        }
        override protected function getIcon(type:uint):Sprite{
            return (new InstagramPopinIconAsset());
        }
        override protected function disposeHeader():void{
            super.disposeHeader();
            icon.x = (icon.y = 0);
        }

    }
}//package wd.hud.popins.datapopins 
