@IsTest(SeeAllData=true)
private class CommunityChatterTest {
	static testMethod void chatterTest() {
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
            
            //Create contact
            Contact portalcontact1 = new Contact(
                    FirstName = 'Test2',
                    Lastname = 'McTesty',
                    AccountId = portalAccount.Id
            );
            insert portalContact1;
        
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
        
            System.runAs(portalUser) {
                CommunityChatter.PostComment('@[' + userinfo.getName() + '] Lets Do This!');                        
            } 
        }
    }
    
    static testMethod void RecordChatterTest(){
    	//Create Product Line
        Product_Line__c prodLine = new Product_Line__c(
        	Product_Line_Family__c = 'Aircraft',
            Name = 'new'
        );
        insert prodLine;
        
        CommunityChatter.RecordPostComment('@[' + userinfo.getName() + '] Lets Do This!', prodLine.Id);        
    }
}