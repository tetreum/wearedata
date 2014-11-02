package wd.landing {
    import flash.display.*;
    import wd.landing.text.*;

    public class TitleLanding extends Sprite {

        public function TitleLanding(_arg1:XMLList):void{
            var _local2:Bitmap = new Bitmap(new logoWd(), "auto", true);
            addChild(_local2);
            _local2.x = (-(_local2.width) >> 1);
            var _local3:Tdf_landing = new Tdf_landing(String(_arg1.txt[0]).toUpperCase(), "LandingInfoText");
            _local3.multiline = false;
            _local3.wordWrap = false;
            addChild(_local3);
            _local3.x = (-(_local3.width) >> 1);
            _local3.y = int((15 + _local2.height));
            var _local4:Shape = new Shape();
            _local4.graphics.beginFill(0, 1);
            _local4.graphics.drawRect((_local3.x - 3), _local3.y, (_local3.width + 10), _local3.height);
            addChildAt(_local4, 0);
            var _local5:Tdf_landing = new Tdf_landing(String(_arg1.txt[1]).toUpperCase(), "LandingInfoText");
            _local5.multiline = true;
            _local5.wordWrap = false;
            addChild(_local5);
            _local5.x = (-(_local5.width) >> 1);
            _local5.y = int(((0 + _local3.y) + _local3.height));
            var _local6:Shape = new Shape();
            _local6.graphics.beginFill(0, 1);
            _local6.graphics.drawRect((_local5.x - 3), _local5.y, (_local5.width + 10), _local5.height);
            addChildAt(_local6, 0);
            var _local7:Tdf_landing = new Tdf_landing(String(_arg1.txt[2]).toUpperCase(), "LandingSelectText");
            _local7.multiline = false;
            _local7.wordWrap = false;
            addChild(_local7);
            _local7.x = int(((_local2.x + _local2.width) - _local7.width));
            _local7.y = int(((15 + _local5.y) + _local5.height));
            var _local8:Shape = new Shape();
            _local8.graphics.beginFill(3328244, 1);
            _local8.graphics.drawRect((_local7.x - 3), _local7.y, (_local7.width + 10), _local7.height);
            addChildAt(_local8, 0);
        }
    }
}//package wd.landing 
