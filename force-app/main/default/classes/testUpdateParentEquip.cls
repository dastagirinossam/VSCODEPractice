@isTest(seeAllData=true)
public class testUpdateParentEquip{

    static testMethod void testUpdateParentEquipmentFH(){
    
    //Create Product Line
    Product_Line__c prodLine = new Product_Line__c(
        Product_Line_Family__c = 'Aircraft',
        Name = 'new'
    );
    insert prodLine;
        
    //Create Account
    Account acnt = new Account();
        acnt.Name = 'test name';
        acnt.BillingStreet = '1600 Amphitheatre Parkway';
        acnt.BillingCity = 'Mountain View';
        acnt.BillingState = 'CA';
        acnt.BillingPostalCode = '94043';
        acnt.BillingCountry = 'United States';
    insert acnt;
    
    //Create Engine
    Equipment__c equip = new Equipment__c(
        Product_Line__c = prodLine.Id,
        Account__c = acnt.id,
        Equipment_Prefix__c = 'HTF',
        EngineorAPUSN__c = '123',
        Equipment_Type__c = 'Engine',
        Equipment_Status__c = 'In-Operation',
        Model__c = 'HTF7000'
    );
    insert equip;
                
    Flight_Hours__c fh = new Flight_Hours__c();
        fh.Hours__c = decimal.valueof('10');
        fh.Hours_Date__c = Date.Today();
        fh.Source__c='DMT ~ Contract Honeywell MSP';
        fh.Equipment__c= equip.Id;    
    insert fh;
      
    Flight_Hours__c fhObj = [
        select id, Parent_Equipment__c, Equipment__c
        from Flight_Hours__c
        where id=: fh.Id];
        
    System.assertEquals(fhObj.Parent_Equipment__c, fhObj.Equipment__c);
    }

}