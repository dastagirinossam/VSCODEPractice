@istest
public class CreateUserHandler_Test {
    
    static testmethod void userHandlerTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile prfl = [SELECT Id, Name FROM Profile WHERE Name = 'Customer Community Plus Login User - Custom'];        
        UserRole r2 = [SELECT DeveloperName, Id, Name FROM UserRole WHERE Name = 'President' limit 1 ];
        
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
        insert u2;
        
        Contact con = new Contact();
        Contact con2 = new Contact();
        User u1 = new User();
        Opportunity opp = new Opportunity();
        Aircraft__c ac = new Aircraft__c();
        Equipment__c equip = new Equipment__c();
        Account account = new Account();
        
        system.runAs(u2) {  
            
            account = testDatagenerator.createAccount();
            
            con = new Contact(FirstName = 'Test', LastName = 'Con345', Email = 'Test345@Test.com', AccountId = account.Id);
            insert con;
            
            con2 = new Contact(FirstName = 'Test', LastName = 'Con346', Email = 'Test346@Test.com', AccountId = account.Id);
            insert con2;
            
            Product_Line__c pl = testDatagenerator.createProductLine();
            ac = testDatagenerator.createAircraft(pl.Id, account.Id);
            equip = testDatagenerator.createEquipment(pl.Id, account.Id, ac.Id);
            Sub_Type_2__c st2 = testDatagenerator.createSubType2(pl.Id);
            opp = testDatagenerator.instantiateOpportunity(account.Id, ac.Id, equip.Id, pl.Id, st2.Id, con.Id);
            
            UserRole r = new UserRole(Name = 'StandardAero Customer User');
            insert r;
            
            u1 = new User( email='test-user@fakeemail.com', contactid = con.id, profileid = prfl.ID, 
                               UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
                               TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
                               LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User');
            insert u1;
        }
        
        CreateUserHandler.CreateUserFromContact(con.Id); 
        CreateUserHandler.CreateUserFromContact(con2.Id);

        /*String userinfo = userinfo.getUserId();
        String u3id = null;
        Date opptyInputDate = Date.today();
        Date opptyOutputDate = Date.today() + 1;
        String portalUser1Id = u1.Id;
        String portalUser2Id = null;
        String portalUser3Id = null;
        String portalUser4Id = null;
        String portalUser5Id = null;
        String portalUser6Id = null;
       
        MPM4_BASE__Milestone1_Project__c project = testDatagenerator.instantiateProject(account.Id, opp.Id, ac.Id, equip.Id,
                                                                                       opptyInputDate, opptyOutputDate,
                                                                                       userinfo,portalUser1Id,
                                                                                       portalUser2Id,
                                                                                       portalUser3Id,
                                                                                       portalUser4Id,
                                                                                       portalUser5Id,
                                                                                       portalUser6Id,
                                                                                       u3id);*/
        
        List<String> uIds = new List<String>();
        User u = [Select Id, New_User_Password__c from User where ContactId =: con.Id];
        uIds.add(u.Id);
        
        String pw = 'testClass01';
        
        CreateUserHandler.setPassWordProj(uIds);
        CreateUserHandler.customerResetPassword(u.Id, pw);
    } 
}