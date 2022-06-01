public class SubmitForApproval {

    Private final SBQQ__QuoteLine__c ql;
    
    Public SubmitForApproval(ApexPages.standardController stdController) {
        this.ql = (SBQQ__QuoteLine__c)stdController.getRecord();
    }
        
    Public PageReference getNextPage(){     
        PageReference p = new PageReference('/Customer/s/quoteline/' + ql.id );
        p.setRedirect(true);
        system.debug('url: ' + p);
        return p;
        
    }
}