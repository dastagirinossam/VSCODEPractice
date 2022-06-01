public without sharing class cloneBuyerQuoteLines {
    
    @AuraEnabled
    public static boolean listOfDeferRecords(List <String> lstRecordId){
        String dte = DateTime.now().format();
        String statusChange = 'Deferred To Buyer';
        String color = 'Purple';
        
        List<String> response = new List<String>();          
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        List<ProcessInstanceWorkitem> workItems = [SELECT Id, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId IN: lstRecordId and ActorId =: UserInfo.getUserId()];
        
        List<SBQQ__QuoteLine__c> updaterejectionType = new List<SBQQ__QuoteLine__c>();
        
        system.debug(UserInfo.getUserId());
        if(workItems.size() > 0 || Test.isRunningTest()){
            Savepoint sp = Database.setSavepoint();
            try{
                for(ProcessInstanceWorkitem workItem : workItems){
                    Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
                    req.setWorkitemId(workItem.Id);
                    req.setAction('Reject');
                    req.setComments('Deferred to Buyer by ' + UserInfo.getName() + ' On: ' + dte);
                    requests.add(req);
                }
                
                Approval.ProcessResult[] processResults = Approval.process(requests);
                
                QuoteLineEmail(lstRecordId, statusChange, color);
                //for(SBQQ__QuoteLine__c sbql :[Select Id, Rejection_Type__c, Add_Work_Status__c from SBQQ__QuoteLine__c where id in: lstRecordId]){
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
                                              SBQQ__Description__c                                            
                                              from SBQQ__QuoteLine__c where id in: lstRecordId]){                            
                                                  sbql.Add_Work_Status__c = 'Deferred To Buyer';
                                                  //sbql.Rejection_Type__c = 'Defer To Buyer';
                                                  updaterejectionType.add(sbql);
                                              }
                
                if(updaterejectionType.size()>0){
                    update updaterejectionType;
                    
                    //Clones Squawks To Buyer Project
                    deferToBuyer1(updaterejectionType);
                    
                    //BuyerSellerSquawks.deferToBuyer(updaterejectionType);
                }
            }catch ( Exception ex ){
                Database.rollback(sp);
                response.add('error' + ex.getMessage());
            }
        }else{
            response.add('You are not able to Defer this Squawk. If you have questions regarding this, please contact your Customer Project Manager.');
        }
        //return response;
        
        return true;
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
          //  q.RecordTypeId = ql.RecordTypeId;
            q.SBQQ__Cost__c = ql.SBQQ__Cost__c;
            q.SBQQ__RequiredBy__c = RequiredBy;
            q.Specification__c = ql.Specification__c;
            q.SBQQ__Description__c = ql.SBQQ__Description__c;
            
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
    
    @auraEnabled
    public static void UpdateQuoteStatus(String qte){
        List<SBQQ__Quote__c> qteList = new List<SBQQ__Quote__c>();
        for(SBQQ__Quote__c q: [Select Id, SBQQ__Status__c from SBQQ__Quote__c where id =: qte]){
            q.SBQQ__Status__c = 'Presented';
            qteList.add(q);
        }
        
        if(qteList.size() > 0)
            update qteList;               
    } 
    
    @auraEnabled
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
    
    public static void QuoteLineEmail(List <String> lstRecordId, String statusChange, String color){
        
        string htmlBody = '';
        Organization instance = [SELECT InstanceName FROM Organization];
        
        List<SBQQ__QuoteLine__c> quoteLines = [Select Id, Job_Card_Description__c, Name, Project__c, Project__r.Name, SBQQ__Quote__c, SBQQ__Quote__r.Name, SBQQ__Quote__r.Add_Work_Work_Order__c, Project__r.Email_Distribution__c, CPM__c, CPM__r.Name, Labor_Code__c, Labor_Amount__c, Add_Work_Labor_Type__c, Material_Amount__c, Material_Type__c from SBQQ__QuoteLine__c where Id In: lstRecordId Order By Name asc];
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
                    '<td><HTML><a href="https://' + instance.InstanceName + '.salesforce.com/apex/Squawk?id=' + ql.Id + '">' + ql.Name + '</a></HTML></td>' + 
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
    
    
    
    
}