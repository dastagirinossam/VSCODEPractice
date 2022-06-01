public class SB_OpportunityLineItemTriggerHandler {
    
    public static void updateDiscount(List<OpportunityLineItem> oppLineItemList){
        
        Map<Id,OpportunityLineItem> quoteLinesOliMap = new Map<Id,OpportunityLineItem>();
        for(OpportunityLineItem oli : oppLineItemList){
            system.debug('--line item in insert is --'+oli.SBQQ__QuoteLine__c);
            if(oli.SBQQ__QuoteLine__c != null){
                quoteLinesOliMap.put(oli.SBQQ__QuoteLine__c,oli);
            }
        }
        if(!quoteLinesOliMap.isEmpty()){
            checkandUpdate(quoteLinesOliMap);
        }
        
    }
    
    public static void checkandUpdate( Map<Id,OpportunityLineItem> quoteLinesOliMap ){
        
        Map<Id, SBQQ__QuoteLine__c> quoteLineMap = new Map<Id, SBQQ__QuoteLine__c>([Select Id, ExcludeFromExecutiveSummary__c
                                                                               From SBQQ__QuoteLine__c
                                                                               where id in :quoteLinesOliMap.keySet()]);
        
        if(quoteLineMap.isEmpty()){
            return;
        }
        for(OpportunityLineItem oli : quoteLinesOliMap.values()){
            if(quoteLineMap.get(oli.SBQQ__QuoteLine__c) != null && 
               quoteLineMap.get(oli.SBQQ__QuoteLine__c).ExcludeFromExecutiveSummary__c){
                   oli.Discount=100;
                   oli.Description = 'It is excluded product on quote';
               }else{
                   oli.Discount =0;
                   oli.Description = null;
               }
        }
    
    }
    
    
    public static void updateDiscountUpdate(List<OpportunityLineItem> oppLineItemList){
         Map<Id,OpportunityLineItem> quoteLinesOliMap = new Map<Id,OpportunityLineItem>();
        for(OpportunityLineItem oli : oppLineItemList){
            system.debug('--line item in insert is updateDiscountUpdate--'+oli.SBQQ__QuoteLine__c);
            if(oli.SBQQ__QuoteLine__c != null){
                quoteLinesOliMap.put(oli.SBQQ__QuoteLine__c,oli);
            }
        }
        if(!quoteLinesOliMap.isEmpty()){
            checkandUpdate(quoteLinesOliMap);
        }
    }

}