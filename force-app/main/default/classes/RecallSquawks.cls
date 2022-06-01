public class RecallSquawks {
        
	@InvocableMethod
	public static void RecallSqks(List<Id> projId){
        
        List<SBQQ__QuoteLine__c> sqks = new List<SBQQ__QuoteLine__c>();
        sqks = [Select Id from SBQQ__QuoteLine__c where Add_Work_Status__c = 'Pending' and Project__c =: projId];
        
        For(Integer i = 0; i < sqks.size(); i++){                                                 
        
        	List<ProcessInstanceWorkItem> piwi = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: sqks[i].Id];
        	Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        	req.setComments('This Squawk Has Been Recalled Because The Designated Approver Has Changed On The Project');
            req.setAction('Removed');        
        	req.setWorkitemId(piwi.get(0).Id);
   
        	Approval.process(req,false);
         
            sqks[i].Submit_For_Approval__c = True;
        }
		update sqks;
    }   
}