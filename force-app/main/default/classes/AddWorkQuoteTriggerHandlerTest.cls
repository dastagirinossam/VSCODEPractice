@istest
public class AddWorkQuoteTriggerHandlerTest {
    
    @testSetup 
    static void setup(){
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Gatekeeper-CPM'];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile c = [Select Id from profile where name = 'Customer Community Plus Login User - Custom'];
        Id QuoteId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId();
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User u2 = new User(
            Alias = 'nUser21',
            UserRoleId = r.Id,
            Email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com');
        
        System.runAs(u2) {
            
              AddWork_Trigger_Setting__c add = new  AddWork_Trigger_Setting__c();
            add.Name = 'AddWork';
            add.IsActive__c = True;
            insert add;
            
            List<Account> accList = new List<Account>();
            List<contact> conList = new List<contact>();
            
            
            Account portalAccount = new Account();
            portalAccount.Name = 'test name';
            portalAccount.BillingStreet = '1600 Amphitheatre Parkway';
            portalAccount.BillingCity = 'Mountain View';
            portalAccount.BillingState = 'CA';
            portalAccount.BillingPostalCode = '94043';
            portalAccount.BillingCountry = 'United States';
            accList.add(portalAccount);
            
            Account acnt2 = new Account();
            acnt2.Name = 'test name';
            acnt2.BillingStreet = '1600 Amphitheatre Parkway';
            acnt2.BillingCity = 'Mountain View';
            acnt2.BillingState = 'CA';
            acnt2.BillingPostalCode = '94043';
            acnt2.BillingCountry = 'United States';
            accList.add(acnt2);
            
            Account acnt = new Account();
            acnt.Name = 'test2 name2';
            acnt.BillingStreet = '1600 Amphitheatre Parkway';
            acnt.BillingCity = 'Mountain View';
            acnt.BillingState = 'CA';
            acnt.BillingPostalCode = '94043';
            acnt.BillingCountry = 'United States';
            acnt.Billing_Account__c = acnt2.Id;
            accList.add(acnt);
            insert accList;
            
            Contact portalcontact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount.Id
            );
            conList.add(portalContact1);
            
            
            Contact portalcontact2 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty2',
                AccountId = acnt.Id
            );
            
            conList.add(portalContact2);
            Contact portalcontact3 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty3',
                AccountId = portalAccount.Id
            );
            
            conList.add(portalContact3);
            Contact portalcontact4 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty4',
                AccountId = portalAccount.Id
            );
            
            conList.add(portalContact4) ;
            Contact portalcontact5 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty5',
                AccountId = portalAccount.Id
            );
            conList.add(portalContact5);
            
            Contact portalcontact6 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty6',
                AccountId = portalAccount.Id
            );
            
            conList.add(portalContact6);
            insert conList;
            
            
            
            List<User> UList = new List<User>();
            User backupCPM = new User(
                Alias = 'nUser22',
                UserRoleId = r.Id,
                Email='newuser21@testorg.com', 
                EmailEncodingKey='UTF-8', 
                LastName='Testing', 
                LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', 
                ProfileId = p1.Id, 
                TimeZoneSidKey='America/Los_Angeles', 
                UserName='newuser22@testorg.com');
            UList.add(backupCPM);
            
            //Admin
            User admin = new User(
                Alias = 'nUser33',
                UserRoleId = r.Id,
                Email='newuser22@testorg.com', 
                EmailEncodingKey='UTF-8', 
                LastName='Testing', 
                LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', 
                ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', 
                UserName='newuser23@testorg.com');
            UList.add(admin);
            
            //Create User
            User portalUser1 = new User(
                ProfileId = c.Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test1@test.com',
                Alias = 'batman1',
                Email='bruce.wayne1@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser123',
                IsActive = true,
                ContactId = portalContact1.id
            );
            UList.add(portalUser1);
            
            
            //Create User
            User portalUser2 = new User(
                ProfileId = c.Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman2',
                Email='bruce.wayne2@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser1234',
                IsActive = true,
                ContactId = portalContact2.id
            );
            
            UList.add(portalUser2);
            User portalUser3 = new User(
                ProfileId = c.Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test3@test.com',
                Alias = 'batman3',
                Email='bruce.wayne3@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser12345',
                IsActive = true,
                ContactId = portalContact3.id
            );
            
            UList.add(portalUser3);
            User portalUser4 = new User(
                ProfileId = c.Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test4@test.com',
                Alias = 'batman4',
                Email='bruce.wayne4@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser123456',
                IsActive = true,
                ContactId = portalContact4.id
            );
            UList.add(portalUser4);
            
            
            User portalUser5 = new User(
                ProfileId = c.Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test5@test.com',
                Alias = 'batman5',
                Email='bruce.wayne5@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser1234567',
                IsActive = true,
                ContactId = portalContact5.id
            );
            
            UList.add(portalUser5);
            User portalUser6 = new User(
                ProfileId = c.Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test6@test.com',
                Alias = 'batman6',
                Email='bruce.wayne6@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser12345678',
                IsActive = true,
                ContactId = portalContact6.id
            );
            UList.add(portalUser6);
            
            insert UList;
            
            
            
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
            
            MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
            proj.Name = 'Project Test';
            proj.MPM4_BASE__Account__c = portalAccount.Id;
            proj.Opportunity__c = masterOpportunity.Id;
            proj.Aircraft__c = aircraft.Id;
            proj.Engine__c = equipment.Id;
            proj.Input_Date__c = masterOpportunity.InputDate__c;
            proj.Delivery_Date__c = masterOpportunity.OutputDate__c;
            proj.MPM4_BASE__Kickoff__c = masterOpportunity.InputDate__c;
            proj.MPM4_BASE__Deadline__c = masterOpportunity.OutputDate__c;
            proj.CPM__c =backupCPM.id;
            proj.Administrator__c = admin.Id;
            proj.Designated_Approver__c = portalUser1.Id;
            proj.Secondary_Approver__c = portalUser2.Id;
            proj.X3_Approver__c = portalUser3.Id;
            proj.X4_Approver__c = portalUser4.Id;
            proj.X5_Approver__c = portalUser5.Id;
            proj.X6_Approver__c = portalUser6.Id;
            proj.BackupCPM__c = backupCPM.id;
            proj.MPM4_BASE__Status__c = 'Active';            
            insert proj;
        }
    }
    private static testMethod void testMthod1(){
        test.startTest();
        Account acnt = [select Id from Account limit 1];
        opportunity childOpp1 = [select Id from opportunity limit 1];
        PriceBook2 pb2 = [select Id,name from PriceBook2 limit 1 ];
        Product2 prodChild2 = [select Id,name from Product2 where Name = 'AdHoc Material' limit 1 ]; 
        Id awqRecType = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId();
        MPM4_BASE__Milestone1_Project__c prj = [select Id from MPM4_BASE__Milestone1_Project__c limit 1];
        
        SBQQ__Quote__c childQuote2 = new SBQQ__Quote__c();
        childQuote2.RecordTypeId = awqRecType;
        childQuote2.SBQQ__Account__c = acnt.Id;
        childQuote2.SBQQ__Primary__c = true;
        childQuote2.Project__c = prj.id;
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
    private static testMethod void testMthod2(){
        test.startTest();
        Account acnt = [select Id from Account limit 1];
        opportunity childOpp1 = [select Id from opportunity limit 1];
        PriceBook2 pb2 = [select Id,name from PriceBook2 limit 1 ];
        Product2 prodChild2 = [select Id,name from Product2 where Name = 'AdHoc Material' limit 1 ]; 
        Id awqRecType = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId();
        MPM4_BASE__Milestone1_Project__c prj = [select Id from MPM4_BASE__Milestone1_Project__c limit 1];
        
        SBQQ__Quote__c childQuote2 = new SBQQ__Quote__c();
        childQuote2.RecordTypeId = awqRecType;
        childQuote2.SBQQ__Account__c = acnt.Id;
        childQuote2.SBQQ__Primary__c = true;
        childQuote2.Project__c = prj.id;
        childQuote2.SBQQ__Type__c = 'Amendment';
        childQuote2.SBQQ__Opportunity2__c = childOpp1.Id;
        childQuote2.SBQQ__PriceBook__c = pb2.id;
        childQuote2.Facility1__c = 'SPI';
        childQuote2.SBQQ__Primary__c = true;
        childQuote2.SBQQ__Status__c = 'Presented';
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