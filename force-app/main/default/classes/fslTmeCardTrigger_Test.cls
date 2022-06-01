@IsTest
public class fslTmeCardTrigger_Test {
    static testMethod void TestMethod1()
    {
        test.startTest();
      
        //Create Account
      Account acnt = new Account();
        acnt.Name = 'test name';
        acnt.BillingStreet = '1600 Amphitheatre Parkway';
        acnt.BillingCity = 'Mountain View';
        acnt.BillingState = 'TN';
        acnt.BillingPostalCode = '37128';
        acnt.BillingCountry = 'United States';
        acnt.Area__c = 'East';
        acnt.RPACustomerNumber__c= 'G0501';
        insert acnt;
        
        //Create ServiceAppointment record
        ServiceAppointment sa = new ServiceAppointment(
            ParentRecordId = acnt.Id,
            Status = 'In Progress'
        );
        insert sa;
        
        //Create Time card record 
        Time_Card__c tc= new Time_Card__c();
        tc.Service_Appointment__c= sa.id;
        
        insert tc;
        
        fslServiceAppointment.getSA(sa.id);
        
        test.stopTest();
    }
}