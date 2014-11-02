package wd.hud.items.pictos {
    import flash.utils.*;
    import flash.geom.*;
    import __AS3__.vec.*;
    import wd.wq.datas.*;
    import wd.http.*;
    import wd.providers.*;
    import wd.utils.*;
    import wd.core.*;

    public class UVPicto {

        private static var pow2Dico:Dictionary;
        private static var instances:Dictionary = new Dictionary();
        private static var rectTracker:Rectangle = new Rectangle(0, 0, 43, 43);
        private static var rectMetro:Rectangle = new Rectangle(0, 0, 32, 32);
        private static var uvs:Vector.<UVCoord>;
        private static var uvsRoll:Vector.<UVCoord>;
        public static var textUVs:Dictionary = new Dictionary();
        private static var DATA_TYPE_PICTO_COUNT:int = 19;
        private static var PARIS_TRAIN_COUNT:int = 17;
        private static var LONDON_TRAIN_COUNT:int = 14;
        private static var BERLIN_TRAIN_COUNT:int = 26;
        private static var londonStartIndex:int = (DATA_TYPE_PICTO_COUNT + PARIS_TRAIN_COUNT);
        private static var berlinStartIndex:int = ((DATA_TYPE_PICTO_COUNT + PARIS_TRAIN_COUNT) + LONDON_TRAIN_COUNT);
        private static var parisStationStartIndex:int = (((DATA_TYPE_PICTO_COUNT + PARIS_TRAIN_COUNT) + LONDON_TRAIN_COUNT) + BERLIN_TRAIN_COUNT);
        private static var londonStationStartIndex:int = (((DATA_TYPE_PICTO_COUNT + (PARIS_TRAIN_COUNT * 2)) + LONDON_TRAIN_COUNT) + BERLIN_TRAIN_COUNT);
        private static var berlinStationStartIndex:int = (((DATA_TYPE_PICTO_COUNT + (PARIS_TRAIN_COUNT * 2)) + (LONDON_TRAIN_COUNT * 2)) + BERLIN_TRAIN_COUNT);

        public const btnSize:int = 22;
        public const btnSizeD2:int = 11;

        public var uvs:UVCoord;
        public var uvsRoll:UVCoord;
        public var width:Number;
        public var height:Number;
        public var halfWidth:Number;
        public var halfHeight:Number;

        public static function init(width:int, height:int):void{
            pow2Dico = new Dictionary();
            var l:int = 20;
            var n:int = 1;
            var i:int;
            while (l--) {
                pow2Dico[n] = i;
                n = (n * 2);
                i++;
            };
            uvs = new Vector.<UVCoord>(150, true);
            uvsRoll = new Vector.<UVCoord>(20, true);
            uvs[pow2Dico[DataType.ADS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 9), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.ADS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 9), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.ANTENNAS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 4), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.ANTENNAS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 4), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.ATMS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 17), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.ATMS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 17), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.CAMERAS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 12), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.CAMERAS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 12), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.ELECTROMAGNETICS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 8), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.ELECTROMAGNETICS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 8), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.FOUR_SQUARE]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 16), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.FOUR_SQUARE]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 16), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.FLICKRS]] = new UVCoord((rectTracker.width / width), (((rectTracker.height * 15) - 3) / height), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.FLICKRS]] = new UVCoord(((rectTracker.width * 2) / width), (((rectTracker.height * 15) - 3) / height), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.INSTAGRAMS]] = new UVCoord((rectTracker.width / width), (((rectTracker.height * 14) - 3) / height), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.INSTAGRAMS]] = new UVCoord(((rectTracker.width * 2) / width), (((rectTracker.height * 14) - 3) / height), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.INTERNET_RELAYS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height * 4) / height), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.INTERNET_RELAYS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height * 4) / height), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.METRO_STATIONS]] = new UVCoord((rectTracker.width / width), (rectTracker.height / height), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.METRO_STATIONS]] = new UVCoord(((rectTracker.width * 2) / width), (rectTracker.height / height), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.MOBILES]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 7), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.MOBILES]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 7), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.PLACES]] = new UVCoord((rectTracker.width / width), (rectTracker.height / height), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.PLACES]] = new UVCoord(((rectTracker.width * 2) / width), (rectTracker.height / height), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.TOILETS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 11), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.TOILETS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 11), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.TRAFFIC_LIGHTS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 10), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.TRAFFIC_LIGHTS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 10), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.VELO_STATIONS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 2), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.VELO_STATIONS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 2), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.WIFIS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 6), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.WIFIS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 6), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.TWITTERS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 13), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.TWITTERS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 13), (rectTracker.width / width), (rectTracker.height / height));
            uvs[pow2Dico[DataType.RADARS]] = new UVCoord((rectTracker.width / width), ((rectTracker.height / height) * 18), (rectTracker.width / width), (rectTracker.height / height));
            uvsRoll[pow2Dico[DataType.RADARS]] = new UVCoord(((rectTracker.width * 2) / width), ((rectTracker.height / height) * 18), (rectTracker.width / width), (rectTracker.height / height));
            var y:Number = 0;
            var x:Number = (43 * 3);
            var startIndex:uint = DATA_TYPE_PICTO_COUNT;
            i = 0;
            while (i < PARIS_TRAIN_COUNT) {
                uvs[startIndex] = new UVCoord(((x + (rectMetro.width * i)) / width), y, (rectMetro.width / width), (rectMetro.height / height));
                startIndex++;
                i++;
            };
            y = (32 / height);
            x = (43 * 3);
            i = 0;
            while (i < LONDON_TRAIN_COUNT) {
                uvs[startIndex] = new UVCoord(((x + (rectMetro.width * i)) / width), y, (rectMetro.width / width), (rectMetro.height / height));
                startIndex++;
                i++;
            };
            y = ((32 / height) * 2);
            x = (43 * 3);
            i = 0;
            while (i < BERLIN_TRAIN_COUNT) {
                uvs[startIndex] = new UVCoord(((x + (rectMetro.width * i)) / width), y, (rectMetro.width / width), (rectMetro.height / height));
                startIndex++;
                i++;
            };
            y = ((32 / height) * 4);
            x = (43 * 3);
            i = 0;
            while (i < PARIS_TRAIN_COUNT) {
                uvs[startIndex] = new UVCoord(((x + (rectMetro.width * i)) / width), y, (rectMetro.width / width), (rectMetro.height / height));
                startIndex++;
                i++;
            };
            y = ((32 / height) * 5);
            x = (43 * 3);
            i = 0;
            while (i < LONDON_TRAIN_COUNT) {
                uvs[startIndex] = new UVCoord(((x + (rectMetro.width * i)) / width), y, (rectMetro.width / width), (rectMetro.height / height));
                startIndex++;
                i++;
            };
            y = ((32 / height) * 6);
            x = (43 * 3);
            i = 0;
            while (i < BERLIN_TRAIN_COUNT) {
                uvs[startIndex] = new UVCoord(((x + (rectMetro.width * i)) / width), y, (rectMetro.width / width), (rectMetro.height / height));
                startIndex++;
                i++;
            };
        }
        public static function getTextUVs(id:String):UVPicto{
            if (textUVs[id] == null){
                return (null);
            };
            if (instances[id] != null){
                return (instances[id]);
            };
            var inst:UVPicto = new (UVPicto)();
            inst.uvsRoll = (inst.uvs = textUVs[id]);
            inst.width = inst.uvsRoll.realW;
            inst.height = inst.uvsRoll.realH;
            inst.halfWidth = (inst.width >> 1);
            inst.halfHeight = (inst.height >> 1);
            instances[(id + "_text")] = inst;
            return (inst);
        }
        public static function getTrackerUVs(type:int):UVPicto{
            if (instances[(type + "picto")] != null){
                return (instances[(type + "picto")]);
            };
            var inst:UVPicto = new (UVPicto)();
            var n:uint = pow2Dico[type];
            inst.uvs = UVPicto.uvs[n];
            inst.uvsRoll = UVPicto.uvsRoll[n];
            inst.width = (inst.height = 43);
            inst.halfWidth = (inst.halfHeight = 21.5);
            instances[(type + "picto")] = inst;
            return (inst);
        }
        public static function getMetroUVs(lineRef:String):UVPicto{
            var n:int;
            if (instances[lineRef] != null){
                return (instances[lineRef]);
            };
            var lineRef2:String = String(lineRef);
            var inst:UVPicto = new (UVPicto)();
            switch (Locator.CITY){
                case Locator.PARIS:
                    n = lineRef2.indexOf("_");
                    if (n != -1){
                        lineRef2 = lineRef2.substring(0, n);
                    };
                    n = lineRef2.indexOf("bis");
                    if (n != -1){
                        switch (lineRef2){
                            case "3bis":
                                inst.uvs = (inst.uvsRoll = UVPicto.uvs[(londonStartIndex - 2)]);
                                break;
                            case "7bis":
                                inst.uvs = (inst.uvsRoll = UVPicto.uvs[(londonStartIndex - 1)]);
                                break;
                        };
                    } else {
                        n = ((parseInt(lineRef2) + DATA_TYPE_PICTO_COUNT) - 1);
                        inst.uvs = (inst.uvsRoll = UVPicto.uvs[n]);
                    };
                    break;
                case Locator.LONDON:
                    n = lineRef2.indexOf("_");
                    if (n != -1){
                        lineRef2 = lineRef2.substring(0, n);
                    };
                    lineRef2 = lineRef2.toUpperCase();
                    n = (MetroLineColors.getIDByName(lineRef2) + londonStartIndex);
                    inst.uvs = (inst.uvsRoll = UVPicto.uvs[n]);
                    break;
                default:
                    n = lineRef2.indexOf("_");
                    if (n != -1){
                        lineRef2 = lineRef2.substring(0, n);
                    };
                    lineRef2 = lineRef2.toUpperCase();
                    n = (MetroLineColors.getIDByName(lineRef2) + berlinStartIndex);
                    inst.uvs = (inst.uvsRoll = UVPicto.uvs[n]);
            };
            inst.width = (inst.height = 32);
            inst.halfWidth = (inst.halfHeight = 16);
            instances[lineRef] = inst;
            return (inst);
        }
        public static function getStationUVs(lineRef:String, hasMultipleConnexions:Boolean=false):UVPicto{
            var n:int;
            if (hasMultipleConnexions){
                lineRef = ("multiLine" + Config.CITY);
            };
            if (instances[(lineRef + "_station")] != null){
                return (instances[(lineRef + "_station")]);
            };
            var lineRef2:String = String(lineRef);
            var inst:UVPicto = new (UVPicto)();
            switch (Locator.CITY){
                case Locator.PARIS:
                    n = lineRef2.indexOf("_");
                    if (n != -1){
                        lineRef2 = lineRef2.substring(0, n);
                    };
                    n = lineRef2.indexOf("bis");
                    if (n != -1){
                        switch (lineRef2){
                            case "3bis":
                                inst.uvs = (inst.uvsRoll = UVPicto.uvs[(londonStationStartIndex - 2)]);
                                break;
                            case "7bis":
                                inst.uvs = (inst.uvsRoll = UVPicto.uvs[(londonStationStartIndex - 1)]);
                                break;
                        };
                    } else {
                        if (hasMultipleConnexions){
                            n = (MetroLineColors.getIDByName(lineRef) + parisStationStartIndex);
                            inst.uvs = (inst.uvsRoll = UVPicto.uvs[n]);
                            break;
                        };
                        n = ((parseInt(lineRef2) + parisStationStartIndex) - 1);
                        inst.uvs = (inst.uvsRoll = UVPicto.uvs[n]);
                    };
                    break;
                case Locator.LONDON:
                    if (hasMultipleConnexions){
                        n = (MetroLineColors.getIDByName(lineRef) + londonStationStartIndex);
                        inst.uvs = (inst.uvsRoll = UVPicto.uvs[n]);
                        break;
                    };
                    n = lineRef2.indexOf("_");
                    if (n != -1){
                        lineRef2 = lineRef2.substring(0, n);
                    };
                    lineRef2 = lineRef2.toUpperCase();
                    n = (MetroLineColors.getIDByName(lineRef2) + londonStationStartIndex);
                    inst.uvs = (inst.uvsRoll = UVPicto.uvs[n]);
                    break;
                default:
                    if (hasMultipleConnexions){
                        n = (MetroLineColors.getIDByName(lineRef) + berlinStationStartIndex);
                        inst.uvs = (inst.uvsRoll = UVPicto.uvs[n]);
                        break;
                    };
                    n = lineRef2.indexOf("_");
                    if (n != -1){
                        lineRef2 = lineRef2.substring(0, n);
                    };
                    lineRef2 = lineRef2.toUpperCase();
                    n = (MetroLineColors.getIDByName(lineRef2) + berlinStationStartIndex);
                    inst.uvs = (inst.uvsRoll = UVPicto.uvs[n]);
            };
            inst.width = (inst.height = 32);
            inst.halfWidth = (inst.halfHeight = 16);
            instances[(lineRef + "station")] = inst;
            return (inst);
        }

    }
}//package wd.hud.items.pictos 
