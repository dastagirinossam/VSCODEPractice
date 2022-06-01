public with sharing class QuoteValidationController {

    private ApexPages.StandardController standardController;
    
    public QuoteValidationController(ApexPages.StandardController standardController){
        // Configure fields to query and valid (alternative to SOQL)
        this.standardController = standardController;

        this.standardController.addFields(
            new List<String> { Schema.SBQQ__Quote__c.SBQQ__Status__c.getDescribe().getName() });
        system.debug('Validation: ' + Schema.SBQQ__Quote__c.SBQQ__Status__c.getDescribe().getName());

        SBQQ__Quote__c quote = (SBQQ__Quote__c) standardController.getRecord();
        system.debug('Quote Status: ' + quote.SBQQ__Status__c);
        if(quote.SBQQ__Status__c != 'Presented')
            quote.SBQQ__Status__c.addError('Not the answer to life the universe and everything!');
        
    }
        
}