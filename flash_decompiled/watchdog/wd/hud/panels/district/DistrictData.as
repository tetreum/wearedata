package wd.hud.panels.district {

    public class DistrictData {

        public var id:int;
        public var name:String;
        public var inhabitants:Number;
        public var births:Number;
        public var display:String;
        public var deaths_thousand:Number;
        public var salary_monthly:Number;
        public var births_thousand:Number;
        public var unemployment:Number;
        public var salary_hourly:Number;
        public var deaths:Number;
        public var electricity_consumption:Number;
        public var electricity:Number;
        public var jobs:String;
        public var crimes_thousands:String;
        public var crimes_thousand:Number;
        public var crimes:Number;

        public function DistrictData(){
            super();
        }
        public function reset(result:Object=null):void{
            var k:*;
            var i:*;
            var value:String;
            if ((((result == null)) || ((result.length == 0)))){
                this.name = "-------";
                this.id = 0;
                this.inhabitants = 0;
                this.births = 0;
                this.display = "";
                this.deaths_thousand = 0;
                this.salary_monthly = 0;
                this.births_thousand = 0;
                this.unemployment = 0;
                this.salary_hourly = 0;
                this.deaths = 0;
                this.electricity_consumption = 0;
                this.electricity = 0;
                this.jobs = "";
                this.crimes_thousands = "";
                this.crimes_thousand = 0;
                this.crimes = 0;
                return;
            };
            this.id = result.id;
            for (k in result) {
                if ((result[k] is Object)){
                    for (i in result[k]) {
                        if ((this[i] is String)){
                            trace(("i" + result[k][i]));
                            this[i] = result[k][i];
                        } else {
                            value = result[k][i];
                            value = value.replace(/\s/gi, "");
                            if (value.lastIndexOf(",") != -1){
                                value = value.replace(",", ".");
                            };
                            this[i] = parseFloat(value);
                        };
                    };
                };
            };
            if (isNaN(this.salary_monthly)){
                this.salary_monthly = -1;
            };
            this.name = this.display;
            this.crimes_thousand = (this.crimes_thousand * 0.01);
        }
        public function toString():String{
            return (((((((((((((((((((((((((((((((((((((((((("name \t\t\t\t" + this.name) + "\n") + "id \t\t\t\t") + this.id) + "\n") + "inhabitants\t\t\t") + this.inhabitants) + "\n") + "births\t\t\t\t") + this.births) + "\n") + "display\t\t\t") + this.display) + "\n") + "deaths_thousand\t\t") + this.deaths_thousand) + "\n") + "salary_monthly\t\t") + this.salary_monthly) + "\n") + "births_thousand\t\t") + this.births_thousand) + "\n") + "unemployment\t\t\t") + this.unemployment) + "\n") + "salary_hourly\t\t\t") + this.salary_hourly) + "\n") + "deaths\t\t\t\t") + this.deaths) + "\n") + "electricity_consumption\t\t\t\t") + this.electricity_consumption) + "\n") + "electricity\t\t\t\t") + this.electricity_consumption) + "\n") + "crimes_thousand\t\t\t\t") + this.crimes_thousand) + "\n"));
        }

    }
}//package wd.hud.panels.district 
