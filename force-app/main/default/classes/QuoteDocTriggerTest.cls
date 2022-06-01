@isTest
public class QuoteDocTriggerTest {
    
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
            Aircraft__c ac = new Aircraft__c();
                ac.Product_Line__c = prodLine.Id;
                ac.Aircraft_Make__c = 'LEARJET';
                ac.Aircraft_Model_2011__c = 'LEAR 45';
                ac.Aircraft_SN__c = '213';
                ac.ACReg__c = 'N9551H';
                ac.name = 'NA';
                ac.Aircraft_Type__c = 'Aircraft';
                ac.OwnerId = UserInfo.getUserId();
                ac.Aircraft_Status__c = 'In-Operation';
           insert ac;
            
            //Create Engine
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.Id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000',
                Aircraft__c = ac.id
                );
            insert equip;
            
            
                
            //Create Product
            Product2 prod = new Product2(
                Name = 'Unscheduled Product',
                ProductCode = 'Code1',
                SBQQ__Specifications__c = 'specification field on product object specification field on quotelines Addworkstatus trigger edit Argument cannot be null issue fix',
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
                oppty.Quote_Revision_Number__c ='1';
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
                RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Standard Proposal').getRecordTypeId(),
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
            
            //Create Quote Document
            
            SBQQ__QuoteDocument__c quoteDoc = new SBQQ__QuoteDocument__c( 
                SBQQ__Quote__c = quote.Id,
                SBQQ__Version__c = 1,
                SBQQ__Opportunity__c = oppty.Id);  
            insert quoteDoc;             
        }
    }
    
    //Testing Quote Document Name
    static testmethod void QuoteDocName(){
        
        test.startTest();
        SBQQ__Quote__c q = [Select Name from SBQQ__Quote__c];
        SBQQ__QuoteDocument__c qd = [Select Name from SBQQ__QuoteDocument__c];  
        
        System.assertEquals(qd.Name, q.Name + '-1');
        
        test.stopTest();       
    }  
    
    //Increase Doc Version
    static testmethod void QuoteDocName2(){
        
        test.startTest();
        SBQQ__Quote__c q = [Select Name from SBQQ__Quote__c];
        Opportunity o = [Select id from Opportunity];
        
        //Create Quote    
        SBQQ__QuoteDocument__c quoteDoc = new SBQQ__QuoteDocument__c( 
            SBQQ__Quote__c = q.Id,
            SBQQ__Version__c = 2,
            SBQQ__Opportunity__c = o.Id);  
        insert quoteDoc;   
        
        SBQQ__QuoteDocument__c qd = [Select Name from SBQQ__QuoteDocument__c where SBQQ__Version__c = 2];
       
        System.assertEquals(qd.Name, q.Name + '-2');
        
        test.stopTest();       
    }   
}