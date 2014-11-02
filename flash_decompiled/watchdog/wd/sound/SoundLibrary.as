package wd.sound {
    import flash.utils.*;
    import flash.media.*;
    import wd.utils.*;

    public class SoundLibrary {

        private static const SNDAmbianceCarteVille:Class = SoundLibrary_SNDAmbianceCarteVille;
        private static const SNDApparitionLieux:Class = SoundLibrary_SNDApparitionLieux;
        private static const SNDChargement:Class = SoundLibrary_SNDChargement;
        private static const SNDClickLieuxVille:Class = SoundLibrary_SNDClickLieuxVille;
        private static const SNDRollOverLieuxVille:Class = SoundLibrary_SNDRollOverLieuxVille;
        private static const SNDBoucleAmbianceBerlin:Class = SoundLibrary_SNDBoucleAmbianceBerlin;
        private static const SNDBoucleAmbianceLondon:Class = SoundLibrary_SNDBoucleAmbianceLondon;
        private static const SNDBoucleAmbianceParis:Class = SoundLibrary_SNDBoucleAmbianceParis;
        private static const SNDApparitionSignalisation:Class = SoundLibrary_SNDApparitionSignalisation;
        private static const SNDClickPanneauFiltre:Class = SoundLibrary_SNDClickPanneauFiltre;
        private static const SNDVilleRollOverV5:Class = SoundLibrary_SNDVilleRollOverV5;
        private static const SNDDeplacementCamera:Class = SoundLibrary_SNDDeplacementCamera;
        private static const SNDZoomApproche:Class = SoundLibrary_SNDZoomApproche;
        private static const SNDMultiConnecteV17:Class = SoundLibrary_SNDMultiConnecteV17;
        private static const SNDMultiConnecteV14:Class = SoundLibrary_SNDMultiConnecteV14;
        private static const SNDClickV4:Class = SoundLibrary_SNDClickV4;
        private static const SNDClickV7:Class = SoundLibrary_SNDClickV7;
        private static const SNDClickV9:Class = SoundLibrary_SNDClickV9;
        private static const SNDPopIn:Class = SoundLibrary_SNDPopIn;
        private static const SNDRollOverV5:Class = SoundLibrary_SNDRollOverV5;
        private static const SNDRollOverV2:Class = SoundLibrary_SNDRollOverV2;

        private static var lib:Dictionary = new Dictionary();

        public static function exist(arg0:String):Boolean{
            if (lib[arg0] != null){
                return (true);
            };
            return (false);
        }
        public static function getSound(arg0:String):Sound{
            return (lib[arg0]);
        }
        public static function setSound(arg0:String, arg1:Sound):void{
            lib[arg0] = arg1;
        }
        public static function init():void{
            setSound("AmbianceCarteVille", new SNDAmbianceCarteVille());
            setSound("RollOverLieuxVille", new SNDRollOverLieuxVille());
            setSound("ClicLieuxVille", new SNDClickLieuxVille());
            setSound("ApparitionLieuxVille", new SNDApparitionLieux());
            setSound("ChargementCarte", new SNDChargement());
            setSound(("BoucleAmbiance_" + Locator.PARIS), new SNDBoucleAmbianceParis());
            setSound(("BoucleAmbiance_" + Locator.LONDON), new SNDBoucleAmbianceLondon());
            setSound(("BoucleAmbiance_" + Locator.BERLIN), new SNDBoucleAmbianceBerlin());
            setSound("ApparitionSignalisation", new SNDApparitionSignalisation());
            setSound("ClickPanneauFiltre", new SNDClickPanneauFiltre());
            setSound("VilleRollOver", new SNDVilleRollOverV5());
            setSound("DeplacementCamera", new SNDDeplacementCamera());
            setSound("ZoomApproche", new SNDZoomApproche());
            setSound("MultiConnecteV17", new SNDMultiConnecteV17());
            setSound("MultiConnecteV14", new SNDMultiConnecteV14());
            setSound("ClickV4", new SNDClickV4());
            setSound("ClickV7", new SNDClickV7());
            setSound("ClickV9", new SNDClickV9());
            setSound("RolloverV5", new SNDRollOverV5());
            setSound("RolloverV2", new SNDRollOverV2());
            setSound("PopIn", new SNDPopIn());
        }

    }
}//package wd.sound 
