@isTest
public class TestContentDocumentTriggerLink {
  
     static testMethod void TestMethod1()
    {
      test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User u2 = new User(
            Alias = 'nUser21',
            UserRoleId = r.Id,
            email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            username='newuser21@testorg.com');
        
        System.runAs(u2) {
            
            Account acc = new Account(Type='Aircraft', Name = 'Test Account', Area__c='East', billingcountry = 'USA', BillingState = 'TN');
            insert acc;
            
            //Create Account
            Account portalAccount = new Account();
            portalAccount.Name = 'test name';
            portalAccount.BillingStreet = '1600 Amphitheatre Parkway';
            portalAccount.BillingCity = 'Mountain View';
            portalAccount.BillingState = 'CA';
            portalAccount.BillingPostalCode = '94043';
            portalAccount.BillingCountry = 'United States';
            insert portalAccount;
            
            //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                Name = 'new'
            );
            
            insert prodLine;
            
            //Create Aircraft
            Aircraft__c ac = new Aircraft__c();
            ac.Product_Line__c = prodLine.Id;
            ac.Aircraft_Make__c = 'LEARJET';
            ac.Aircraft_Model_2011__c = 'LEAR 45';
            ac.Aircraft_SN__c = '213';
            ac.ACReg__c = 'N9551H';
            ac.name = 'NA';
            ac.Aircraft_Type__c = 'Aircraft';
            ac.OwnerId = UserInfo.getUserId();
            insert ac;      
            
            //Create Equipment
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.Id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Aircraft__c =ac.id,
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000'
            );
            insert equip;
           
            
            
            //Create Opportunity
            Opportunity oppt = new Opportunity(Name ='New mAWS Deal',
                                               Aircraft__c = ac.Id,
                                               Equipment__c = equip.Id,
                                               RSM__c = 'Account unassigned',
                                               Type = 'TFE731 - REP',
                                               Facility__c = 'AGS',
                                               Tier_Level__c = '1',
                                               Operator__c= 'FAA Part 91',
                                               SubType__c = 'TFE731 - REP',
                                               InputDate__c = System.today(),
                                               OutputDate__c = System.today(),
                                               AccountId = portalAccount.ID,
                                               StageName = 'Customer Won',
                                               Amount = 3000,
                                               CloseDate = System.today(),
                                               Opportunity_Name_Details__c ='asdfsddfggfhfghfgh'
                                               //SubType2__c,Sub_Type_2_Required__c
                                              );
            
            insert oppt;
            
            
            //Create Agent Opportunity
            Agent_Opportunity__c agentOpp = new Agent_Opportunity__c();
            agentOpp.Opportunity__c = oppt.Id;
            agentOpp.Aircraft__c = ac.Id;
            agentOpp.Account__c = portalAccount.Id;
            agentOpp.Equipment__c = equip.Id;
            insert agentOpp;
            
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion; 
           
            Id contentDocumentId = [select Id, ContentDocumentId, OwnerId from ContentVersion where Id = :contentVersion.Id].ContentDocumentId; 
            ContentDocument cd = [select Id, OwnerId from ContentDocument where Id = :contentDocumentId]; 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = agentOpp.Id;
            cdl.ContentDocumentId = cd.Id;
            //cdl.ContentDocumentId = conDocId;
            cdl.shareType = 'V';
            Insert cdl;
            system.assertNotEquals(cdl.visibility,'AllUsers');
           test.stopTest();
        }
    }
    
    /*static testMethod void TestMethod2()
    { 

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
        insert r;
        
        User u2 = new User(
            Alias = 'nUser21',
            UserRoleId = r.Id,
            email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            username='newuser21@testorg.com');
        insert u2;
        
        System.runAs(u2) {
            
            Account acc = new Account(Type='Aircraft', Name = 'Test Account', Area__c='East', billingcountry = 'USA', BillingState = 'TN');
            insert acc;
            
            //Create Account
            Account portalAccount = new Account();
            portalAccount.Name = 'test name';
            portalAccount.BillingStreet = '1600 Amphitheatre Parkway';
            portalAccount.BillingCity = 'Mountain View';
            portalAccount.BillingState = 'CA';
            portalAccount.BillingPostalCode = '94043';
            portalAccount.BillingCountry = 'United States';
            insert portalAccount;
            
            //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                Name = 'new'
            );
            
            insert prodLine;
            
            //Create Aircraft
            Aircraft__c ac = new Aircraft__c();
            ac.Product_Line__c = prodLine.Id;
            ac.Aircraft_Make__c = 'LEARJET';
            ac.Aircraft_Model_2011__c = 'LEAR 45';
            ac.Aircraft_SN__c = '213';
            ac.ACReg__c = 'N9551H';
            ac.name = 'NA';
            ac.Aircraft_Type__c = 'Aircraft';
            ac.OwnerId = UserInfo.getUserId();
            insert ac;      
            
            //Create Equipment
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.Id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Aircraft__c =ac.id,
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000'
            );
            insert equip;
            
            //Create Opportunity
            Opportunity oppt = new Opportunity(Name ='New mAWS Deal',
                                               Aircraft__c = ac.Id,
                                               Equipment__c = equip.Id,
                                               RSM__c = 'Account unassigned',
                                               Type = 'TFE731 - REP',
                                               Facility__c = 'AGS',
                                               Tier_Level__c = '1',
                                               Operator__c= 'FAA Part 91',
                                               SubType__c = 'TFE731 - REP',
                                               InputDate__c = System.today(),
                                               OutputDate__c = System.today(),
                                               AccountId = portalAccount.ID,
                                               StageName = 'Customer Won',
                                               Amount = 3000,
                                               CloseDate = System.today(),
                                               Opportunity_Name_Details__c ='asdfsddfggfhfghfgh'
                                               //SubType2__c,Sub_Type_2_Required__c
                                              );
            
            insert oppt;
            
            //Create contact
            Contact portalcontact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount.Id
            );
            insert portalContact1;
            
            //Create contact2
            Contact portalcontact2 = new Contact(
                FirstName = 'Seefab',
                Lastname = 'matma',
                AccountId = acc.Id
            );
            insert portalContact2;
            
            
            Profile c = [Select Id from profile where name = 'Customer Community Plus Login User - Custom'];
            Profile p1 = [SELECT Id FROM Profile WHERE Name='Gatekeeper-CPM'];
             List<User> uList =new List<User>(); 
           
            
            //Create User2
            User portalUser1 = new User(
                ProfileId = c.Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test1@test.com',
                Alias = 'batman1',
                email='bruce.wayne1@wayneenterprises.com',
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
            uList.add(portalUser1);
         //   insert portalUser1;
           //Create User3
            User portalUser2 = new User(
                ProfileId = c.Id,
                PortalRole = 'Executive',
                Username = System.now().millisecond() + 'test2@test.com',
                Alias = 'batman1',
                email='bruce.wayne1@wayneenterprises.com',
                EmailEncodingKey='UTF-8',
                Firstname='Bruce',
                Lastname='Wayne',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testyUser1423',
                IsActive = true,
                ContactId = portalContact2.id
            );
           // insert portalUser2;
           uList.add(portalUser2); 
            insert uList;
            
            List<MPM4_BASE__Milestone1_Project__c> projList = new List<MPM4_BASE__Milestone1_Project__c>();
            //Create Project
            MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
            proj.Name = 'Project Test';
            proj.MPM4_BASE__Account__c = portalAccount.Id;
            proj.Opportunity__c = oppt.Id;
            proj.Aircraft__c = ac.Id;
            proj.Engine__c = equip.Id;
            proj.Input_Date__c = oppt.InputDate__c;
            proj.Delivery_Date__c = oppt.OutputDate__c;
            proj.MPM4_BASE__Kickoff__c = oppt.InputDate__c;
            proj.MPM4_BASE__Deadline__c = oppt.OutputDate__c;
            // proj.CPM__c = userInfo.getUserId();
            //proj.CPM__c = portalUser1.id;
            proj.Designated_Approver__c = portalUser2.id;
            proj.MPM4_BASE__Status__c = 'Active';            
            //insert proj;
            projList.add(proj);
            insert projList;
        /*    //Check Pending Squawks number on Project
            MPM4_BASE__Milestone1_Project__c updatedProj = [Select Id, Pending_Squawks__c from MPM4_BASE__Milestone1_Project__c];
            Integer actual = integer.valueOf(updatedProj.Pending_Squawks__c);       
            System.AssertEquals(0, actual);
        */
            /*Id QuoteId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId();
            
            //Create Quote  
            List<SBQQ__Quote__c> qList = new List<SBQQ__Quote__c>();  
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                RecordTypeId = QuoteId,
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                Aircraft__c = ac.Id,
                Facility1__c = 'AGS',
                Project__c = proj.Id);  
            qList.add(quote);
            
            // create new product record
            Product2 prod2 = new Product2();
            prod2.Family = 'Labor';
            prod2.Name = 'Avionics Labor';
            prod2.IsActive = True;
            prod2.Family_Type__c = 'Avionics';
            prod2.SBQQ__QuantityEditable__c = True;
            prod2.SBQQ__DefaultQuantity__c = 1;
            prod2.SBQQ__ConfigurationType__c = 'Allowed';
            prod2.SBQQ__ConfigurationEvent__c = 'Always';
            prod2.SBQQ__BlockPricingField__c = 'Quantity';
            prod2.SBQQ__OptionLayout__c = 'Sections';
            prod2.SBQQ__OptionSelectionMethod__c = 'Click';
            prod2.SBQQ__AssetAmendmentBehavior__c = 'One per quote line';
            prod2.SBQQ__PricingMethod__c = 'List';
            prod2.SBQQ__PricingMethodEditable__c = True;
            prod2.SBQQ__CostEditable__c = True;
            prod2.SBQQ__PriceEditable__c = True;      
            prod2.SBQQ__Specifications__c='testing';
            prod2.ExcludeFromExecutiveSummary__c = True;
            try{
                insert prod2;
            }catch(exception e){System.debug('setup exception'+e);}
            
            //Create Quote    
            SBQQ__Quote__c quote2 = new SBQQ__Quote__c( 
                RecordTypeId = QuoteId,
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                Aircraft__c = ac.Id,
                Facility1__c = 'AGS',
                Project__c = proj.Id);  
            qList.add(quote2);
            
            insert qList;
            
            test.startTest();
            //Create Squawks
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
            ql.Project__c = proj.Id;
            ql.SBQQ__Product__c = prod2.Id;
            ql.Job_Card_Description__c = 'Test Squawk1';
            ql.SBQQ__Quote__c = quote.id;
            ql.Submit_For_Approval__c = True;
            insert ql;
            test.stopTest();
            //Create Agent Opportunity
            Agent_Opportunity__c agentOpp = new Agent_Opportunity__c();
            agentOpp.Opportunity__c = oppt.Id;
            agentOpp.Aircraft__c = ac.Id;
            agentOpp.Account__c = portalAccount.Id;
            agentOpp.Equipment__c = equip.Id;
            insert agentOpp;
            
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            
        
            Id contentDocumentId = [select Id, ContentDocumentId, OwnerId from ContentVersion where Id = :contentVersion.Id].ContentDocumentId; 
            ContentDocument cd = [select Id, OwnerId from ContentDocument where Id = :contentDocumentId]; 
               
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = proj.Id;
            cdl.ContentDocumentId = cd.Id;
            cdl.shareType = 'V';
            Insert cdl;
            
            
           // test.stopTest();
        }
    }*/
}