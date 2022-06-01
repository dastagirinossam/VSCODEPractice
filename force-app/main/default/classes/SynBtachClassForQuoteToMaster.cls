public class SynBtachClassForQuoteToMaster implements Database.Batchable<sObject> {
    public  string quoteId;
    public  string masterId;
     public  integer currentMaxCount;
    public  string masterName;
    public SynBtachClassForQuoteToMaster(string quoteId,string masterId,integer CurrentMaxCount,string masterName){
        this.quoteId = quoteId;
        this.masterId = masterId;
        this.CurrentMaxCount = CurrentMaxCount;
        this.masterName = masterName;
    }
    
    public database.QueryLocator start(database.BatchableContext bc){
        String soqlQuoteLineQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
       
        return Database.getQueryLocator(soqlQuoteLineQuery + ' where SBQQ__Quote__c = '+'\''+ quoteId +'\'' + ' Order by SBQQ__Number__c');
    }
    public void execute(database.BatchableContext bc,List<SBQQ__QuoteLine__c> currentQuoteLinesToClone){
       SBQQ.TriggerControl.disable();
        Try{
 
         Map<Id, Id> qlIdReqByIdOldMap = new Map<Id, Id>();
     List<SBQQ__QuoteLine__c> freshLineToInsertInMQ = new List<SBQQ__QuoteLine__c>();
     Map<Id, Id> oldDerivedIdNewIdMap = new  Map<Id, Id>();
        
         Integer countForNewLineToIncreaseFrom = CurrentMaxCount;
        
           for(SBQQ__QuoteLine__c ql : currentQuoteLinesToClone){
            SBQQ__QuoteLine__c newql = ql.clone(false,true,false,false);
            newql.SBQQ__Quote__c = masterId;
            newql.Derived_From_Quote_Line__c = ql.id;
            newql.Derived_From_Child_Quote__c = ql.SBQQ__Quote__c;
            newql.SBQQ__Number__c = ++countForNewLineToIncreaseFrom;
           
                if(ql.SBQQ__RequiredBy__c != null){
             newql.SBQQ__RequiredBy__c = ql.SBQQ__RequiredBy__c; 
            qlIdReqByIdOldMap.put(ql.id, ql.SBQQ__RequiredBy__c); 
                    
                }  
                 freshLineToInsertInMQ.add(newql);
        }
        insert freshLineToInsertInMQ;
    
              Map<Id, Id> newIdOldReqById = new Map<Id, Id>(); 
        for(SBQQ__QuoteLine__c ql : freshLineToInsertInMQ){
            oldDerivedIdNewIdMap.put(ql.Derived_From_Quote_Line__c, ql.id);
            newIdOldReqById.put(ql.id, ql.SBQQ__RequiredBy__c);
        }
        
        List<SBQQ__QuoteLine__c> toUpdate = new List<SBQQ__QuoteLine__c>();
        for(SBQQ__QuoteLine__c ql : freshLineToInsertInMQ){
            if(ql.SBQQ__RequiredBy__c != null){
                Id oldReqById = newIdOldReqById.get(ql.id);
                Id reqByToSet = oldDerivedIdNewIdMap.get(oldReqById);
                ql.SBQQ__RequiredBy__c = reqByToSet;
                toUpdate.add(ql);
            }
        }
        
        update toUpdate;
        
        List<Bundle> bundleList = null;
        List<SBQQ__QuoteLine__c> childLineList = null;
        Bundle bundleline = null;
        
        Map<Id,Bundle> bundleMap = new Map<Id,Bundle>();
        
        for(SBQQ__QuoteLine__c ql : freshLineToInsertInMQ){
            
            if(ql.SBQQ__RequiredBy__c == null){
                
                bundleline = bundleMap.get(ql.id);
                
                if(bundleline == null){
                    
                    bundleline = new Bundle();
                    
                    bundleline.mainLine = ql;
                    childLineList = new List<SBQQ__QuoteLine__c>();
                    bundleline.childLines = childLineList;
                    
                    bundleMap.put(ql.id, bundleline);
                }
                else{
                    
                    bundleline.mainLine = ql;
                    
                    bundleMap.put(ql.id ,bundleline);
                }                
            }
            else{
                
                bundleline = bundleMap.get(ql.SBQQ__RequiredBy__c);
                
                if(bundleline == null){
                    
                    bundleline = new Bundle();
                    
                    childLineList = new List<SBQQ__QuoteLine__c>();
                    childLineList.add(ql);
                    bundleline.childLines = childLineList;
                    bundleMap.put(ql.SBQQ__RequiredBy__c ,bundleline);
                    continue;
                    
                }
                else{
                    
                    childLineList = bundleline.childLines ;
                    childLineList.add(ql);
                    bundleline.childLines = childLineList;
                    bundleMap.put(ql.SBQQ__RequiredBy__c ,bundleline);
                    
                } 
            }
        }
        
        List<SBQQ__QuoteLine__c> additionalLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        for(Bundle bl : bundleMap.values()){
            
            system.debug(' -- bl --'+bl.mainLine.Name);
            system.debug('-- bl child list - '+ bl.childLines.size());
            if(bl.childLines == null || bl.childLines.size() == 0){
                
                additionalLinesOfBundle.add(bl.mainLine);
                
                bundleMap.remove(bl.mainLine.id);
            }  
        }
        
        // Get maximum count of line number from master quote
        Integer counter = CurrentMaxCount;
        List<SBQQ__QuoteLine__c> quoteLineToUpdateFinal = new List<SBQQ__QuoteLine__c>();
        
        bundleList = bundleMap.values();
        bundleList.sort();
        
        for(Bundle bl : bundleList){
            
            SBQQ__QuoteLine__c mainLine = bl.mainLine;
            mainLine.SBQQ__Number__c = ++counter;
            
            quoteLineToUpdateFinal.add(mainLine);
            
            List<SBQQ__QuoteLine__c> childLines = bl.childLines;
            
            for(SBQQ__QuoteLine__c ql : childLines){
                ql.SBQQ__Number__c = ++counter;
                quoteLineToUpdateFinal.add(ql);
            }
        }
              
        List<SB_QuoteLineSorter> additionalLineSorter = new List<SB_QuoteLineSorter>();
        for(SBQQ__QuoteLine__c ql :additionalLinesOfBundle){
            SB_QuoteLineSorter sbs = new SB_QuoteLineSorter();
            sbs.quoteLine = ql;
            additionalLineSorter.add(sbs);
        }
        
        additionalLineSorter.sort();
        
        additionalLinesOfBundle = new List<SBQQ__QuoteLine__c>();
        
        for(SB_QuoteLineSorter sbs : additionalLineSorter){
            additionalLinesOfBundle.add(sbs.quoteLine);
        }
        
        for(SBQQ__QuoteLine__c ql : additionalLinesOfBundle ){
            ql.SBQQ__Number__c = ++counter;
            quoteLineToUpdateFinal.add(ql);
        }
        
        update quoteLineToUpdateFinal;
        
        //clone to insert new/fresh lines in master quote of current child
        List<SBQQ__QuoteLine__c> masterToUpdateWithPropercount = [Select id, SBQQ__Number__c
                                                                  from SBQQ__QuoteLine__c
                                                                  where SBQQ__Quote__c =: masterId 
                                                                  order by SBQQ__Number__c];
        
        counter = 0;     													  
        for(SBQQ__QuoteLine__c ql : masterToUpdateWithPropercount ){
            ql.SBQQ__Number__c = ++counter;
        }	    
        
        update masterToUpdateWithPropercount; 													  
        
      
          
    
        } finally {
            SBQQ.TriggerControl.enable();
        }      
        
    }
    
    public void finish(database.BatchableContext bc){
        
    }
     public class Bundle implements Comparable{
        
        public SBQQ__QuoteLine__c mainLine {get;set;}
        public List<SBQQ__QuoteLine__c> childLines {get;set;}
        
        public Integer compareTo(Object compare) {
                       
            Bundle compareBundle = (Bundle)compare;
            
            if (this.mainLine.SBQQ__Number__c == compareBundle.mainLine.SBQQ__Number__c ) return 0;
            
            if (this.mainLine.SBQQ__Number__c  > compareBundle.mainLine.SBQQ__Number__c ) return 1;
            
            return -1;       
            
        }
    }
    
}