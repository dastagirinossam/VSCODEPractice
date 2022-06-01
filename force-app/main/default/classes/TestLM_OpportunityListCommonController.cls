@isTest
public class TestLM_OpportunityListCommonController {
    
    static testMethod void testfetchRecordTypeValues(){
        Test.startTest();
        List<String> recTypes = LM_OpportunityListCommonController.fetchRecordTypeValues();
        Test.stopTest();
        System.assertNotEquals(0, recTypes.size());
    }
    
    
    static testMethod void testgetRecTypeId(){
        Account acc = TestDataGenerator.createAccount();
        Product_Line__c  proline = TestDataGenerator.createProductLine();
        Aircraft__c craft = TestDataGenerator.createAircraft(proline.Id);
        Equipment__c eqpmt = TestDataGenerator.createEquipment(proline.Id, acc.Id);
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opportunity' LIMIT 1];
        Test.startTest();
        LM_OpportunityListCommonController.OpportunityWrapper wr= LM_OpportunityListCommonController.getRecTypeId(rt.name,craft.id);
        LM_OpportunityListCommonController.OpportunityWrapper wr1= LM_OpportunityListCommonController.getRecTypeId(rt.name,eqpmt.Id);
        LM_OpportunityListCommonController.isCreatable('Opportunity');
        Test.stopTest();
        System.assertNotEquals(null, wr.AirRec);
        System.assertEquals(rt.Id, wr.TypeId);
    }
    
    @isTest
    static void testWrapper()
    {
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opportunity' LIMIT 1];
        Test.startTest();
        try
        {
            LM_OpportunityListCommonController.OpportunityWrapper wr= LM_OpportunityListCommonController.getRecTypeId(rt.name,'a023');
        }
        catch (Exception ex)
        {
            System.debug(ex.getMessage());
        }
        Test.stopTest();
    }
    
    
}