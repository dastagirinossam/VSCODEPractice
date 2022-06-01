@isTest
private class testEquipmentCloneController {

private static testMethod void testEquipmentCloneController() {

      Equipment__c equip = new Equipment__c(Name = 'APU.158 (BD)');
      
      ApexPages.StandardController con = new ApexPages.StandardController(equip);
 
      EquipmentCloneController ext = new EquipmentCloneController(con);

      PageReference ref = ext.saveAndReturn();
      
      PageReference pref = ext.GoBack();

    }         
}