public class ProCom {
    @AuraEnabled
    public static List<SBQQ__QuoteLine__c> getSqk() {
        return [Select id, Name, Labor_Code__c, Labor_Amount__c, Project__r.Name, Job_Card__c, Material_Amount__c, Job_Card_Description__c from SBQQ__QuoteLine__c where Add_Work_Status__c = 'Pending' Order BY Job_Card__c asc];
        /*and Designated_Approver__c =: UserInfo.getUserId() */
    }

    @AuraEnabled
    public static list<MPM4_BASE__Milestone1_Project__c> getActiveProjects(){
        return [SELECT Id, Name, CPM__c, CPM__r.Name, MPM4_BASE__Deadline__c FROM MPM4_BASE__Milestone1_Project__c where MPM4_BASE__Status__c = 'Active'];
    }
    
    @AuraEnabled
    public static list<MPM4_BASE__Milestone1_Project__c> getOldProjects(){
        return [SELECT Id, Name, CPM__c, CPM__r.Name, MPM4_BASE__Deadline__c FROM MPM4_BASE__Milestone1_Project__c where MPM4_BASE__Status__c = 'Completed'];
    }
            
    @AuraEnabled
    public static List <SBQQ__QuoteLine__c> getProjectRecords(List <Id> lstRecordId) {   
        return [Select id, Name, Labor_Code__c, Labor_Amount__c, Project__r.Name, Job_Card__c, Material_Amount__c, Job_Card_Description__c from SBQQ__QuoteLine__c where Add_Work_Status__c = 'Pending' and project__c in: lstRecordId];   
    }
      
    @AuraEnabled
    public static List < MPM4_BASE__Milestone1_Project__c > findProjects(String searchKeyWord) {
        String searchKey = '%' + searchKeyWord + '%';
        List < MPM4_BASE__Milestone1_Project__c > returnList = new List < MPM4_BASE__Milestone1_Project__c > ();
        List < MPM4_BASE__Milestone1_Project__c > lstOfProjects = [Select id, Name, CPM__C, CPM__r.Name, MPM4_BASE__Description__c from MPM4_BASE__Milestone1_Project__c where MPM4_BASE__Status__c = 'Completed' and Name LIKE: searchKey];
 
        for (MPM4_BASE__Milestone1_Project__c sqk: lstOfProjects) {
            returnList.add(sqk);
        }
        return returnList;
    } 
    
    @AuraEnabled
    public static List<AggregateResult> getCount() {
        return [SELECT project__r.id projId, project__r.name projName, project__r.MPM4_BASE__Deadline__c projDate, project__r.CPM__r.Name projCPM, project__r.CPM__c projCPMiD, Count(id) total FROM SBQQ__QuoteLine__c where (project__r.MPM4_BASE__Status__c = 'Active' or project__r.MPM4_BASE__Status__c = 'On Hold' or project__r.MPM4_BASE__Status__c = 'Completed') and Add_Work_Status__c = 'Pending' Group By project__r.name,project__r.id,project__r.MPM4_BASE__Deadline__c,project__r.CPM__c, Project__r.CPM__r.Name];
    }
    
    @AuraEnabled
    public static List < SBQQ__QuoteLine__c > findSquawks(String searchKeyWord) {
        String searchKey = '%' + searchKeyWord + '%';
        List < SBQQ__QuoteLine__c > returnList = new List < SBQQ__QuoteLine__c > ();
        List < SBQQ__QuoteLine__c > lstOfSquawks = [Select id, Name, SBQQ__Quote__c, SBQQ__Quote__r.Name, Designated_Approver__c, Designated_Approver__r.Name, 	Add_Work_Labor_Type__c, Project__r.Name, Job_Card_Description__c, Job_Card__c, Labor_Amount__c, Material_Type__c, AddWork_Estimated_Total__c, Job_Card_Description_Section__c, Material_Amount__c, IsFirmPriceMaterial__c, IsFirmPriceLabour__c, IsRTS__c, Add_Work_Status__c, Job_Card_Description_Section_1__c from SBQQ__QuoteLine__c where Add_Work_Status__c != null and SBQQ__ProductCode__c!= 'UnscheduledBundle' and (Job_Card_Search_1__c LIKE: searchKey or Job_Card_Search_2__c LIKE: searchKey)];
 
        for (SBQQ__QuoteLine__c sqk: lstOfSquawks) {
            returnList.add(sqk);
        }
        return returnList;
    } 
    
}