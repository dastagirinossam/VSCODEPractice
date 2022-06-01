@isTest
public class ProjectsTriggerHelper_test {
    
   @testSetup
    static void setup(){
       
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
            
            //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                Name = 'new'
            );
            insert prodLine;
            
            //Create Account
            Account portalAccount = new Account();
            portalAccount.Name = 'test name';
            portalAccount.BillingStreet = '1600 Amphitheatre Parkway';
            portalAccount.BillingCity = 'Mountain View';
            portalAccount.BillingState = 'CA';
            portalAccount.BillingPostalCode = '94043';
            portalAccount.BillingCountry = 'United States';
            insert portalAccount;
            
            system.debug('Portal Account Owner Role: ' + portalAccount.Owner.UserRole);
                                 
            //Create Aircraft
            Aircraft__c ac = new Aircraft__c();
            ac.Product_Line__c = prodLine.Id;
            ac.Aircraft_Make__c = 'CASA';
            ac.Aircraft_SN__c = '213';
            ac.name = 'NA';
            ac.Aircraft_Type__c = 'Aircraft';
            ac.Aircraft_Status__c = 'In-Operation';
            ac.OwnerId = UserInfo.getUserId();
            insert ac;
            
            //Create Engine
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.Id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Aircraft__c = ac.Id,
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000'
            );
            insert equip;
            
            //Create Product
            Product2 prod = new Product2(
                Name = 'Unscheduled Product',
                ProductCode = 'Code1',
                isActive = True
            );
            insert prod;
            
            //Create contact
            Contact portalcontact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount.Id
            );
            insert portalContact1;
            
            //Create Account
            Account acnt = new Account();
                acnt.Name = 'Test Name2';
                acnt.BillingStreet = '1600 Test Testway';
                acnt.BillingCity = 'Test View';
                acnt.BillingState = 'TN';
                acnt.BillingPostalCode = '37128';
                acnt.BillingCountry = 'United States';
                acnt.Area__c = 'East';
                acnt.RPACustomerNumber__c= 'G123456';
            insert acnt;
            
            List<contact> conList = new List<contact>();
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
            //BackUp CPM
           List<User> UList = new List<User>();
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
            
            //Check Pending Squawks number on Project
            MPM4_BASE__Milestone1_Project__c updatedProj = [Select Id, Pending_Squawks__c from MPM4_BASE__Milestone1_Project__c];
            Integer actual = integer.valueOf(updatedProj.Pending_Squawks__c);       
            System.AssertEquals(0, actual);
            
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
         
            //Create Squawks
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
            ql.Project__c = proj.Id;
            ql.SBQQ__Product__c = prod.Id;
            ql.Job_Card_Description__c = 'Test Squawk1';
            ql.SBQQ__Quote__c = quote.id;
            ql.Submit_For_Approval__c = True;
            test.startTest();
            insert ql;
            test.stopTest();
            //Create Quote Document
            SBQQ__QuoteDocument__c qd = new SBQQ__QuoteDocument__c();
            qd.Name = 'Test Document';
            qd.Project_On_Quote__c = proj.id;
            qd.SBQQ__Quote__c = quote.id;
            qd.SBQQ__Version__c = 1;
            qd.SBQQ__Template__c = 'Squawks Template';
            qd.SBQQ__OutputFormat__c = 'PDF';
            insert qd;
            
            //Create Content Document
            /*ContentVersion contentVersion = new ContentVersion(
Title = 'Test Document',
PathOnClient = 'Test.jpg',
VersionData = Blob.valueOf('Test Content'),
IsMajorVersion = true
);
insert contentVersion;

ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id =: contentVersion.Id];

//create ContentDocumentLink  record 
ContentDocumentLink cdl = New ContentDocumentLink();
cdl.LinkedEntityId = quote.id;
cdl.ContentDocumentId = testcontent.ContentDocumentId;
cdl.shareType = 'V';
insert cdl; 

//create ContentDocumentLink QuoteLine record 
ContentDocumentLink cdl1 = New ContentDocumentLink();
cdl1.LinkedEntityId = ql.id;
cdl1.ContentDocumentId = testcontent.ContentDocumentId;
cdl1.shareType = 'V';
insert cdl1;   

//create ContentDocumentLink QuoteDocument record 
ContentDocumentLink cdl2 = New ContentDocumentLink();
cdl2.LinkedEntityId = qd.id;
cdl2.ContentDocumentId = testcontent.ContentDocumentId;
cdl2.shareType = 'V';
insert cdl2;  

//create ContentDocumentLink QuoteDocument record 
ContentDocumentLink cdl3 = New ContentDocumentLink();
cdl3.LinkedEntityId = proj.id;
cdl3.ContentDocumentId = testcontent.ContentDocumentId;
cdl3.shareType = 'V';
insert cdl3;*/            
        }
    }
    
    //Test Project Do Not Share
    private static testmethod void individualProjectSharing(){  
        test.startTest();
        List<MPM4_BASE__Milestone1_Project__c> proj = new List<MPM4_BASE__Milestone1_Project__c>();
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, Do_Not_Share_Project__c from MPM4_BASE__Milestone1_Project__c]){
            p.Do_Not_Share_Project__c = True;
            proj.add(p);
        }
        
        update proj;  
        Test.stopTest();          
    }
    
    //Test Delete Admin Sharing
    private static testmethod void DeleteAdminSharing(){  
        test.startTest();
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Administrator__c from MPM4_BASE__Milestone1_Project__c];
        
        proj.Administrator__c = null;
        
        update proj;  
        test.stopTest();          
    }
    
    //Test Change Admin Sharing Delete CPM
    static testmethod void ChangeAdminSharing(){  
        test.startTest();
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Administrator__c, BackupCPM__c from MPM4_BASE__Milestone1_Project__c];
        
        proj.Administrator__c = proj.BackUpCPM__c;
        proj.BackUpCPM__c = null;
        
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
    
    //Test Project Group Share
    static testmethod void groupProjectSharing(){   
        test.startTest();
        List<MPM4_BASE__Milestone1_Project__c> proj = new List<MPM4_BASE__Milestone1_Project__c>();
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, Do_Not_Share_Project__c from MPM4_BASE__Milestone1_Project__c]){
            p.Do_Not_Share_Project__c = False;
            proj.add(p);
        }
        
        
        update proj;  
        test.stopTest();          
    }
    
    //Test Project Designated Approver Change
    static testmethod void ProjectDesignatedApprover(){  
        test.startTest();
        List<MPM4_BASE__Milestone1_Project__c> proj = new List<MPM4_BASE__Milestone1_Project__c>();
        SBQQ__QuoteLine__c ql = [Select Id from SBQQ__QuoteLine__c];
        
        Approval.ProcessSubmitRequest newReq = new Approval.ProcessSubmitRequest();
        newReq.setObjectId(ql.Id);
        newReq.setSubmitterId(UserInfo.getUserId());
        Approval.ProcessResult processResult = Approval.process(newReq);
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, Designated_Approver__c, Secondary_Approver__c, X3_Approver__c, X4_Approver__c, X5_Approver__c, X6_Approver__c from MPM4_BASE__Milestone1_Project__c]){
            p.Secondary_Approver__c = null;
            proj.add(p);
        }
        
        
        update proj;  
        test.stopTest();        
    }
    
    //Test Project Status
    static testmethod void ProjectStatus(){ 
        test.startTest();
        List<MPM4_BASE__Milestone1_Project__c> proj = new List<MPM4_BASE__Milestone1_Project__c>();
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, MPM4_BASE__Status__c from MPM4_BASE__Milestone1_Project__c]){
            p.MPM4_BASE__Status__c = 'Planning'; 
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
    
    static testmethod void QuoteLineApprovers(){  
         test.startTest();
        List<MPM4_BASE__Milestone1_Project__c> proj = new List<MPM4_BASE__Milestone1_Project__c>();
        SBQQ__QuoteLine__c ql = [Select Id from SBQQ__QuoteLine__c];
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(ql.Id);
        Approval.ProcessResult processResult = Approval.process(req);
        
        for(MPM4_BASE__Milestone1_Project__c p : [Select Id, X4_Approver__c, MPM4_BASE__Status__c from MPM4_BASE__Milestone1_Project__c]){
            p.MPM4_BASE__Status__c = 'Active';
            p.X4_Approver__c = null;
            proj.add(p);
        }
        
       
        update proj;  
        test.stopTest();        
    }
}