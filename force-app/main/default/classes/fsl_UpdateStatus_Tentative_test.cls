@isTest
public class fsl_UpdateStatus_Tentative_test {
    
    static testMethod void Method1(){
        test.startTest();
        
        Product_Line__c pl = TestDataGenerator.createProductLine();
        Account acnt = TestDataGenerator.createAccount();
        Contact contact = TestDataGenerator.createContact(acnt.Id);
        Aircraft__c ac = TestDataGenerator.createAircraft(pl.Id, acnt.Id);
        Equipment__c equip = TestDataGenerator.createEquipment(pl.Id, acnt.Id, ac.Id);
        
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
        
        WorkOrder wodr = new WorkOrder(
            Subject = 'qwerty',
            AccountId = acnt.Id,
            StartDate = System.today(), 
            ContactId = contact.Id, 
            EndDate = System.today()+8, 
            ServiceTerritoryId = st.Id ,
            Equipment__c = equip.Id, 
            Aircraft__c = ac.Id,
            PO__c = '15',
            Priority= 'Medium',
            Status ='In Progress',
            Description = 'Test', 
            Crew_Size_Per_Work_Order__c = 10
        );
        insert wodr;
        
        ServiceAppointment sa = new ServiceAppointment(
            ParentRecordId = acnt.Id,
            Status = 'Scheduled'
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
        
        List<Id> saList = new List<Id>();
        saList.add(sa.Id);
               
        Map<String, Object> additionalParameters = new Map<String, Object>();
        additionalParameters.put(string.valueof(sa.Id), sa);
        
        Datetime ganttStartDate = wodr.StartDate; 
        Datetime ganttEndDate = wodr.EndDate;
        
        String fromStatus = 'Scheduled';
        String toStatus = 'Tentative';
        
        FSL.GlobalAPIS.addStatusTransition(fromStatus, toStatus);
        
		fsl_UpdateStatus_Tentative t = new fsl_UpdateStatus_Tentative();
        t.action(saList, ganttStartDate, ganttEndDate, additionalParameters);        
        test.stopTest();
    }  
}