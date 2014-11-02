package away3d.core.sort {
    import away3d.errors.*;
    import away3d.core.traverse.*;

    public class EntitySorterBase {

        public function sort(collector:EntityCollector):void{
            throw (new AbstractMethodError());
        }

    }
}//package away3d.core.sort 
