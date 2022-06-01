@isTest
public class testChatterFileVisibility {

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
            	ac.Aircraft_Status__c = 'In-Operation';
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
                proj.Crew_Chief__c = 'Spoon Man';
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
                Facility1__c = 'AGS',
                Project__c = proj.Id);  
            insert quote;
        
            //Create Squawks
            SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c();
                ql.Project__c = proj.Id;
                ql.SBQQ__Product__c = prod.Id;
                ql.Job_Card_Description__c = 'Test Squawk1';
                ql.SBQQ__Quote__c = quote.id;
                ql.Designated_Approver__c = proj.Designated_Approver__c;
            	ql.CPM__c = proj.CPM__c;
            insert ql;
            
            //insert logbook
            Log_Book_Entry__c lb = new Log_Book_Entry__c();
                lb.Name = 'Test Logbook';
                lb.Project__c = proj.Id;
            insert lb;
            
            //Insert Contract Change Order
            Contract_Change_Order__c cco = new Contract_Change_Order__c();
            	cco.Project__c = proj.Id;
            insert cco;
        
        	//insert file
    		ContentVersion cont = new ContentVersion();

    		cont.Title = 'Title for this contentVersion';
    		cont.PathOnClient = 'file_' + Datetime.now().getTime() + '.txt';
    		cont.VersionData = Blob.valueOf('My Content in file_' + Datetime.now().getTime() + '.txt');
    		cont.Origin = 'H';

        	insert cont;
            
            FeedItem quoteLinePost = new FeedItem();
        		quoteLinePost.ParentId = ql.Id;
        		quoteLinePost.Body = 'test';
        		quoteLinePost.Type = 'ContentPost';
        		quoteLinePost.RelatedRecordId = cont.Id;
            insert quoteLinePost;
        
        	FeedItem quotePost = new FeedItem();
        		quotePost.ParentId = quote.Id;
        		quotePost.Body = 'test';
        		quotePost.Type = 'ContentPost';
        		quotePost.RelatedRecordId = cont.Id;
            insert quotePost;
        
        	FeedItem contactPost = new FeedItem();
        		contactPost.ParentId = portalcontact.Id;
        		contactPost.Body = 'test';
        		contactPost.Type = 'ContentPost';
        	contactPost.RelatedRecordId = cont.Id;
            insert contactPost;
            
        
        	FeedItem projPost = new FeedItem();
        		projPost.ParentId = proj.Id;
        		projPost.Body = 'test';
        		projPost.Type = 'ContentPost';
        	projPost.RelatedRecordId = cont.Id;
        	insert projPost;
           
        }
    }
 
    static testmethod void testPostProject(){
        Profile profile = [Select Id from profile where name = 'Customer Community Plus - Custom'];
        MPM4_BASE__Milestone1_Project__c proj = [Select Id from MPM4_BASE__Milestone1_Project__c];
        User portalUser = [Select Id from User where CommunityNickname = 'testUser123'];
        
        system.runAs(portalUser){
        
            Test.StartTest();
    
                FeedItem projPost = new FeedItem();
                    projPost.ParentId = proj.Id;
                    projPost.Body = 'test';             
                insert projPost;
                               
            Test.StopTest();
        }
    }

    
	static testmethod void testPostContact(){
        Profile profile = [Select Id from profile where name = 'Customer Community Plus - Custom'];
        Contact c = [Select Id from Contact];
        User portalUser = [Select Id from User where CommunityNickname = 'testUser123'];
        
        system.runAs(portalUser){
        
            Test.StartTest();
    
                FeedItem conPost = new FeedItem();
                    conPost.ParentId = c.Id;
                    conPost.Body = 'test';             
                insert conPost;
                                  
            Test.StopTest();
        }
    }
    
	static testmethod void testPostQuote(){
        Profile profile = [Select Id from profile where name = 'Customer Community Plus - Custom'];
        SBQQ__Quote__c quote = [Select Id from SBQQ__Quote__c];
        User portalUser = [Select Id from User where CommunityNickname = 'testUser123'];
        
        system.runAs(portalUser){
        
            Test.StartTest();
    
                FeedItem quotePost = new FeedItem();
                    quotePost.ParentId = quote.Id;
                    quotePost.Body = 'test';             
                insert quotePost;
                                             
            Test.StopTest();
        }
    }
    
	static testmethod void testPostQuoteLine(){
        Profile profile = [Select Id from profile where name = 'Customer Community Plus - Custom'];
        SBQQ__QuoteLine__c ql = [Select Id from SBQQ__QuoteLine__c];
        User portalUser = [Select Id from User where Email = 'bruce.wayne@wayneenterprises.com'];
        
        system.runAs(portalUser){
        
            Test.StartTest();

            	FeedItem QuoteLinePost = new FeedItem();
                    QuoteLinePost.ParentId = ql.Id;
                    QuoteLinePost.Body = 'test';             
                insert QuoteLinePost;
                        
            Test.StopTest();
        }
    }
    
	static testmethod void testPostLogbook(){
        Log_Book_Entry__c lb = [Select Id from Log_Book_Entry__c];
		
        Test.StartTest();
   
            FeedItem lbPost = new FeedItem();
            	lbPost.ParentId = lb.Id;
                lbPost.Body = 'test';             
            insert lbPost;           
                                 
		Test.StopTest();
    }
    
	static testmethod void testPostCCO(){
        Contract_Change_Order__c cco = [Select Id from Contract_Change_Order__c];
		
        Test.StartTest();
   
            FeedItem ccoPost = new FeedItem();
            	ccoPost.ParentId = cco.Id;
                ccoPost.Body = 'test';             
            insert ccoPost;
                                 
		Test.StopTest();
    }
           
}