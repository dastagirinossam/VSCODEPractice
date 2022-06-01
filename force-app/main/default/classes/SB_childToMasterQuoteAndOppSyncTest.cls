/**
*@author - Krunal Pala
*@Date - 24/2/2017
*Purpose - Test Class for SB_childToMasterQuoteAndOppSync
*/
@isTest
private class SB_childToMasterQuoteAndOppSyncTest {
    
    @testSetup
    
    public static void syncChildQuoteWithMaster() {
        AddWork_Trigger_Setting__c add = new  AddWork_Trigger_Setting__c();
        add.Name = 'AddWork';
        add.IsActive__c = false;
        insert add;
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
        
        Id rtId2 = opportunityRecordTypeInfo .get('RFQ').getRecordTypeId();
        
        
        Product_Line__c prodLine = new Product_Line__c(
            Product_Line_Family__c = 'Aircraft',
            Name = 'new'
        );
        
        insert prodLine;
        
        // Create Products
        List<Product2> productList = new List<Product2>();
        
        Product2 prodChild1 = new Product2(
            Name = 'TRIM JACK SN 9304',
            ProductCode = 'Code1',
            isActive = true);
        
        productList.add(prodChild1);
        
        Product2 prodChild2 = new Product2(
            Name = 'TRIM JACK SN 9304',
            ProductCode = 'Code1',
            isActive = true);
        productList.add(prodChild2);
        
        insert productList;
        
        // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
        
        List<PricebookEntry> pbentryStandard = new List<PricebookEntry>();
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prodChild2.Id,
            UnitPrice = 10000, IsActive = true);
        pbentryStandard.add(standardPrice);
        
        PricebookEntry standardPrice1 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prodChild1.Id,
            UnitPrice = 11000, IsActive = true);
        pbentryStandard.add(standardPrice1);
        
        insert pbentryStandard;
        
        // Custom Price Book
        PriceBook2 pb2=new PriceBook2();
        pb2.Name = 'test';
        pb2.IsActive = true;
        
        insert pb2;
        
        List<PricebookEntry> pbentrys = new List<PricebookEntry>();
        
        PricebookEntry one = new PricebookEntry();
        one.pricebook2Id = pb2.id;
        one.product2id = prodChild1.id;
        one.unitprice = 1249.0;
        one.isactive = true;
        pbentrys.add(one);
        
        PricebookEntry two = new PricebookEntry();
        two.pricebook2Id = pb2.id;
        two.product2id = prodChild2.id;
        two.unitprice = 1252.0;
        two.isactive = true;
        pbentrys.add(two);
        
        insert pbentrys;
        
        // Master Opportunity
        Opportunity masterOpportunity = new Opportunity(
            Opportunity_Name_Details__c = 'Krunal Opportunity Master',
            RecordTypeId=rtId,
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
            Product_Line__c = prodLine.id,
            SubType__c = 'Airframe - Inspection',
            LeadSource = 'CPM',
            QuoteDelivery__c = 'Hand Delivery',
            QuoteRequiredBy__c =  Date.today(),
            Base_Quote_Number__c = '1',
            QuotedDate__c =  Date.today(),
            Concession1__c = 'None',
            Agent_Representative__c = 'Not Applicable',
            Master_Opportunity__c = true,
            
            Pricebook2Id =pb2.id);
        
        insert masterOpportunity;
        SBQQ__Quote__c masterQuote = new SBQQ__Quote__c();
        masterQuote.SBQQ__PrimaryContact__c = masterOpportunity.Contact__c;
        masterQuote.SBQQ__Type__c = 'Quote child 1';
        masterQuote.SBQQ__Opportunity2__c = masterOpportunity.Id;
        masterQuote.SBQQ__PriceBook__c = pb2.id;
        
        //masterQuote.MasterOpportunityLookup__c = masterOpportunity.Id;
        // masterQuote.SBQQ__PrimaryQuote__c =true;
        insert masterQuote;
        Opportunity  masteroppUpdate = [Select Id ,Name ,SBQQ__PrimaryQuote__c from Opportunity  where Id =: masterOpportunity.id Limit 1];
        masteroppUpdate.SBQQ__PrimaryQuote__c = masterQuote.id;
        Update masteroppUpdate;
        //
        // masterQuote.MasterOPportunityLOOkuo__c = some mater opp.Id;
        
        
        //Child Opportunity
        List<Opportunity> childOpportunity = new List<Opportunity>();
        
        Opportunity childOpp1 = new Opportunity(
            Opportunity_Name_Details__c = 'Krunal Opportunity Child 1',
            RecordTypeId=rtId2,
            RSM__c = 'Campbell,Tom',
            Name = 'Opportunity Child 1',
            AccountId = acnt.id,
            StageName = 'RFQ - Subsection Complete',
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
            Pricebook2Id =pb2.id);
        
        childOpportunity.add(childOpp1);
        
        Opportunity childOpp2 = new Opportunity(
            Opportunity_Name_Details__c = 'Krunal Opportunity Child 2',
            RecordTypeId=rtId,
            RSM__c = 'Campbell,Tom',
            Name = 'Opportunity Child 2',
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
            Pricebook2Id =pb2.id);
        
        childOpportunity.add(childOpp2);
        
        
        insert childOpportunity;
        
        
        
        // Create Child quotes
        List<SBQQ__Quote__c> childQuotes = new List<SBQQ__Quote__c>();
        
        SBQQ__Quote__c childQuote1 = new SBQQ__Quote__c();
        childQuote1.SBQQ__PrimaryContact__c = childOpp1.Contact__c;
        childQuote1.SBQQ__Type__c = 'Quote child 1';
        childQuote1.SBQQ__Opportunity2__c = childOpp1.Id;
        childQuote1.SBQQ__PriceBook__c = pb2.id;
        childQuotes.add(childQuote1);
        
        SBQQ__Quote__c childQuote2 = new SBQQ__Quote__c();
        childQuote2.SBQQ__PrimaryContact__c = childOpp2.Contact__c;
        childQuote2.SBQQ__Type__c = 'Quote child 2';
        childQuote2.SBQQ__Opportunity2__c = childOpp2.Id;
        childQuote2.SBQQ__PriceBook__c = pb2.id;
        childQuotes.add(childQuote2);
        
        insert childQuotes;
        
        // Create Line Items
        List<SBQQ__QuoteLine__c> lineItemsInsert = new List<SBQQ__QuoteLine__c>();
        
        SBQQ__QuoteLine__c quote1Line1 = new SBQQ__QuoteLine__c();
        quote1Line1.SBQQ__Quote__c = childQuote1.id;
        quote1Line1.SBQQ__Product__c = prodChild2.id;
        quote1Line1.SBQQ__Quantity__c=1;
        quote1Line1.SBQQ__Number__c = 1;
        quote1Line1.SBQQ__PricingMethod__c= 'List';
        quote1Line1.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote1Line1.SBQQ__UnitCost__c = 3000;
        quote1Line1.SBQQ__ListPrice__c = 3000;
        
        lineItemsInsert.add(quote1Line1);
        
        SBQQ__QuoteLine__c quote2Line1 = new SBQQ__QuoteLine__c();
        quote2Line1.SBQQ__Quote__c = childQuote2.id;
        quote2Line1.SBQQ__Product__c = prodChild1.id;
        quote2Line1.SBQQ__Quantity__c=1;
        quote2Line1.SBQQ__Number__c = 1;
        quote2Line1.SBQQ__PricingMethod__c= 'List';
        quote2Line1.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote2Line1.SBQQ__UnitCost__c = 3200;
        quote2Line1.SBQQ__ListPrice__c = 3200;
        lineItemsInsert.add(quote2Line1);
        
        insert lineItemsInsert;
        
        // Make child quotes primary so that they sync. with their opp.
        childQuote1.SBQQ__Primary__c = true;
        childQuote2.SBQQ__Primary__c = true;
        
        update childQuotes;
        
        ApexPages.StandardController oppController = new ApexPages.StandardController(masterOpportunity);
        
        SBQQ__Quote__c masterQuote1 = SB_MasterQuoteBuilderFrmOppunity.createMasterQuote(masterOpportunity.id);
        
        SB_childToMasterQuoteAndOppSync.getSyncToMasterQuoteAndOpportunity(masterQuote.Id);
        system.debug(masterQuote.name);
        
        
        
        
    }
    
    @isTest
    public static void testSync(){
        Test.startTest();  
        
        SBQQ__Quote__c childQuote1 = [Select Id, Name from SBQQ__Quote__c where SBQQ__Type__c = 'Quote child 1' Limit 1];
        SBQQ__QuoteLine__c[] lines = [Select id, Name,SBQQ__Number__c from SBQQ__QuoteLine__c limit 5];
        ApexPages.StandardController childQuoteController = new ApexPages.StandardController(childQuote1);
        
        SB_childToMasterQuoteAndOppSync cmObj = new SB_childToMasterQuoteAndOppSync(childQuoteController);
        SB_childToMasterQuoteAndOppSync.getSyncToMasterQuoteAndOpportunity((string)childQuote1.Id);
        
        
        //Check we have error/page messages
        //System.assert(ApexPages.hasMessages());
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Successfully')) b = true;
        }
        //system.assertEquals(b,true);
        
        SB_childToMasterQuoteAndOppSync.Bundle  bundle = new SB_childToMasterQuoteAndOppSync.Bundle();
        bundle.mainLine = lines[0];
        SB_childToMasterQuoteAndOppSync.Bundle  bundle1 = new SB_childToMasterQuoteAndOppSync.Bundle();
        bundle1.mainLine = lines[1];
        bundle.compareTo(bundle1);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testNegateive2(){
        Test.startTest();  
        
        SBQQ__Quote__c childQuote2 = [Select Id, Name,SBQQ__Opportunity2__c from SBQQ__Quote__c where SBQQ__Type__c = 'Quote child 2'];
        
        ApexPages.StandardController childQuoteController = new ApexPages.StandardController(childQuote2);
        
        SB_childToMasterQuoteAndOppSync cmObj = new SB_childToMasterQuoteAndOppSync(childQuoteController);
        SB_childToMasterQuoteAndOppSync.getSyncToMasterQuoteAndOpportunity((string)childQuote2.Id);
        
        
        //Check we have error/page messages
        //System.assert(ApexPages.hasMessages());
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Successfully')) b = true;
        }
        system.assertEquals(b,false);
        
        childQuote2.SBQQ__Opportunity2__c = null;
        update childQuote2;
        cmObj = new SB_childToMasterQuoteAndOppSync(childQuoteController);
        SB_childToMasterQuoteAndOppSync.getSyncToMasterQuoteAndOpportunity((string)childQuote2.Id);
        
        Test.stopTest();
    }
    
    @isTest
    public static void testNegateiveNoLines(){
        Test.startTest();
        
        SBQQ__Quote__c childQuote1 = [Select Id, Name from SBQQ__Quote__c where SBQQ__Type__c = 'Quote child 1' limit 1];
        
        SBQQ__QuoteLine__c[] ql = [select Id from SBQQ__QuoteLine__c where SBQQ__Quote__c = : childQuote1.id ];
        
        delete ql;
        
        ApexPages.StandardController childQuoteController = new ApexPages.StandardController(childQuote1);
        
        SB_childToMasterQuoteAndOppSync cmObj = new SB_childToMasterQuoteAndOppSync(childQuoteController);
        SB_childToMasterQuoteAndOppSync.getSyncToMasterQuoteAndOpportunity((string)childQuote1.Id);
        
        
        Test.stopTest();
    }
    
    @isTest
    public static void testSyncNegative(){
        
        Test.startTest();
        
        SBQQ__Quote__c childQuote1 = [Select Id, Name,SBQQ__Primary__c  from SBQQ__Quote__c where SBQQ__Type__c = 'Quote child 1' Limit 1];
        
        childQuote1.SBQQ__Primary__c = false;
        
        update childQuote1;
        
        ApexPages.StandardController childQuoteController = new ApexPages.StandardController(childQuote1);
        
        SB_childToMasterQuoteAndOppSync cmObj = new SB_childToMasterQuoteAndOppSync(childQuoteController);
        SB_childToMasterQuoteAndOppSync.getSyncToMasterQuoteAndOpportunity((string)childQuote1.Id);
        
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Please')) b = true;
        }
        // system.assert(b);
        
        Test.stopTest();
    }
}