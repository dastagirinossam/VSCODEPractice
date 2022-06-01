@isTest
public class fslAccountLookupControllerTest {

    @isTest
    Public static void Testmethod1(){
        
        Account acnt = new Account();
        acnt.Name = 'test name';
        acnt.BillingStreet = '1600 Amphitheatre Parkway';
        acnt.BillingCity = 'Mountain View';
        acnt.BillingState = 'CA';
        acnt.BillingPostalCode = '94043';
        acnt.BillingCountry = 'United States';
        insert acnt;
        
      Contact ct= new Contact (LastName = 'Test',AccountId = acnt.Id);
    insert ct;  
        
        fslAccountLookupController fsl = new fslAccountLookupController();
        fsl.AccountId = acnt.Id;
        fsl.contact = ct;
        
        PageReference resPg = fsl.gotoAccountSummary();
        
    }
}