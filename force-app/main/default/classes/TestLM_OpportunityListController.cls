//Test Class to check the LM_OpportunityListController

@isTest
public class TestLM_OpportunityListController {
    
    static testMethod void testfetchRecordTypeValues(){
        Test.startTest();
        List<String> recTypes = LM_OpportunityListController.fetchRecordTypeValues();
        Test.stopTest();
        System.assertNotEquals(0, recTypes.size());
    }
    
    
    static testMethod void testgetRecTypeId(){
        Product_Line__c  proline = TestDataGenerator.createProductLine();
        Aircraft__c craft = TestDataGenerator.createAircraft(proline.Id);
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opportunity' LIMIT 1];
        Test.startTest();
        	LM_OpportunityListController.OpportunityWrapper wr= LM_OpportunityListController.getRecTypeId(rt.name,craft.id);
           LM_OpportunityListController.isCreatable('Opportunity');
        Test.stopTest();
        System.assertNotEquals(null, wr.AirRec);
        System.assertEquals(rt.Id, wr.TypeId);
    }
    
    @isTest
    static void testWrapper()
    {
         RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Opportunity' LIMIT 1];
         Test.startTest();
        try{
        	LM_OpportunityListController.OpportunityWrapper wr= LM_OpportunityListController.getRecTypeId(rt.name,'a023');
        }
        catch(AuraHandledException e){
            System.debug(e.getMessage());
        }
        Test.stopTest();
    }

}