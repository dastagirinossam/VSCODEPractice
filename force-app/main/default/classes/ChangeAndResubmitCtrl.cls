public class ChangeAndResubmitCtrl {
    
    @AuraEnabled
    public static Quotelinewrapper getQuoteLine (String quoteId){
        system.debug('===5====='+quoteId);
        SBQQ__QuoteLine__c quoteLine = [SELECT ID, Add_Work_Status__c FROM SBQQ__QuoteLine__c WHERE ID=:quoteId];
        system.debug('========'+quoteLine);
         Quotelinewrapper wrap = new Quotelinewrapper();
         wrap.lineRec = quoteLine;
         return wrap;   
    }
    public class Quotelinewrapper{
    @AuraEnabled public SBQQ__QuoteLine__c lineRec;   
    }
}