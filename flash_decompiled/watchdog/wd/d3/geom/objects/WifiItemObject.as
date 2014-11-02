package wd.d3.geom.objects {
    import away3d.materials.*;
    import wd.core.*;
    import wd.d3.lights.*;
    import flash.display.*;
    import away3d.entities.*;
    import away3d.primitives.*;
    import aze.motion.*;
    import aze.motion.easing.*;
    import wd.hud.items.*;
    import __AS3__.vec.*;
    import flash.utils.*;

    public class WifiItemObject extends BaseItemObject {

        private var mesh:Mesh;
        private var height:Number = 30;
        private var mat:ColorMaterial;
        private var contour:WireframeCylinder;
        private var time:Number = 0;
        public var radius:Number = 50;

        public function WifiItemObject(manager:ItemObjectsManager){
            super(manager);
            visible = false;
        }
        override public function open(tracker:Tracker, list:Vector.<Tracker>=null, apply:Boolean=false):void{
            var top:Number;
            var bottom:Number;
            var sides:Number;
            super.open(tracker, list, true);
            if (this.mat == null){
                top = 0;
                bottom = 1;
                sides = 32;
                this.mat = new ColorMaterial(Colors.getColorByType(tracker.data.type), 0.25);
                this.mat.gloss = 10;
                this.mat.specular = 0.5;
                this.mat.lightPicker = LightProvider.lightPickerObjects;
                this.mat.blendMode = BlendMode.ADD;
                this.mat.bothSides = true;
                this.mesh = new Mesh(new CylinderGeometry(top, bottom, this.height, sides), this.mat);
                this.mesh.y = (this.height * 0.5);
                addChild(this.mesh);
                scale(0.001);
            };
            visible = true;
            position = tracker;
            var s:Number = 1E-6;
            scale(s);
            eaze(this).to(0.5, {
                scaleX:this.radius,
                scaleY:1,
                y:(this.height * 0.5),
                scaleZ:this.radius
            }).easing(Expo.easeOut).onComplete(onOpened);
        }
        override public function close(apply:Boolean=false):void{
            super.close();
            var s:Number = 1E-6;
            eaze(this).to(0.5, {
                scaleX:s,
                scaleY:1,
                y:(this.height * 0.5),
                scaleZ:s
            }).easing(Expo.easeOut).chain(this).to(0.35, {
                scaleY:s,
                y:0
            }).easing(Expo.easeOut);
        }
        override public function update():void{
            this.time = (((getTimer() * 0.01) % 30) / 30);
            this.mat.alpha = (0.5 - (this.time * 0.5));
            this.mesh.scaleX = (this.mesh.scaleZ = this.time);
            if (((opened) && (!((tracker == null))))){
                LightProvider.light1.position = tracker;
                LightProvider.light1.y = tracker.y;
            };
        }

    }
}//package wd.d3.geom.objects 
