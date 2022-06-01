@isTest
public class ResetPwdTest {
    @isTest
    static void testResetPassword(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u2 = new User(
            Alias = 'testnew',
            Email='newusertest21@testorg.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='newusertest21@testorg.com');
        insert u2;
        System.runAs(u2){
            Test.startTest();
            Resetpwd.resetPassword();
            Test.stopTest();
        }
        
    }

}