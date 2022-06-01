@isTest
public class CreateCustomerTest {
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
            
 
        }
    }
    
  	static testMethod void testExistingCustomerUser() {
      	Test.startTest();
        Contact portalcontact = [Select Id from Contact];
              
        system.debug('Contact: ' + portalContact.Id);
        
        Test.setCurrentPageReference(new PageReference('Page.CustomerCreation'));
    	System.currentPageReference().getParameters().put('Id', portalContact.Id);

    	ApexPages.StandardController sc = new ApexPages.standardController(portalContact);
    	CreateCustomerUser controller = new CreateCustomerUser(sc);       
		controller.prFinishLocation();
        
        test.stopTest();
               
    } 
    
    static testMethod void testCreateCustomerUser() {
        Account accntId = [Select Id from Account];
        
        Contact portalcontact = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = accntId.Id
        );
        
        insert portalContact;
        
        system.debug('Contact: ' + portalContact.Id);
        
        Test.setCurrentPageReference(new PageReference('Page.CustomerCreation'));
    	System.currentPageReference().getParameters().put('Id', portalContact.Id);
		ApexPages.currentPage().getHeaders().put('referer', 'lightning');

    	ApexPages.StandardController sc = new ApexPages.standardController(portalContact);
    	CreateCustomerUser controller = new CreateCustomerUser(sc);       
		controller.prFinishLocation();
               
    } 
       static testMethod void testCreateCustomerUserClassic() {
        Account accntId = [Select Id from Account];
        
        Contact portalcontact = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = accntId.Id
        );
        
        insert portalContact;
        
        system.debug('Contact: ' + portalContact.Id);
        
        Test.setCurrentPageReference(new PageReference('Page.CustomerCreation'));
    	System.currentPageReference().getParameters().put('Id', portalContact.Id);
		ApexPages.currentPage().getHeaders().put('referer', 'classic');

    	ApexPages.StandardController sc = new ApexPages.standardController(portalContact);
    	CreateCustomerUser controller = new CreateCustomerUser(sc);       
		controller.prFinishLocation();
               
    } 
    
    
}