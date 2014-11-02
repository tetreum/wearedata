package away3d.errors {

    public class AbstractMethodError extends Error {

        public function AbstractMethodError(message:String=null, id:int=0){
            super(((message) || ("An abstract method was called! Either an instance of an abstract class was created, or an abstract method was not overridden by the subclass.")), id);
        }
    }
}//package away3d.errors 
