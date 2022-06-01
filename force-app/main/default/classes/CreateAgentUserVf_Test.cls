@istest
public class CreateAgentUserVf_Test {
    
     
    Static testMethod void createUsersFromContact(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        UserRole r2 = [SELECT DeveloperName,Id,Name FROM UserRole WHERE Name = 'President' limit 1 ];
        String profileId1 = [Select Id from profile where name = 'NBAA Customer'].Id;
        
        test.startTest();
        User u2 = new User(
            Alias = 'nUser21',
            UserRoleId = r2.Id,
            Email='newuser21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newuser21@testorg.com');
        UserRole r = new UserRole(DeveloperName = 'StandardAeroCustomerUser', Name = 'StandardAeroCustomer User');
        insert r;
        Contact con=new Contact();
        insert u2;
        system.runAs(u2) {
            Account acc = new Account(name = 'StandardAero', Type = 'Customer', Area__c = 'W/U', BillingState = 'CO');
            insert acc;
            
            con = new Contact(FirstName = 'Test', LastName = 'Con345', Email = 'Test345@Test.com',AccountId=acc.Id,User_Record__c=UserInfo.getUserId());
            insert con;
            
            User u1 = new User(
                ProfileId = profileId1,
                //PortalRole = 'President',
                Username = con.Email + '.NBAA',
                Alias = 'Supbman',
                Email=con.Email,
                EmailEncodingKey='UTF-8',
                Firstname=con.FirstName,
                Lastname=con.LastName,
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Chicago',
                CommunityNickname = 'testUser123',
                //UserRoleId = stringrole,
                //UserRoleId=r.id,
                IsActive = true,
                ContactId = con.id
            );
            insert u1;
            
            Test.setCurrentPageReference(new PageReference('Page.CreateAgentVfPage'));
            System.currentPageReference().getParameters().put('Id', con.Id);

           ApexPages.StandardController sc = new ApexPages.standardController(con);
           CreateAgentUserVf controller = new CreateAgentUserVf(sc);       
            controller.CreateUserFromContact();
        CreateAgentUserVf.getData(con.Id);
           test.stopTest();
           
       ApexPages.StandardController sc1 = new ApexPages.StandardController(con);

    CreateAgentUserVf cvf = new CreateAgentUserVf(sc1);
    PageReference result = cvf.CreateUserFromContact();
    PageReference result1 = cvf.redirect();       
          
        }
    }
   }