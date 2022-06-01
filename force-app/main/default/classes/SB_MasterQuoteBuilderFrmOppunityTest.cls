/**
*@author - Krunal Pala
*@Date - 22/2/2017
*Purpose - Test Class for SB_MasterQuoteBuilderFrmOppunity
*/
@isTest
private class SB_MasterQuoteBuilderFrmOppunityTest {
	
	@isTest

	public static void createMasterQuoteTest() {
		
         AddWork_Trigger_Setting__c add = new  AddWork_Trigger_Setting__c();
            add.Name = 'AddWork';
            add.IsActive__c = False;
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
 


		// Create Products
		/*List<Product2> productList = new List<Product2>();

        Product2 prodChild1 = new Product2(
        	Name = 'TRIM JACK SN 9304',
        	ProductCode = 'Code1',
            Family = 'Bundle',
        	isActive = true);

        productList.add(prodChild1);

		Product2 prodChild2 = new Product2(
        	Name = 'TRIM JACK SN 9304',
        	ProductCode = 'Code2',
            SBQQ__OptionSelectionMethod__c = 'Add',
        	isActive = true);

		productList.add(prodChild2);

		insert productList;

        SBQQ__ProductFeature__c prodFeature = new SBQQ__ProductFeature__c(
            Name = 'feature1',
            SBQQ__Number__c =1,
            SBQQ__ConfiguredSKU__c = prodChild1.id);
        insert prodFeature;

        List<SBQQ__ProductOption__c> productOptionList = new List<SBQQ__ProductOption__c>();
       /* SBQQ__ProductOption__c productOption = new SBQQ__ProductOption__c(
            SBQQ__Selected__c = true,
            SBQQ__QuantityEditable__c = true,
            SBQQ__Number__c =1,
            SBQQ__ConfiguredSKU__c = prodChild2.id,
            SBQQ__Type__c = 'Component',
            SBQQ__OptionalSKU__c = prodChild1.id
            );

        productOptionList.add(productOption);*/

       /* SBQQ__ProductOption__c productOption1 = new SBQQ__ProductOption__c(
            SBQQ__Selected__c = true,
            SBQQ__QuantityEditable__c = true,
            SBQQ__ConfiguredSKU__c = prodChild1.id,
            SBQQ__Number__c =2,
            SBQQ__Type__c = 'Component',
            SBQQ__OptionalSKU__c = prodChild2.id,
            SBQQ__Feature__c =prodFeature.id
            
            );

        productOptionList.add(productOption1);
        insert productOptionList;
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

		insert pbentrys;*/

        Product_Line__c prodLine = new Product_Line__c(
            Product_Line_Family__c = 'Aircraft',
            Name = 'new'
            );

        insert prodLine;
		
		// Master Opportunity
        Opportunity masterOpportunity = new Opportunity(
        Opportunity_Name_Details__c = 'Krunal Opportunity Master',
        RecordTypeId=rtId,
        Product_Line__c = prodLine.id,
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

       /* Opportunity childOpp2 = new Opportunity(
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

       // childOpportunity.add(childOpp2);*/


        insert childOpportunity;

        Aircraft__c aircraft = new Aircraft__c();
       aircraft.Product_Line__c = prodLine.id;
       aircraft.Aircraft_Make__c = 'CASA';
       aircraft.Aircraft_SN__c = '213';
       aircraft.name = 'new';
       aircraft.Aircraft_Type__c = 'Aircraft';
       aircraft.OwnerId = UserInfo.getUserId();

       insert aircraft;

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

      /*  SBQQ__Quote__c childQuote2 = new SBQQ__Quote__c();
        childQuote2.SBQQ__PrimaryContact__c = childOpp2.Contact__c;
        childQuote2.SBQQ__Type__c = 'Quote child 2';
        childQuote2.SBQQ__Opportunity2__c = childOpp2.Id;
        childQuote2.SBQQ__PriceBook__c = pb2.id;
       // childQuotes.add(childQuote2);*/

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


      /*  lines[0].SBQQ__Bundle__c = true; 
        lines[1].SBQQ__RequiredBy__c = lines[0].Id; 
         lines[2].SBQQ__RequiredBy__c = lines[0].Id; 
        lines[3].SBQQ__RequiredBy__c = lines[0].Id; 
       
        update lines;*/

        // Create Line Items
        /*List<SBQQ__QuoteLine__c> lineItemsInsert = new List<SBQQ__QuoteLine__c>();

        SBQQ__QuoteLine__c quote1Line1 = new SBQQ__QuoteLine__c();
        quote1Line1.SBQQ__Quote__c = childQuote1.id;
        quote1Line1.SBQQ__Product__c = prodChild1.id;
        quote1Line1.SBQQ__Quantity__c=1;
        quote1Line1.SBQQ__Number__c = 1;
        quote1Line1.SBQQ__PricingMethod__c= 'List';
        quote1Line1.SBQQ__Bundled__c = true;
        quote1Line1.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote1Line1.SBQQ__UnitCost__c = 0;
        quote1Line1.SBQQ__ListPrice__c = 0;
        insert quote1Line1;


        SBQQ__QuoteLine__c quoteline3 = new SBQQ__QuoteLine__c();
        quoteline3.SBQQ__Quote__c = childQuote1.id;
        quoteline3.SBQQ__Product__c = prodChild2.id;
        quoteline3.SBQQ__Quantity__c=1;
        quoteline3.SBQQ__RequiredBy__c = quote1Line1.id;
      //  quoteline3.SBQQ__ProductOption__c = productOption1.id;
        quoteline3.SBQQ__Number__c = 2;
        quoteline3.SBQQ__PricingMethod__c= 'List';
        quoteline3.Product_Pricing__c = 'Cost Plus Desired Margin';
        quoteline3.SBQQ__UnitCost__c = 3000;
        quoteline3.SBQQ__ListPrice__c = 3000;
        lineItemsInsert.add(quoteline3);


   /*     SBQQ__QuoteLine__c quoteline4 = new SBQQ__QuoteLine__c();
        quoteline4.SBQQ__Quote__c = childQuote2.id;
        quoteline4.SBQQ__Product__c = prodChild2.id;
        quoteline4.SBQQ__Quantity__c=1;
        quoteline4.SBQQ__Number__c = 1;
        quoteline4.SBQQ__PricingMethod__c= 'List';
        quoteline4.Product_Pricing__c = 'Cost Plus Desired Margin';
        quoteline4.SBQQ__UnitCost__c = 3000;
        quoteline4.SBQQ__ListPrice__c = 3000;
    //    insert quoteline4;

        SBQQ__QuoteLine__c quote2Line1 = new SBQQ__QuoteLine__c();
        quote2Line1.SBQQ__Quote__c = childQuote2.id;
        quote2Line1.SBQQ__Product__c = prodChild1.id;
        quote2Line1.SBQQ__Quantity__c=1;
      //    quote2Line1.SBQQ__RequiredBy__c = quoteline4.id;
        //  quote2Line1.SBQQ__ProductOption__c = productOption1.id;
        quote2Line1.SBQQ__Number__c = 2;
        quote2Line1.SBQQ__PricingMethod__c= 'List';
        quote2Line1.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote2Line1.SBQQ__UnitCost__c = 3200;
        quote2Line1.SBQQ__ListPrice__c = 3200;
       // lineItemsInsert.add(quote2Line1);*/

//        insert lineItemsInsert;

        // Make child quotes primary so that they sync. with their opp.
        childQuote1.SBQQ__Primary__c = true;
     //   childQuote2.SBQQ__Primary__c = true;

        update childQuotes;
       

    	ApexPages.StandardController sc = new ApexPages.StandardController(masterOpportunity);
    
      	
      	Test.startTest();  

      	SB_MasterQuoteBuilderFrmOppunity mqb = new SB_MasterQuoteBuilderFrmOppunity(sc);
      	SBQQ__Quote__c myQuote = SB_MasterQuoteBuilderFrmOppunity.createMasterQuote(masterOpportunity.id);
      	System.assertNotEquals(myQuote,null);

      	SBQQ__Quote__c masterQuote = [Select Id from SBQQ__Quote__c where SBQQ__Opportunity2__c = :masterOpportunity.id];

      	System.assertNotEquals(masterQuote,null);

        delete childOpportunity;
        SB_MasterQuoteBuilderFrmOppunity.createMasterQuote(masterOpportunity.id);

        masterOpportunity.Master_Opportunity__c = false;
        update masterOpportunity;
       SB_MasterQuoteBuilderFrmOppunity.createMasterQuote(masterOpportunity.id);

        SB_MasterQuoteBuilderFrmOppunity.Bundle  b = new SB_MasterQuoteBuilderFrmOppunity.Bundle();
        b.mainLine = lines[0];
        SB_MasterQuoteBuilderFrmOppunity.Bundle  b1 = new SB_MasterQuoteBuilderFrmOppunity.Bundle();
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