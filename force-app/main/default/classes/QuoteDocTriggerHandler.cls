public class QuoteDocTriggerHandler {
    public static Set<Id> quoteMap = new Set<Id>();
    public static Set<Id> projMap = new Set<Id>();
    
    public static Date expirationDate = Date.valueOf(System.today()+Integer.valueOf(30));
    
    public static Map<Id, String> qnMap = new Map<Id, String>();
    public static Map<Id, SBQQ__Quote__c> quoteDocMap = new Map<Id, SBQQ__Quote__c>();
    public static Map<Id, Decimal> qdvMap = new Map<Id, Decimal>();
    public static Map<Id, SBQQ__QuoteDocument__c> opMap = new Map<Id, SBQQ__QuoteDocument__c>();
    
    public static Date expirationDate1 = Date.valueOf(System.today()+Integer.valueOf(30)); 
    
    public static   set<Id> Qids = new set<Id>();
    public static   Map<Id, SBQQ__QuoteDocument__c> opMap1 = new Map<Id, SBQQ__QuoteDocument__c>();
    public static  Map<Id, String> qnMap1 = new Map<Id, String>();
    public static  Map<Id, Decimal> qdvMap1 = new Map<Id, Decimal>();
    public static Map<Id, SBQQ__Quote__c> quoteDocMap1 = new Map<Id, SBQQ__Quote__c>();
    
    
    public static List<SBQQ__Quote__c> qteList = new List<SBQQ__Quote__c>();
    public static List<Opportunity> oList = new List<Opportunity>();
    
    public static void beforeTrigger(List<SBQQ__QuoteDocument__c> qDocs){
        for(SBQQ__QuoteDocument__c qd : qDocs ){
            quoteMap.add(qd.SBQQ__Quote__c);         
        }  
        
        for(SBQQ__Quote__c qn : [Select Id, Name, Project__c, SBQQ__Opportunity2__c, Quote_Document_Version__c, SBQQ__ExpirationDate__c from SBQQ__Quote__c where Id in: quoteMap]){
            quoteDocMap.put(qn.Id, qn);
        }
        
        for(SBQQ__QuoteDocument__c qd : qDocs){   
            qd.Name = quoteDocMap.get(qd.SBQQ__Quote__c).Name + '-' + qd.SBQQ__Version__c;  
            qd.Project_On_Quote__c = quoteDocMap.get(qd.SBQQ__Quote__c).Project__c;
            qdvMap.put(qd.SBQQ__Quote__c, qd.SBQQ__Version__c);
            opMap.put(quoteDocMap.get(qd.SBQQ__Quote__c).SBQQ__Opportunity2__c, qd);
        } 
        system.debug('qdvMap---trigger>>>'+qdvMap+'>>>>>'+opMap);
    }
    @future(callout=true) 
    public static void afterTrigger(set<Id> Qdids){ 
        
        for(SBQQ__QuoteDocument__c qds : [Select Id,SBQQ__Quote__c,SBQQ__Version__c from SBQQ__QuoteDocument__c where Id In: Qdids ]){
            
            qdvMap1.put(qds.SBQQ__Quote__c,qds.SBQQ__Version__c);
            Qids.add(qds.SBQQ__Quote__c);
        }
        
        
        for(SBQQ__Quote__c q : [Select Id, Name,SBQQ__Primary__c, SBQQ__ExpirationDate__c,SBQQ__Opportunity2__c,Quote_Document_Version__c from SBQQ__Quote__c   where Id In: Qids]){
            if(q.SBQQ__Primary__c == True){
                q.SBQQ__ExpirationDate__c = expirationDate1;
                q.Quote_Document_Version__c = qdvMap1.get(q.Id);
                quoteDocMap1.put(q.Id, q);
                qnMap1.put(q.Id, q.Name);
                qteList.add(q);
            }   
        }
        
        try{
            
            
            for(SBQQ__QuoteDocument__c qd1 : [Select Id,SBQQ__Quote__c,SBQQ__Version__c from SBQQ__QuoteDocument__c where Id In: Qdids ]){
                if(quoteDocMap1!=null){
                    opMap1.put(quoteDocMap1.get(qd1.SBQQ__Quote__c).SBQQ__Opportunity2__c, qd1);   
                }
            }
        } catch(Exception e){
            System.debug('Exception' +e.getMessage());
        }
        for(Opportunity o : [Select Id, Base_Quote_Number__c, Quote_Revision_Number__c from Opportunity where Id In: opMap1.keySet()]){
            Id qId = opMap1.get(o.Id).SBQQ__Quote__c;
            o.Base_Quote_Number__c = qnMap1.get(qId);
            o.Quote_Revision_Number__c = String.valueof(opMap1.get(o.Id).SBQQ__Version__c);
            oList.add(o);
        }
        
        if(!qteList.isEmpty())
            update qteList;
        
        if(!oList.isEmpty())
            update oList;    
    }  
    
}