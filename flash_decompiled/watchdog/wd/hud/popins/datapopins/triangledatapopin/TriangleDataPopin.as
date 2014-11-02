package wd.hud.popins.datapopins.triangledatapopin {
    import flash.geom.*;
    import flash.display.*;
    import wd.hud.common.tween.*;
    import wd.hud.common.text.*;
    import flash.events.*;

    public class TriangleDataPopin extends Sprite {

        private static const DATA_1_SPOT:Point = new Point(-109, 125);
        private static const DATA_2_SPOT:Point = new Point(66, 66);

        private var data1:TriangleDataPopinData;
        private var data2:TriangleDataPopinData;
        private var data1LabelCTF:CustomTextField;
        private var data2LabelCTF:CustomTextField;
        private var data1ValueCTF:CustomTextField;
        private var data2ValueCTF:CustomTextField;
        private var data1Dot:Sprite;
        private var data2Dot:Sprite;
        private var line1:AnimatedLine;
        private var line2:AnimatedLine;
        private var dotStart:Sprite;

        public function TriangleDataPopin(d1:TriangleDataPopinData, d2:TriangleDataPopinData){
            super();
            this.data1 = d1;
            this.data2 = d2;
        }
        public function start():void{
            this.dotStart = new Sprite();
            this.dotStart.graphics.lineStyle(2, 0xFFFFFF, 1);
            this.dotStart.graphics.beginFill(0, 1);
            this.dotStart.graphics.drawCircle(0, 0, 4);
            this.line1 = new AnimatedLine(DATA_1_SPOT);
            this.line1.alpha = 0.5;
            this.line1.addEventListener(AnimatedLine.TWEEN_RENDER, this.renderLine1);
            this.addChild(this.line1);
            this.data1Dot = new Sprite();
            this.data1Dot.graphics.beginFill(0xFFFFFF, 1);
            this.data1Dot.graphics.drawCircle(0, 0, 4);
            this.addChild(this.data1Dot);
            this.line2 = new AnimatedLine(DATA_2_SPOT);
            this.line2.alpha = 0.5;
            this.line2.addEventListener(AnimatedLine.TWEEN_RENDER, this.renderLine2);
            this.addChild(this.line2);
            this.data2Dot = new Sprite();
            this.data2Dot.graphics.beginFill(0xFFFFFF, 1);
            this.data2Dot.graphics.drawCircle(0, 0, 4);
            this.addChild(this.data2Dot);
            this.data1LabelCTF = new CustomTextField(this.data1.label, "elecCoordsLabels");
            this.data1LabelCTF.wordWrap = false;
            this.addChild(this.data1LabelCTF);
            this.data1ValueCTF = new CustomTextField("", "elecCoordsData");
            this.data1ValueCTF.wordWrap = false;
            this.addChild(this.data1ValueCTF);
            this.data2LabelCTF = new CustomTextField(this.data2.label, "elecCoordsLabels");
            this.data2LabelCTF.wordWrap = false;
            this.addChild(this.data2LabelCTF);
            this.data2ValueCTF = new CustomTextField("", "elecCoordsData");
            this.data2ValueCTF.wordWrap = false;
            this.addChild(this.data2ValueCTF);
            this.addChild(this.dotStart);
        }
        protected function renderLine1(e:Event):void{
            var t:Array;
            this.data1Dot.x = (DATA_1_SPOT.x * e.target.step);
            this.data1Dot.y = (DATA_1_SPOT.y * e.target.step);
            this.data1LabelCTF.x = (this.data1Dot.x + 10);
            this.data1LabelCTF.y = (this.data1Dot.y - (this.data1LabelCTF.height / 2));
            if ((this.data2.data is int)){
                this.data1ValueCTF.text = Math.round((this.data1.data * e.target.step)).toString();
            } else {
                t = (this.data1.data * e.target.step).toFixed(6).split(".");
                this.data1ValueCTF.text = (((t[0] + ".<span class=\"elecCoordsData2\">") + t[1]) + "</span>");
            };
            this.data1ValueCTF.text = (this.data1ValueCTF.text + this.data1.unit);
            this.data1ValueCTF.x = this.data1LabelCTF.x;
            this.data1ValueCTF.y = ((this.data1LabelCTF.y + this.data1LabelCTF.height) - 10);
        }
        protected function renderLine2(e:Event):void{
            var t:Array;
            this.data2Dot.x = (DATA_2_SPOT.x * e.target.step);
            this.data2Dot.y = (DATA_2_SPOT.y * e.target.step);
            this.data2LabelCTF.x = (this.data2Dot.x + 10);
            this.data2LabelCTF.y = (this.data2Dot.y - (this.data2LabelCTF.height / 2));
            if ((this.data2.data is int)){
                this.data2ValueCTF.text = Math.round((this.data2.data * e.target.step)).toString();
            } else {
                t = (this.data2.data * e.target.step).toFixed(6).split(".");
                this.data2ValueCTF.text = (((t[0] + ".<span class=\"elecCoordsData2\">") + t[1]) + "</span>");
            };
            this.data2ValueCTF.text = (this.data2ValueCTF.text + this.data2.unit);
            this.data2ValueCTF.x = this.data2LabelCTF.x;
            this.data2ValueCTF.y = ((this.data2LabelCTF.y + this.data2LabelCTF.height) - 10);
        }

    }
}//package wd.hud.popins.datapopins.triangledatapopin 
