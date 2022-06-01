/**
*@author - Krunal Pala
*@Date - 14/03/2017
*Purpose - Test Class for SB_QTSalesRepSectionProcessor
*/
@isTest
private class SB_QTSalesRepSectionProcessorTest {
    
    // below test method is used to test sync from child to master.
    @isTest
    public static void testMethodForQTSalesRepSection() {
        
        
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
        
        System.runAs (usr) {
            
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
            
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                Name = 'new'
            );
            
            insert prodLine;
            
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
            
            Aircraft__c aircraft = new Aircraft__c();
            aircraft.Product_Line__c = prodLine.id;
            aircraft.Aircraft_Make__c = 'CASA';
            aircraft.Aircraft_SN__c = '213';
            aircraft.name = 'new';
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
                Account__c =acnt.id,
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
                Pricebook2Id =pb2.id);
            
            insert masterOpportunity;  
            
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
                AFSM_Lookup__c =usr1.id,
                Name = 'Opportunity Child 2',
                AccountId = acnt.id,
                Aircraft__c = aircraft.id,
                Equipment__c = equipment.id,
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
            childQuote1.SBQQ__SalesRep__c = usr.id;
            childQuote1.SBQQ__Type__c = 'Quote child 1';
            childQuote1.SBQQ__Opportunity2__c = childOpp1.Id;
            childQuote1.SBQQ__PriceBook__c = pb2.id;
            childQuote1.Facility1__c = 'SPI';
            //        childQuote1.Labor_Type1__c='Airframe';
            childQuote1.SBQQ__Primary__c = true;
            childQuotes.add(childQuote1);
            
            SBQQ__Quote__c childQuote2 = new SBQQ__Quote__c();
            childQuote2.SBQQ__PrimaryContact__c = childOpp2.Contact__c;
            childQuote2.SBQQ__SalesRep__c = usr1.id;
            childQuote2.SBQQ__Type__c = 'Quote child 2';
            childQuote2.SBQQ__Opportunity2__c = childOpp2.Id;
            childQuote2.SBQQ__PriceBook__c = pb2.id;
            childQuote2.Facility1__c = 'SPI';
            // childQuote2.Labor_Type1__c='Engine Shop';
            childQuote2.SBQQ__Primary__c = true;
            childQuotes.add(childQuote2);
            
            insert childQuotes;
            
            // Create Line Items
            List<SBQQ__QuoteLine__c> lineItemsInsert = new List<SBQQ__QuoteLine__c>();
            
            SBQQ__QuoteLine__c quoteLineNew = new SBQQ__QuoteLine__c();
                      
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
            system.debug('lineItemsInsert =='+lineItemsInsert);
            
            // Creating master Quote
            ApexPages.StandardController sc = new ApexPages.StandardController(masterOpportunity);
            
            SB_MasterQuoteBuilderFrmOppunity mqb = new SB_MasterQuoteBuilderFrmOppunity(sc);
            PageReference pref = mqb.createMasterQuote();
            System.assertNotEquals(pref,null);
            
            SBQQ__Quote__c masterQuote = [Select Id from SBQQ__Quote__c where SBQQ__Opportunity2__c = :masterOpportunity.id];
            
            // Testing method.
            Test.setCurrentPageReference(new PageReference('Page.SB_QTSalesRepContactList')); 
            System.currentPageReference().getParameters().put('qid',masterQuote.id );
            
            Test.startTest();
            SB_QTSalesRepSectionProcessor sbqtSales = new SB_QTSalesRepSectionProcessor();
            /* System.assertNotEquals(sbqtSales.quoteSObj,null);
            System.assertNotEquals(sbqtSales.salesRepArray,null);
            System.assertEquals(sbqtSales.salesRepArray.size(), 2);*/
            
            
            SB_QTSalesRepSectionProcessor.SalesRepDepWise  srd = new SB_QTSalesRepSectionProcessor.SalesRepDepWise();
            srd.derivedOppTypOrEnginEquipmnt = 'Engine';
            srd.compareTo(srd);
            SB_QTSalesRepSectionProcessor.SalesRepDepWise  srd1 = new SB_QTSalesRepSectionProcessor.SalesRepDepWise();
            srd1.derivedOppTypOrEnginEquipmnt = 'Engine1';
            srd.compareTo(srd1);
            
            
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
                              MobilePhone = '123456789',
                              TimeZoneSidKey = 'America/Los_Angeles',
                              LocaleSidKey = 'en_US',
                              LanguageLocaleKey = 'en_US',
                              ProfileId = profId,
                              UserRoleId = roleId);
        return tuser;
    }
    
}