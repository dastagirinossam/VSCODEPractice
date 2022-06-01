@isTest
public class TestCreateCZIOpportunityEquipmentCtrl {
    
    static testMethod void testMethod1() 
    {
        Account acc = TestDataGenerator.createAccount();
        Product_Line__c  proline = TestDataGenerator.createProductLine();
        Aircraft__c craft = TestDataGenerator.createAircraft(proline.Id);
        Equipment__c eq = TestDataGenerator.createEquipment(proline.Id, acc.Id);
        Opportunity opp = TestDataGenerator.instantiateOpportunity();
        opp.AccountId= acc.Id;
        opp.Equipment__c=eq.Id;
        opp.Aircraft__c= craft.Id;
        opp.Product_Line__c=proline.ID;
        insert opp;
        
        Test.startTest();
        CreateCZIOpportunityEquipmentCtrl.eqpOpportunity(eq.Id);
        CreateCZIOpportunityEquipmentCtrl.OppRecord(opp.Id);
        CreateCZIOpportunityEquipmentCtrl.fetchRecordTypeValues();
        CreateCZIOpportunityEquipmentCtrl.getRecTypeId('Budgetary-RFQ');
        Test.stopTest();
    }
}