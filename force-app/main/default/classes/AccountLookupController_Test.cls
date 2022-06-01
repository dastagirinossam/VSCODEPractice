@IsTest
public class AccountLookupController_Test {
    static testMethod void TestMethod1()
    {
        test.startTest();
        
         //Create Account
        Account acnt1 = new Account(Type='Aircraft', Name = 'Test Account', Area__c='East', billingcountry = 'US', BillingState = 'CO');
        insert acnt1;
        
        //Create Account
        Account acnt = new Account();
        acnt.Name = 'test name';
        acnt.BillingStreet = '1600 Amphitheatre Parkway';
        acnt.BillingCity = 'Mountain View';
        acnt.BillingState = 'CO';
        acnt.BillingPostalCode = '37128';
        acnt.BillingCountry = 'United States';
        acnt.Area__c = 'East';
        
       insert acnt;
        
        List<Account> accList= new List<Account>();
        AccountLookupController alc = new AccountLookupController();
        accList= alc.performSearch('Test');
        alc.runSearch();
        
        String str=alc.getFormTag();
        String str1= alc.getTextBox();
        
        PageReference pref = Page.fslAccountLookup;       
        pref.getParameters().put('Id',acnt.id);   
        Test.setCurrentPage(pref);
        
        
        
        ApexPages.StandardController stc = new ApexPages.StandardController(acnt);
        AccountLookupController mycon = new AccountLookupController();
        mycon.search();
       // mycon.saveAccount();
        
        test.stopTest();
    }
}