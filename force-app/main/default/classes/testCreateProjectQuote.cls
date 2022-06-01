@isTest
public class testCreateProjectQuote {

    @testSetup 
    static void setup(){
         
        //Create Role
        UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
	    insert r;
        
        //Create User
        User u = new User(
        	ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'puser@email.com',
            Username = 'puser@email.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserRoleId = r.id
    	);
        insert u;
         
        System.runAs(u) {
            //Create Product Line
            Product_Line__c prodLine = new Product_Line__c(
                Product_Line_Family__c = 'Aircraft',
                Name = 'new'
            );
            insert prodLine;
                   
            //Create Account
            Account portalAccount = new Account(
                Name = 'test name',
                BillingStreet = '1600 Amphitheatre Parkway',
                BillingCity = 'Mountain View',
                BillingState = 'TN',
                BillingPostalCode = '37128',
                BillingCountry = 'United States',
                Area__c = 'East',
                OwnerId = u.id
            );
            insert portalAccount;
            
            //Create contact
            Contact contact = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                ContactType__c = 'Primary Contact',
                AccountId = portalAccount.Id,
                Email = 'test@test.com'
            );
            
            insert contact;
                          
            //Create portal User
            User pu = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Plus - Custom'].Id,
                LastName = 'McTesty',
                Email = 'testuser@email.com',
                Username = 'testuser@email.com' + System.currentTimeMillis(),
                ContactId = contact.id,
                CompanyName = 'TEST',
                Title = 'Test',
                Alias = 'tUser1',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US'
            );
            insert pu;
                         
            //Create Engine
            Equipment__c equip = new Equipment__c(
                Product_Line__c = prodLine.id,
                Account__c = portalAccount.id,
                Equipment_Prefix__c = 'TFE',
                EngineorAPUSN__c = 'ABC',
                Equipment_Type__c = 'Engine',
                Equipment_Status__c = 'In-Operation',
                Model__c = 'HTF7000',
                name = 'NA'
                );
            insert equip;
            
            //Create Aircraft
            Aircraft__c ac = new Aircraft__c();
                ac.Product_Line__c = prodLine.id;
                ac.Aircraft_Make__c = 'FALCON';
                ac.Aircraft_Model_2011__c = 'FALCON 7X';
                ac.Aircraft_SN__c = '213';
                ac.name = 'new';
                ac.Aircraft_Country__c = 'United States';
                ac.ACReg__c = 'N12345';
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
            
            Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
            Map<String,Schema.RecordTypeInfo> opportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();
            Id rtId = opportunityRecordTypeInfo .get('New Opportunity').getRecordTypeId();
            Id masterId = opportunityRecordTypeInfo .get('Master Opportunity').getRecordTypeId();
            
            //Create Opportunity
            Opportunity oppty = new Opportunity();
                oppty.Input_Date_Accuracy__c = 'Firm';
                oppty.Operator__c = 'FAA Part 135';
                oppty.RecordTypeId = masterId;
                oppty.RSM__c = 'Campbell,Tom';
                oppty.Name = 'trigger test';
                oppty.Opportunity_Name_Details__c = 'trigger test';
                oppty.StageName = 'New Opportunity';
                oppty.AccountId = portalAccount.Id;
                oppty.Aircraft__c = ac.Id;
                oppty.Amount = decimal.valueof('1471620');
                oppty.Equipment__c = equip.Id;
                oppty.CustomerName__c = 'World Jet, Inc.';
                oppty.Facility__c = 'PHX';
                oppty.Tier_Level__c = '1';
                oppty.CloseDate =  Date.today();
                oppty.InputDate__c =  Date.today();
                oppty.OutputDate__c =  Date.today();
                oppty.Product_Line__c = ac.Product_Line__c;
                oppty.Type = 'Master';
                oppty.SubType__c = 'Cabin Broadband';
                oppty.LeadSource = 'CPM';
                oppty.QuoteDelivery__c = 'Hand Delivery';
                oppty.QuoteRequiredBy__c =  Date.today();
                oppty.Base_Quote_Number__c = '1';
                oppty.QuotedDate__c =  Date.today();
                oppty.Concession1__c = 'None';
                oppty.Agent_Representative__c = 'Not Applicable';
                oppty.Master_Opportunity__c = True;
                oppty.Competitor__c = 'Harrods Aviation';
                oppty.WinorLossReason1__c = 'Location';
                oppty.Win_Loss_Description__c = 'Test';
                oppty.Customer_Satisfaction_Survey_Contact__c = contact.id;
                oppty.Contact__c = contact.id;
                oppty.AFSM_Lookup__c = u.id;
            insert oppty;
            
            //Create Project
            MPM4_BASE__Milestone1_Project__c proj = new MPM4_BASE__Milestone1_Project__c();
                proj.Name = 'Project Test';
                proj.MPM4_BASE__Account__c = portalAccount.Id;
                proj.Opportunity__c = oppty.Id;
                proj.Aircraft__c = ac.Id;
            	proj.Engine__c = equip.id;
                proj.Input_Date__c = oppty.InputDate__c;
                proj.Delivery_Date__c = oppty.OutputDate__c;
                proj.MPM4_BASE__Kickoff__c = oppty.InputDate__c;
                proj.MPM4_BASE__Deadline__c = oppty.OutputDate__c;
                proj.Crew_Chief__c = 'Spoon Man';
                proj.CPM__c = userInfo.getUserId();
                proj.Designated_Approver__c = pu.Id;
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
            
            //Create Custom Action
            SBQQ__CustomAction__c customAction = new SBQQ__CustomAction__c();
                  customAction.Name = 'Add Products';
                  customAction.SBQQ__DisplayOrder__c = 900;
                  customAction.SBQQ__Type__c = 'Menu';
                  customAction.SBQQ__Active__c = True;
                  customAction.SBQQ__Default__c = True;
                  customAction.SBQQ__Page__c = 'Quote Line Editor';
                  customAction.SBQQ__Location__c = 'Quote/Group';
                  customAction.SBQQ__Label__c = 'Add Products';
            insert customAction;
        }        
    }
    
	static testmethod void SetVariablesTests() {
        
        MPM4_BASE__Milestone1_Project__c proj = [Select Id from MPM4_BASE__Milestone1_Project__c];
        SBQQ__Quote__c quote = [Select Id from SBQQ__Quote__c];
        Product2 prod = [Select Id From Product2];
        SBQQ__CustomAction__c customAction = [Select Id from SBQQ__CustomAction__c];
        String org = URL.getSalesforceBaseUrl().getHost().substringAfter('.').substringBefore('.');
        
		PageReference pageRef = Page.CreateNewProjectQuote;
		Test.setCurrentPage(pageRef);
		createProjectQuote testCtrl = new createProjectQuote(new ApexPages.StandardController(proj));
               
        testCtrl.strQuoteVariable = quote.Id;
        testCtrl.strProductVariable = prod.Id;
        testCtrl.strCustomActionVariable = customAction.Id;       
        testCtrl.prFinishLocation.getUrl();       
	}
    
    //Delete Share Record On Project
    static testmethod void DeleteProjectShareRecord() {
        
        MPM4_BASE__Milestone1_Project__c proj = [Select Id, Designated_Approver__c from MPM4_BASE__Milestone1_Project__c];
        proj.MPM4_BASE__Status__c = 'Planning';
        update proj;
      
	} 
}