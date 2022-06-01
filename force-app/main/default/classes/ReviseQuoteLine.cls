public class ReviseQuoteLine {
    
    private final SBQQ__QuoteLine__c currentQuoteLine;
    public string comments{get;set;}    
    
    public string getComments(){
        return comments;
    }
    
    public ReviseQuoteLine(ApexPages.StandardController controller) {
        this.currentQuoteLine = (SBQQ__QuoteLine__c)controller.getRecord();        
    } 
    
    public PageReference saveRevision() {
        PageReference ref = new PageReference('/apex/Squawk?id=' + currentQuoteLine.Id);
        
        Approval.Unlock(currentQuoteLine.Id, false);
        Update currentQuoteLine;
        
        ref.setRedirect(true);
        return ref;
    }
    
    public PageReference ChangeResubmit() {       
        PageReference ref = new PageReference('/apex/Squawk?id=' + currentQuoteLine.Id);
        
        Approval.Unlock(currentQuoteLine.Id, false);
        currentQuoteLine.Approved__c = false;
        currentQuoteLine.Submit_For_Approval__c = false;
        currentQuoteLine.Add_Work_Status__c = null;
        Update currentQuoteLine;
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(currentQuoteLine.Id);
        req.setSubmitterId(userinfo.getUserId());  
        
        Approval.ProcessResult processResult = Approval.process(req,false);                       
        Approval.Unlock(currentQuoteLine.Id, false);
        
        ChangeResubmitEmail(currentQuoteLine.Id);
        
        ref.setRedirect(true);
        return ref;
    }
    
    public Static void ChangeResubmitEmail(Id qlId){
        SBQQ__QuoteLine__c qlProj = [Select Id, Project__c, Designated_Approver__c, CPM__c from SBQQ__QuoteLine__c where Id =: qlId];
        EmailTemplate lstEmailTemplates = [SELECT Id, Body, Subject from EmailTemplate where DeveloperName = 'New_Squawks_Notification'];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(lstEmailTemplates.Id);
        mail.setSaveAsActivity(false);
        mail.setTargetObjectId(UserInfo.getUserId());// Any contact or User id of your record
        mail.setToAddresses(new list<string>{qlProj.CPM__c, qlProj.Designated_Approver__c});
        
        Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
    public PageReference CancelRecall(){
        PageReference ref = new PageReference('/apex/Squawk?id=' + currentQuoteLine.Id);
        ref.setRedirect(true);
        return ref;
    }
    
    public PageReference RecallApproval() {    
        List<ProcessInstanceWorkItem> p = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: currentQuoteLine.Id];
        
        String recallComment = this.comments;      
        PageReference ref = new PageReference('/' + currentQuoteLine.Id);
        
        system.debug('comments:' + this.comments);
        
        if(!p.IsEmpty()){
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setComments(recallComment);
            req.setAction('Removed');        
            req.setWorkitemId(p[0].Id);
            
            Approval.process(req, false);   
            Approval.Unlock(currentQuoteLine.Id, false); 
        }
        
        ref.setRedirect(true);
        return ref;
    }
    
    public PageReference RecallApprovalRequest() {
        ProcessInstanceWorkItem p;
        try{
            p = [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId =: currentQuoteLine.Id limit 1];
        }
        
        catch (QueryException qe)
        {
            PageReference ref;
            ref = new PageReference('/' + currentQuoteLine.Id);
            ref.setRedirect(true);
            return ref;
        }
        
        String recallComment;
        PageReference ref;
        System.debug (p);
        if(p!=null){
            recallComment = Apexpages.currentPage().getParameters().get('comments');       
            ref = new PageReference('/apex/RecallApprovalRequest?id=' + currentQuoteLine.Id);
        }
        ref.setRedirect(true);
        return ref;
    }
}