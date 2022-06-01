public class AccountSummaryController {
    @AuraEnabled    
    public static AccountSummaryWrapper accountSummary(string Ids){
        system.debug('Ids>>'+ Ids);
        AccountSummaryWrapper actsw = new AccountSummaryWrapper();
        actsw.acc = [select Id, 
                     Owner.Name, 
                     Area__c,
                     Type,
                     Customer_Account_Rating__c,
                     Phone,
                     BillingStreet,
                     BillingCity,
                     BillingState,
                     BillingPostalcode,
                     BillingCountry,
                     Name
                     from Account 
                     where Id =:Ids ];
        
        actsw.getContactSum = getContactSum(Ids);
        actsw.getACSum = getACSum(Ids);
        actsw.getMST = getMST(Ids);
        actsw.getCases = getCases(Ids);
        actsw.getManagedAC = getManagedAC(Ids);
        actsw.getManagedACEquipSum = getManagedACEquipSum(Ids);
        actsw.getEquipSum = getEquipSum(Ids);
        actsw.getOpptySum = getOpptySum(Ids);
        actsw.getManagedOpptySum = getManagedOpptySum(Ids);
        system.debug('actsw>>'+ actsw);
        
        return actsw;
    }
    
    @AuraEnabled
    public static List<Contact> getContactSum(string Ids) {
        return [select name,
                title,
                ContactType__c,
                phone,
                hangarphone__c,
                mobilephone,
                email
                from Contact WHERE accountid = :Ids
                AND ContactType__c <> 'INACTIVE CONTACT'
                ORDER BY Name ASC
               ]; 
    } 
    
    @AuraEnabled
    public static List<Aircraft__c> getACSum(string Ids) {
        return [select name, System_Aircraft_Name__c,Aircraft_Tracking_Program__c,Maintenance_Program__c, Airport_Code__c,
                Aircraft_Model_2011__c,ACReg__c,AircraftDeliveryDate__c,Aircraft_Status__c,ACHRS__c,ACHRSDate__c,Average_Monthly_Hours__c
                from Aircraft__c WHERE account__c =: Ids
                AND Aircraft_Status__c <> 'Permanent Out of Service'
                ORDER BY Name ASC
               ]; 
    }
    
    @AuraEnabled
    public static List<MST_Dispatch__c> getMST(string Ids) {
        return [select Aircraft__r.Name, AC_Reg__c, Name, Trip_Type__c, Dispatch_Description__c, Start_Date__c, 
                End_Date__c, Contact__r.Name
                from MST_Dispatch__c WHERE account__c =: Ids 
                ORDER BY Name ASC
               ]; 
    }
    
    @AuraEnabled
    public static List<Case> getCases(string Ids) {
        return [select CaseNumber, Description, Case_Contact__c, Aircraft__r.Name, Contact.Name, Status, CreatedDate
                from Case WHERE AccountId =: Ids 
                ORDER BY CaseNumber ASC
               ]; 
    }
    
    @AuraEnabled
    public static List<Aircraft__c> getManagedAC(string Ids) {
        return [select name, System_Aircraft_Name__c,Aircraft_Tracking_Program__c,Maintenance_Program__c, Airport_Code__c, Aircraft_Model_2011__c,ACReg__c,AircraftDeliveryDate__c,Aircraft_Status__c,ACHRS__c,ACHRSDate__c,Average_Monthly_Hours__c
                from Aircraft__c WHERE Management_Company__c =: Ids
                AND Aircraft_Status__c <> 'Permanent Out of Service'
                ORDER BY Name ASC
               ]; 
    }
    
    @AuraEnabled
    public static List<Equipment__c> getManagedACEquipSum(string Ids) {
        return [select name,
                Aircraft_System_Name__c,
                Interval_Confirmed__c,
                MaintenancePrgmType__c,
                Model__c,
                Aircraft__c,
                Average_Monthly_Hours__c,
                LastHours__c,
                LastHoursDate__c,
                LastMPI__c,
                MPIDate__c,
                MPIInterval__c,
                Next_MPI_Date__c,
                LASTCZI__c,
                CZIDate__c,
                CZIINTVL__c,
                Next_CZI_Date__c,
                HSI_Interval__c,
                Last_HSI__c,
                Last_HSI_Date__c,
                Next_HSI_Date_TSN__c,
                O_H_Interval__c,
                Last_O_H_Hours_TSN__c,
                Last_O_H_Date_TSN__c,
                Next_O_H_Date_TSN__c,
                Equipment_Prefix__c
                from Equipment__c WHERE Aircraft__r.Management_Company__c =: Ids
                ORDER BY Aircraft__c ASC ]; 
    }
    
    @AuraEnabled
    public static List<Equipment__c> getEquipSum(string Ids) {
        return [select name,
                Aircraft_System_Name__c,
                Interval_Confirmed__c,
                MaintenancePrgmType__c,
                Model__c,
                Aircraft__c,
                Average_Monthly_Hours__c,
                LastHours__c,
                LastHoursDate__c,
                LastMPI__c,
                MPIDate__c,
                MPIInterval__c,
                Next_MPI_Date__c,
                LASTCZI__c,
                CZIDate__c,
                CZIINTVL__c,
                Next_CZI_Date__c,
                HSI_Interval__c,
                Last_HSI__c,
                Last_HSI_Date__c,
                Next_HSI_Date_TSN__c,
                O_H_Interval__c,
                Last_O_H_Hours_TSN__c,
                Last_O_H_Date_TSN__c,
                Next_O_H_Date_TSN__c,
                Equipment_Prefix__c
                from Equipment__c WHERE Account__c =: Ids
                ORDER BY Aircraft__c ASC ]; 
    }
    
    @AuraEnabled
    public static List<Opportunity> getOpptySum(string Ids) {
        Date onlyDate = Date.today();
        
        return [select name,closedate, inputdate__c,stagename,Aircraft_AC_Reg__c,isclosed,subtype__c,amount
                from Opportunity WHERE AccountId =: Ids 
                AND isclosed <> true
                AND inputdate__c < :onlyDate.addDays(+731)
                ORDER BY inputdate__c ASC 
               ]; 
    }
    
    @AuraEnabled
    public static List<Opportunity> getManagedOpptySum(string Ids) {
        Date onlyDate = Date.today();
        
        return [select name,closedate,inputdate__c,stagename,Aircraft_AC_Reg__c,isclosed,subtype__c,amount
                from Opportunity WHERE Aircraft__r.Management_Company__c =: Ids 
                AND isclosed <> true
                AND inputdate__c <: onlyDate.addDays(+731)
                ORDER BY inputdate__c ASC 
               ]; 
    }   
    
}