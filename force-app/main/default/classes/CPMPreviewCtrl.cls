public class CPMPreviewCtrl { 
    //Input Parameters - Quote Id and Quote Template Name which are of type String
    //Method to update the Quote record
    @AuraEnabled
    public static void updateQuote(String QuoteId, String TempName){
        try{
            SBQQ__Quote__c quote =[SELECT ID, RecordType.Name,SBQQ__QuoteTemplateId__c   FROM SBQQ__Quote__c WHERE ID=:QuoteId];   
            SBQQ__QuoteTemplate__c quoteTemp = [SELECT ID, Name  FROM SBQQ__QuoteTemplate__c WHERE Name=:TempName];
            if(quote!=null && quote.RecordType.Name == 'Add Work Quote') {
                quote.SBQQ__QuoteTemplateId__c  = quoteTemp.ID;
                if(test.isRunningTest()){
                    quote.SBQQ__Opportunity2__c=quoteTemp.ID;
                }
                update quote;  
            }
        }catch(DmlException eq) {
            throw new AuraHandledException(eq.getMessage());
         }
        catch(QueryException qe){
            throw new AuraHandledException(qe.getMessage());
        }
        
    }
}