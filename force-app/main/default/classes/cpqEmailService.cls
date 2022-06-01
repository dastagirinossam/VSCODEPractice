global without sharing class cpqEmailService implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env){
        
        // Create an InboundEmailResult object for returning the result of the 
        // Apex Email Service
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        String emailBody = email.plainTextBody;
        system.debug('Email: ' + emailBody);
        String approverEmail = email.fromAddress;

        String comments = email.plainTextBody;
        String approvalStatus = '';
        String approvalId = '';

        Integer n = emailBody.length();  
        System.debug('Length of the String : ' + n);  

        Integer nr = emailBody.indexOf('-----Do not edit below this line-----');        
        System.debug('Length of the String : ' + nr);
        
        emailBody = emailBody.substring(nr, n);
        system.debug('New Email Body: ' + emailBody);
        
        Integer status;
        
        if(emailBody.indexOf('Approved') != -1){
            approvalStatus = 'Approved';
            status = emailBody.indexOf('Approved');
            approvalId = emailBody.substring(status + 9, status + 27);
            
        }else if(emailBody.indexOf('Rejected') != -1){
            approvalStatus = 'Rejected';
            status = emailBody.indexOf('Rejected');
            approvalId = emailBody.substring(status + 9, status + 27);
        }
          
		system.debug('Status: ' + approvalStatus);
        
        comments = comments.substring(comments.indexOf('[') + 1);
        comments = comments.substring(0, comments.indexOf(']'));
        comments = comments.trim();
              
        system.debug('Approval Id: ' + approvalId);
   		system.debug('Approval Id Length: ' + approvalId.length());
        
		User u = [Select Id from User where Email =: approverEmail and IsActive = True limit 1];
        
        if(approvalId.length() == 18){
            if(approvalStatus == 'Approved' && u != null)
                approveQuote(comments, approvalId, u);
            
            if(approvalStatus == 'Rejected' && u != null)
                rejectQuote(comments, approvalId, u);     
        }
        
        return result;
    }
    
    //Approve Quote via Email Response
    public static void approveQuote(String comments, String approvalId, User u){
        List<sbaa__Approval__c> saList = new List<sbaa__Approval__c>();
        for(sbaa__Approval__c sa : [Select sbaa__ApprovedBy__c, sbaa__Status__c, sbaa__CommentsLong__c, Quote__c from sbaa__Approval__c where Id=: approvalId]){
            
            //if(sa.sbaa__Status__c == 'Requested'){
                
                if(comments != '---Insert Comments Here---' && comments != '')
                    sa.sbaa__CommentsLong__c = comments;
                
                sa.sbaa__Status__c = 'Approved';
                sa.sbaa__ApprovedBy__c = u.id;
            	sa.Approval_Date__c = System.now();
                
                saList.add(sa);   
            //}
        }
        
        if(saList.Size() > 0)
            update saList;    
    }
    
    //Reject Quote via Email Response
    public static void rejectQuote(String comments, String approvalId, User u){
        List<sbaa__Approval__c> saList = new List<sbaa__Approval__c>();
        for(sbaa__Approval__c sa : [Select sbaa__ApprovedBy__c, sbaa__Status__c, sbaa__CommentsLong__c, Quote__c from sbaa__Approval__c where Id=: approvalId]){
            
            //if(sa.sbaa__Status__c == 'Requested'){
                
                if(comments != '---Insert Comments Here---' && comments != '')
                    sa.sbaa__CommentsLong__c = comments;
                
                sa.sbaa__Status__c = 'Rejected';
                sa.sbaa__ApprovedBy__c = u.id;
                sa.Approval_Date__c = System.now();
            
                saList.add(sa);  
            //}
        }
        
        if(saList.Size() > 0)
            update saList;    
    }
    
}