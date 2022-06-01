public class LM_RecallSquawk {
    //Input Parameter -Squawk Id of type String
    //Method to remove the approval squawk record from ProcessInstanceWorkitem object.
    //Returns string value 
    @auraEnabled
    public static String recallSquawk(string squawkId) {
        string returnvalue;        
        List<ProcessInstanceWorkitem> piwoID = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: squawkId Limit 1];
        if(piwoID!=null && piwoId.Size() > 0 ){  
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setAction('Removed');       // steps to recall the approval process
            req.setWorkitemId(piwoId.get(0).Id);
            Approval.process(req,false);
            returnvalue= 'Record Recalled Successfully';
         }else{
            returnvalue= 'Record can not recall';
        }  
        return returnvalue;
    }
}