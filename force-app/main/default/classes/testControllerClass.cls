@isTest
private class testControllerClass {

private static testMethod void testFlightHours() {

      Equipment__c equip = new Equipment__c(Name = 'APU.158 (BD)');
       
      Flight_Hours__c fhrs = new Flight_Hours__c(Equipment__C = equip.id);
    
      ApexPages.StandardController sc = new ApexPages.StandardController(equip);
      FlightHours cls = new FlightHours(sc);
      cls.getFhrs();     
    }
    
private static testMethod void testsaveAndReturn() {

      Equipment__c equip = new Equipment__c(Name = 'APU.158 (BD)');
      Flight_Hours__c fhrs = new Flight_Hours__c(Equipment__C = equip.id);
    
      PageReference pref = Page.View_Flight_Hours;
      pref.getParameters().put('id', equip.id);      
      Test.setCurrentPageReference(pref);
      Test.startTest();   

      ApexPages.StandardController sc = new ApexPages.StandardController(equip);
      FlightHours cls = new FlightHours(sc);
      cls.getFhrs();  
      cls.saveAndReturn();
      test.stopTest();
} 
      
}