@isTest
public class TestPTH {
    
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
        
        System.runAs(u2){
            
            //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                Name = 'new'
            );
            insert prodLine;
            
            //Create Account
            Account portalAccount = new Account();
            portalAccount.Name = 'test PORname';
            portalAccount.BillingStreet = '1600 Amphitheatre Parkway';
            portalAccount.BillingCity = 'Mountain View';
            portalAccount.BillingState = 'CA';
            portalAccount.BillingPostalCode = '94043';
            portalAccount.BillingCountry = 'United States';
            portalAccount.Type = 'Customer - Broker';
            insert portalAccount;
            
            //Create Engine
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.Id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000'
            );
            insert equip;
            
            //Create Aircraft
            Aircraft__c ac = new Aircraft__c();
            ac.Product_Line__c = prodLine.Id;
            ac.Aircraft_Make__c = 'CASA';
            ac.Aircraft_SN__c = '213';
            ac.name = 'new';
            ac.Aircraft_Type__c = 'Aircraft';
            ac.OwnerId = UserInfo.getUserId();
            insert ac;
            
            //Create Product
            Product2 prod = new Product2(
                Name = 'Unscheduled Product',
                ProductCode = 'Code1',
                isActive = True
            );
            insert prod;
            
            //Create contact
            Contact portalcontact = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount.Id,
                Eligible_for_BizAv_Intro_Email__c = 'Yes'
            );
            insert portalContact;
            
            Contact portalcontact2 = new Contact(
                FirstName = 'Tell12',
                Lastname = 'McTesty1',
                AccountId = portalAccount.Id,
                Eligible_for_BizAv_Intro_Email__c='Yes'
            );
            
            insert portalContact2;
            
            
            Contact portalcontact3 = new Contact(
                FirstName = 'met3',
                Lastname = 'McTesty3',
                AccountId = portalAccount.Id,
                Eligible_for_BizAv_Intro_Email__c='Yes'
            );
            
            insert portalContact3;
            
            
            Contact portalcontact4 = new Contact(
                FirstName = 'Treat4',
                Lastname = 'McTesty4',
                AccountId = portalAccount.Id,
                Eligible_for_BizAv_Intro_Email__c='Yes'
            );
            
            insert portalContact4;
            
            
            Contact portalcontact5 = new Contact(
                FirstName = 'Trust5',
                Lastname = 'McTesty5',
                AccountId = portalAccount.Id,
                Eligible_for_BizAv_Intro_Email__c='Yes'
            );
            
            insert portalContact5;
            
            
            Contact portalcontact6 = new Contact(
                FirstName = 'Tet6',
                Lastname = 'McTesty6',
                AccountId = portalAccount.Id,
                Eligible_for_BizAv_Intro_Email__c='Yes'
            );
            
            insert portalContact6;
            
            Profile c = [Select Id from profile where name = 'Customer Community Plus - Custom'];
            
            //Create User
            User portalUser = new User(
                ProfileId = c.Id,
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
            
            insert portalUser2;
            
            
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
            
            insert portalUser3;
            
            
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
            
            insert portalUser4;
            
            
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
            
            insert portalUser5;
            
            
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
            
            insert portalUser6;
            
            //Create Opportunity
            Opportunity oppty = new Opportunity();
            oppty.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Opportunity').getRecordTypeId();
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
            //BackUp CPM
            User backupCPM = new User(
                Alias = 'nUser22',
                UserRoleId = r.Id,
                Email='newuser21@testorg.com', 
                EmailEncodingKey='UTF-8', 
                LastName='Testing', 
                LanguageLocaleKey='en_US', 
                LocaleSidKey='en_US', 
                ProfileId = p.Id, 
                TimeZoneSidKey='America/Los_Angeles', 
                UserName='newuser22@testorg.com');
            
            insert backupCPM;
            
            
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
            
            insert admin;
            
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
            proj.Crew_Chief__c = 'Spoon Man';
            proj.CPM__c = userInfo.getUserId();
            proj.BackupCPM__c = backupCPM.id;
            proj.Administrator__c = admin.Id;
            proj.Designated_Approver__c = portalUser.Id;
            proj.Secondary_Approver__c = portalUser2.Id;
            proj.X3_Approver__c = portalUser3.Id;
            proj.X4_Approver__c = portalUser4.Id;
            proj.X5_Approver__c = portalUser5.Id;
            proj.X6_Approver__c = portalUser6.Id; 
            proj.MPM4_BASE__Status__c = 'Active';
            proj.Same_Labor_Rate_Applied__c = True;
            Test.startTest();
            insert proj;
            
            //Create Quote    
            SBQQ__Quote__c quote = new SBQQ__Quote__c( 
                RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId(),
                Labor_Type1__c = 'Airframe',
                SBQQ__Status__c = 'Presented',
                SBQQ__Account__c = portalAccount.Id,
                Aircraft__c = ac.Id,
                Facility1__c = 'AGS',
                Project__c = proj.Id);
            
            insert quote; 
            
            
            String quotestring = String.valueOf(quote.id); 
            
            //Create Squawks            
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
            ql.Project__c = proj.Id;
            ql.SBQQ__Product__c = prod.Id;
            ql.Job_Card__c = 'Test Job Card';
            ql.Job_Card_Description__c = 'Test Squawk1';
            ql.SBQQ__Quote__c = quote.id;
            ql.Designated_Approver__c = portalUser.Id;
            ql.Add_Work_Status__c = 'Pending';
            ql.Labor_Amount__c = 10;
            ql.Labor_Code__c = 'Labor';
            ql.Add_Work_Labor_Type__c = 'FIRM';
            ql.Material_Amount__c = 20;
            ql.Material_Type__c = 'FIRM';
            ql.RTS__c  = True;
            ql.CPM__c  = UserInfo.getUserId();
            ql.BackupCPM__c = UserInfo.getUserId();
            ql.Designated_Approver__c  = UserInfo.getUserId();
            ql.Secondary_Approver__c = UserInfo.getUserId();
            ql.X3_Approver__c = UserInfo.getUserId();
            ql.X4_Approver__c = UserInfo.getUserId();
            ql.X5_Approver__c = UserInfo.getUserId();
            ql.X6_Approver__c = UserInfo.getUserId();
            ql.SBQQ__Number__c = 2;
            ql.RecordTypeId = Schema.SObjectType.SBQQ__QuoteLine__c.getRecordTypeInfosByName().get('Primary').getRecordTypeId();
            //ql.SBQQ__Cost__c = ;
            //ql.SBQQ__RequiredBy__c = ;
            ql.Specification__c = 'Test Specification';
            ql.Product_Description__c = 'Test Description';                
            
            insert ql; 
            Test.stopTest();
            
            
        }
        
    }
    static testmethod void ProjectCrewChief(){
        test.startTest();
        List<MPM4_BASE__Milestone1_Project__c> proj = new List<MPM4_BASE__Milestone1_Project__c>();
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, Crew_Chief_Lookup__c from MPM4_BASE__Milestone1_Project__c]){
            p.Crew_Chief_Lookup__c = null;
            proj.add(p);
        }
        
        update proj;  
        test.stopTest();        
    }
    
    static testmethod void addProjectCrewChief(){
        test.startTest();
        
        List<MPM4_BASE__Milestone1_Project__c> proj = new List<MPM4_BASE__Milestone1_Project__c>();
        
        Crew_Chief__c crewChief = new Crew_Chief__c(
            Name = 'Ryan Ellis'
        );
        Insert crewChief;
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, Crew_Chief__c, Crew_Chief_Lookup__c from MPM4_BASE__Milestone1_Project__c]){
            p.Crew_Chief_Lookup__c = crewChief.Id;
            proj.add(p);
        }
        
        update proj;
        
        MPM4_BASE__Milestone1_Project__c project = [Select Id, Crew_Chief__c from MPM4_BASE__Milestone1_Project__c];
        
        //system.assertEquals(crewChief.Name, project.Crew_Chief__c);
        
        test.stopTest();        
    }
    
    static testMethod void changeBroker(){
        
        test.startTest();
        
        List<MPM4_BASE__Milestone1_Project__c> proj = new List<MPM4_BASE__Milestone1_Project__c>();
        
        Account acc = [Select id,Name from Account where name =:'test PORname'];
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, Crew_Chief__c,broker__c  from MPM4_BASE__Milestone1_Project__c]){
            p.broker__c = acc.Id;
            proj.add(p);
        }
        
        update proj;
        test.stopTest();
        
    }
    
    //Test Project Approvers
    static testmethod void ProjectApprovers(){
        test.startTest();
        List<MPM4_BASE__Milestone1_Project__c> proj = new List<MPM4_BASE__Milestone1_Project__c>();
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, X4_Approver__c from MPM4_BASE__Milestone1_Project__c]){
            p.X4_Approver__c = null;
            proj.add(p);
        }
        
        
        update proj;  
        test.stopTest();        
    } 
    //Test Change Backup CPM Sharing Delete Admin
    static testmethod void ChangeBackupSharing(){  
        test.startTest();
        
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Administrator__c, BackupCPM__c from MPM4_BASE__Milestone1_Project__c];
        
        proj.BackUpCPM__c = proj.Administrator__c;
        proj.Administrator__c = null;
        
        
        update proj;  
        test.stopTest();          
    }
    
    
}