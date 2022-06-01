public without sharing class QuotaPerformanceController {
  
    @AuraEnabled
    public static PerformanceWrapper QuotaPerformance()
    {
        Performance__c px =[select id,Name,Role__c,Year__c,Quarter__c,region__c from Performance__c where Quota_Sales_Employee__r.User__c=:UserInfo.getUserId()  limit 1 ];
        PerformanceWrapper n = new PerformanceWrapper();
        n.PerformanceId = px.id ;
        n.region = px.region__c;
        return n;      
    } 
    
    @AuraEnabled
    public static EmployeeWrapper QuotaEmployee()
    {
        Quota_Sales_Employee__c ex =[select id,leader__c from  Quota_Sales_Employee__c where User__c=:UserInfo.getUserId()  limit 1 ];
        EmployeeWrapper ewrap = new EmployeeWrapper();
        ewrap.EmployeeId = ex.id;
        ewrap.leader= ex.leader__c;
        return ewrap;
    }
    
    public class PerformanceWrapper
    {   
        @AuraEnabled public Id PerformanceId{get;set;}
        @AuraEnabled public String region{get;set;}
      
    }
    public class EmployeeWrapper
    {
        @AuraEnabled public Id EmployeeId{get;set;}
        @AuraEnabled public String leader{get;set;}
    }
}