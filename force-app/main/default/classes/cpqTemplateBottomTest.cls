@isTest
public class cpqTemplateBottomTest {
    
    @isTest
    public static void testMethodForQtExAndPropDetSection(){
        
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
        
        Product_Line__c prodLine = new Product_Line__c(
            Product_Line_Family__c = 'Aircraft',
            Name = 'new'
        );
        
        insert prodLine;
        
        Product_Line__c prodLine1 = new Product_Line__c(
            Product_Line_Family__c = 'Avionics',
            Name = 'Avionics'
        );
        
        insert prodLine1;
        
        // Create Products
        List<Product2> productList = new List<Product2>();
        
        Product2 prodChild1 = new Product2(
            Name = 'TRIM JACK SN 9304',
            ProductCode = 'Code1',
            Family='Materials',
            SBQQ__Specifications__c = 'aaaaaa',
            Executive_Summary_Group__c='Airframe',
            isActive = true);
        
        productList.add(prodChild1);
        
        Product2 prodChild2 = new Product2(
            Name = 'TRIM JACK SN 9304',
            ProductCode = 'Code1',
            SBQQ__Specifications__c = 'aaaaaa',
            Family='Labor',
            Executive_Summary_Group__c='Engine',
            isActive = true);
        productList.add(prodChild2);
        
        Product2 prodChild3 = new Product2(
            Name = 'TRIM JACK SN 9304',
            ProductCode = 'Code1',
            Family='Materials',
            SBQQ__Specifications__c = 'aaaaaa',
            Executive_Summary_Group__c='Airframe',
            isActive = true);
        
        productList.add(prodChild3);
        
        Product2 prodChild4 = new Product2(
            Name = 'TRIM JACK SN 9304',
            ProductCode = 'Code1',
            Family='Labor',
            SBQQ__Specifications__c = 'aaaaaa',
            Executive_Summary_Group__c='Airframe',
            isActive = true);
        
        productList.add(prodChild4);
        
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
        
        PricebookEntry standardPrice2 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prodChild3.Id,
            UnitPrice = 11000, IsActive = true);
        pbentryStandard.add(standardPrice2);
        
        PricebookEntry standardPrice3 = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = prodChild4.Id,
            UnitPrice = 11000, IsActive = true);
        pbentryStandard.add(standardPrice3);
        
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
        
        PricebookEntry three = new PricebookEntry();
        three.pricebook2Id = pb2.id;
        three.product2id = prodChild3.id;
        three.unitprice = 1252.0;
        three.isactive = true;
        pbentrys.add(three);
        
        PricebookEntry four = new PricebookEntry();
        four.pricebook2Id = pb2.id;
        four.product2id = prodChild4.id;
        four.unitprice = 1252.0;
        four.isactive = true;
        pbentrys.add(four);
        
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
            Type = 'Avionics',
            Product_Line__c = prodLine1.id,
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
        childQuote1.SBQQ__Primary__c = true;
        childQuotes.add(childQuote1);
               
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
        quote1Line1.Specification__c = 'aaaaa';
        quote1Line1.OriginalSpecification__c ='aaaaa';
        lineItemsInsert.add(quote1Line1);
        
        SBQQ__QuoteLine__c quote2Line1 = new SBQQ__QuoteLine__c();
        quote2Line1.SBQQ__Quote__c = childQuote1.id;
        quote2Line1.SBQQ__Product__c = prodChild1.id;
        quote2Line1.SBQQ__Quantity__c=1;
        quote2Line1.SBQQ__Number__c = 1;
        quote2Line1.SBQQ__PricingMethod__c= 'List';
        quote2Line1.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote2Line1.SBQQ__UnitCost__c = 3200;
        quote2Line1.SBQQ__ListPrice__c = 3200;
        quote1Line1.Specification__c = 'aaaaa';
        lineItemsInsert.add(quote2Line1);
        
        SBQQ__QuoteLine__c quote2Line3 = new SBQQ__QuoteLine__c();
        quote2Line3.SBQQ__Quote__c = childQuote1.id;
        quote2Line3.SBQQ__Product__c = prodChild3.id;
        quote2Line3.SBQQ__Quantity__c=1;
        quote2Line3.SBQQ__Number__c = 1;
        quote2Line3.SBQQ__PricingMethod__c= 'List';
        quote2Line3.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote2Line3.SBQQ__UnitCost__c = 3200;
        quote2Line3.SBQQ__ListPrice__c = 3200;
        lineItemsInsert.add(quote2Line3);
        
        SBQQ__QuoteLine__c quote2Line4 = new SBQQ__QuoteLine__c();
        quote2Line4.SBQQ__Quote__c = childQuote1.id;
        quote2Line4.SBQQ__Product__c = prodChild4.id;
        quote2Line4.SBQQ__Quantity__c=1;
        quote2Line4.SBQQ__Number__c = 1;
        quote2Line4.SBQQ__PricingMethod__c= 'List';
        quote2Line4.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote2Line4.SBQQ__UnitCost__c = 3200;
        quote2Line4.SBQQ__ListPrice__c = 3200;
        lineItemsInsert.add(quote2Line4);
        
        insert lineItemsInsert;
        
        // Make child quotes primary so that they sync. with their opp.     
        Test.startTest();
        
        Test.setCurrentPageReference(new PageReference('Page.cpqTemplateBottom')); 
        System.currentPageReference().getParameters().put('qid',childQuote1.id );
        
        cpqTemplateBottomHandler tbh = new cpqTemplateBottomHandler();
        //childQuote1 = tbh.getQuote();
        Test.stopTest();       
    }   
}