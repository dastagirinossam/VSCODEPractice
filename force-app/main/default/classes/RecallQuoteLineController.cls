public with Sharing Class RecallQuoteLineController{

    private final SBQQ__QuoteLine__c p;
    public RecallQuoteLineController(ApexPages.StandardController stdController) {
        this.p = (SBQQ__QuoteLine__c)stdController.getRecord();
    }
    
    public PageReference autoRun() {
    
        String quoteLineId = ApexPages.currentPage().getParameters().get('id');                 
        List<ProcessInstanceWorkitem> piwoID = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: quoteLineId Limit 1];
        
        if(piwoId.Size() > 0){                                     
            PageReference pageRef = new PageReference('/' + piwoId[0].Id + '/e?et=REMOVE&retURL=%2F' + quoteLineId);
            pageRef.setRedirect(true);
            return pageRef;
        }else{
            PageReference pageRef = new PageReference('/' + quoteLineId);
            return pageRef;           
        }       
    }     
}