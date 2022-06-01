@isTest
public class testAddWorkStatusHelper {

    @testSetup 
    static void setup(){
        
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
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
                      
            Product_Line__c prodLine = testdatagenerator.createProductLine();       
            Account portalAccount = testdatagenerator.createAccount();
            Contact portalcontact = testdatagenerator.createContact(portalAccount.Id);
            Product2 prod =  testdatagenerator.createProduct();
            Aircraft__c ac = testdatagenerator.createAircraft(prodLine.Id, portalAccount.Id);
            Equipment__c equip = testdatagenerator.createEquipment(prodLine.Id, portalAccount.Id, ac.Id);
        
            //Create User
            User portalUser = new User(
                ProfileId = [Select Id from profile where name = 'Customer Community Plus - Custom'].Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman',
                Email='bruce.wayne@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser123',
                IsActive = true,
                ContactId = portalContact.id
            );
            insert portalUser;
            
            system.debug('Portal User: ' + portalUser.Id);
             
            Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
            Id rtId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
            
            //Create Opportunity
            Opportunity oppty = new Opportunity();
                oppty.RecordTypeId = rtId;
                oppty.RSM__c = 'Campbell,Tom';
                oppty.Name = 'trigger test';
                oppty.Opportunity_Name_Details__c = 'trigger test';
                oppty.StageName = 'Cust Submitted Quote';
                oppty.AccountId = portalAccount.Id;
                oppty.Aircraft__c = ac.Id;
                oppty.Amount = decimal.valueof('1471620');
                oppty.Equipment__c = equip.Id;
                oppty.CustomerName__c = 'World Jet, Inc.';
                oppty.Facility__c = 'AGS';
                oppty.Tier_Level__c = '1';
                oppty.CloseDate =  Date.today();
                oppty.InputDate__c =  Date.today();
                oppty.OutputDate__c =  Date.today();
                oppty.Product_Line__c = ac.Product_Line__c;
                oppty.Type = 'Airframe';
                oppty.SubType__c = 'Airframe - Inspection';
                oppty.LeadSource = 'CPM';
                oppty.QuoteDelivery__c = 'Hand Delivery';
                oppty.QuoteRequiredBy__c =  Date.today();
                oppty.Base_Quote_Number__c = '1';
                oppty.QuotedDate__c =  Date.today();
                oppty.Concession1__c = 'None';
                oppty.Agent_Representative__c = 'Not Applicable';                                   
            insert oppty;
                
            //Create Project
            MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
                proj.Name = 'Project Test';
                proj.MPM4_BASE__Account__c = portalAccount.Id;
                proj.Opportunity__c = oppty.Id;
                proj.Aircraft__c = ac.Id;
                proj.Engine__c = equip.Id;
                proj.Input_Date__c = oppty.InputDate__c;
                proj.Delivery_Date__c = oppty.OutputDate__c;
                proj.MPM4_BASE__Kickoff__c = oppty.InputDate__c;
                proj.MPM4_BASE__Deadline__c = oppty.OutputDate__c;
                proj.CPM__c = userInfo.getUserId();
                proj.Designated_Approver__c = portalUser.Id;
                proj.MPM4_BASE__Status__c = 'Active';             
            insert proj;
               
            //Check Pending Squawks number on Project
            MPM4_BASE__Milestone1_Project__c updatedProj = [Select Id, Pending_Squawks__c from MPM4_BASE__Milestone1_Project__c];
            Integer actual = integer.valueOf(updatedProj.Pending_Squawks__c);       
            System.AssertEquals(0, actual);
        
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId(),
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                SBQQ__Opportunity2__c = oppty.Id,
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS');  
            insert quote;                   
        }
    }
    
    
    //Trigger should not fire
    static testmethod void SquawkWithOutProject(){
        
        test.startTest();
        
        Product2 prod = [Select Id from Product2];
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c, BackupCPM__c, CPM__c, Administrator__c, Secondary_Approver__c, X3_Approver__c, X4_Approver__c, X5_Approver__c, X6_Approver__c from MPM4_BASE__Milestone1_Project__c];
        SBQQ__Quote__c quote = [Select Id from SBQQ__Quote__c];
        User portalUser = [Select Id from User where Alias = 'batman'];
        
        //Create Squawk
        SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
        ql.SBQQ__Product__c = prod.Id;
        ql.Job_Card_Description__c = 'Test Squawk1';
        ql.SBQQ__Quote__c = quote.id;         
        insert ql; 
               
        SBQQ__QuoteLine__c ql1 = [Select Project__c, Designated_Approver__c, BackupCPM__c, CPM__c, Administrator__c, Secondary_Approver__c, X3_Approver__c, X4_Approver__c, X5_Approver__c, X6_Approver__c from SBQQ__QuoteLine__c where Id =: ql.Id];  
        
        System.assertEquals(ql1.Project__c, null);
        System.assertEquals(ql1.Designated_Approver__c, null);
        System.assertEquals(ql1.BackupCPM__c, null);
        System.assertEquals(ql1.CPM__c, null); 
        System.assertEquals(ql1.Administrator__c, null); 
        System.assertEquals(ql1.Secondary_Approver__c, null);
        System.assertEquals(ql1.X3_Approver__c, null);
        System.assertEquals(ql1.X4_Approver__c, null);
        System.assertEquals(ql1.X5_Approver__c, null);
        System.assertEquals(ql1.X6_Approver__c, null);
        
        test.stopTest();
        
    }
    
    //Trigger should fire
    /*static testmethod void SquawkWithProject(){

        Test.startTest();
        
        Product2 prod = [Select Id from Product2];
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c, BackupCPM__c, CPM__c, Administrator__c, Secondary_Approver__c, X3_Approver__c, X4_Approver__c, X5_Approver__c, X6_Approver__c from MPM4_BASE__Milestone1_Project__c];
        Opportunity o = [Select Id from Opportunity];
        SBQQ__Quote__c quote = [Select Id from SBQQ__Quote__c];
        User portalUser = [Select Id from User where Alias = 'batman'];
        
        //Add Project & Opportunity To Quote
        quote.Project__c = proj.Id;
        quote.SBQQ__Opportunity2__c = o.Id;
        quote.SBQQ__Primary__c = true;
        Update quote;        
        
        //Create Squawk
        SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();       
        ql.SBQQ__Product__c = prod.Id;
        ql.Job_Card_Description__c = 'Test Squawk1';
        ql.SBQQ__Quote__c = quote.id; 
        ql.Add_Work_Status__c = 'Pending';
        insert ql; 
        
         SBQQ__QuoteLine__c ql1 = new SBQQ__QuoteLine__c();       
        ql1.SBQQ__Product__c = prod.Id;
        ql1.Job_Card_Description__c = 'Test Squawk1';
        ql1.SBQQ__Quote__c = quote.id; 
        ql1.Add_Work_Status__c = 'Approved';
        insert ql1; 
        
        SBQQ__QuoteLine__c ql2 = [Select Project__c, Add_Work_Status__c, Designated_Approver__c, BackupCPM__c, CPM__c, Administrator__c, Secondary_Approver__c, X3_Approver__c, X4_Approver__c, X5_Approver__c, X6_Approver__c from SBQQ__QuoteLine__c where Id =: ql.Id];
        MPM4_BASE__Milestone1_Project__c proj2 = [Select Id, Pending_Squawks__c from MPM4_BASE__Milestone1_Project__c where Id =: ql2.Project__c];
        
        system.debug('Pending Squawks: ' + proj2.Pending_Squawks__c);
        
        System.assertEquals(ql2.Project__c, proj.Id);
        System.assertEquals(ql2.Designated_Approver__c, proj.Designated_Approver__c);
        System.assertEquals(ql2.BackupCPM__c, proj.BackupCPM__c);
        System.assertEquals(ql2.CPM__c, proj.CPM__c); 
        System.assertEquals(ql2.Administrator__c, proj.Administrator__c ); 
        System.assertEquals(ql2.Secondary_Approver__c, proj.Secondary_Approver__c);
        System.assertEquals(ql2.X3_Approver__c, proj.X3_Approver__c);
        System.assertEquals(ql2.X4_Approver__c, proj.X4_Approver__c);
        System.assertEquals(ql2.X5_Approver__c, proj.X5_Approver__c);
        System.assertEquals(ql2.X6_Approver__c, proj.X6_Approver__c); 
        
        test.stopTest();
    }*/
    
    static testmethod void tsmMethodTest(){
        
        test.startTest();
        
        Opportunity opp = [Select Id from Opportunity];
        Contact c = [Select Id from Contact];
        
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
            Executive_Summary_Group__c='Avionics',
            isActive = true);
        
        productList.add(prodChild4);
        
        insert productList;
        
        SBQQ__ProductFeature__c featureObj = new SBQQ__ProductFeature__c();
        featureObj.Name = 'Labor';
        featureObj.SBQQ__Number__c = 1;
        featureObj.SBQQ__MaxOptionCount__c = 1;
        featureObj.SBQQ__ConfiguredSKU__c = prodChild2.Id;
        Insert featureObj;
        
        SBQQ__ProductOption__c optionObj = new SBQQ__ProductOption__c();
        optionObj.SBQQ__Number__c = 2;
        optionObj.SBQQ__ConfiguredSKU__c= prodChild2.Id;
        optionObj.SBQQ__OptionalSKU__c = prodChild3.Id;
        optionObj.SBQQ__Feature__c = featureObj.Id;
        insert optionObj;
               
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
    
        // Create Child quotes
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.SBQQ__PrimaryContact__c = c.Id;
        quote.SBQQ__Type__c = 'Quote child 1';
        quote.SBQQ__Opportunity2__c = opp.Id;
        quote.SBQQ__PriceBook__c = pb2.id;
        quote.SBQQ__Primary__c = true;
               
        insert quote;
        
        // Create Line Items
        List<SBQQ__QuoteLine__c> lineItemsInsert = new List<SBQQ__QuoteLine__c>();
        
        SBQQ__QuoteLine__c quote1Line1 = new SBQQ__QuoteLine__c();
        quote1Line1.SBQQ__Quote__c = quote.id;
        quote1Line1.SBQQ__Product__c = prodChild2.id;
        quote1Line1.SBQQ__Quantity__c = 1;
        quote1Line1.SBQQ__Number__c = 1;
        quote1Line1.SBQQ__PricingMethod__c= 'List';
        quote1Line1.Labor__c = False;
        quote1Line1.SBQQ__Optional__c = false;
        quote1Line1.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote1Line1.SBQQ__UnitCost__c = 3000;
        quote1Line1.Customer_Price__c = 1000;
        quote1Line1.SBQQ__ListPrice__c = 3000;
        quote1Line1.Specification__c = 'aaaaa';
        quote1Line1.ExcludeFromExecutiveSummary__c = true;
        quote1Line1.TSM_Notes__c = 'Testing TSM Notes';
        lineItemsInsert.add(quote1Line1);
        
        SBQQ__QuoteLine__c quote2Line1 = new SBQQ__QuoteLine__c();
        quote2Line1.SBQQ__Quote__c = quote.id;
        quote2Line1.SBQQ__Product__c = prodChild1.id;
        quote2Line1.SBQQ__Quantity__c = 1;
        quote2Line1.SBQQ__Number__c = 2;
        quote2Line1.Customer_Price__c = 100;
        quote2Line1.SBQQ__PricingMethod__c= 'List';
        quote2Line1.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote2Line1.SBQQ__UnitCost__c = 3200;
        quote2Line1.SBQQ__ListPrice__c = 3200;       
        lineItemsInsert.add(quote2Line1);
        
        SBQQ__QuoteLine__c quote2Line3 = new SBQQ__QuoteLine__c();
        quote2Line3.SBQQ__Quote__c = quote.id;
        quote2Line3.SBQQ__Product__c = prodChild3.id;
        quote2Line3.SBQQ__Quantity__c= 1;
        quote2Line3.SBQQ__Number__c = 3;
        quote2Line3.SBQQ__PricingMethod__c= 'List';
        quote2Line3.Customer_Price__c = 100;
        quote2Line3.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote2Line3.SBQQ__UnitCost__c = 3200;
        quote2Line3.SBQQ__RequiredBy__c = quote1Line1.ID;
        quote2Line3.SBQQ__ListPrice__c = 3200;
        lineItemsInsert.add(quote2Line3);
        
        SBQQ__QuoteLine__c quote2Line4 = new SBQQ__QuoteLine__c();
        quote2Line4.SBQQ__Quote__c = quote.id;
        quote2Line4.SBQQ__Product__c = prodChild4.id;
        quote2Line4.SBQQ__Quantity__c = 1;
        quote2Line4.SBQQ__Number__c = 4;
        quote2Line4.Customer_Price__c = 1000;
        quote2Line4.SBQQ__PricingMethod__c= 'List';
        quote2Line4.Product_Pricing__c = 'Cost Plus Desired Margin';
        quote2Line4.SBQQ__UnitCost__c = 3200;
        quote2Line4.SBQQ__ListPrice__c = 3200;
        lineItemsInsert.add(quote2Line4);       
           
        SBQQ__QuoteLine__c quoteLineObj = new SBQQ__QuoteLine__c();
        quoteLineObj.SBQQ__Quote__c = quote.id;
        quoteLineObj.SBQQ__Product__c = prodChild1.id;
        quoteLineObj.SBQQ__Quantity__c=1;
        quoteLineObj.SBQQ__Number__c = 5;
        quoteLineobj.Labor__c = True;
        quoteLineobj.Customer_Price__c = 1000;
        quoteLineobj.SBQQ__Optional__c = false;
        quoteLineObj.SBQQ__PricingMethod__c= 'List';
        quoteLineObj.Product_Pricing__c = 'Cost Plus Desired Margin';
        quoteLineObj.SBQQ__UnitCost__c = 3200;
        quoteLineObj.SBQQ__ListPrice__c = 3200;
        quoteLineObj.SBQQ__RequiredBy__c = quote1Line1.ID;
        quoteLineObj.Sync_To_Product__c = true;
        
        lineItemsInsert.add(quoteLineObj); 
        insert lineItemsInsert;
        
        SBQQ__QuoteLine__c ql = [Select Id, Sync_To_Product__c from SBQQ__QuoteLine__c where SBQQ__Number__c =: 5];
		ql.Sync_To_Product__c = true;
        
        update ql;
        test.stopTest();
    }  
}