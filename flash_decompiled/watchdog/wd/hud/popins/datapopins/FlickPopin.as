package wd.hud.popins.datapopins {
    import wd.hud.items.datatype.*;
    import flash.net.*;
    import flash.events.*;
    import flash.display.*;
    import wd.utils.*;
    import flash.geom.*;
    import wd.hud.common.text.*;
    import flash.xml.*;

    public class FlickPopin extends DataPopin {

        private var imgLoader:URLLoader;
        private var img:Loader;
        private var imgContainer:Sprite;
        private var miniLoader:MiniLoaderAsset;
        private var footer:Sprite;
        private var link:String;

        public function FlickPopin(data:Object){
            super(data);
            var idata:FlickrTrackerData = (tdata as FlickrTrackerData);
            this.imgLoader = new URLLoader();
            this.imgLoader.dataFormat = "binary";
            if (idata.url != null){
                this.imgLoader.load(new URLRequest(idata.url));
                this.imgLoader.addEventListener(ProgressEvent.PROGRESS, this.imgLoaderProgress);
                this.imgLoader.addEventListener(IOErrorEvent.IO_ERROR, this.imgLoaderIoError);
                this.imgLoader.addEventListener(Event.COMPLETE, this.imgLoaderComplete);
            };
            this.link = idata.httpUrl;
            this.footer = new Sprite();
            var t:String = "";
            if (idata.title != "null"){
                t = (t + idata.title);
            };
            if (idata.description != "null"){
                t = (t + (" " + idata.description));
            };
            t = StringUtils.htmlDecode(t);
            if (t.length > 0x0200){
                t = (t.substring(0, 0x0200) + "...");
            };
            var imgSize:Rectangle = this.getImageSize(idata.width, idata.height);
            var txt1:CustomTextField = new CustomTextField(t, "instPopinImageTitle");
            txt1.wordWrap = false;
            if (txt1.width > 370){
                txt1.wordWrap = true;
                txt1.width = 370;
            };
            this.footer.addChild(txt1);
            txt1.y = (-(txt1.height) / 2);
            var txt2:CustomTextField = new CustomTextField(getUnixDate(Number(idata.time)), "instPopinImagePlace");
            txt2.wordWrap = false;
            txt2.y = (txt1.y + txt1.height);
            this.footer.addChild(txt2);
            this.imgContainer = new Sprite();
            this.imgContainer.y = (line.y + 10);
            this.imgContainer.x = (ICON_WIDTH + (((POPIN_WIDTH - ICON_WIDTH) - imgSize.width) / 2));
            var sh:Shape = new Shape();
            sh.graphics.beginFill(0, 0.5);
            sh.graphics.drawRect(0, 0, imgSize.width, imgSize.height);
            this.imgContainer.addChild(sh);
            this.addChild(this.imgContainer);
            this.miniLoader = new MiniLoaderAsset();
            this.miniLoader.x = (imgSize.width / 2);
            this.miniLoader.y = (imgSize.height / 2);
            this.imgContainer.addChild(this.miniLoader);
            addTweenInItem([this.imgContainer]);
            this.footer.x = ICON_WIDTH;
            this.addChild(this.footer);
            this.footer.y = ((this.imgContainer.y + this.imgContainer.height) + (this.footer.height / 2));
            addTweenInItem([this.footer]);
            this.footer.addEventListener(MouseEvent.CLICK, this.gotoLink);
            this.footer.buttonMode = true;
            this.footer.mouseChildren = false;
        }
        private function getImageSize(w:uint, h:uint):Rectangle{
            var r:Rectangle = new Rectangle(0, 0, w, h);
            if (w > (POPIN_WIDTH - ICON_WIDTH)){
                r.width = (POPIN_WIDTH - ICON_WIDTH);
                r.height = ((h * r.width) / w);
            };
            if (r.height > 370){
                r.height = 370;
                r.width = ((w * r.height) / h);
            };
            return (r);
        }
        public function htmlUnescape(str:String):String{
            return (new XMLDocument(str).firstChild.nodeValue);
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
        private function posImage(e:Event):void{
            this.imgContainer.removeChild(this.miniLoader);
            (this.img.content as Bitmap).smoothing = true;
            var size:Rectangle = this.getImageSize(this.img.width, this.img.height);
            this.img.width = size.width;
            this.img.height = size.height;
            this.imgContainer.x = (ICON_WIDTH + (((POPIN_WIDTH - ICON_WIDTH) - this.imgContainer.width) / 2));
            this.imgContainer.addEventListener(MouseEvent.CLICK, this.gotoLink);
            this.imgContainer.buttonMode = true;
            this.imgContainer.mouseChildren = false;
        }
        private function gotoLink(e:Event):void{
            navigateToURL(new URLRequest(this.link), "_blank");
        }
        override protected function get titleData():String{
            return ((tdata as FlickrTrackerData).userName);
        }
        override protected function setTitle(str:String):void{
            super.setTitle(StringUtils.htmlDecode(str));
            titleCtn.addEventListener(MouseEvent.CLICK, this.clickTitle);
            titleCtn.buttonMode = true;
            titleCtn.mouseChildren = false;
        }
        private function clickTitle(e:Event):void{
            JsPopup.open((("http://www.flickr.com/people/" + (tdata as FlickrTrackerData).owner) + "/"));
        }
        override protected function getIcon(type:uint):Sprite{
            return (new FlickRPopinIconAsset());
        }
        override protected function disposeHeader():void{
            super.disposeHeader();
            icon.x = (icon.y = 0);
        }

    }
}//package wd.hud.popins.datapopins 
