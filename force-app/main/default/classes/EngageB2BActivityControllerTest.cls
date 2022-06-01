@isTest

private class EngageB2BActivityControllerTest {

    static testMethod void buildValuesTest() {
    
        Lead testLead = new Lead();
        testLead.FirstName = 'Test FirstName ';
        testLead.LastName = 'Test LastName ';
        testLead.Company = 'Test Account';
        
        insert testLead;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        
        EngageB2BActivityController Controller = new EngageB2BActivityController(sc);

        //PageReference myPage = new Pagereference('/apex/EngageB2BActivityInsight?');
        //myPage.getParameters().put('object', 'personAccount');
        //Account accountTest = new Account(Name = 'Test');
        //insert accountTest;
        //Contact contactTest = new Contact(Title = 'Test', AccountId = accountTest.Id, LastName = 'Test');
        //insert contactTest;
        //myPage.getParameters().put('id', accountTest.Id);
        //Test.setCurrentPage(myPage);  
        Controller.buildValues();
        System.assertEquals(Controller.crmSyncID, testLead.Id);
  
    }

}