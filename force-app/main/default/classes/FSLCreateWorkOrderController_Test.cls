@isTest
public class FSLCreateWorkOrderController_Test {
    
    static testMethod void GetRecordsMethod(){
        
        Id RecordTypeIdEquipment = Schema.SObjectType.Equipment__c.getRecordTypeInfosByName().get('ALL OTHER').getRecordTypeId();
        
        Product_Line__c prodLine = testdatagenerator.createProductLine();
		Account acnt = testdatagenerator.createAccount();
        Contact contact = testdatagenerator.createContact(acnt.Id);
        Aircraft__c ac = testdatagenerator.createAircraft(prodLIne.Id, acnt.Id);
        Equipment__c equip = testdatagenerator.createEquipment(prodLIne.Id, acnt.Id, ac.Id);

        OperatingHours  opHrs= new OperatingHours(
            Name= 'TestOprHrs',
            TimeZone = 'America/Los_Angeles'            
        );
        insert opHrs;

        ServiceTerritory st= new ServiceTerritory(
            Name= 'Service Territory',
            OperatingHoursId= opHrs.Id,
            IsActive= True
        );
        insert st;

        Test.startTest();
        String aircraftId;
        aircraftId = ac.Id;
        FSLCreateWorkOrderController.getAircraft(aircraftId);

        List<Equipment__c> EquipList= new List<Equipment__c>();
        List<String> lstRecordId = new List<String>();
        lstRecordId.add(equip.Id);
        FSLCreateWorkOrderController.getEquipments(lstRecordId);
        Test.stopTest();
    }
    
    static testMethod void createWOMethod(){
        
        Id RecordTypeIdEquipment = Schema.SObjectType.Equipment__c.getRecordTypeInfosByName().get('ALL OTHER').getRecordTypeId();
        
        Product_Line__c prodLine = testdatagenerator.createProductLine();
		Account acnt = testdatagenerator.createAccount();
        Contact contact = testdatagenerator.createContact(acnt.Id);
        Aircraft__c ac = testdatagenerator.createAircraft(prodLIne.Id, acnt.Id);
        Equipment__c equip = testdatagenerator.createEquipment(prodLIne.Id, acnt.Id, ac.Id);
        
        OperatingHours  opHrs= new OperatingHours(
            Name= 'TestOprHrs',
            TimeZone = 'America/Los_Angeles'            
        );
        insert opHrs;

        ServiceTerritory st= new ServiceTerritory(
            Name= 'Service Territory',
            OperatingHoursId= opHrs.Id,
            IsActive= True
        );
        insert st;
        
        String aircraftId;
        aircraftId = ac.Id;
        FSLCreateWorkOrderController.getAircraft(aircraftId);

        List<Equipment__c> EquipList= new List<Equipment__c>();
        List<String> lstRecordId = new List<String>();
        lstRecordId.add(equip.Id);
        FSLCreateWorkOrderController.getEquipments(lstRecordId);
        
        Test.startTest();
        String  newWOJSON, newWOLIJSON;
        newWOJSON = '[{"Crew_Size_Per_Work_Order__c":1,' +
            '"ServiceTerritoryId":"' + st.Id + '",' +
            '"AccountId":"' + acnt.Id + '",' +
            '"ContactId":"' + contact.Id + '",' +
            '"Aircraft__c":"' + ac.Id + '",' +
            '"StartDate":"2020-08-25T09:46:00.000Z",' +
            '"EndDate":"2020-08-25T09:46:00.000Z",' +
            '"Status":"New",' +
            '"Priority":"Low",' +
            '"Subject":"Testing 24th August",' +
            '"Part_91_135_121__c":"Part 91",' +
            '"RII_Required__c":true,' + 
            '"RPA_Work_Order__c":"Test"}]';
        
        newWOLIJSON = '[{"Equipment__c":"'+equip.Id+'","PO__c":"1234"}]';
        FSLCreateWorkOrderController.insertWO( newWOJSON, newWOLIJSON );
        Test.stopTest();
    }
}