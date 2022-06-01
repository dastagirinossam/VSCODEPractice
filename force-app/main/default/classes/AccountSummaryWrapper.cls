public class AccountSummaryWrapper {
    @AuraEnabled
    public Account acc;
       @AuraEnabled
    public List<Contact> getContactSum;
       @AuraEnabled
    public  List<Aircraft__c> getACSum;
       @AuraEnabled
    public List<MST_Dispatch__c> getMST;
       @AuraEnabled
    public List<Case> getCases;
       @AuraEnabled
    public List<Aircraft__c> getManagedAC;
       @AuraEnabled
    public List<Equipment__c> getManagedACEquipSum;
       @AuraEnabled
    public List<Equipment__c> getEquipSum;
       @AuraEnabled
    public List<Opportunity> getOpptySum;
       @AuraEnabled
    public List<Opportunity> getManagedOpptySum;
}