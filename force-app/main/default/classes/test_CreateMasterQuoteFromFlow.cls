@isTest
public class test_CreateMasterQuoteFromFlow{
  
    static testMethod void test_CreateMasterQuoteFromFlow() {
    
        // Insert Account
        Account acnt = new Account();
        acnt.Name = 'test name';
        acnt.BillingStreet = '1600 Amphitheatre Parkway';
        acnt.BillingCity = 'Mountain View';
        acnt.BillingState = 'CA';
        acnt.BillingPostalCode = '94043';
        acnt.BillingCountry = 'United States';
        insert acnt;

        //Get Record Id for Opportunity
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();

          sampleProducts = new List<Product2>{ 
                new Product2(Name = 'Bundle Parent', IsActive = true, SBQQ__AssetConversion__c = 'One per quote line'), 
                new Product2(Name = 'Subscription Child', IsActive = true, SBQQ__SubscriptionPricing__c = 'Percent Of Total', SBQQ__SubscriptionTerm__c = 12, SBQQ__SubscriptionType__c = 'Renewable'), 
                new Product2(Name = 'Non-Subscription Child 1', IsActive = true, SBQQ__AssetConversion__c = 'One per quote line'), 
                new Product2(Name = 'Non-Subscription Child 2', IsActive = true, SBQQ__AssetConversion__c = 'One per quote line'), 
                new Product2(Name = 'Standalone', IsActive = true, SBQQ__AssetConversion__c = 'One per unit'), 
                new Product2(Name = 'Subscription Extra', IsActive = true, SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__SubscriptionTerm__c = 12, SBQQ__SubscriptionType__c = 'Renewable') 
        }; 
        insert sampleProducts; 
 
        entries = new List<PricebookEntry>(); 
        entries.add(new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = sampleProducts[0].Id, IsActive = true, UnitPrice = 100)); 
        entries.add(new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = sampleProducts[1].Id, IsActive = true, UnitPrice = 200)); 
        entries.add(new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = sampleProducts[2].Id, IsActive = true, UnitPrice = 100)); 
        entries.add(new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = sampleProducts[3].Id, IsActive = true, UnitPrice = 100)); 
        entries.add(new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = sampleProducts[4].Id, IsActive = true, UnitPrice = 100)); 
        entries.add(new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = sampleProducts[5].Id, IsActive = true, UnitPrice = 100)); 
        insert entries; 
 
        prodOptions = new List<SBQQ__ProductOption__c>(); 
        // 3 bundle children 
        prodOptions.add(new SBQQ__ProductOption__c(SBQQ__Number__c = 20, SBQQ__ConfiguredSKU__c = sampleProducts[0].Id, SBQQ__Type__c = 'Component', SBQQ__OptionalSKU__c = sampleProducts[1].Id)); 
        prodOptions.add(new SBQQ__ProductOption__c(SBQQ__Number__c = 30, SBQQ__ConfiguredSKU__c = sampleProducts[0].Id, SBQQ__Type__c = 'Component', SBQQ__OptionalSKU__c = sampleProducts[2].Id)); 
        prodOptions.add(new SBQQ__ProductOption__c(SBQQ__Number__c = 40, SBQQ__ConfiguredSKU__c = sampleProducts[0].Id, SBQQ__Type__c = 'Component', SBQQ__OptionalSKU__c = sampleProducts[3].Id)); 
        insert prodOptions; 
 
        //Product Line
        Product_Line__c prodLine = new Product_Line__c(
            Product_Line_Family__c = 'Aircraft',
            Name = 'new'
        );

        insert prodLine;
        
        //Aircraft
        Aircraft__c aircraft = new Aircraft__c();
        aircraft.Product_Line__c = prodLine.id;
        aircraft.Aircraft_Make__c = 'CASA';
        aircraft.Aircraft_SN__c = '213';
        aircraft.name = 'new';
        aircraft.Aircraft_Type__c = 'Aircraft';
        aircraft.OwnerId = UserInfo.getUserId();

        insert aircraft;
    
        // Master Opportunity
        Opportunity masterOpportunity = new Opportunity(
        Opportunity_Name_Details__c = 'Krunal Opportunity Master',
        RecordTypeId=rtId,
        Product_Line__c = prodLine.id,
        Aircraft__c = aircraft.id,
        RSM__c = 'Campbell,Tom',
        Name = 'Opportunity Master',
        AccountId = acnt.id,
        StageName = 'New Opportunity',
        Amount = decimal.valueof('1471620'),
        CustomerName__c = 'World Jet, Inc.',
        Facility__c = 'AGS',
        Tier_Level__c = '1',
        CloseDate =  Date.today(),
        InputDate__c =   Date.today(),
        OutputDate__c =   Date.today(),
        Type = 'Airframe',
        SubType__c = 'Airframe - Inspection',
        LeadSource = 'CPM',
        QuoteDelivery__c = 'Hand Delivery',
        QuoteRequiredBy__c =  Date.today(),
        Base_Quote_Number__c = '1',
        QuotedDate__c =  Date.today(),
        Concession1__c = 'None',
        Agent_Representative__c = 'Not Applicable',
        Master_Opportunity__c = true,
        Pricebook2Id =Test.getStandardPricebookId());
                                      
        insert masterOpportunity;  

        //Child Opportunity
        List<Opportunity> childOpportunity = new List<Opportunity>();

        Opportunity childOpp1 = new Opportunity(
        Opportunity_Name_Details__c = 'Krunal Opportunity Child 1',
        RecordTypeId=rtId,
        RSM__c = 'Campbell,Tom',
        Name = 'Opportunity Child 1',
        AccountId = acnt.id,
        StageName = 'New Opportunity',
        Amount = decimal.valueof('1471620'),
        CustomerName__c = 'World Jet, Inc.',
        Facility__c = 'AGS',
        Tier_Level__c = '1',
        CloseDate =  Date.today(),
        InputDate__c =   Date.today(),
        OutputDate__c =   Date.today(),
        Type = 'Airframe',
        Product_Line__c = prodLine.id,
        SubType__c = 'Airframe - Inspection',
        LeadSource = 'CPM',
        QuoteDelivery__c = 'Hand Delivery',
        QuoteRequiredBy__c =  Date.today(),
        Base_Quote_Number__c = '1',
        QuotedDate__c =  Date.today(),
        Concession1__c = 'None',
        Agent_Representative__c = 'Not Applicable',
        Master_Opportunity__c = false,
        MasterOpportunitylookup__c = masterOpportunity.id,
        Pricebook2Id =Test.getStandardPricebookId());

        childOpportunity.add(childOpp1);

        insert childOpportunity;

        // Create Child quotes
        List<SBQQ__Quote__c> childQuotes = new List<SBQQ__Quote__c>();

        SBQQ__Quote__c childQuote1 = new SBQQ__Quote__c();
        childQuote1.SBQQ__PrimaryContact__c = childOpp1.Contact__c;
        childQuote1.Aircraft__c = aircraft.id;
        childQuote1.SBQQ__Type__c = 'Quote child 1';
        childQuote1.SBQQ__Opportunity2__c = childOpp1.Id;
        childQuote1.SBQQ__PriceBook__c = Test.getStandardPricebookId();
        childQuote1.SBQQ__StartDate__c = System.today();
        childQuote1.SBQQ__SubscriptionTerm__c = 12;
        childQuote1.Facility1__c = 'SPI';

        childQuotes.add(childQuote1);

        insert childQuotes;

        lines = new List<SBQQ__QuoteLine__c>(); 
        // Bundle 
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = childQuote1.Id,SBQQ__Number__c =1,SBQQ__Product__c = sampleProducts[0].Id, SBQQ__Quantity__c = 1, SBQQ__NetPrice__c = 100)); 
        // Subscription child 
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = childQuote1.Id, SBQQ__Number__c =2,SBQQ__Product__c = sampleProducts[1].Id, SBQQ__Quantity__c = 1, SBQQ__SubscriptionPricing__c = 'Percent Of Total', SBQQ__StartDate__c = System.today(), SBQQ__EndDate__c = System.today().addMonths(12).addDays(-1), SBQQ__DefaultSubscriptionTerm__c = 12, SBQQ__ListPrice__c = 200, SBQQ__NetPrice__c = 200)); 
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = childQuote1.Id, SBQQ__Number__c =3,SBQQ__Product__c = sampleProducts[2].Id, SBQQ__Quantity__c = 1, SBQQ__ListPrice__c = 200, SBQQ__NetPrice__c = 200)); 
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = childQuote1.Id,SBQQ__Number__c =4, SBQQ__Product__c = sampleProducts[3].Id, SBQQ__Quantity__c = 1, SBQQ__ListPrice__c = 200, SBQQ__NetPrice__c = 200)); 
        // Standalone 
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = childQuote1.Id,SBQQ__Number__c =5, SBQQ__Product__c = sampleProducts[4].Id, SBQQ__Quantity__c = 1, SBQQ__ListPrice__c = 200, SBQQ__NetPrice__c = 200)); 

        insert lines; 

        //Make child quotes primary so that they sync. with their opp.
        childQuote1.SBQQ__Primary__c = true;
        
        update childQuotes;
        
        List<Id> masterOpp = new List<Id>();
        masterOpp.add(masterOpportunity.Id);
                  
        Test.startTest();  

        CreateMasterQuoteFromFlow.CreateMasterQuoteFromFlow(masterOpp);

        SBQQ__Quote__c masterQuote = [Select Id from SBQQ__Quote__c where SBQQ__Opportunity2__c =: masterOpp];

        System.assertNotEquals(masterQuote,null);

        delete childOpportunity;

        masterOpportunity.Master_Opportunity__c = false;
        update masterOpportunity;

        CreateMasterQuoteFromFlow.Bundle  b = new CreateMasterQuoteFromFlow.Bundle();
        b.mainLine = lines[0];
        CreateMasterQuoteFromFlow.Bundle  b1 = new CreateMasterQuoteFromFlow.Bundle();
        b1.mainLine = lines[1];
        b.compareTo(b1);

        SB_QuoteLineSorter  qls = new SB_QuoteLineSorter (lines[1]);
        SB_QuoteLineSorter  qls1 = new SB_QuoteLineSorter (lines[1]);
        qls.compareTo(qls1);
     
        Test.stopTest();
    }
    
    private static Account customer; 
    private static Opportunity opp; 
    private static SBQQ__Quote__c quoteRec; 
    private static List<Product2> sampleProducts; 
    private static List<PricebookEntry> entries; 
    private static List<SBQQ__ProductOption__c> prodOptions; 
    private static List<SBQQ__QuoteLine__c> lines; 
 
}