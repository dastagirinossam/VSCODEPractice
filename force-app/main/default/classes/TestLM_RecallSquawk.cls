@isTest
public class TestLM_RecallSquawk {
    //implement System.runAs User
    static testMethod void testRecallSquawk(){
        
        Account acc = TestDataGenerator.createAccount();
        Product_Line__c  proline = TestDataGenerator.createProductLine();
        Aircraft__c craft = TestDataGenerator.createAircraft(proline.Id);
        Equipment__c eq = TestDataGenerator.createEquipment(proline.Id, acc.Id);
        //Create Product
        Product2 prod = new Product2(
            Name = 'Unscheduled Product',
            ProductCode = 'Code1',
            isActive = True
        );
        insert prod;
        SBQQ__Quote__c	 qr = new SBQQ__Quote__c	(Labor_Type1__c='Airframe');
        insert qr;
        
        SBQQ__Cost__c cost = new SBQQ__Cost__c();
        cost.SBQQ__Product__c = prod.Id;
        cost.SBQQ__UnitCost__c = 100;
        insert cost;
        
        SBQQ__QuoteLine__c qline = new SBQQ__QuoteLine__c();
        qline.SBQQ__Product__c = prod.Id;
        qline.SBQQ__Quote__c = qr.Id;
        qline.SBQQ__Quantity__c = 1;
        qline.SBQQ__RegularPrice__c = 100;
        qline.SBQQ__CustomerPrice__c = 50;
        qline.SBQQ__Cost__c = cost.Id;
        qline.Designated_Approver__c = UserInfo.getUserId();
        //Change to new Portal User
        insert qline;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(qline.id);
        
        // Submit on behalf of a specific submitter 
        req1.setSubmitterId(UserInfo.getUserId()); 
        
        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('Add_Work_Approval_Process');
        req1.setSkipEntryCriteria(true); 
        
        // Submit the approval request for the account
        try{
            Approval.ProcessResult result = Approval.process(req1);
         }
        catch(Exception e){
            System.debug(e.getMessage());
        }
        ProcessInstance pid = new ProcessInstance();
        pid.TargetObjectId = qline.id;
        ProcessInstanceWorkitem piwoID = new ProcessInstanceWorkitem();
        piwoID.ProcessInstanceId = pid.Id;
        test.startTest();
        LM_RecallSquawk.recallSquawk(qline.id);
        test.stopTest();
    }
     @isTest
    static void testRecallSquawkException(){
        test.startTest();
        LM_RecallSquawk.recallSquawk('abc');
        test.stopTest();
    }
    
    
}