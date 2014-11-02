package wd.hud.popins.datapopins {
    import flash.display.*;
    import wd.hud.items.datatype.*;
    import flash.net.*;
    import wd.hud.common.text.*;
    import wd.providers.texts.*;
    import wd.utils.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.xml.*;

    public class TwitterPopin extends DataPopin {

        private var txtAt:CustomTextField;
        private var txtDate:CustomTextField;
        private var menu:Sprite;
        private var bottomMenu:Sprite;
        private var btnFollow:Sprite;
        private var txt:CustomTextField;
        private var tweet_id:String;
        private var tweetos_id:String;
        private var user_name:String;
        private var user_name2:String;
        private var xmlDoc:XMLDocument;

        public function TwitterPopin(data:Object){
            var profileImage:Loader;
            var twData:TwitterTrackerData = (data as TwitterTrackerData);
            this.user_name = twData.name;
            this.user_name2 = twData.from_user;
            super(data);
            if (twData.profile_picture){
                profileImage = new Loader();
                profileImage.x = -13;
                profileImage.y = -3;
                profileImage.load(new URLRequest(twData.profile_picture));
                this.addChild(profileImage);
                addTweenInItem([profileImage]);
                profileImage.y = (title.y + ((title.height - 48) / 2));
            };
            this.menu = new Sprite();
            this.bottomMenu = new Sprite();
            this.tweet_id = twData.tweet_id;
            this.tweetos_id = twData.from_user_id;
            this.txtAt = new CustomTextField(((twData.place_name + " ") + getUnixDate(Number(twData.time))), "twitterPopinAt");
            this.txtAt.wordWrap = false;
            this.txtAt.y = (-(this.txtAt.height) / 2);
            this.menu.addChild(this.txtAt);
            var btnFollow:Sprite = this.followButton(((DataDetailText.twitterFollow + " @") + data.name), this.clickFollow);
            btnFollow.y = (-(btnFollow.height) / 2);
            this.menu.addChild(btnFollow);
            var btnFav:Sprite = this.setMenuItem(new TwitterPopinIconFavAsset(), DataDetailText.twitterFavorites, this.clickFav);
            btnFav.x = (POPIN_WIDTH - btnFav.width);
            btnFav.y = (-(btnFav.height) / 2);
            this.bottomMenu.addChild(btnFav);
            var btnRetw:Sprite = this.setMenuItem(new TwitterPopinIconRetAsset(), DataDetailText.twitterRetweet, this.clickRetw);
            btnRetw.x = (btnFav.x - btnRetw.width);
            btnRetw.y = (-(btnFav.height) / 2);
            this.bottomMenu.addChild(btnRetw);
            var btnReply:Sprite = this.setMenuItem(new TwitterPopinIconReplyAsset(), DataDetailText.twitterReply, this.clickReply);
            btnReply.x = (btnRetw.x - btnReply.width);
            btnReply.y = (-(btnReply.height) / 2);
            this.bottomMenu.addChild(btnReply);
            var btnSeeConv:Sprite = this.setMenuItem(new Sprite(), DataDetailText.twitterSeeConversation, this.clickSeeConv);
            btnSeeConv.y = 0;
            btnSeeConv.x = ICON_WIDTH;
            this.bottomMenu.addChild(btnSeeConv);
            btnFollow.x = ((POPIN_WIDTH - btnFollow.width) - ICON_WIDTH);
            this.menu.x = ICON_WIDTH;
            this.menu.y = ((line.y + (this.menu.height / 2)) + 10);
            this.addChild(this.menu);
            this.addChild(this.bottomMenu);
            addTweenInItem([this.menu]);
            var t:String = URLFormater.addAnchors(StringUtils.htmlDecode(data.caption));
            t = this.addTwitterAnchors(t);
            trace(("t : " + t));
            var txt:CustomTextField = new CustomTextField(t, "twitterPopinText");
            txt.embedFonts = false;
            txt.width = (POPIN_WIDTH - ICON_WIDTH);
            txt.y = (this.menu.y + this.menu.height);
            txt.x = ICON_WIDTH;
            this.bottomMenu.y = ((txt.y + txt.height) + 15);
            this.addChild(txt);
            addTweenInItem([txt]);
            addTweenInItem([this.bottomMenu]);
        }
        private function addTwitterAnchors(strIn:String):String{
            var r:String;
            var i:*;
            var a:Array = strIn.split(" ");
            trace(("a.length :" + a.length));
            if (a.length > 0){
                for (i in a) {
                    if (a[i].charAt(0) == "@"){
                        a[i] = (((("<a href=\"https://twitter.com/" + a[i].replace("@", "%40")) + "\" target=\"_blank\">") + a[i]) + "</a>");
                    } else {
                        if (a[i].charAt(0) == "#"){
                            a[i] = (((("<a href=\"https://twitter.com/search?q=" + a[i].replace("#", "%23")) + "\" target=\"_blank\">") + a[i]) + "</a>");
                        };
                    };
                };
                r = a.join(" ");
            } else {
                r = strIn;
            };
            return (r);
        }
        private function clickFav(e:Event):void{
            JsPopup.open(("https://twitter.com/intent/favorite?tweet_id=" + this.tweet_id));
        }
        private function clickRetw(e:Event):void{
            JsPopup.open(("https://twitter.com/intent/retweet?tweet_id=" + this.tweet_id));
        }
        private function clickReply(e:Event):void{
            JsPopup.open(("https://twitter.com/intent/tweet?in_reply_to=" + this.tweet_id));
        }
        private function clickSeeConv(e:Event):void{
            JsPopup.open(((("https://twitter.com/" + this.tweetos_id) + "/status/") + this.tweet_id));
        }
        private function setMenuItem(icon:Sprite, label:String, clickMethod:Function):Sprite{
            var r:Sprite = new Sprite();
            var i:Sprite = icon;
            var t:CustomTextField = new CustomTextField(label, "twitterPopinMenuItem");
            var bg:Sprite = new Sprite();
            r.addChild(bg);
            t.wordWrap = false;
            t.x = (i.width + 2);
            t.y = ((i.height - t.height) / 2);
            r.addChild(i);
            r.addChild(t);
            r.buttonMode = true;
            r.mouseChildren = false;
            r.addEventListener(MouseEvent.CLICK, clickMethod);
            bg.graphics.beginFill(0xFFFFFF, 0);
            bg.graphics.drawRect(0, 0, r.width, r.height);
            return (r);
        }
        private function clickFollow(e:MouseEvent):void{
            JsPopup.open(("https://twitter.com/intent/user?user_id=" + this.tweetos_id));
        }
        override protected function getIcon(type:uint):Sprite{
            return (new Sprite());
        }
        override protected function setTitle(str:String):void{
            super.setTitle(((((this.user_name2 + "<br/><span class=\"twitterPopinSubTitle\">") + "@") + this.user_name) + "</span>"));
            titleCtn.addEventListener(MouseEvent.CLICK, this.clickTitle);
            titleCtn.buttonMode = true;
            titleCtn.mouseChildren = false;
        }
        private function clickTitle(e:Event):void{
            JsPopup.open(("https://twitter.com/" + this.user_name));
        }
        override protected function disposeHeader():void{
            super.disposeHeader();
            icon.x = (icon.y = 0);
        }
        public function followButton(label:String, clickFunc:Function):Sprite{
            var r:Sprite = new Sprite();
            var HEIGHT:uint = 18;
            var f:Sprite = new TwitterBtnIconAsset();
            f.x = 5;
            f.y = (((HEIGHT - f.height) / 2) + 2);
            r.addChild(f);
            var labelt:CustomTextField = new CustomTextField(label, "twitterPopinFollowBtn");
            labelt.x = (f.width + 3);
            labelt.wordWrap = false;
            labelt.y = (((HEIGHT - labelt.height) / 2) + 2);
            r.addChild(labelt);
            var bg:Shape = new Shape();
            var m:Matrix = new Matrix();
            m.createGradientBox((f.width + labelt.width), HEIGHT, (-(Math.PI) / 2));
            bg.graphics.lineStyle(1, 0x999999);
            bg.graphics.beginGradientFill(GradientType.LINEAR, [0xFDFDFD, 0xE1E1E1], [1, 1], [0, 254], m);
            bg.graphics.drawRoundRect(0, 2, ((22 + 3) + labelt.width), HEIGHT, 5, 5);
            r.addChildAt(bg, 0);
            r.buttonMode = true;
            r.mouseChildren = false;
            r.addEventListener(MouseEvent.CLICK, clickFunc);
            return (r);
        }

    }
}//package wd.hud.popins.datapopins 
