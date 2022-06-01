@isTest
public class TestLM_CommonUtils {
    
    static testMethod void testIsCreatable(){
        //Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Gatekeeper'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='testuser@testwilcos.com');
        System.runAs(u) {
            // The following code runs as user 'u'
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId());
            LM_CommonUtils.isCreatable('SIR__c');
            LM_CommonUtils.isCreatable('Opportunity');
        }
    }   
}