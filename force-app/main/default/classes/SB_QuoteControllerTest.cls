@isTest
private class SB_QuoteControllerTest {
    
    private static Account customer; 
    private static Opportunity opp; 
    private static SBQQ__Quote__c quoteRec; 
    private static List<Product2> sampleProducts; 
    private static List<PricebookEntry> entries; 
    private static List<SBQQ__ProductOption__c> prodOptions; 
    private static List<SBQQ__QuoteLine__c> lines; 
    
    @isTest static void test_method_one() {
        Product_Line__c prodLine = testdatagenerator.createProductLine();
        Account acnt = testDataGenerator.createAccount();
        Aircraft__c aircraft = testDatagenerator.createAircraft(prodLine.Id, acnt.Id);
        
        AddWork_Trigger_Setting__c add = new  AddWork_Trigger_Setting__c();
        add.Name = 'AddWork';
        add.IsActive__c = False;
        insert add;
               
        Product_Process_Setting__c pps = new Product_Process_Setting__c();
        pps.Active__c = true;
        insert pps;
      
        //Get Record Id for Opportunity
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
        Id rtId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
        
        sampleProducts = new List<Product2>{ 
            new Product2(Name = 'Bundle Parent', IsActive = true, SBQQ__AssetConversion__c = 'One per quote line', SBQQ__Specifications__c ='ABC'), 
                new Product2(Name = 'Subscription Child', IsActive = true, SBQQ__SubscriptionPricing__c = 'Percent Of Total', SBQQ__Specifications__c ='ABC',SBQQ__SubscriptionTerm__c = 12, SBQQ__SubscriptionType__c = 'Renewable'), 
                new Product2(Name = 'Non-Subscription Child 1', IsActive = true, SBQQ__AssetConversion__c = 'One per quote line',SBQQ__Specifications__c ='ABC'), 
                new Product2(Name = 'Non-Subscription Child 2', IsActive = true, SBQQ__AssetConversion__c = 'One per quote line',SBQQ__Specifications__c ='ABC', Family = 'Materials'), 
                new Product2(Name = 'Standalone', IsActive = true, SBQQ__AssetConversion__c = 'One per unit',SBQQ__Specifications__c ='ABC'), 
                new Product2(Name = 'Subscription Extra', IsActive = true,SBQQ__Specifications__c ='ABC', SBQQ__SubscriptionPricing__c = 'Fixed Price', SBQQ__SubscriptionTerm__c = 12, SBQQ__SubscriptionType__c = 'Renewable') 
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
            // MasterOpportunitylookup__c = masterOpportunity.id,
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
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = childQuote1.Id, SBQQ__Number__c = 1, SBQQ__Product__c = sampleProducts[0].Id, SBQQ__Quantity__c = 1, SBQQ__NetPrice__c = 100, SBQQ__Bundle__c = true, ExcludeFromExecutiveSummary__c = true)); 
        // Subscription child 
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = childQuote1.Id, SBQQ__Number__c = 2,SBQQ__Product__c = sampleProducts[1].Id, SBQQ__Quantity__c = 1, ExcludeFromExecutiveSummary__c = false, SBQQ__SubscriptionPricing__c = 'Percent Of Total', SBQQ__StartDate__c = System.today(), SBQQ__EndDate__c = System.today().addMonths(12).addDays(-1), SBQQ__DefaultSubscriptionTerm__c = 12, SBQQ__ListPrice__c = 200, SBQQ__NetPrice__c = 200)); 
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = childQuote1.Id, SBQQ__Number__c = 3,SBQQ__Product__c = sampleProducts[2].Id, SBQQ__Quantity__c = 1, SBQQ__ListPrice__c = 200, SBQQ__NetPrice__c = 200, ExcludeFromExecutiveSummary__c = false)); 
        lines.add(new SBQQ__QuoteLine__c(SBQQ__Quote__c = childQuote1.Id,SBQQ__Number__c = 4, SBQQ__Product__c = sampleProducts[3].Id, SBQQ__Quantity__c = 1, SBQQ__ListPrice__c = 200, SBQQ__NetPrice__c = 200, ExcludeFromExecutiveSummary__c = false)); 
        
        insert lines; 
        
        lines[1].SBQQ__RequiredBy__c = lines[0].id;
        lines[2].SBQQ__RequiredBy__c = lines[0].id;
        lines[3].SBQQ__RequiredBy__c = lines[0].id;
        lines[3].Sync_To_Product__c = true;
        
        update lines;
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(childQuote1);
        
        SB_QuoteController qc = new SB_QuoteController(sc);
        qc.checkAndUpdate(); 
        
        Test.stopTest();
    }
    
    
}