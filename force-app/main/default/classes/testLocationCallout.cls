@IsTest
private class testLocationCallout{
  
    public static testmethod void testLocationCallout() {
        Account acnt = new Account();
            acnt.Name = 'test name';
        	acnt.Type = 'Customer';
            acnt.Area__c = 'WEST';
            acnt.BillingStreet = '1600 Amphitheatre Parkway';
            acnt.BillingCity = 'Mountain View';
            acnt.BillingState = 'CA';
            acnt.BillingPostalCode = '94043';
            acnt.BillingCountry = 'United States';
            insert acnt;
        
        System.Test.startTest();
        SingleRequestMock fakeResponse = new SingleRequestMock(200,'Complete','[{"location" : {"lat" : 37.42291810, "lng" : -122.08542120}}]',null);
        System.Test.setMock(HttpCalloutMock.class, fakeResponse); 
        LocationCallouts.getLocation(acnt.Id);

    } 

    public static testmethod void testAccountUpdate(){
        Account acnt = new Account();
        acnt.Name = 'test name';
        acnt.Type = 'Customer';
        acnt.Area__c = 'WEST';
        acnt.BillingStreet = '1600 Amphitheatre Parkway';
        acnt.BillingCity = 'Mountain View';
        acnt.BillingState = 'CA';
        acnt.BillingPostalCode = '94043';
        acnt.BillingCountry = 'United States';
        insert acnt;
        
        Account a = [Select Id, Account_Trigger_Update__c from Account where Id =: acnt.Id];
        a.Account_Trigger_Update__c = True;
        update a;
        
        System.Test.startTest();
        SingleRequestMock fakeResponse = new SingleRequestMock(200,'Complete','[{"location" : {"lat" : 37.42291810, "lng" : -122.08542120}}]',null);
        System.Test.setMock(HttpCalloutMock.class, fakeResponse); 
        LocationCallouts.getLocation(a.Id);             
    }    
}