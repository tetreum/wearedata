package wd.d3.geom.axes {
    import wd.utils.*;
    import wd.core.*;

    public class Axes {

        public function Axes(){
            super();
            new CSVLoader((("assets/csv/axes/" + Config.CITY.toLowerCase()) + ".csv"));
        }
    }
}//package wd.d3.geom.axes 
