public class CPM_SubmitSquawksForApproval{
    
    public List<SquawkWrapper> squawks {get;set;}
    public Set<Id> da {get;set;}
    
    public static User u = [Select Id, Name, Title, Phone, Email from User where Id =: userinfo.getUserId()];
    public static EmailTemplate template = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName =: 'New_Squawks_Notification'];
    public static OrgWideEmailAddress owa = [select Id from OrgWideEmailAddress where Address = 'customercommunity@standardaero.com']; 
    public static Product2 prod = [Select Id from Product2 where Name =: 'Unscheduled Product'];
    
    private List<SBQQ__QuoteLine__c> qls; 
    private MPM4_BASE__Milestone1_Project__c proj;
    
    public class SquawkWrapper {
        public SBQQ__QuoteLine__c squawk {get;set;}        
        public Boolean sendSquawk {get;set;}
        
        public SquawkWrapper() {
            this.sendSquawk = false;
        }
        
        public SquawkWrapper(SBQQ__QuoteLine__c squawk) {
            this.squawk = squawk;
        }
    }
    
    public CPM_SubmitSquawksForApproval(ApexPages.StandardController controller) {
        
        MPM4_BASE__Milestone1_Project__c project = (MPM4_BASE__Milestone1_Project__c)controller.getRecord();
        this.proj = [select id, Designated_Approver__c, Secondary_Approver__c, X3_Approver__c, X4_Approver__c, X5_Approver__c, X6_Approver__c from MPM4_BASE__Milestone1_Project__c where id = :project.id];
        
        da = new Set<Id>();
        
        if(this.proj.Designated_Approver__c != null)
        	da.add(this.proj.Designated_Approver__c);
        
        if(this.proj.Secondary_Approver__c != null)
        	da.add(this.proj.Secondary_Approver__c);

        if(this.proj.X3_Approver__c != null)
        	da.add(this.proj.X3_Approver__c);
        
        if(this.proj.X4_Approver__c != null)
        	da.add(this.proj.X4_Approver__c);
        
        if(this.proj.X5_Approver__c != null)
        	da.add(this.proj.X5_Approver__c);
        
        if(this.proj.X6_Approver__c != null)
        	da.add(this.proj.X6_Approver__c);        
                      
        squawks = new List<SquawkWrapper>();        
        
        for(SBQQ__QuoteLine__c squawk : [Select id, SBQQ__Quote__c, Name, Project__c, fxItemNo__c, Job_Card__c, Job_Card_Description__c, Material_Amount__c, Material_Type__c, Labor_Amount__c, Add_Work_Labor_Type__c, IsRTS__c, Add_Work_Status__c from SBQQ__QuoteLine__c where Project__c  = : proj.id and SBQQ__Product__c =: prod.Id And Add_Work_Status__c = NULL]){
            squawks.add(new SquawkWrapper(squawk));            
        }        
        
        if(squawks.isEmpty())
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'There Are Currently No Squawks To Submit For Approval'));
    }
    
    public pagereference submitForApproval(){
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
        Set<Id> project = new Set<Id>();
        Set<Id> quote = new set<Id>();
        Set<Id> daIds = new Set<Id>(this.da);

        for(SquawkWrapper ql : this.squawks){
            if(ql.sendSquawk){                                  
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(ql.squawk.Id);
                req.setSubmitterId(UserInfo.getUserId());
                quoteLines.add(ql.squawk);
                project.add(ql.squawk.Project__c);
                quote.add(ql.squawk.SBQQ__Quote__c);
                requests.add(req);            
            }           
        }
        
        if(!quoteLines.IsEmpty()){
            try{
                //Change Status On Project
                ChangeProjectStatus(project);
                
                //Change Status On Quote
                QuoteStatus(quote);
                
                //Submit For Approval
                Approval.ProcessResult[] processResult = Approval.process(requests, true);
                Approval.UnlockResult[] qlList = Approval.unlock(quoteLines, true);
                
                //Send Email
                SendNotification(daIds);
            }catch(Exception e){
                system.debug('Submit for Approval Error: ' + e.getMessage()); 
            }
        }
        
        return null;
    }
    
    //Change Project Status To Active; Ensures customer sees squawks when submitted
    public static void ChangeProjectStatus(Set<Id> project){
        MPM4_BASE__Milestone1_Project__c p = [Select Id, MPM4_BASE__Status__c from MPM4_BASE__Milestone1_Project__c where Id In: project];
               
        if(p.MPM4_BASE__Status__c != 'Active'){
            p.MPM4_BASE__Status__c = 'Active';
            update p;
        }
    }
    
    //Change Quotes Status To Presented; Ensures customer sees squawks when submitted
    public static void QuoteStatus(Set<Id> quote){
        List<SBQQ__Quote__c> qte = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c q : [Select Id, SBQQ__Status__c from SBQQ__quote__C where Id in: quote]){
            q.SBQQ__Status__c = 'Presented';
            qte.add(q);
        }
        
        if(!qte.isEmpty())
            update qte;
    }
    
    public static void SendNotification(Set<Id> daIds){
        Map<String, String> approversMap = new Map<String, String>();               
        for(User u : [Select FirstName, LastName, Email from User where Id In: daIds]){
            approversMap.put(u.FirstName + ' ' + u.LastName, u.Email);
        }
        
        if(!approversMap.IsEmpty()){
            for(String a : approversMap.keySet()){
                
                String emails = approversMap.get(a) + ',' + userinfo.getUserEmail();                  
                String body = template.Body;
                String subject = template.Subject;
                List<String> emailDistribution = emails.split(',');
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                body = body.replace('{!MPM4_BASE__Milestone1_Project__c.Designated_Approver__c}', a);
                body = body.replace('{!User.Name}', u.Name);
                body = body.replace('{!User.Title}', u.Title);
                body = body.replace('{!User.Phone}', u.Phone);
                body = body.replace('{!User.Email}', u.Email);
                
                mail.setplaintextbody(body);
                mail.setSubject(subject);
                mail.setToAddresses(emailDistribution); 
                mail.setOrgWideEmailAddressId(owa.Id);
                mail.optOutPolicy = 'FILTER';
                
                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            }
        }
        
        return;     
    }
}