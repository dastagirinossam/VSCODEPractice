@isTest
private class testAircraftControllerClass {

private static testMethod void testFlightHours() {

      Aircraft__c ac = new Aircraft__c(Name = 'F2K.081');
       
      Flight_Hours__c fhrs = new Flight_Hours__c(Aircraft__c = ac.id);
    
      ApexPages.StandardController sc = new ApexPages.StandardController(ac);
      AircraftFlightHours  cls = new  AircraftFlightHours(sc);
      cls.getFhrs();     
    }
    
private static testMethod void testsaveAndReturn() {

      Aircraft__c ac = new Aircraft__c(Name = 'F2K.081');
      Flight_Hours__c fhrs = new Flight_Hours__c(Aircraft__c = ac.id);
    
      PageReference pref = Page.Aircraft_ArchiveFlightHours;
      pref.getParameters().put('id', ac.id);      
      Test.setCurrentPageReference(pref);
      Test.startTest();   

      ApexPages.StandardController sc = new ApexPages.StandardController(ac);
      AircraftFlightHours cls = new  AircraftFlightHours(sc);
      cls.getFhrs();  
      cls.saveAndReturn();
      test.stopTest();
} 
      
}