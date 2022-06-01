public class SB_PrepopulateQuoteFieldsController{
    public SBQQ__Quote__c quote;
    public Opportunity oppty;
    public string Quote_AccountId;
    public string Quote_OpportunityId;
    public string Quote_Facility;
    public string Quote_Aircraft;
    public string Quote_RecordTypeId;
    
    public SB_PrepopulateQuoteFieldsController(ApexPages.StandardsetController con){
        string opptyId = ApexPages.currentPage().getParameters().get('id');
        
        if(opptyId != null){
            oppty = [select id,name, Aircraft__c, Aircraft__r.name, Facility__c, AccountId, Account.Name, Master_Opportunity__c from Opportunity where id = :opptyId];
        
            QuoteFieldsMetadata__c settingsData = QuoteFieldsMetadata__c.getValues('SBQQ__Account__c');
            Quote_AccountId = settingsData.Field_ID__c;
            settingsData = QuoteFieldsMetadata__c.getValues('SBQQ__Opportunity2__c');
            Quote_OpportunityId = settingsData.Field_ID__c;
            settingsData = QuoteFieldsMetadata__c.getValues('Facility1__c');
            Quote_Facility = settingsData.Field_ID__c;
            settingsData = QuoteFieldsMetadata__c.getValues('Aircraft__c');
            Quote_Aircraft = settingsData.Field_ID__c;
            
            if(oppty.Master_Opportunity__c){
                Quote_RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Master Proposal').getRecordTypeId();
            }else{
                Quote_RecordTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Standard Proposal').getRecordTypeId();
            }
        }
    }
    public PageReference populateFields(){
         Schema.DescribeSObjectResult Q = SBQQ__Quote__c.SObjectType.getDescribe();                           
         return new PageReference('/' + Q.getKeyPrefix() + '/e?' + Quote_Facility + '=' + oppty.Facility__c 
                                 + '&CF' + Quote_Aircraft + '_lkid=' + oppty.Aircraft__c + '&CF' + Quote_Aircraft + '=' + EncodingUtil.URLENCODE(oppty.Aircraft__r.name, 'UTF-8')
                                 + '&CF' + Quote_AccountId +'_lkid=' + oppty.AccountId + '&CF' + Quote_AccountId + '=' + EncodingUtil.URLENCODE(oppty.Account.Name, 'UTF-8')
                                 + '&CF' + Quote_OpportunityId + '_lkid=' + oppty.id + '&CF' + Quote_OpportunityId + '=' + oppty.name
                                 + '&retURL=%2F' + oppty.Id + '&RecordType=' + Quote_RecordTypeId);
    } 
}