@isTest
Public class cloneBuyerQuoteLines_test{
    static testMethod void createTestData(){
    
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
       insert u2;
            System.runAs(u2){
                
                 Profile p1 = [SELECT Id FROM Profile WHERE Name='Gatekeeper-CPM'];    
          UserRole r1 = new UserRole(DeveloperName = 'MyCustomRole1', Name = 'My Role');
          insert r1;
                    
              User u3 = new User(
              Alias = 'nUser21',
              UserRoleId = r1.Id,
              Email='newuser221@testorg.com', 
              EmailEncodingKey='UTF-8', 
              LastName='Testing', 
              LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', 
              ProfileId = p1.Id, 
              TimeZoneSidKey='America/Los_Angeles', 
              UserName='newuser221@testorg.com');
                insert u3;
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
                
                 Aircraft__c ac = new Aircraft__c();
                ac.Product_Line__c = prodLine.Id;
                ac.Aircraft_Make__c = 'CASA';
                ac.Aircraft_SN__c = '213';
                ac.name = 'NA';
                ac.Aircraft_Type__c = 'Aircraft';
                ac.OwnerId = UserInfo.getUserId();
           insert ac;
            //Create Engine
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.Id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                name = 'NA',
                Model__c = 'HTF7000'
                );
            insert equip;
            
            //Create Aircraft
           
                
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
                proj.CPM__c = u3.Id;
                proj.Designated_Approver__c = portalUser.Id;
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
                ql.SBQQ__Description__c = 'Test Description';                
               
            insert ql; 
            Test.stopTest();
            List<String> listRecId = new List<String>();
            listRecId.add(ql.id);
            List<SBQQ__QuoteLine__c> qlList = new List<SBQQ__QuoteLine__c>();
            qlList.add(ql);
            String cpmstr = ql.CPM__c;
    
    
         System.debug('Current User'+UserInfo.getUserId());       
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: listRecId and ActorId =: UserInfo.getUserId()];
        
        for(ProcessInstanceWorkitem workItem : workItems){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(workItem.Id);
            req.setAction('Reject');
            requests.add(req);
        }
        Approval.ProcessResult[] processResults = Approval.process(requests);
        cloneBuyerQuoteLines.listOfDeferRecords(listRecId);
        cloneBuyerQuoteLines.UpdateQuoteStatus(quotestring);
        cloneBuyerQuoteLines.SubmitQuoteLines(qlList, cpmstr);
         
        }
        
    }
}