public with sharing class CreateMasterQuoteFromFlow {

    public CreateMasterQuoteFromFlow(ApexPages.StandardController controller) {

    }
     
    // Instanciate the Flow for use from the Controller
    public Flow.Interview.Create_Master_Opportunity myflow {get;set;} 
       
    //finish Location
    public PageReference getQuoteAssignment() {  
        PageReference pRef = new PageReference('/006?fcf=00B70000007QB0h');
        pRef.setRedirect(true);
        return pRef; 
    } 
             
    // Constructor
    @InvocableMethod
    public static void CreateMasterQuoteFromFlow(List<Id> oppId) {
     
        Opportunity oppty = [Select Id, Name, Master_Opportunity__c,SBQQ__PrimaryQuote__c,Contact__c,
                            AccountId,Amount ,Facility__c,Aircraft__c
                          From Opportunity
                          Where id =: oppId];
   
        List<Opportunity> childOppList = [Select Id,SBQQ__PrimaryQuote__c,SBQQ__PrimaryQuote__r.Facility1__c,
                                          SBQQ__PrimaryQuote__r.Aircraft__c
                                         From Opportunity
                                         Where MasterOpportunitylookup__c = :oppty.Id and SBQQ__PrimaryQuote__c != null];
        
        String queryQuoteIdstr = '';
        Set<Id> quoteIdSet = new Set<Id>();
        String facilityFromChildQuote = '';
        Id aircraftFromChildquote = null;

        system.debug('---Opportunity: '+oppty.SBQQ__PrimaryQuote__c);
        system.debug('---Opportunity Child List: '+childOppList.size());
        
        if(oppty.Facility__c != null){
          facilityFromChildQuote = oppty.Facility__c;
        }
        if(oppty.Aircraft__c != null){
          aircraftFromChildquote = oppty.Aircraft__c;
        }
        
        SBQQ__Quote__c myQuote = new SBQQ__Quote__c();
        myQuote.SBQQ__PrimaryContact__c = oppty.Contact__c;
        myQuote.SBQQ__Account__c = oppty.AccountId;
        myQuote.SBQQ__Type__c = 'Quote';
        myQuote.Facility1__c = facilityFromChildQuote;
        myQuote.Aircraft__c = aircraftFromChildquote;
        myQuote.SBQQ__Opportunity2__c = oppty.Id;
        myQuote.Labor_Type1__c = 'Master';

        insert myQuote;
        
        if(!childOppList.IsEmpty()){
            for(Opportunity opp : childOppList ){

              queryQuoteIdstr = queryQuoteIdstr+String.valueOf('\'')+opp.SBQQ__PrimaryQuote__c+String.valueOf('\',');
              
              if(opp.SBQQ__PrimaryQuote__r.Facility1__c != null){
                facilityFromChildQuote = opp.SBQQ__PrimaryQuote__r.Facility1__c;
              }
              
              if(opp.SBQQ__PrimaryQuote__r.Aircraft__c !=null){
                aircraftFromChildquote = opp.SBQQ__PrimaryQuote__r.Aircraft__c;
              }
              
              quoteIdSet.add(opp.SBQQ__PrimaryQuote__c);
            }


        system.debug('---queryQuoteIdstr.length '+queryQuoteIdstr.length());
 
          queryQuoteIdstr = queryQuoteIdstr.substring(0,(queryQuoteIdstr.length()-1));
          queryQuoteIdstr = '('+queryQuoteIdstr+')';
          system.debug('queryQuoteIdstr ---33'+queryQuoteIdstr);

        List<SBQQ__Quote__c> childQuoteList = [Select Id,SBQQ__Account__c,SBQQ__PrimaryContact__c /*,
                                                    Discrepancy_Labor_Hours_Estimate__c,Discrepancy_Materials_Estimate__c,
                                                     Discrepancy_Labor_Estimate__c */
                                              From SBQQ__Quote__c
                                              where id in :quoteIdSet  ];   

        String soqlQuoteLineQuery = SB_ApexUtility.getInstance().queryBuilder('SBQQ__QuoteLine__c');
        List<SBQQ__QuoteLine__c> quoteLinesOfChildQuotesList = Database.query(soqlQuoteLineQuery + ' where SBQQ__Quote__c in '+queryQuoteIdstr);

        system.debug('---'+quoteLinesOfChildQuotesList);

        List<SBQQ__QuoteLine__c> toInsertQl = new List<SBQQ__QuoteLine__c>();
          
        Map<Id, Id> qlIdReqByIdOldMap = new Map<Id,Id>();

        Map<Id, Id> oldDerivedIdNewIdMap = new Map<Id,Id>();

        for(SBQQ__QuoteLine__c ql : quoteLinesOfChildQuotesList){
          SBQQ__QuoteLine__c newql = ql.clone(false,true,false,false);
          newql.SBQQ__Quote__c = myQuote.id;
          newql.Derived_From_Quote_Line__c = ql.id;
          newql.Derived_From_Child_Quote__c = ql.SBQQ__Quote__c;
          toInsertQl.add(newql);
          qlIdReqByIdOldMap.put(ql.id,ql.SBQQ__RequiredBy__c);
        }

        insert toInsertQl;

         Map<Id, Id> newIdOldReqById = new Map<Id,Id>();

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

        update toUpdate;

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

        }      
    }
    
    public class Bundle implements Comparable{

       public SBQQ__QuoteLine__c mainLine {get;set;}
       public List<SBQQ__QuoteLine__c> childLines {get;set;}

         public Integer compareTo(Object compare) {
         
            Bundle compareBundle = (Bundle)compare;
    
            if (this.mainLine.SBQQ__Number__c == compareBundle.mainLine.SBQQ__Number__c) return 0;

            if (this.mainLine.SBQQ__Number__c > compareBundle.mainLine.SBQQ__Number__c) return 1;

            return -1;

        }
    }
   
    // below method async. makes master quote to primary 
    public static void updateQuoteFuture(Id sbQuoteId){

        SBQQ__Quote__c quoteToUpdate = [Select id, SBQQ__Primary__c 
                                        From SBQQ__Quote__c
                                        Where id =:sbQuoteId];

        if(quoteToUpdate !=null){
                 
           quoteToUpdate.SBQQ__Primary__c = true;
             update quoteToUpdate;
        }        
    }
}