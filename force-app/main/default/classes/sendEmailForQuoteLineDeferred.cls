global class sendEmailForQuoteLineDeferred implements Schedulable{
    global List<SBQQ__QuoteLine__c> qlines;
    global Id userId;
    global Map<Id,String> mapOfJobsAborted;
    public sendEmailForQuoteLineDeferred(List<SBQQ__QuoteLine__c> ql ,Id uId){
        qlines =ql;
        userId =uId;
    }

    global void execute(SchedulableContext sc) {
        sendemail(qlines,userId);
    }
    
    global static void sendemail (List<SBQQ__QuoteLine__c> quoteList,Id usrId){
        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
        User u = [Select Id, Name, Title, Phone, Email from User where Id =: usrId ];
        EmailTemplate template = [SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE DeveloperName =: 'New_Squawks_Notification'];
    	String body = template.Body;
        String subject = template.Subject;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
                body = body.replace('{!User.Name}', u.Name);
                body = body.replace('{!User.Title}', u.Title);
                body = body.replace('{!User.Phone}', u.Phone);
                body = body.replace('{!User.Email}', u.Email);
                
                
       
        List<String> toadd= new List<String>();
        if(quoteList[0].Project__r.Same_Labor_Rate_Applied__c){
            if(quoteList[0].Project__r.Buyer_Inspection__r.Designated_Approver__r.Name != null){
             body = body.replace('{!MPM4_BASE__Milestone1_Project__c.Designated_Approver__c}', quoteList[0].Project__r.Buyer_Inspection__r.Designated_Approver__r.Name);
            toadd.add(quoteList[0].Project__r.Buyer_Inspection__r.Designated_Approver__r.Email);
            }
            mail.setToAddresses(toadd);
        }
        else{
            
            body = body.replace('{!MPM4_BASE__Milestone1_Project__c.Designated_Approver__c}', quoteList[0].Project__r.Buyer_Inspection__r.BackupCPM__r.Name + ',' + quoteList[0].Project__r.Buyer_Inspection__r.CPM__r.Name);
            toadd.add(quoteList[0].Project__r.Buyer_Inspection__r.BackupCPM__r.Email);
            toadd.add(quoteList[0].Project__r.Buyer_Inspection__r.CPM__r.Email);
            mail.setToAddresses(toadd);
        }
        mail.setplaintextbody(body);
        mail.setSubject(subject);
        mailsToSend.add(mail);
        
        //Messaging.sendEmail(new Messaging.Email[] {mail});
        Messaging.sendEmail(mailsToSend);
        
        
        
    }
    
    
    
    
    
    
    
    
}