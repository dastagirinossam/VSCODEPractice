public with sharing class SubmitQuoteLinesForApproval {
  
    @InvocableMethod
    public static void SubmitQuoteLines(List<String> fxRecord) { 
        
        String recordId = fxRecord[0];       
           
        if(recordId.substring(0,1) == 'L'){
            String QuoteLineId = recordId.mid(1,15);
        	SubmitSingleQuoteLine(QuoteLineId);          
        }else if(recordId.substring(0,1) == 'Q'){
            String QuoteId = recordId.mid(1,15);
            SubmitAllQuoteLines(QuoteId);
        }       
    }
    
    public static void SubmitSingleQuoteLine(String QuoteLineId) {
                     SBQQ__QuoteLine__c    ql = [Select Id, Add_Work_Status__c,
                                                  Project__r.Same_Labor_Rate_Applied__c,                                                                                                    
                                                  RecordTypeId,
                                                  SBQQ__Cost__c,
                                                  Project__r.Buyer_Inspection__r.Buyers_Quote_Line_Id__c,
                                                  Specification__c,
                                                  SBQQ__Description__c                                            
                                                  from SBQQ__QuoteLine__c where id =:QuoteLineId];
        if(ql.Add_Work_Status__c == 'Pending'){
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(QuoteLineId);
        Approval.ProcessResult processResult = Approval.process(req);
		} 	
        //When ready this will unlock the QuoteLine Record
        Approval.unlock(QuoteLineId, true); 
       
    }
                                                    
    public static void SubmitAllQuoteLines(String QuoteId){
        List<SBQQ__QuoteLine__c> quoteLines = [SELECT Id FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =: QuoteId and Add_Work_Status__c = null and SBQQ__ProductName__c = 'Unscheduled Product'];
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();

        if(quoteLines != null || !quoteLines.IsEmpty()){
            for(SBQQ__QuoteLine__c ql : quoteLines){
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setObjectId(ql.Id);
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
}