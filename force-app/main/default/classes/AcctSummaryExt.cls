public class AcctSummaryExt {
    private final account acct;
    
    public AcctSummaryExt (ApexPages.standardcontroller Account) {
        this.acct = (Account)Account.getRecord();
    }
    
    public String getAcctId() {
        
        return acct.id;
    }
    
    public List<Contact> getContactSum() {
        return [select name,title,ContactType__c,phone,hangarphone__c,mobilephone,email
                from Contact WHERE accountid = :ApexPages.currentPage().getParameters().get('id').substring(0,15)
                AND ContactType__c <> 'INACTIVE CONTACT'
                ORDER BY Name ASC
               ]; 
    }       
    
    public List<Aircraft__c> getACSum() {
        return [select name, System_Aircraft_Name__c,Aircraft_Tracking_Program__c,Maintenance_Program__c, Airport_Code__c,Aircraft_Model_2011__c,ACReg__c,AircraftDeliveryDate__c,Aircraft_Status__c,ACHRS__c,ACHRSDate__c,Average_Monthly_Hours__c
                from Aircraft__c WHERE account__c =: ApexPages.currentPage().getParameters().get('id').substring(0,15)
                AND Aircraft_Status__c <> 'Permanent Out of Service'
                ORDER BY Name ASC
               ]; 
    }
    
	public List<MST_Dispatch__c> getMST() {
        return [select Aircraft__r.Name, AC_Reg__c, Name, Trip_Type__c, Dispatch_Description__c, Start_Date__c, End_Date__c, Contact__r.Name
                from MST_Dispatch__c WHERE account__c =: ApexPages.currentPage().getParameters().get('id').substring(0,15) 
                ORDER BY Name ASC
               ]; 
    }
    
	public List<Case> getCases() {
        return [select CaseNumber, Description, Case_Contact__c, Aircraft__r.Name, Contact.Name, Status, CreatedDate
                from Case WHERE AccountId =: ApexPages.currentPage().getParameters().get('id').substring(0,15) 
                ORDER BY CaseNumber ASC
               ]; 
    }
    
	public List<Aircraft__c> getManagedAC() {
        return [select name, System_Aircraft_Name__c,Aircraft_Tracking_Program__c,Maintenance_Program__c, Airport_Code__c, Aircraft_Model_2011__c,ACReg__c,AircraftDeliveryDate__c,Aircraft_Status__c,ACHRS__c,ACHRSDate__c,Average_Monthly_Hours__c
                from Aircraft__c WHERE Management_Company__c =: ApexPages.currentPage().getParameters().get('id').substring(0,15) 
                AND Aircraft_Status__c <> 'Permanent Out of Service'
                ORDER BY Name ASC
               ]; 
    }
    
	public List<Equipment__c> getManagedACEquipSum() {
        return [select name,
                Aircraft_System_Name__c,
                Interval_Confirmed__c,
                MaintenancePrgmType__c,
                AircraftEngineorAPUMode__c,
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
                Next_O_H_Date_TSN__c
                from Equipment__c WHERE Aircraft__r.Management_Company__c =: ApexPages.currentPage().getParameters().get('id').substring(0,15) 
                ORDER BY Aircraft__c ASC ]; 
    }
    
    public List<Equipment__c> getEquipSum() {
        return [select name,
                Aircraft_System_Name__c,
                Interval_Confirmed__c,
                MaintenancePrgmType__c,
                AircraftEngineorAPUMode__c,
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
                Next_O_H_Date_TSN__c
                from Equipment__c WHERE account_id__c =: ApexPages.currentPage().getParameters().get('id').substring(0,15) 
                ORDER BY Aircraft__c ASC ]; 
    }
    
    public List<Opportunity> getOpptySum() {
        Date onlyDate = Date.today();
        
        return [select name,closedate,account_id__c,inputdate__c,stagename,Aircraft_AC_Reg__c,isclosed,subtype__c,amount
                from Opportunity WHERE account_id__c =: ApexPages.currentPage().getParameters().get('id').substring(0,15) 
                AND isclosed <> true
                AND inputdate__c < :onlyDate.addDays(+731)
                ORDER BY inputdate__c ASC 
               ]; 
    }    
    
    public List<Opportunity> getManagedOpptySum() {
        Date onlyDate = Date.today();
        
        return [select name,closedate,inputdate__c,stagename,Aircraft_AC_Reg__c,isclosed,subtype__c,amount
                from Opportunity WHERE Aircraft__r.Management_Company__c =: ApexPages.currentPage().getParameters().get('id').substring(0,15) 
                AND isclosed <> true
                AND inputdate__c <: onlyDate.addDays(+731)
                ORDER BY inputdate__c ASC 
               ]; 
    }   
}