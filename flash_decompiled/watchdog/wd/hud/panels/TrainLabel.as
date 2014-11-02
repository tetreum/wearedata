package wd.hud.panels {
    import flash.geom.*;

    public class TrainLabel extends TrackerLabel {

        public function TrainLabel(){
            super();
        }
        public function update(dest:Point):void{
            mainLabel.setText(currentTracker.data.labelData, false);
            if (trackertIsOnTheLeft()){
                posX = -(DELTA_X);
            } else {
                posX = DELTA_X;
            };
            if (trackertIsOnTop()){
                posY = -(DELTA_Y);
            } else {
                posY = DELTA_Y;
            };
            posX = (posX + currentTracker.screenPosition.x);
            posY = (posY + currentTracker.screenPosition.y);
            dot.x = posX;
            dot.y = posY;
        }

    }
}//package wd.hud.panels 
