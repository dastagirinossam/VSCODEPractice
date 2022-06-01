@isTest
private class SB_QuoteTriggerHandlerTest {

     
    @testSetup 
    static void setup(){

		Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        
        // Creating users
        List<User> userList = new List<User>();

        User usr = createTestUser(null, pf.Id, 'Test FirstName', 'Test LastName');
        userList.add(usr);
        User usr1 = createTestUser(null, pf.Id, 'Test FirstName 1', 'Test LastName 1');
        userList.add(usr1);
        User usr2 = createTestUser(null, pf.Id, 'Test FirstName2', 'Test LastName 2');
        userList.add(usr2);
        insert userList;

        // creating userroles
        List<UserRole> userRoleList = new List<UserRole>();
        UserRole ur = new UserRole(Name = 'Vice President Sales');
        userRoleList.add(ur);
        UserRole ur1 = new UserRole(Name = 'President Sales');
        userRoleList.add(ur1);
        UserRole ur2 = new UserRole(Name = 'Sales Manager');
        userRoleList.add(ur2);
        
        insert userRoleList;
        usr.UserRoleId = ur.id;
        usr1.UserRoleId = ur1.id;
        usr2.UserRoleId = ur2.id;

        userList = new List<User>();
        userList.add(usr);
        userList.add(usr1);
        userList.add(usr2);

        update userList;
      System.runAs (usr) {
		// Insert Account
	 	Account acnt2 = new Account();
          acnt2.Name = 'test name';
          acnt2.BillingStreet = '1600 Amphitheatre Parkway';
          acnt2.BillingCity = 'Mountain View';
          acnt2.BillingState = 'CA';
          acnt2.BillingPostalCode = '94043';
          acnt2.BillingCountry = 'United States';
        insert acnt2;
          
        Account acnt = new Account();
          acnt.Name = 'test2 name2';
          acnt.BillingStreet = '1600 Amphitheatre Parkway';
          acnt.BillingCity = 'Mountain View';
          acnt.BillingState = 'CA';
          acnt.BillingPostalCode = '94043';
          acnt.BillingCountry = 'United States';
          acnt.Billing_Account__c = acnt2.Id;
        insert acnt;

        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
		Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
		Id rtId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();

        Id rtId2 = opportunityRecordTypeInfo .get('RFQ').getRecordTypeId();
          Product_Line__c prodLine = new Product_Line__c(
            Product_Line_Family__c = 'Aircraft',
            Name = 'new'
            );

        insert prodLine;

        List<Product2> productList = new List<Product2>();
         Product2 prodChild1 = new Product2(
        	Name = 'AdHoc Material',
        	ProductCode = 'Code1',
        	isActive = true);

        productList.add(prodChild1);

		Product2 prodChild2 = new Product2(
        	Name = 'AdHoc Material',
        	ProductCode = 'Code1',
        	isActive = true);
		productList.add(prodChild2);

		insert productList;

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

         Aircraft__c aircraft = new Aircraft__c();
       aircraft.Product_Line__c = prodLine.id;
       aircraft.Aircraft_Make__c = 'CASA';
       aircraft.Aircraft_SN__c = '213';
       aircraft.name = 'NA';
       aircraft.Aircraft_Type__c = 'Aircraft';
       aircraft.OwnerId = UserInfo.getUserId();

       insert aircraft;

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

        Equipment__c equipment = new Equipment__c(
            Product_Line__c = prodLine.id,
            Account__c = acnt.id,
            Aircraft__c = aircraft.id,
            Equipment_Prefix__c = 'TFE',
            EngineorAPUSN__c = 'ABC',
            Equipment_Type__c = 'Engine',
            Equipment_Status__c = 'In-Operation',
            Model__c = 'HTF7000'
            );

        insert equipment;

        // Master Opportunity
        Opportunity masterOpportunity = new Opportunity(
        Opportunity_Name_Details__c = 'Krunal Opportunity Master',
        RecordTypeId=rtId,
        RSM__c = 'Campbell,Tom',
        Name = 'Opportunity Master',
        Aircraft__c = aircraft.id,
        Equipment__c = equipment.id,
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
        SBQQ__Contracted__c = true,
        Pricebook2Id =pb2.id);
                                      
        insert masterOpportunity;  

        Contract contract = new Contract(
        	Name = 'conctract',
        	SBQQ__Opportunity__c = masterOpportunity.id,
        	Status = 'Draft',
        	StartDate = System.today(),
        	ContractTerm =4,
        	AccountId = acnt.id);

        insert contract;

		//Child Opportunity
          List<Opportunity> childOpportunity = new List<Opportunity>();
          Opportunity childOpp1 = new Opportunity(
              Opportunity_Name_Details__c = 'Krunal Opportunity Child 1',
              RecordTypeId=rtId2,
              RSM__c = 'Campbell,Tom',
              Name = 'Opportunity Child 1',
              AccountId = acnt.id,
              AFSM_Lookup__c =usr2.id,
              Aircraft__c = aircraft.id,
              Equipment__c = equipment.id,
              StageName = 'New Opportunity',
              Amount = decimal.valueof('1471620'),
              CustomerName__c = 'World Jet, Inc.',
              Facility__c = 'SPI',
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
              SBQQ__AmendedContract__c = contract.id,
              Pricebook2Id =pb2.id);
          
          childOpportunity.add(childOpp1);
          
          insert childOpportunity;
          
          Sub_Type_2__c subtype2 = new Sub_Type_2__c(
              Product_Line__c = prodLine.id,
              Opportunity_Type__c = 'TPE331',
              Out_the_Door__c = 444,
              Generic__c = true,
              Name = 'hello'
          );

          insert subtype2;
          
          
          
          Test.startTest();
          
          SBQQ__Quote__c childQuote2 = new SBQQ__Quote__c();
          childQuote2.SBQQ__Account__c = acnt.Id;
          childQuote2.SBQQ__Primary__c = true;
          childQuote2.SBQQ__Type__c = 'Amendment';
          childQuote2.SBQQ__Opportunity2__c = childOpp1.Id;
          childQuote2.SBQQ__PriceBook__c = pb2.id;
          childQuote2.Facility1__c = 'SPI';
          childQuote2.SBQQ__Primary__c = true;
          childQuote2.Use_Billing_Address__c = true;
          
          insert childQuote2;
          
          // Create Line Items
          List<SBQQ__QuoteLine__c> lineItemsInsert = new List<SBQQ__QuoteLine__c>();
          
          SBQQ__QuoteLine__c quote1Line1 = new SBQQ__QuoteLine__c();
          quote1Line1.SBQQ__Quote__c = childQuote2.id;
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
          
          childOpp1.Previous_Stage__c = 'New Opportunity';
          childOpp1.StageName = 'RFS';
          childOpp1.recordTypeId = opportunityRecordTypeInfo .get('RFS').getRecordTypeId();
          childOpp1.SubType2__c = subtype2.id;
          childOpp1.SubType__c = 'Cust Direct';
          childOpp1.LeadSource = 'Calendar';
          childOpp1.QuoteDelivery__c = 'None';
          childOpp1.QuoteRequiredBy__c = System.today();
          childOpp1.QuotedDate__c = System.today();
          childOpp1.Agent_Representative__c = 'AR -  Mordern Jet Solutions';
          childOpp1.Agent_Commission_Amount_or_Percent__c ='2';
          childOpp1.Competitor__c = 'No Competitor';
          childOpp1.WinorLossReason1__c = 'Capability';
          childOpp1.Win_Loss_Description__c ='eee';
          childOpp1.Facility__c='SPI';
          
          childOpp1.Probability=100;
          
          update childOpp1;
          
          Opportunity childOpp2 = new Opportunity(
              Opportunity_Name_Details__c = 'bname',
              Name ='Opp',
              Amount = 500,
              StageName = 'RFQ Accepted',
              CloseDate=System.today(),
              SBQQ__AmendedContract__c = contract.id
          );
          
          List<Opportunity> opplist = new List<Opportunity>();
          opplist.add(childOpp2);
          
          List<SBQQ__Quote__c> quoteList = new List<SBQQ__Quote__c>();
          quoteList.add(childQuote2);
          
          SB_OpportunityTriggerHandler.OpportunityBeforeInsert(opplist);
          
          SB_QuoteTriggerHandler qth = new SB_QuoteTriggerHandler();
          
          qth.updateFacilityAndAircraftForAmmendment(quoteList);
          qth.checkFacility(quoteList,'Insert');
          
          System.debug('childOpp1 ==$$'+childOpp1.IsWon );
          System.debug('SBQQ__AmendedContract__c ==$$'+childOpp1.SBQQ__AmendedContract__c );
          
          Map<Id, Opportunity> opportunityTriggerMap = new Map<Id, Opportunity>([Select Id,SBQQ__PrimaryQuote__c, Facility__c,IsWon,SBQQ__AmendedContract__c from Opportunity where id= :childOpp1.id]);
          SB_OpportunityTriggerHandler.updateAmountsInQuote(opportunityTriggerMap);
          
          Test.stopTest();
      }

	}

	// Private method to create user.
    private static User createTestUser(Id roleId, Id profID, String fName, String lName)
    {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
       
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = fName,
                                lastName = lName,
                                email = uniqueName + '@test' + orgId + '.org',
                                Username = uniqueName + '@test' + orgId + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                Title = 'VP',
                                MobilePhone = '1234567890',
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId,
                                UserRoleId = roleId);
        return tuser;
    }
      private static testMethod void crec() {
    CheckRecursive.runAfterOnce();
    CheckRecursive.runBeforeInsertOnce();
    CheckRecursive.runBeforeUpdateOnce();
     }
    private static testMethod void testMthod1(){
        test.startTest();
        Account acnt = [select Id from Account limit 1];
        opportunity childOpp1 = [select Id from opportunity limit 1];
        PriceBook2 pb2 = [select Id,name from PriceBook2 limit 1 ];
        Product2 prodChild2 = [select Id,name from Product2 where Name = 'AdHoc Material' limit 1 ]; 
         Id awqRecType = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId();
     
        SBQQ__Quote__c childQuote2 = new SBQQ__Quote__c();
        childQuote2.RecordTypeId = awqRecType;
          childQuote2.SBQQ__Account__c = acnt.Id;
          childQuote2.SBQQ__Primary__c = true;
          childQuote2.SBQQ__Type__c = 'Amendment';
          childQuote2.SBQQ__Opportunity2__c = childOpp1.Id;
          childQuote2.SBQQ__PriceBook__c = pb2.id;
          childQuote2.Facility1__c = 'SPI';
          childQuote2.SBQQ__Primary__c = true;
          childQuote2.Use_Billing_Address__c = true;
          
          insert childQuote2;
          
          // Create Line Items
          List<SBQQ__QuoteLine__c> lineItemsInsert = new List<SBQQ__QuoteLine__c>();
          
          SBQQ__QuoteLine__c quote1Line1 = new SBQQ__QuoteLine__c();
          quote1Line1.SBQQ__Quote__c = childQuote2.id;
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
          quote2Line1.SBQQ__Product__c = prodChild2.id;
          quote2Line1.SBQQ__Quantity__c=1;
          quote2Line1.SBQQ__Number__c = 1;
          quote2Line1.SBQQ__PricingMethod__c= 'List';
          quote2Line1.Product_Pricing__c = 'Cost Plus Desired Margin';
          quote2Line1.SBQQ__UnitCost__c = 3200;
          quote2Line1.SBQQ__ListPrice__c = 3200;
          lineItemsInsert.add(quote2Line1);
          
          insert lineItemsInsert;
        test.stopTest(); 
    } 
}