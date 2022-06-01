public class cpqTemplateBottomHandler {
    
    private final Id quoteId;
    Public SBQQ__Quote__c quote {get;set;}
    public cpqTemplateBottomHandler(){
        quoteId = (Id)ApexPages.currentPage().getParameters().get('qid');
         SBQQ__Quote__c quote = [SELECT Id, SBQQ__BillingName__c, Add_3rd_Party_Signature__c, X3rd_Party_Signature_Line_Option__c FROM SBQQ__Quote__c WHERE Id =: quoteId];
       
        System.debug('Quote: ' + quoteId);
    }
    
  /*  public SBQQ__Quote__c getQuote(){
        SBQQ__Quote__c quote = [SELECT Id, SBQQ__BillingName__c, Add_3rd_Party_Signature__c, X3rd_Party_Signature_Line_Option__c FROM SBQQ__Quote__c WHERE Id =: quoteId];
        system.debug('Quote: ' + quote);
        return quote;
    } */
       
}