public Class CheckRecursive{   
    private static boolean runBeforeInsert = true;
    private static boolean runBeforeUpdate = true;
    private static boolean runAfterInsert = true;
    private static boolean runAfterUpdate = true;
    private static boolean run = true;
    private static boolean runAfter = true;
    
    public static boolean runOnce(){
        if(run){
            run = false;
            return true;
        }else{
            return run;
        }
    }
    
    public static boolean runAfterOnce(){
        if(runAfter){
            runAfter = false;
            return true;
        }else{
            return runAfter;
        }
    } 
    
    public static boolean runBeforeInsertOnce(){
        
        if(runBeforeInsert){
            runBeforeInsert = false;
            return true;   
        }
        else{
            return runBeforeInsert;
        }        
    }
    
    public static boolean runBeforeUpdateOnce(){
        
        if(runBeforeUpdate){
            runBeforeUpdate = false;
            return true;
        }
        else{
            return runBeforeUpdate;
        }       
    }
         
}