public with sharing class SB_MasterQuoteBuilderFrmOppunity {
    
   private static Id masterRecTypeId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Master Proposal').getRecordTypeId();
   public static string errorMessage; 
    public Opportunity opp;
    
    // Constructor
    public SB_MasterQuoteBuilderFrmOppunity(ApexPages.StandardController opportunityStdController) {
        this.opp = (Opportunity)opportunityStdController.getRecord(); 
        
        Opportunity opp = [Select Id, Name, Master_Opportunity__c,SBQQ__PrimaryQuote__c,Contact__c,
                           AccountId,Amount ,Facility__c,Aircraft__c,Pricebook2Id
                           From Opportunity
                           Where id = :this.opp.id   ];
        
        this.opp = opp;
    }
    
    // Below method creates a master quote with business validation.
	@AuraEnabled
    public static SBQQ__Quote__c createMasterQuote(Id oppId) {
	SBQQ__Quote__c myQuote;
        
        
        Try{
             
	Opportunity opp1 = [Select Id, Name, Master_Opportunity__c,SBQQ__PrimaryQuote__c,Contact__c,
                           AccountId,Amount ,Facility__c,Aircraft__c,Pricebook2Id
                           From Opportunity
                           Where id = :oppId   ];
	
        
        if(!opp1.Master_Opportunity__c){
            
          /*  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                                       'As <a href= '+'\''+'/'+opp.Id+'\''+ '>'+opp.name+'</a> is not a master Opportunity, master Proposal cannot be created. Please go back to Opportunity.'+
                                                       '<p> Kindly check again and retry. </p>' 
                                                      )); */
				errorMessage = '{\n' +
                ' "errorMsg" : "Please check the following in the Opportunity: ",\n' +
                ' "errorMsgTitle" : "Opportunity is not a master Opportunity, master Proposal cannot be created",\n' +
                ' "errorMsgId" : "' + string.valueof(opp1.Id) + '",\n' +
                ' "errorMsgIdName" : "' + opp1.Name + '"\n' +       
                '}';
            
            AuraHandledException ex = new AuraHandledException(errorMessage);
            ex.setMessage(errorMessage);
            throw ex;
													  
          
        }
        
        List<Opportunity> childOppList = [Select Id,SBQQ__PrimaryQuote__c,SBQQ__PrimaryQuote__r.Facility1__c,
                                          SBQQ__PrimaryQuote__r.Aircraft__c
                                          From Opportunity
                                          Where MasterOpportunitylookup__c   = :opp1.Id and SBQQ__PrimaryQuote__c != null];
        
        if(childOppList == null || childOppList.isEmpty()){
           /* ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                                       'As there are no child opportunites, master quote cannot be created for ' +
                                                       ' <a href= '+'\''+'/'+opp.Id+'\''+ '>'+opp.name+'</a>' + 
                                                       '<p> Kindly check again and retry. </p>' ));  
            return null;*/
			
			
			errorMessage = '{\n' +
                ' "errorMsg" : "Please check the following in the Opportunity: ",\n' +
                ' "errorMsgTitle" : "As there are no child opportunites, master quote cannot be created for,\n' +
                ' "errorMsgId" : "' + string.valueof(opp1.Id) + '",\n' +
                ' "errorMsgIdName" : "' + opp1.Name + '"\n' +       
                '}';
            
            AuraHandledException ex = new AuraHandledException(errorMessage);
            ex.setMessage(errorMessage);
            throw ex;
			
        }
        
        String queryQuoteIdstr = '';
        Set<Id> quoteIdSet = new Set<Id>();
        String facilityFromChildQuote = '';
        Id aircraftFromChildquote = null;
        
        for(Opportunity opp : childOppList ){           
            queryQuoteIdstr = queryQuoteIdstr+String.valueOf('\'')+opp.SBQQ__PrimaryQuote__c+String.valueOf('\',');
            
            if(opp.SBQQ__PrimaryQuote__r.Facility1__c != null)
                facilityFromChildQuote = opp.SBQQ__PrimaryQuote__r.Facility1__c;
            
            if(opp.SBQQ__PrimaryQuote__r.Aircraft__c !=null)
                aircraftFromChildquote = opp.SBQQ__PrimaryQuote__r.Aircraft__c;
            
            quoteIdSet.add(opp.SBQQ__PrimaryQuote__c);          
        }
        
        if(opp1.Facility__c != null){
            facilityFromChildQuote = opp1.Facility__c;
        }
        if(opp1.Aircraft__c != null){
            aircraftFromChildquote = opp1.Aircraft__c;
        }
        
        system.debug('---queryQuoteIdstr.length '+queryQuoteIdstr.length());
        
        queryQuoteIdstr = queryQuoteIdstr.substring(0,(queryQuoteIdstr.length()-1));
        queryQuoteIdstr = '('+queryQuoteIdstr+')';
        system.debug('queryQuoteIdstr ---33'+queryQuoteIdstr);
        
        List<SBQQ__Quote__c> childQuoteList = [Select Id,SBQQ__Account__c,SBQQ__PrimaryContact__c /*,
			Discrepancy_Labor_Hours_Estimate__c,Discrepancy_Materials_Estimate__c,
			Discrepancy_Labor_Estimate__c */
                                               From SBQQ__Quote__c
                                               where id in :quoteIdSet];
            
             Triggers.OpportunityTrigger_Disabled = True;
        Triggers.AddWorkStatusTrigger_Disabled = True;
        Triggers.SB_QuoteTrigger = True;      
       SBQQ.TriggerControl.disable();
                     
        myQuote = new SBQQ__Quote__c();
        myQuote.SBQQ__PrimaryContact__c = opp1.Contact__c;
        myQuote.SBQQ__Account__c = opp1.AccountId;
        myQuote.SBQQ__Type__c = 'Quote';
        myQuote.RecordTypeId = masterRecTypeId;
        myQuote.SBQQ__Status__c = 'Draft';
        myQuote.SBQQ__Primary__c = True;
        myQuote.Labor_Type1__c = 'Master';
        myQuote.Facility1__c = facilityFromChildQuote;
        myQuote.Aircraft__c = aircraftFromChildquote;
        myQuote.SBQQ__Opportunity2__c = opp1.Id;
        myQuote.SBQQ__PriceBook__c = opp1.Pricebook2Id;
        
        insert myQuote;
        
        String soqlQuoteLineQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        List<SBQQ__QuoteLine__c> quoteLinesOfChildQuotesList = Database.query(soqlQuoteLineQuery + ' where SBQQ__Quote__c in '+queryQuoteIdstr);
        
        
        List<SBQQ__QuoteLine__c> toInsertQl = new List<SBQQ__QuoteLine__c>();
        List<SBQQ__QuoteLine__c> toInsertQlSecond = new List<SBQQ__QuoteLine__c>();
        
        List<SBQQ__QuoteLine__c> toInsertQlFirst = new List<SBQQ__QuoteLine__c>();
        Map<Id, Id> qlIdReqByIdOldMap = new Map<Id,Id>();
        
        for(SBQQ__QuoteLine__c ql : quoteLinesOfChildQuotesList){
            
            SBQQ__QuoteLine__c newql = ql.clone(false,true,false,false);
            newql.SBQQ__Quote__c = myQuote.id;
            newql.Derived_From_Quote_Line__c = ql.id;
            newql.Derived_From_Child_Quote__c = ql.SBQQ__Quote__c;
            newql.SBQQ__DynamicOptionId__c = null;
            newql.SBQQ__UpgradedSubscription__c = null;
            
            if(ql.SBQQ__RequiredBy__c == null){
                toInsertQlFirst.add(newql);
                
            }else{
                toInsertQlSecond.add(newql);
            }
            
            qlIdReqByIdOldMap.put(ql.id,ql.SBQQ__RequiredBy__c);
            
        }
        
        insert toInsertQlFirst;
        
        Map<Id, Id> oldDerivedIdNewIdMapNew = new Map<Id,Id>();
        
        for(SBQQ__QuoteLine__c qline : toInsertQlFirst){
            oldDerivedIdNewIdMapNew.put(qline.Derived_From_Quote_Line__c,qline.id);
            
        }
        
        
        
        for(SBQQ__QuoteLine__c ql :toInsertQlSecond ){
            
            ql.SBQQ__RequiredBy__c =  oldDerivedIdNewIdMapNew.get(ql.SBQQ__RequiredBy__c);
            
        }
        
        insert toInsertQlSecond;
        
        toInsertQl.addAll(toInsertQlFirst);
        toInsertQl.addAll(toInsertQlSecond);
        
        //--------------------------------
        
        /*
Map<Id, Id> qlIdReqByIdOldMap = new Map<Id,Id>();

Map<Id, Id> oldDerivedIdNewIdMap = new Map<Id,Id>();


for(SBQQ__QuoteLine__c ql : quoteLinesOfChildQuotesList){
SBQQ__QuoteLine__c newql = ql.clone(false,true,false,false);
newql.SBQQ__Quote__c = myQuote.id;
newql.Derived_From_Quote_Line__c = ql.id;
newql.Derived_From_Child_Quote__c = ql.SBQQ__Quote__c;
newql.SBQQ__DynamicOptionId__c = null;
newql.SBQQ__UpgradedSubscription__c = null;

toInsertQl.add(newql);
qlIdReqByIdOldMap.put(ql.id,ql.SBQQ__RequiredBy__c);
}

insert toInsertQl;
/* List<String> exceptions = new List<String>();
Database.SaveResult[] srList = Database.insert(toInsertQl, false);
processException(srList,'Insert QL','insert',toInsertQl,exceptions);
*/
        //system.debug('----exceptions ----'+exceptions);
        
        
        
        /* Map<Id, Id> newIdOldReqById = new Map<Id,Id>();

for(SBQQ__QuoteLine__c ql : toInsertQl){
oldDerivedIdNewIdMap.put(ql.Derived_From_Quote_Line__c,ql.id);
newIdOldReqById.put(ql.id,ql.SBQQ__RequiredBy__c);
}

List<SBQQ__QuoteLine__c> toUpdate = new List<SBQQ__QuoteLine__c>();
for(SBQQ__QuoteLine__c ql : toInsertQl){

if(ql.SBQQ__RequiredBy__c !=null){
Id oldReqById = newIdOldReqById.get(ql.id);
Id reqByToSet = oldDerivedIdNewIdMap.get(oldReqById);
ql.SBQQ__RequiredBy__c = reqByToSet;
toUpdate.add(ql);
}
}

update toUpdate;*/
        
        List<Bundle> bundleList = null;
        List<SBQQ__QuoteLine__c> childLineList = null;
        Bundle bundleline = null;
        
        Map<Id,Bundle> bundleMap = new Map<Id,Bundle>();
        
        for(SBQQ__QuoteLine__c ql : toInsertQl){
            
            if(ql.SBQQ__RequiredBy__c == null){
                
                bundleline = bundleMap.get(ql.id);
                
                if(bundleline == null){
                    
                    bundleline = new Bundle();
                    
                    bundleline.mainLine = ql;
                    childLineList = new List<SBQQ__QuoteLine__c>();
                    bundleline.childLines = childLineList;
                    
                    bundleMap.put(ql.id ,bundleline);
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
        
        Integer counter = 0;
        List<SBQQ__QuoteLine__c> quoteLineToUpdateFinal = new List<SBQQ__QuoteLine__c>();
        
        bundleList = bundleMap.values();
        //bundleList.sort();
        
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
        
        for(SBQQ__QuoteLine__c ql :additionalLinesOfBundle ){
            ql.SBQQ__Number__c = ++counter;
            quoteLineToUpdateFinal.add(ql);
        }
        
        update quoteLineToUpdateFinal;
        
        
        
        updateQuoteFuture(myQuote.id);
         }Catch(exception e){           
        System.debug('The following exception has occurred: ' + e.getMessage());
             string errorMessage ;
                         errorMessage = '{\n' +
                ' "errorMsg" : "Please check the following Opportunity: ",\n' +
                ' "errorMsgTitle" : "Opportunity failed to Generate",\n' +
                ' "errorLine" : "' + e.getLineNumber() + '",\n' +
                ' "errorMessage" : "' + e.getMessage() + '"\n' +       
                '}';
             AuraHandledException ex = new AuraHandledException(errorMessage);
            ex.setMessage(errorMessage);
            if(!Test.isRunningTest())
            throw ex;
        }finally {
              sbqq.TriggerControl.Enable();
             Triggers.OpportunityTrigger_Disabled = False;
        Triggers.AddWorkStatusTrigger_Disabled = False;
        Triggers.SB_QuoteTrigger = False;
          
            }   
        
        
        return myQuote;        
        
    }
    
    public class Bundle implements Comparable{
        
        public SBQQ__QuoteLine__c mainLine {get;set;}
        public List<SBQQ__QuoteLine__c> childLines {get;set;}
        
        public Integer compareTo(Object compare) {
            
            
            Bundle compareBundle = (Bundle)compare;
            
            /*   if (this.mainLine.Name == compareBundle.mainLine.Name ) return 0;
				if (this.mainLine.Name  > compareBundle.mainLine.Name ) return 1;
				return -1;       
			*/
            
            if (this.mainLine.SBQQ__Number__c == compareBundle.mainLine.SBQQ__Number__c) return 0;
            
            if (this.mainLine.SBQQ__Number__c > compareBundle.mainLine.SBQQ__Number__c) return 1;
            
            return -1;
            
        }
    }
    
    
    // below method async. makes master quote to primary 
    @future
    public static void updateQuoteFuture(Id sbQuoteId){
        try{
         Triggers.OpportunityTrigger_Disabled = True;
        Triggers.AddWorkStatusTrigger_Disabled = True;
        Triggers.SB_QuoteTrigger = True;      
       SBQQ.TriggerControl.disable();
        SBQQ__Quote__c quoteToUpdate = [Select id, SBQQ__Primary__c 
                                        From SBQQ__Quote__c
                                        Where id =:sbQuoteId];
        
        if(quoteToUpdate !=null){
            
            quoteToUpdate.SBQQ__Primary__c = true;
            update quoteToUpdate;
        }
        
    
    }Finally{
        sbqq.TriggerControl.Enable();
             Triggers.OpportunityTrigger_Disabled = False;
        Triggers.AddWorkStatusTrigger_Disabled = False;
        Triggers.SB_QuoteTrigger = False; 
    } 
    } 
}