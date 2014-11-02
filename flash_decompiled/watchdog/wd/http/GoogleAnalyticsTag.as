package wd.http {
    import wd.core.*;

    public class GoogleAnalyticsTag {

        private var _id:String;
        private var _type:String;
        private var _format:String;

        public function GoogleAnalyticsTag(id:String, type:String, _format:String){
            super();
            this.id = id;
            this.type = type;
            this.format = _format;
            this.format = this.format.replace("XXX", Config.CITY);
            this.format = this.format.replace("aa-AA", Config.LOCALE);
            this.format = this.format.replace(/\|/gi, "&");
        }
        public function get id():String{
            return (this._id);
        }
        public function set id(value:String):void{
            this._id = value;
        }
        public function get type():String{
            return (this._type);
        }
        public function set type(value:String):void{
            this._type = value;
        }
        public function get format():String{
            return (this._format);
        }
        public function set format(value:String):void{
            this._format = value;
        }

    }
}//package wd.http 
