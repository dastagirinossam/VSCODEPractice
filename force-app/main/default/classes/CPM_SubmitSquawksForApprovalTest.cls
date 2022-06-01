@isTest
public class CPM_SubmitSquawksForApprovalTest{
    
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
            Aircraft__c ac2 = new Aircraft__c();
            ac2.Product_Line__c = prodLine.Id;
            ac2.Aircraft_Make__c = 'CASA';
            ac2.Aircraft_SN__c = '213';
            ac2.name = 'NA';
            ac2.Aircraft_Type__c = 'Aircraft';
            ac2.Aircraft_Status__c = 'In-Operation';
            ac2.OwnerId = UserInfo.getUserId();
            insert ac2;
             
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
                ac.Aircraft_Make__c = 'LEARJET';
                ac.Aircraft_Model_2011__c = 'LEAR 45';
                ac.Aircraft_SN__c = '213';
                ac.ACReg__c = 'N9551H';
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
                    AccountId = portalAccount.Id
            );
            insert portalContact;
        
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
                           
            //Create Project
            MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
                proj.Name = 'Project Test';
                proj.MPM4_BASE__Account__c = portalAccount.Id;
                proj.Aircraft__c = ac.Id;
                proj.Engine__c = equip.Id;
                proj.Input_Date__c = Date.today();
                proj.Delivery_Date__c = Date.today();
                proj.MPM4_BASE__Kickoff__c = Date.today();
                proj.MPM4_BASE__Deadline__c = Date.today();
                //proj.Crew_Chief__c = 'Spoon Man';
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
                Aircraft__c = ac.Id,
                Account_Name__c = portalAccount.Name,
                Add_Work_Aircraft_Model__c = ac.Aircraft_Model_2011__c,
                Add_Work_Aircraft_Reg_Number__c = ac.ACReg__c,
                Add_Work_Aircraft_Serial_Number__c = ac.Aircraft_SN__c,
                Facility1__c = 'AGS');  
            insert quote; 
            
            //Create Squawk
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
                ql.SBQQ__Product__c = prod.Id;
                ql.Project__c = proj.Id;           
                ql.Job_Card_Description__c = 'Test Squawk1';
                ql.SBQQ__Quote__c = quote.id; 
                ql.Designated_Approver__c = portalUser.id;
            insert ql; 
        }
    }
       
    public static testMethod void testSubmitButton() {
    
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        SBQQ__QuoteLine__c ql = [Select Id, Add_Work_Status__c from SBQQ__QuoteLine__c];
        
        Set<Id> qlIds = new Set<Id>();
        for(SBQQ__QuoteLine__c q : [Select Id, Add_Work_Status__c from SBQQ__QuoteLine__c])
            qlIds.add(q.Id);
        
        PageReference pref = Page.CPM_SubmitSquawksForApproval;
        PageReference prefApprove = Page.CPM_SquawkManagement;
        pref.getParameters().put('id', proj.id); 
        prefApprove.getParameters().put('id', proj.id); 
          
        test.startTest();
        
        Test.setCurrentPageReference(pref);
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        CPM_SubmitSquawksForApproval cls = new CPM_SubmitSquawksForApproval(sc);
        cls.squawks[0].sendSquawk = true;
        cls.submitForApproval();            
           
        Test.setCurrentPageReference(prefApprove);
        ApexPages.StandardController nsc = new ApexPages.StandardController(proj);
        CPM_SquawkManagement ncls = new CPM_SquawkManagement(nsc);
        ncls.squawks[0].pendingSquawk = true;
        ncls.ApproveSquawks(); 
        
        test.stopTest();
    }
        
    public static testMethod void testCPM_Recall() {
    
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        SBQQ__QuoteLine__c ql = [Select Id, Add_Work_Status__c from SBQQ__QuoteLine__c];
                
        PageReference pref = Page.CPM_SubmitSquawksForApproval;
        PageReference prefApprove = Page.CPM_SquawkManagement;
        pref.getParameters().put('id', proj.id); 
        prefApprove.getParameters().put('id', proj.id); 
          
        test.startTest();
        
        Test.setCurrentPageReference(pref);
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        CPM_SubmitSquawksForApproval cls = new CPM_SubmitSquawksForApproval(sc);
        cls.squawks[0].sendSquawk = true;
        cls.submitForApproval();            
           
        Test.setCurrentPageReference(prefApprove);
        ApexPages.StandardController nsc = new ApexPages.StandardController(proj);
        CPM_SquawkManagement ncls = new CPM_SquawkManagement(nsc);
        ncls.squawks[0].pendingSquawk = true;
        ncls.RecallSquawks();  
        
        test.stopTest();
    } 
    
    public static testMethod void testCPM_Reject() {
    
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
                
        PageReference pref = Page.CPM_SubmitSquawksForApproval;
        PageReference prefApprove = Page.CPM_SquawkManagement;
        pref.getParameters().put('id', proj.id); 
        prefApprove.getParameters().put('id', proj.id); 
          
        test.startTest();
      
        Test.setCurrentPageReference(pref);
        ApexPages.StandardController sc = new ApexPages.StandardController(proj);
        CPM_SubmitSquawksForApproval cls = new CPM_SubmitSquawksForApproval(sc);
        cls.squawks[0].sendSquawk = true;
        cls.submitForApproval();            

        SBQQ__QuoteLine__c ql = [Select Id, Add_Work_Status__c from SBQQ__QuoteLine__c where Project__c =: proj.Id];
        system.debug('Squawk Status Before: ' + ql.Add_Work_Status__c);
        
        Test.setCurrentPageReference(prefApprove);
        ApexPages.StandardController nsc = new ApexPages.StandardController(proj);
        CPM_SquawkManagement ncls = new CPM_SquawkManagement(nsc);
        ncls.squawks[0].pendingSquawk = true;
        ncls.RejectSquawks(); 
        
        SBQQ__QuoteLine__c ql2 = [Select Id, Add_Work_Status__c from SBQQ__QuoteLine__c where Project__c =: proj.Id];
        system.debug('Squawk Status After: ' + ql2.Add_Work_Status__c);
        
        test.stopTest();
    } 
    
    public static testMethod void testSubmitButtonOnQuote() {
        
        SBQQ__Quote__c q = [Select Id from SBQQ__Quote__c];     
        List<String> rl = new List<String>();
        
        String fxRecord = 'Q' + q.Id;
        rl.add(fxRecord);
        
        test.startTest();
        
        SubmitQuoteLinesForApproval.SubmitAllQuoteLines(q.Id);
        SubmitQuoteLinesForApproval.SubmitQuoteLines(rl);
        
        Test.stopTest();               
    }   
    
    public static testMethod void testSubmitButtonOnQuoteLine() {
        
        SBQQ__QuoteLine__c ql = [Select Id from SBQQ__QuoteLine__c];        
        List<String> rl = new List<String>();
        
        String fxRecord = 'L' + ql.Id;
        rl.add(fxRecord);
        
        test.startTest();
        
        //SubmitQuoteLinesForApproval.SubmitSingleQuoteLine(ql.Id);
        SubmitQuoteLinesForApproval.SubmitQuoteLines(rl);
        
        Test.stopTest();               
    } 
}