@isTest
public class testReviseQuoteLine {

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
                proj.Designated_Approver__c = portalUser.Id;
                proj.MPM4_BASE__Status__c = 'Active';             
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
        
            //Create Squawks
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
                ql.Project__c = proj.Id;
                ql.SBQQ__Product__c = prod.Id;
                ql.Job_Card_Description__c = 'Test Squawk1';
                ql.SBQQ__Quote__c = quote.id;
                ql.Designated_Approver__c = portalUser.Id;
            insert ql; 
                  
            Approval.ProcessSubmitRequest newReq = new Approval.ProcessSubmitRequest();
        	newReq.setObjectId(ql.Id);
        	newReq.setSubmitterId(UserInfo.getUserId());
        	Approval.ProcessResult processResult = Approval.process(newReq);                
        }
    }
     
     static testMethod void RQL(){
           
        Test.startTest();
         
        SBQQ__QuoteLine__c sqk = [Select Id from SBQQ__QuoteLine__c];
             
        ApexPages.StandardController sc = new ApexPages.StandardController(sqk);
        ReviseQuoteLine testRQL = new ReviseQuoteLine(sc);
        
        PageReference p = testRQL.saveRevision();
                               
        Test.stopTest();              
	}  
    
    static testMethod void ChangeAndResubmit(){
        
        Test.startTest();  
        
        SBQQ__QuoteLine__c sqk = [Select Id from SBQQ__QuoteLine__c];
        
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: sqk.Id ];
        
        for(ProcessInstanceWorkitem workItem : workItems){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(workItem.Id);
            req.setAction('Approve');
            requests.add(req);
        }
        
        Approval.ProcessResult[] processResults = Approval.process(requests);
               
        ApexPages.StandardController sc = new ApexPages.StandardController(sqk);
        ReviseQuoteLine testRQL = new ReviseQuoteLine(sc);
        
        PageReference p = testRQL.ChangeResubmit();            
    }  
    
    static testMethod void RecallApproval(){
        
        Test.startTest();
        
        SBQQ__QuoteLine__c sqk = [Select Id from SBQQ__QuoteLine__c];               
                
        ApexPages.StandardController sc = new ApexPages.StandardController(sqk);
        ReviseQuoteLine testRQL = new ReviseQuoteLine(sc);
        
        PageReference p = testRQL.RecallApproval();
        
        Test.stopTest();              
    }
    
    static testMethod void RecallApprovalRequest(){
        
        Test.startTest();
        
        SBQQ__QuoteLine__c sqk = [Select Id from SBQQ__QuoteLine__c];              
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sqk);
        ReviseQuoteLine testRQL = new ReviseQuoteLine(sc);
        
        PageReference p = testRQL.RecallApprovalRequest();
               
        Test.stopTest();              
    } 
    
	static testMethod void CancelRecall(){
        
        Test.startTest();        
        
        SBQQ__QuoteLine__c sqk = [Select Id from SBQQ__QuoteLine__c];
             
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sqk);
        ReviseQuoteLine testRQL = new ReviseQuoteLine(sc);
        
        PageReference p = testRQL.CancelRecall();
               
        Test.stopTest();              
    } 
}