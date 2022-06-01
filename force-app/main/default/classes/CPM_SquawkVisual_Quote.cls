public class CPM_SquawkVisual_Quote {

    private final SBQQ__Quote__c quote;
    
    public CPM_SquawkVisual_Quote(ApexPages.StandardController stdController){
        this.quote = (SBQQ__Quote__c)stdController.getRecord();
    }
    
    public List<SBQQ__QuoteLine__c> getQuoteLines(){
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT Id, Name, Add_Work_Status__c, fxJob_Card__c, Non_Routine__c, Job_Card__c, Job_Card_Description__c, Designated_Approver__c, Add_Work_Labor_Type__c, Labor_Amount__c, Material_Amount__c, Material_Type__c, IsRTS__c FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =: quote.Id and SBQQ__Product__r.Name like '%Product'];
        return quoteLines;
    }
}