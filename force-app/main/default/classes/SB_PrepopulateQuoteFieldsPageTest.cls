@isTest
private class SB_PrepopulateQuoteFieldsPageTest{
    static testmethod void test(){
        List<QuoteFieldsMetadata__c> setList = new List<QuoteFieldsMetadata__c> ();
        QuoteFieldsMetadata__c setData = new QuoteFieldsMetadata__c();
        setData.name = 'SBQQ__Account__c';
        setData.Field_ID__c = 'test';
        setList.add(setData);
        setData = new QuoteFieldsMetadata__c();
        setData.name = 'SBQQ__Opportunity2__c';
        setData.Field_ID__c = 'test';
        setList.add(setData);
        setData = new QuoteFieldsMetadata__c();
        setData.name = 'Facility1__c';
        setData.Field_ID__c = 'test';
        setList.add(setData);
        setData = new QuoteFieldsMetadata__c();
        setData.name = 'Aircraft__c';
        setData.Field_ID__c = 'test';
        setList.add(setData);
        insert setList;
        
        Account acc = new Account(name = 'test', Type = 'Customer', Area__c = 'CENTRAL', BillingState = 'FL', BillingCountry = 'United States');
        insert acc;
        
        List<Product2> sampleProducts = new List<Product2>{ 
                new Product2(Name = 'Bundle Parent', IsActive = true, SBQQ__AssetConversion__c = 'One per quote line',SBQQ__Specifications__c ='ABC')
        }; 
        insert sampleProducts; 
 
        Aircraft__c ac = new Aircraft__c();
        ac.account__c = acc.id;
        ac.product__c = sampleProducts[0].id;
       // ac.OwnerId = '00570000003gv3i';
        ac.Aircraft_Make__c = 'WESTWIND';
        ac.Aircraft_Model_2011__c = 'WESTWIND 1124A';
        ac.Aircraft_SN__c = '435';
        ac.Aircraft_Type__c = 'Aircraft';
        ac.ACReg__c = 'YV-DREW';
        insert ac;
        
        Opportunity oppty = new Opportunity();
        oppty.RSM__c = 'Campbell,Tom';
        oppty.Name = 'trigger test';
        oppty.Opportunity_Name_Details__c = 'trigger test';
        oppty.StageName = 'Cust Submitted Quote';
        oppty.AccountId = acc.Id;
        oppty.Aircraft__c = ac.Id;
        oppty.Amount = decimal.valueof('1471620');
        oppty.CustomerName__c = 'World Jet, Inc.';
        oppty.Facility__c = 'IAH';
        oppty.Tier_Level__c = '1';
        oppty.CloseDate =  Date.today();
        oppty.InputDate__c =  Date.today();
        oppty.OutputDate__c =  Date.today();
        oppty.Product_Line__c = ac.Product_Line__c;
        oppty.Type = 'Avionics';
        oppty.SubType__c = 'Cabin Broadband';
        oppty.LeadSource = 'CPM';
        oppty.QuoteDelivery__c = 'Hand Delivery';
        oppty.QuoteRequiredBy__c =  Date.today();
        oppty.Base_Quote_Number__c = '1';
        oppty.QuotedDate__c =  Date.today();
        oppty.Concession1__c = 'None';
        oppty.Agent_Representative__c = 'Not Applicable';                                   
        insert oppty;   
        
        PageReference pageRef = Page.SB_PrepopulateQuoteFieldsPage;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',Oppty.id);
        List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(quoteList);
        SB_PrepopulateQuoteFieldsController controller = new SB_PrepopulateQuoteFieldsController(setCon);
        System.assertNotEquals(null,controller.populateFields());
    }
}