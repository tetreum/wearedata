package away3d.materials.methods {
    import __AS3__.vec.*;
    import away3d.materials.passes.*;
    import away3d.core.managers.*;
    import away3d.materials.utils.*;

    public class OutlineMethod extends EffectMethodBase {

        private var _outlinePass:OutlinePass;

        public function OutlineMethod(outlineColor:uint=0, outlineSize:Number=1, showInnerLines:Boolean=true, dedicatedMeshes:Boolean=false){
            super();
            _passes = new Vector.<MaterialPassBase>();
            this._outlinePass = new OutlinePass(outlineColor, outlineSize, showInnerLines, dedicatedMeshes);
            _passes.push(this._outlinePass);
        }
        override function initVO(vo:MethodVO):void{
            vo.needsNormals = true;
        }
        public function get showInnerLines():Boolean{
            return (this._outlinePass.showInnerLines);
        }
        public function set showInnerLines(value:Boolean):void{
            this._outlinePass.showInnerLines = value;
        }
        public function get outlineColor():uint{
            return (this._outlinePass.outlineColor);
        }
        public function set outlineColor(value:uint):void{
            this._outlinePass.outlineColor = value;
        }
        public function get outlineSize():Number{
            return (this._outlinePass.outlineSize);
        }
        public function set outlineSize(value:Number):void{
            this._outlinePass.outlineSize = value;
        }
        override function reset():void{
            super.reset();
        }
        override function activate(vo:MethodVO, stage3DProxy:Stage3DProxy):void{
        }
        override function getFragmentCode(vo:MethodVO, regCache:ShaderRegisterCache, targetReg:ShaderRegisterElement):String{
            return ("");
        }

    }
}//package away3d.materials.methods 
