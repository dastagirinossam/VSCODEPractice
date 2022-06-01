@isTest
public class fslCreateServiceAuthorizations_Test {
    
    static testMethod void Method1(){
        
        test.startTest();
        
        Account acnt = testDataGenerator.createAccount();
        Product_Line__c prodLine = testDataGenerator.createProductLine();
        Contact contact = testDataGenerator.createContact(acnt.Id);
        Aircraft__c ac = testDataGenerator.createAircraft(prodLine.Id, acnt.Id);
        Equipment__c equip = testDatagenerator.createEquipment(prodLine.Id, acnt.Id, ac.Id);
        
        OperatingHours opHrs= new OperatingHours(
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
        
        WorkOrder wodr = new WorkOrder(
            Subject = 'qwerty',
            //WorkTypeId = '',
            AccountId = acnt.Id,
            StartDate = System.today(), 
            ContactId = contact.Id, 
            EndDate = System.today()+8, 
            ServiceTerritoryId = st.Id ,
            Equipment__c = equip.Id, 
            Aircraft__c = ac.Id,
            PO__c = '15',
            Priority= 'Medium',
            Status ='New',
            Description = 'Test', 
            Crew_Size_Per_Work_Order__c = 10,
            Part_91_135_121__c = 'Part 91'            
        );
        insert wodr;
        
        ServiceAppointment sa = new ServiceAppointment(
            ParentRecordId = acnt.Id,
            Status = 'New'
        );
        insert sa;
        
        List<Id> woIDs = new List<Id>();
        woIDs.add(wodr.Id);
        
        List<WorkOrder>  wodrList = new  List<WorkOrder>();
        wodrList.add(wodr);
        
        List<Equipment__c> EquipList= new List<Equipment__c>();
        
        List<String> lstRecordId = new List<String>();
        lstRecordId.add(equip.Id);
        
        String  str,newWOsJSON; 
        
        List<ServiceAppointment> saList = new List<ServiceAppointment>();
        saList.add(sa);
        
        fslCreateServiceAuthorizations.CreateServiceAppointments(woIDs);
        EquipList= fslCreateServiceAuthorizations.getEquipment(lstRecordId);
        String jsonval = JSON.serialize(wodrList);
        fslCreateServiceAuthorizations.insertWO(jsonval); 
        test.stopTest();
    }
}