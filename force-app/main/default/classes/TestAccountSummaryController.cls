@isTest
public class TestAccountSummaryController {
       
    @testSetup static void setup() {
        Account a = TestDataGenerator.createAccount();
        Contact c = TestDataGenerator.createContact(a.Id);  
    }

    @isTest Static void TestaccountSummary(){
     
        Account a = [SELECT  Name, id FROM Account]; 
        AccountSummaryController.accountSummary(a.Id);               
    }
}