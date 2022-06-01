@isTest
public class TestCPMPreviewCtrl {
    
    static testMethod void testUpdateQuote() 
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
        SBQQ__Quote__c quote = TestDataGenerator.instantiateQuote();
        quote.SBQQ__Opportunity2__c=opp.Id;
        quote.SBQQ__Account__c=acc.Id;
        quote.Aircraft__c=craft.Id;
        insert quote;
        SBQQ__QuoteTemplate__c quoteTemp = new SBQQ__QuoteTemplate__c();
        quoteTemp.Name = 'test';
        insert quoteTemp; 
        quote.SBQQ__QuoteTemplateId__c= quoteTemp.Id;
        update quote;
        Test.startTest();
        
        try{
            CPMPreviewCtrl.updateQuote(quote.Id,'test');
         
        }
        catch(AuraHandledException e){
            System.debug(e);
        }
        Test.stopTest();
    }
    @isTest
    static void testUpdateQuoteException(){
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
        SBQQ__Quote__c quote = TestDataGenerator.instantiateQuote();
        quote.SBQQ__Opportunity2__c=opp.Id;
        quote.SBQQ__Account__c=acc.Id;
        quote.Aircraft__c=craft.Id;
        insert quote;
        quote.SBQQ__Opportunity2__c=quote.Id;
        
        test.startTest();
        try{
         CPMPreviewCtrl.updateQuote(quote.id,'test');
        }
        catch(AuraHandledException e){
            System.debug(e);
        }
        test.stopTest();
    }
    
    
}