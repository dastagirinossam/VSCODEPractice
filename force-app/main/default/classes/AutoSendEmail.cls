public class AutoSendEmail {
    
    @InvocableMethod
    public static void checkQuoteLineEmail(List<Id> QuoteId) {
        System.debug('quote line send email '+QuoteId);
        List<SBQQ__QuoteLine__c> qlines =[Select id, Name,Project__r.Same_Labor_Rate_Applied__c,Project__c,Project__r.Buyer_Inspection__c,Project__r.Buyer_Inspection__r.Designated_Approver__r.Name,Project__r.Buyer_Inspection__r.BackupCPM__r.Name,Project__r.Buyer_Inspection__r.CPM__r.Name,Project__r.Buyer_Inspection__r.Designated_Approver__r.Email,Project__r.Buyer_Inspection__r.BackupCPM__r.Email,Project__r.Buyer_Inspection__r.CPM__r.Email from SBQQ__QuoteLine__c where Add_Work_Status__c='Deferred To Buyer' and id=:QuoteId];
        Map<Id,String> allQuoteLine = new Map<Id,String>();
        //Map<Id,String> mapofAbortedJobs = new Map<Id,String> ();
        Set<String> quotelineOptions = new Set<String>();
        //Set<String> abortedQuoteLines = new Set<String>();
        System.debug('quote line send email 1'+qlines);
        for (SBQQ__QuoteLine__c ql : [Select id, Name,Project__r.Same_Labor_Rate_Applied__c,Project__c,Project__r.Buyer_Inspection__c,Project__r.Buyer_Inspection__r.Designated_Approver__r.Email,Project__r.Buyer_Inspection__r.BackupCPM__r.Email,Project__r.Buyer_Inspection__r.CPM__r.Email from SBQQ__QuoteLine__c where Add_Work_Status__c='Deferred To Buyer' and Project__c =:qlines[0].Project__c]){
            allQuoteLine.put(ql.id,ql.Name);
            quotelineOptions.add('%'+ql.id+'%');
            
        }
        System.debug('quote line send email 1 allQuoteLine'+allQuoteLine);
        if( ! allQuoteLine.isEmpty()){
            for (CronTrigger job : [ Select Id, CronJobDetailId, CronJobDetail.Name, NextFireTime, PreviousFireTime, State, StartTime, EndTime   from CronTrigger where CronJobDetail.Name Like : quotelineOptions and NextFireTime != null] ){
                System.abortJob(job.id);
                // abortedQuoteLines.add(job.CronJobDetail.Name);
                // mapofAbortedJobs.put(job.CronJobDetail.Name ,allQuoteLine.get(job.CronJobDetail.Name ));
            }
        }
        /*
        if(!abortedQuoteLines.isEmpty()){
            for(String abortQL :abortedQuoteLines){
                List<String> Values = abortQL.trim().split(' ');
                for(integer i=0;i<Values.size()-2;i++ ){
                    mapofAbortedJobs.put(Values[i],allQuoteLine.get(Values[i]));
                }
                
            }
        }
        */
        
        //sendEmailForQuoteLineDeferred sc = new sendEmailForQuoteLineDeferred(qlines,mapofAbortedJobs);
        sendEmailForQuoteLineDeferred sc = new sendEmailForQuoteLineDeferred(qlines,userinfo.getUserId());
        
        Datetime dt = Datetime.now() + (0.024305); // i.e. 30 mins
        
        String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
        String schedJobName='';
        for(Id qId :QuoteId){
            schedJobName = schedJobName +qId +' ';
            
        }
        schedJobName=schedJobName+Datetime.now();
        Id schedId = System.Schedule(schedJobName,timeForScheduler,sc);
        System.debug('finished');
        
   }
    
}