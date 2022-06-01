public class CPM_SquawkManagement {
    
    public List<SquawkWrapper> squawks {get;set;}
    private List<SBQQ__QuoteLine__c> qls; 
    private MPM4_BASE__Milestone1_Project__c proj; 
    
    public class SquawkWrapper {
        public SBQQ__QuoteLine__c squawk {get;set;}        
        public Boolean pendingSquawk {get;set;}
        
        public SquawkWrapper() {
            this.pendingSquawk = false;
        }
        
        public SquawkWrapper(SBQQ__QuoteLine__c squawk) {
            this();
            this.squawk = squawk;
        }
    }
    
    public CPM_SquawkManagement(ApexPages.StandardController controller) {
        this.proj = (MPM4_BASE__Milestone1_Project__c)controller.getRecord();
        
        squawks = new List<SquawkWrapper>();
        
        Product2 prod = [Select Id from Product2 where Name =: 'Unscheduled Product'];        
        List<SBQQ__QuoteLine__c> quoteLines = [Select id, Name, Designated_Approver__c, Job_Card__c, Job_Card_Description__c, Material_Amount__c, Material_Type__c, Labor_Amount__c, Add_Work_Labor_Type__c, IsRTS__c from SBQQ__QuoteLine__c where Project__c  = : proj.id and SBQQ__Product__c =: prod.Id and Add_Work_Status__c = 'Pending'];
        
        if(quoteLines.isEmpty()){
            ApexPages.addmessage(
                new ApexPages.message(
                    ApexPages.severity.INFO,'There Are Currently No Squawks Pending Approval'));
        }else{ 
            For(SBQQ__QuoteLine__c squawk : quoteLines){
                squawks.add(new SquawkWrapper(squawk));
            }
        }
    }
    
    public PageReference ApproveSquawks(){
        
        String dte = DateTime.now().format();
        String statusChange = 'Approved';
        String color = 'Blue';
        
        Set<Id> pito = new Set<Id>();  
        Set<Id> desApprover = new Set<Id>();
        List<Id> squawkList = new List<Id>();
        List<String> response = new List<String>();
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        
        for(SquawkWrapper ql : this.squawks){
            if(ql.pendingSquawk){
                squawkList.add(ql.squawk.Id);
                if(!desApprover.contains(ql.squawk.Designated_Approver__c))
                    desApprover.add(ql.squawk.Designated_Approver__c);              
            }
        }
        
        for(ProcessInstanceWorkitem workItem : [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId In: squawkList and ActorId In: desApprover]){
            if(!pito.contains(workItem.ProcessInstance.TargetObjectId)){
                pito.add(workItem.ProcessInstance.TargetObjectId);
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setWorkitemId(workItem.Id);
                req.setAction('Approve');
                req.setComments('Approved by ' + UserInfo.getName() + ' On: ' + dte);
                requests.add(req);
            }
        }
        
        if(!requests.IsEmpty()){
            Approval.ProcessResult[] processResults = Approval.process(requests);
            QuoteLineEmail(squawkList, statusChange, color);
        }
        
        return null;
    }
    
    public pagereference RejectSquawks(){
        String dte = DateTime.now().format();
        String statusChange = 'Declined';
        String color = 'Red';
        
        Set<Id> pito = new Set<Id>();       
        Set<Id> desApprover = new Set<Id>();
        List<Id> squawkList = new List<Id>();
        List<String> response = new List<String>();
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        
        for(SquawkWrapper ql : this.squawks){
            if(ql.pendingSquawk){
                squawkList.add(ql.squawk.Id);
                if(!desApprover.contains(ql.squawk.Designated_Approver__c))
                    desApprover.add(ql.squawk.Designated_Approver__c);
            }
        }
        
        for(ProcessInstanceWorkitem workItem : [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId In: squawkList and ActorId In: desApprover]){
            if(!pito.contains(workItem.ProcessInstance.TargetObjectId)){
                pito.add(workItem.ProcessInstance.TargetObjectId);
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setWorkitemId(workItem.Id);
                req.setAction('Reject');
                req.setComments('Rejected by ' + UserInfo.getName() + ' On: ' + dte);
                requests.add(req);
            }
        }
        
        if(!requests.IsEmpty()){
            Approval.ProcessResult[] processResults = Approval.process(requests);
            QuoteLineEmail(squawkList, statusChange, color);
        }
        
        return null;
    }
       
    public pagereference RecallSquawks(){
        
        String dte = DateTime.now().format();
        String statusChange = 'Recalled';
        String color = 'Gray';
        
        Set<Id> pito= new Set<Id>();
        Set<Id> desApprover = new Set<Id>();       
        List<Id> squawkList = new List<Id>();
        List<SBQQ__QuoteLine__c> squawks = new List<SBQQ__QuoteLine__c>();
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        
        for(SquawkWrapper ql : this.squawks){
            if(ql.pendingSquawk){
                squawkList.add(ql.squawk.Id);
                if(!desApprover.contains(ql.squawk.Designated_Approver__c))
                    desApprover.add(ql.squawk.Designated_Approver__c);
            }
        }
        
        for(ProcessInstanceWorkitem workItem : [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId In: squawkList and ActorId In: desApprover]){
            if(!pito.contains(workItem.ProcessInstance.TargetObjectId)){
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                req.setWorkitemId(workItem.Id);
                req.setAction('Removed');
                req.setComments('Recalled by ' + UserInfo.getName() + ' On: ' + dte);
                requests.add(req);
            }            
        }
        
        if(!requests.IsEmpty()){
            Approval.ProcessResult[] processResults = Approval.process(requests, true);
            QuoteLineEmail(squawkList, statusChange, color);
        }
        
        if(!squawkList.IsEmpty()){          
            for(SBQQ__QuoteLine__c s : [Select Id, Add_Work_Status__c from SBQQ__QuoteLine__c where Id In: squawkList]){
                s.Add_Work_Status__c = null;
                squawks.add(s);    
            }
            update squawks;
        }
        
        return null;
    }
    
    public static void QuoteLineEmail(List<id> squawkList, String statusChange, String color){
        
        string htmlBody = '';
        Organization instance = [SELECT InstanceName FROM Organization];
        
        List<SBQQ__QuoteLine__c> quoteLines = [Select Id, Job_Card_Description__c, Name, Project__c, Project__r.Name, SBQQ__Quote__c, SBQQ__Quote__r.Name, SBQQ__Quote__r.Add_Work_Work_Order__c, Project__r.Email_Distribution__c, CPM__c, CPM__r.Name, Labor_Code__c, Labor_Amount__c, Add_Work_Labor_Type__c, Material_Amount__c, Material_Type__c from SBQQ__QuoteLine__c where Id In: squawkList];
        List<String> emailDistribution = quoteLines[0].Project__r.Email_Distribution__c.split(',');
        OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'customercommunity@standardaero.com']; 
        
        if(quoteLines != null || !quoteLines.isEmpty()){
            
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setToAddresses(emailDistribution); 
            message.setOrgWideEmailAddressId(owea.Id);
            message.optOutPolicy = 'FILTER';
            message.subject = Userinfo.getName() + ' ' + statusChange + ' ' + quoteLines.Size() + ' Squawks on Project: ' + quoteLines[0].Project__r.Name;
            message.HTMLBody = '<b>' + quoteLines[0].CPM__r.Name + ' :<b/>' + 
                '<br/><br/><b>' + Userinfo.getName() + ' has ' + statusChange + ' the following squawks on Project: </b>' +
                '<HTML><a href="https://' + instance.InstanceName + '.salesforce.com/' + quoteLines[0].Project__c + '">' + quoteLines[0].Project__r.Name + '</a></HTML>' +
                '<br/><br/>' +
                '<table border="1" style="border-collapse: collapse" cellpadding="10">'+
                '<thead><td colspan="9" style="background-color:' + color + '"><center><b>' + statusChange + '<b/></center></td></thead>'+
                '<tr><th>Name</th><th>Labor Code</th><th width="35%">Job Card Description</th><th>Labor Amount</th><th>Labor Type</th><th>Material Amount</th><th>Material Type</th><th>Quote</th><th>Work Order</th></tr>';
            for(SBQQ__QuoteLine__c ql : quoteLines){    
                
                String sqkJobCard = ql.Job_Card_Description__c; if(ql.Job_Card_Description__c == null){sqkJobCard = '[Not Provided]';}
                Decimal sqkLaborAmount = ql.Labor_Amount__c; if(ql.Labor_Amount__c == null){sqkLaborAmount = null;}
                String sqkLaborType = ql.Add_Work_Labor_Type__c; if(ql.Add_Work_Labor_Type__c == null){sqkLaborType = '[Not Provided]';}
                Decimal sqkMaterialAmount = ql.Material_Amount__c; if(ql.Material_Amount__c == null){sqkMaterialAmount = null;}
                String sqkMaterialType = ql.Material_Type__c; if(ql.Material_Type__c == null){sqkMaterialType = '[Not Provided]';}
                
                message.htmlBody += '<tr>' +
                    '<td><HTML><a href="https://' + instance.InstanceName + '.salesforce.com/' + ql.Id + '">' + ql.Name + '</a></HTML></td>' + 
                    '<td>' + ql.Labor_Code__c + '</td>' +
                    '<td white-space="wrap">' + sqkJobCard + '</td>' +
                    '<td>' + sqkLaborAmount + '</td>'+
                    '<td>' + sqkLaborType + '</td>' +
                    '<td>' + sqkMaterialAmount + '</td>'+
                    '<td>' + sqkMaterialType +'</td>'+
                    '<td><HTML><a href="https://' + instance.InstanceName + '.salesforce.com/' + ql.SBQQ__Quote__c + '">' + ql.SBQQ__Quote__r.Name + '</a></HTML></td>' + 
                    '<td>' + ql.SBQQ__Quote__r.Add_Work_Work_Order__c + '</td>' + 
                    '</tr>';                    
            }                  
            message.htmlBody += '</table>';
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
    }
   
    public pagereference DeferSquawks(){
          system.debug('enetered Squawks>>>'+ this.squawks );           
        Set<Id> pito = new Set<Id>();  
        Set<Id> desApprover = new Set<Id>();
        List<Id> squawkList = new List<Id>();
       
        for(SquawkWrapper ql : this.squawks){
            system.debug('pendingSquawk>>'+ ql.pendingSquawk);
            if(ql.pendingSquawk){
                squawkList.add(ql.squawk.Id);
                system.debug('ql.squawk.Id>>>'+ql.squawk.Id+'<<desApprover>>'+ ql.squawk.Designated_Approver__c);
                if(!desApprover.contains(ql.squawk.Designated_Approver__c))
                    desApprover.add(ql.squawk.Designated_Approver__c);              
            }
        }
                     
        String dte = DateTime.now().format();
        String statusChange = 'Deferred To Buyer';
        String color = 'Purple';
        
        List<String> response = new List<String>();          
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();

        List<SBQQ__QuoteLine__c> updaterejectionType = new List<SBQQ__QuoteLine__c>();
        
        system.debug(UserInfo.getUserId());
       // if(!Test.isRunningTest()){
               system.debug('save');       
            Savepoint sp = Database.setSavepoint();
            system.debug('sp>>>'+ sp);
            for(ProcessInstanceWorkitem workItem : [SELECT Id, ProcessInstanceId, ProcessInstance.TargetObjectId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId In: squawkList and ActorId In: desApprover]){
                system.debug('workItem>>'+ workItem);
                    if(!pito.contains(workItem.ProcessInstance.TargetObjectId)){
                        pito.add(workItem.ProcessInstance.TargetObjectId);
                        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                        req.setWorkitemId(workItem.Id);
                        req.setAction('Reject');
                        req.setComments('Deferred to Buyer by ' + UserInfo.getName() + ' On: ' + dte);
                        requests.add(req);
                    }
                }
                
                if(!requests.IsEmpty()){
                    Approval.ProcessResult[] processResults = Approval.process(requests);
                    QuoteLineEmail(squawkList, statusChange, color);
                 
                    for(SBQQ__QuoteLine__c sbql :[Select Id, Add_Work_Status__c,
                                                  Project__r.Same_Labor_Rate_Applied__c, 
                                                  Job_Card__c,
                                                  Job_Card_Description__c,
                                                  Labor_Amount__c,
                                                  Labor_Code__c,
                                                  Add_Work_Labor_Type__c,
                                                  Material_Amount__c,
                                                  Material_Type__c,
                                                  Project__r.Buyer_Inspection__c,
                                                  Project__r.Buyer_Inspection__r.Buyers_Quote__c,
                                                  Project__r.Buyer_Inspection__r.Buyers_Quote__r.SBQQ__Status__c,
                                                  RTS__c,
                                                  CPM__c,
                                                  BackupCPM__c,
                                                  Designated_Approver__c,
                                                  Secondary_Approver__c,
                                                  X3_Approver__c,
                                                  X4_Approver__c,
                                                  X5_Approver__c,
                                                  X6_Approver__c,
                                                  SBQQ__Number__c,
                                                  SBQQ__Product__c,
                                                  RecordTypeId,
                                                  SBQQ__Cost__c,
                                                  Project__r.Buyer_Inspection__r.Buyers_Quote_Line_Id__c,
                                                  Specification__c,
                                                  Product_Description__c                                            
                                                  from SBQQ__QuoteLine__c where id in: squawkList]){ 
                                                      system.debug('sbql.Add_Work_Status__c>>>'+sbql.Add_Work_Status__c);
                                                      sbql.Add_Work_Status__c = 'Deferred To Buyer';
                                                      updaterejectionType.add(sbql);
                                                  }
                    
                    if(updaterejectionType.size()>0){
                        system.debug('updaterejectionType>>'+updaterejectionType);
                        update updaterejectionType;
                        
                        //Clones Squawks To Buyer Project
                        deferToBuyer1(updaterejectionType);
                    }
                    
                }
        //}          
        return null;              
    }
    
    @AuraEnabled
    public static void deferToBuyer1(List <SBQQ__QuoteLine__c> lst) {
        List <SBQQ__QuoteLine__c> newQuoteLines = new List <SBQQ__QuoteLine__c>();
        String RequiredBy = lst[0].Project__r.Buyer_Inspection__r.Buyers_Quote_Line_Id__c;
        String qte = lst[0].Project__r.Buyer_Inspection__r.Buyers_Quote__c;
        String qteStatus = lst[0].Project__r.Buyer_Inspection__r.Buyers_Quote__r.SBQQ__Status__c;
        String prj = lst[0].Project__r.Buyer_Inspection__c;
        String CPM = lst[0].CPM__c;
        Boolean lbrRate = lst[0].Project__r.Same_Labor_Rate_Applied__c;
        
        
        for(SBQQ__QuoteLine__c ql : lst){ 
            
            SBQQ__QuoteLine__c q = new SBQQ__QuoteLine__c();
            
            q.Job_Card__c = ql.Job_Card__c;
            q.Job_Card_Description__c= ql.Job_Card_Description__c;
            q.Labor_Amount__c = ql.Labor_Amount__c;
            q.Labor_Code__c = ql.Labor_Code__c;
            q.Add_Work_Labor_Type__c = ql.Add_Work_Labor_Type__c;
            q.Material_Amount__c = ql.Material_Amount__c;
            q.Material_Type__c = ql.Material_Type__c;
            q.Project__c = prj;
            q.SBQQ__Quote__c = qte;
            q.RTS__c = ql.RTS__c;
            q.CPM__c = CPM;
            q.BackupCPM__c = ql.BackupCPM__c;
            q.Designated_Approver__c = ql.Designated_Approver__c;
            q.Secondary_Approver__c = ql.Secondary_Approver__c;
            q.X3_Approver__c = ql.X3_Approver__c;
            q.X4_Approver__c = ql.X4_Approver__c;
            q.X5_Approver__c = ql.X5_Approver__c;
            q.X6_Approver__c = ql.X6_Approver__c;
            q.SBQQ__Number__c = ql.SBQQ__Number__c;
            q.SBQQ__Product__c = ql.SBQQ__Product__c;
           // q.RecordTypeId = ql.RecordTypeId;
            q.SBQQ__Cost__c = ql.SBQQ__Cost__c;
            q.SBQQ__RequiredBy__c = RequiredBy;
            q.Specification__c = ql.Specification__c;
            q.Product_Description__c = ql.Product_Description__c;
            
            newQuoteLines.add(q);   
        }
        
        if(newQuoteLines.size() > 0){
            System.debug('trying to insert record');
            try{
                insert newQuoteLines;
            }catch(Exception e){
                System.debug('insert exception '+e.getMessage());
                throw e;
            }
            
            if(qteStatus != 'Presented')
                UpdateQuoteStatus(qte);
            
            SubmitQuoteLines(newQuoteLines, CPM);
        }
    }
    
    public static void UpdateQuoteStatus(String qte){
        List<SBQQ__Quote__c> qteList = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c q: [Select Id, SBQQ__Status__c from SBQQ__Quote__c where id =: qte]){
            q.SBQQ__Status__c = 'Presented';
            qteList.add(q);
        }
        
        if(qteList.size() > 0)
            update qteList;               
    } 
    
    public static void SubmitQuoteLines(List <SBQQ__QuoteLine__c> quoteLines, String CPM){
        
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        
        for(SBQQ__QuoteLine__c ql : quoteLines){
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(ql.Id);
            req.setSubmitterId(CPM);
            requests.add(req);               
        }
        
        try{ 
            Approval.ProcessResult[] submitRequests = Approval.process(requests, true);           
        }catch(Exception e){
            system.debug('Resubmit for Approval Error: ' + e.getMessage()); 
        }
        
        //Unlock the QuoteLine Record
        Approval.UnlockResult[] qlRecords = Approval.unlock(quoteLines, true);          
    }         
}