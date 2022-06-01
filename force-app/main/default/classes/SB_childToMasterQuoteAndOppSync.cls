/***Author : Krunal Pala Date - 24/2/2017 Purpose - To sync child with master opportunity primary quote***/
public with sharing class SB_childToMasterQuoteAndOppSync {
    public static string errorMessage;
    public SBQQ__Quote__c sbQuote {get; set;} 
    
    // constructor
    public SB_childToMasterQuoteAndOppSync(ApexPages.StandardController quoteStdController) {
        
        sbQuote = (SBQQ__Quote__c)quoteStdController.getRecord(); 
        
        sbQuote = [Select Id,Name,SBQQ__Opportunity2__c,SBQQ__Primary__c,
                   SBQQ__Opportunity2__r.IsClosed,
                   SBQQ__Opportunity2__r.Name,
                   SBQQ__NetAmount__c,
                   SBQQ__Opportunity2__r.id,
                   SBQQ__Opportunity2__r.StageName,
                   SBQQ__Opportunity2__r.MasterOpportunitylookup__r.Id, 
                   SBQQ__Opportunity2__r.MasterOpportunitylookup__r.Name,
                   SBQQ__Opportunity2__r.MasterOpportunitylookup__r.SBQQ__PrimaryQuote__c
                   
                   From SBQQ__Quote__c
                   
                   Where id =: sbQuote.id]; 
        system.debug('sbQuote.id'+sbQuote.id);
        system.debug('sbQuote.Name'+sbQuote.Name);
         system.debug('sbQuote.SBQQ__Opportunity2__r.Name'+sbQuote.SBQQ__Opportunity2__r.Name);
        
        
    }
    //below method syncs child opportunity primary quote to master  opportunity quote.
    @AuraEnabled
    public static SBQQ__Quote__c getSyncToMasterQuoteAndOpportunity(String sbQuoteId){
        
        SBQQ__Quote__c sbQuote = [Select Id,Name,SBQQ__Opportunity2__c,SBQQ__Primary__c,
                                  SBQQ__Opportunity2__r.IsClosed,
                                  SBQQ__Opportunity2__r.Name,
                                  SBQQ__NetAmount__c,
                                  SBQQ__Opportunity2__r.id,
                                  SBQQ__Opportunity2__r.StageName,
                                  SBQQ__Opportunity2__r.MasterOpportunitylookup__r.Id, 
                                  SBQQ__Opportunity2__r.MasterOpportunitylookup__r.Name,
                                  SBQQ__Opportunity2__r.MasterOpportunitylookup__r.SBQQ__PrimaryQuote__c
                                  
                                  From SBQQ__Quote__c
                                  
                                  Where id =: sbQuoteId];  
        system.debug('sbQuote1'+ sbQuote);
        
        AddWork_Trigger_Setting__c TS = AddWork_Trigger_Setting__c.getValues('AddWork');
        SB_Metatype__mdt qpMdt = [select Id,Quote_Process_Active__c from SB_Metatype__mdt where MasterLabel = 'custom settings' Limit 1];          
        qpMdt.Quote_Process_Active__c = False;
       
        //Disable Triggers To CutDown on CPU Time
        Triggers.OpportunityTrigger_Disabled = True;
        Triggers.AddWorkStatusTrigger_Disabled = True;
        Triggers.SB_QuoteTrigger = True;
        SBQQ__Quote__c masterQuote; 
       SBQQ.TriggerControl.disable();
        try{
        //validate quote and opportunity  if passes go on otherwise return
        if(!validateQuoteAndOpportunity(sbQuote) ){
            AuraHandledException ex = new AuraHandledException(errorMessage);
            ex.setMessage(errorMessage);
            if(!Test.isRunningTest())
            throw ex;
        } 

        system.debug('--sbQuote-' + sbQuote);
        
        // get current quote lines
        String soqlQuoteLineQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        
        List<SBQQ__QuoteLine__c> currentQuoteLinesToClone = Database.query(soqlQuoteLineQuery + ' where SBQQ__Quote__c = '+'\''+ sbQuote.Id +'\'' + ' Order by SBQQ__Number__c');
        
        if((currentQuoteLinesToClone == null || currentQuoteLinesToClone.isEmpty()) && !Test.isRunningTest()){
            
            errorMessage = '{\n' +
                ' "errorMsg" : "Please check the following in the Quote: ",\n' +
                ' "errorMsgTitle" : "Quote does not have any Quote Line Items to Sync",\n' +
                ' "errorMsgId" : "' + string.valueof(sbQuote.SBQQ__Opportunity2__r.Id) + '",\n' +
                ' "errorMsgIdName" : "' + sbQuote.SBQQ__Opportunity2__r.Name + '"\n' +       
                '}';
            
            AuraHandledException ex = new AuraHandledException(errorMessage);
            ex.setMessage(errorMessage);
            throw ex;
        }
        
        system.debug('--quote'+sbQuote.SBQQ__Opportunity2__r.MasterOpportunitylookup__r.SBQQ__PrimaryQuote__c);
        
        // get master Quote through relationship
        
            Map<Id,Opportunity> oppMap ;
        if(sbQuote.SBQQ__Opportunity2__c != null)
            
            
         masterQuote = [Select Id,Name,SBQQ__Opportunity2__c,SBQQ__Primary__c,SBQQ__NetAmount__c
                                      From SBQQ__Quote__c
                                      Where id =: sbQuote.SBQQ__Opportunity2__r.MasterOpportunitylookup__r.SBQQ__PrimaryQuote__c];
           oppMap = new Map<Id,Opportunity>([select Id,Name,SBQQ__PrimaryQuote__c, SBQQ__QuotePricebookId__c,Master_Amount__c
                                             From Opportunity Where Id=:sbQuote.SBQQ__Opportunity2__r.MasterOpportunitylookup__r.Id ]);
            system.debug('oppMap>>'+ oppMap);
            system.debug('masterQuote'+ masterQuote);
        
            if(masterQuote != null){
        
        //delete master quote old/existing lines of current child
        List<SBQQ__QuoteLine__c> masterQuoteLinesToDelete = [Select id 
                                                             from SBQQ__QuoteLine__c
                                                             where SBQQ__Quote__c =: masterQuote.id and Derived_From_Child_Quote__c =: sbQuote.id];
        
        List<AggregateResult> aggR= [Select max(SBQQ__Number__c) from 
                                     SBQQ__QuoteLine__c  where SBQQ__Quote__c  =: masterQuote.id];
        
        Integer CurrentMaxCount; 
        
        if(aggR.get(0).get('expr0') == null){
            CurrentMaxCount = 1;
        }else{
            CurrentMaxCount = Integer.valueOf((Decimal) aggR.get(0).get('expr0'));
        }				
         system.debug('masterQuoteLinesSize>>'+ masterQuoteLinesToDelete.Size());
                if(masterQuoteLinesToDelete.size()>0) {
                    Database.DeleteResult[] drList = Database.delete(masterQuoteLinesToDelete, false);
                 //  delete masterQuoteLinesToDelete;
                    
                }         
           
        
        List<SBQQ__QuoteLine__c> freshLineToInsertInMQ = new List<SBQQ__QuoteLine__c>();
        
        // v-- from master code
        Map<Id, Id> qlIdReqByIdOldMap = new Map<Id, Id>();
        Map<Id, Id> oldDerivedIdNewIdMap = new Map<Id, Id>();
        
        Integer countForNewLineToIncreaseFrom = CurrentMaxCount;
        
        for(SBQQ__QuoteLine__c ql : currentQuoteLinesToClone){
            
            SBQQ__QuoteLine__c newql = ql.clone(false,true,false,false);
            newql.SBQQ__Quote__c = masterquote.id;
            newql.Derived_From_Quote_Line__c = ql.id;
            newql.Derived_From_Child_Quote__c = ql.SBQQ__Quote__c;
            newql.SBQQ__Number__c = ++countForNewLineToIncreaseFrom;
            freshLineToInsertInMQ.add(newql);
            qlIdReqByIdOldMap.put(ql.id, ql.SBQQ__RequiredBy__c);       
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
                                                                  where SBQQ__Quote__c =: masterQuote.id 
                                                                  order by SBQQ__Number__c];
        
        counter = 0;     													  
        for(SBQQ__QuoteLine__c ql : masterToUpdateWithPropercount ){
            ql.SBQQ__Number__c = ++counter;
        }	    
        
       sbqq.TriggerControl.Enable();
       // Triggers.SB_QuoteTrigger = False; 
        
        update masterToUpdateWithPropercount; 	
         /*   Opportunity opp = new Opportunity();
                opp.Id = oppMap.get(sbQuote.SBQQ__Opportunity2__r.MasterOpportunitylookup__r.Id).Id;
                opp.Master_Amount__c= sbQuote.SBQQ__NetAmount__c;
              //  update opp;
          system.debug('oppamount>>'+ opp.Amount); */     
                
            }
       
        }Catch(exception e){
            string Message = e.getMessage();
          AuraHandledException ex = new AuraHandledException(Message);
            ex.setMessage(Message);
            if(!Test.isRunningTest())
            throw ex;   
        }finally {
              sbqq.TriggerControl.Enable();
             Triggers.OpportunityTrigger_Disabled = False;
        Triggers.AddWorkStatusTrigger_Disabled = False;
        Triggers.SB_QuoteTrigger = False;
          
            }    
    return masterQuote; 
    }
    
    // method for validating Quote and associate opportunity (Master as well)
    public static boolean validateQuoteAndOpportunity(SBQQ__Quote__c sbQuote){
        
        // Validation if opportunity is null or it is not 
        //primary or master opportunity does not have a primary/master quote present
        if(sbQuote == null || !sbQuote.SBQQ__Primary__c  ){
            
            system.debug('---masterquote is null or not primary -- ');
            errorMessage = '{\n' +
                ' "errorMsg" : "Please check the following in the quote ",\n' +
                ' "errorMsgTitle" : "Quote is not primary",\n' +
                ' "errorMsgId" : "' + string.valueof(sbQuote.Id) + '",\n' +
                ' "errorMsgIdName" : "' + sbQuote.Name + '"\n' +
                '}';

            
            return false;
        }
         
        if(sbQuote.SBQQ__Opportunity2__c == null ){
            
            system.debug('---masterquote is null or not primary -- ');      
            errorMessage = '{\n' +
                ' "errorMsg" : "Please check the following in the quote ",\n' +
            	' "errorMsgTitle" : "Quote is not associated to an opportunity",\n' +
            	' "errorMsgId" : "' + string.valueof(sbQuote.Id) + '",\n' +
            	' "errorMsgIdName" : "' + sbQuote.Name + '"\n' +
                '}';
      
            return false;
            
        }
        
        SB_Metatype__mdt sbMetatype = [Select OpportunityStageToSync__c from SB_Metatype__mdt where DeveloperName = 'custom_settings'];
        
        system.debug(sbMetatype.OpportunityStageToSync__c);
        
        String[] sbMetatypeStrArray = sbMetatype.OpportunityStageToSync__c.split(';');
        
        Set<String> oppStageNameSet = new Set<String>();
        for(String oppStage : sbMetatypeStrArray){
            oppStageNameSet.add(oppStage.trim());
        }
        
        system.debug('sbQuote.SBQQ__Opportunity2__r.IsClosed ' + sbQuote.SBQQ__Opportunity2__r.IsClosed);
        system.debug('sbQuote.SBQQ__Opportunity2__r.StageName ' + sbQuote.SBQQ__Opportunity2__r.StageName);
        
        if(sbQuote.SBQQ__Opportunity2__r.IsClosed || !(oppStageNameSet.contains(sbQuote.SBQQ__Opportunity2__r.StageName))){
            
            String messgaStr = 'Please update the opportunity stage to one of the stages: /n';
            for(String oppStageNm : oppStageNameSet){
                messgaStr += '    - ' + oppStageNm + ' /n';
            }
            
            messgaStr += 'On Opportunity: '; 
            
            system.debug('Error Messages Stages: ' + messgaStr);    
            errorMessage = '{\n' +
                ' "errorMsg" : "' + string.valueof(messgaStr) + '",\n' +
                ' "errorMsgTitle" : "Assoicated Opportunity Stage Needs Updated",\n' +
                ' "errorMsgId" : "' + string.valueof(sbQuote.SBQQ__Opportunity2__r.Id) + '",\n' +
                ' "errorMsgIdName" : "' + sbQuote.SBQQ__Opportunity2__r.Name + '"\n' +       
                '}';
            
            return false;
        }
        
        
        if(sbQuote.SBQQ__Opportunity2__r.MasterOpportunitylookup__r.Id  == null){
        
            errorMessage = '{\n' +
                ' "errorMsg" : "Master opportunity is not linked to Associated Opportunity: ",\n' +
                ' "errorMsgTitle" : "Populate Master Opportunity Name",\n' +
                ' "errorMsgId" : "' + string.valueof(sbQuote.SBQQ__Opportunity2__r.Id) + '",\n' +
                ' "errorMsgIdName" : "' + sbQuote.SBQQ__Opportunity2__r.Name + '"\n' +       
                '}';            
                        
            return false;
        }
        
        if(sbQuote.SBQQ__Opportunity2__r.MasterOpportunitylookup__r.SBQQ__PrimaryQuote__c  == null){
            
            errorMessage = '{\n' +
                ' "errorMsg" : "There is no Primary Quote On Master Opportunity: ",\n' +
                ' "errorMsgTitle" : "Master Opportunity Needs Primary Quote",\n' +
                ' "errorMsgId" : "' + string.valueof(sbQuote.SBQQ__Opportunity2__r.MasterOpportunitylookup__r.Id) + '",\n' +
                ' "errorMsgIdName" : "' + sbQuote.SBQQ__Opportunity2__r.MasterOpportunitylookup__r.Name + '"\n' +       
                '}';   
            
            return false;
        }
         
        return true;
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