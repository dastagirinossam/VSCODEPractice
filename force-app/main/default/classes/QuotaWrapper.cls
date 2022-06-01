public class QuotaWrapper {
    
    public QuotaWrapper(){    
        perf = new List<Performance__c>();
        perf2 = new List<Performance__c>();
        emp = new List<Quota_Sales_Employee__c>();
        
    }
  
    @AuraEnabled public Id PerformanceId;
    @AuraEnabled public String region;
    @AuraEnabled public List<Performance__c> perf;
    @AuraEnabled public List<Performance__c> perf2;
    @AuraEnabled public List<Quota_Sales_Employee__c> emp;
        
}