public with sharing class SB_OpportunityTriggerHandler {
    /*public SB_OpportunityTriggerHandler() {
        
    }*/

    private static Id amendmentRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Amendment').getRecordTypeId();

    public static void updateAmountsInQuote(Map<Id, Opportunity> opportunityTriggerMap){

        Set<Id> oppIdsToCheck = new Set<Id>();
        Set<Id> contractIds = new Set<Id>();
        Map<Id,Id> currenAmdOppAndCurrAmdOppQuoteIdMap = new Map<Id,Id>();
        Map<Id,Id> oppIdPrimaryQuoteIdMapForFacility = new Map<Id,Id>();
        Map<Id, String> oppIdFacilityMap = new Map<Id,String>();
        boolean updateForAmendment = false;
        boolean updateForNormal = false;
        
        for(Opportunity opp : opportunityTriggerMap.values()){
            system.debug('--opp.IsWon --'+opp.IsWon );
            system.debug('--opp.SBQQ__AmendedContract__c  --'+opp.SBQQ__AmendedContract__c );
            
                      
            if(opp.IsWon && opp.SBQQ__AmendedContract__c != null){
                oppIdsToCheck.add(opp.id);
                contractIds.add(opp.SBQQ__AmendedContract__c);
                currenAmdOppAndCurrAmdOppQuoteIdMap.put(opp.id,opp.SBQQ__PrimaryQuote__c);
                
            }
            if(opp.Facility__c != null && opp.SBQQ__PrimaryQuote__c != null){
                oppIdPrimaryQuoteIdMapForFacility.put(opp.id,opp.SBQQ__PrimaryQuote__c);
                oppIdFacilityMap.put(opp.id,opp.Facility__c);
                
            }
            
       
            

        }

        system.debug('oppIdsToCheck  --' + oppIdsToCheck);
        system.debug('contractIds  --' + contractIds);

        system.debug('oppIdsToCheck  --' + oppIdsToCheck.size());
        system.debug('contractIds  --' + contractIds.size());

        system.debug('oppIdPrimaryQuoteIdMapForFacility  --' + oppIdPrimaryQuoteIdMapForFacility.size());

        if(oppIdPrimaryQuoteIdMapForFacility.isEmpty()){
            return;
        }else{
            updateForNormal = true;
        }

        if(!updateForNormal && 
            (oppIdsToCheck.isEmpty() || contractIds.isEmpty() )){
            return;
        }else{
            updateForAmendment = true;
        }

        if(updateForAmendment && !system.isFuture() && !contractIds.isEmpty()){
            // Opportunity - ammend contract - all opp - all quote cust total.
                updateAmendmentAmounts(contractIds,currenAmdOppAndCurrAmdOppQuoteIdMap,oppIdsToCheck);
        }
        
        system.debug('oppIdFacilityMap>>'+oppIdFacilityMap+'oppIdsToCheck>>'+oppIdsToCheck);
        if(updateForNormal && !system.isFuture() && !oppIdPrimaryQuoteIdMapForFacility.isEmpty() && !oppIdsToCheck.isEmpty() ){

            updateFacilityforQuotes(oppIdFacilityMap,oppIdPrimaryQuoteIdMapForFacility,oppIdsToCheck);


        }



    }

    @future
    public static void updateFacilityforQuotes(Map<Id, String> oppIdFacilityMap,
                                                Map<Id,Id> oppIdPrimaryQuoteIdMapForFacility,
                                                Set<Id> oppIdsToCheckAmendments){

        List<SBQQ__Quote__c> toUpdate = new List<SBQQ__Quote__c>();

        List<SBQQ__Quote__c> quoteToUpdate = [Select Id, SBQQ__Opportunity2__c,SBQQ__Type__c,Facility1__c,Engine__c,
                                                    SBQQ__Opportunity2__r.SBQQ__AmendedContract__c,
                                                    SBQQ__Opportunity2__r.StageName,
                                                    SBQQ__Opportunity2__r.SBQQ__AmendedContract__r.SBQQ__Opportunity__r.Facility__c,
                                                    SBQQ__Opportunity2__r.Facility__c,Facility__c,SBQQ__Opportunity2__r.Equipment__c
                                                  From SBQQ__Quote__c
                                                  where id in :oppIdPrimaryQuoteIdMapForFacility.values() ];
        
         // done to make sync opp facility and quote facility
        for(SBQQ__Quote__c quote :quoteToUpdate){
            
            boolean add = false;
            if(quote.Facility1__c == null || quote.Facility1__c != quote.SBQQ__Opportunity2__r.Facility__c ){
                quote.Facility1__c = quote.SBQQ__Opportunity2__r.Facility__c;
                add = true;
            }
            if(quote.Engine__c == null || quote.Engine__c != quote.SBQQ__Opportunity2__r.Equipment__c){
                quote.Engine__c=   quote.SBQQ__Opportunity2__r.Equipment__c;
                add = true;
            }
            
            
            
            /*if(quote.SBQQ__Type__c == 'Amendment'){
                quote.Facility1__c = quote.SBQQ__Opportunity2__r.SBQQ__AmendedContract__r.SBQQ__Opportunity__r.Facility__c;
            }else{
            
                quote.Facility1__c = quote.SBQQ__Opportunity2__r.Facility__c;
            }*/
            
            if(quote.SBQQ__Opportunity2__r.StageName == 'RFS'){
                quote.SBQQ__StartDate__c = System.today();
                quote.SBQQ__Status__c = 'Accepted';
                add = true;
            }

            if(add){
                toUpdate.add(quote);
            }
            
        }
        
        if(toUpdate != null && toUpdate.size() > 0){
            update toUpdate;                                                
        }
        

    }

    @future
    public static void updateAmendmentAmounts(Set<Id> contractIds,
                                            Map<Id,Id> currenAmdOppAndCurrAmdOppQuoteIdMap,
                                            Set<Id> oppIdsToCheck ){

        List<Opportunity> opportunityList = [Select SBQQ__AmendedContract__c, Id,SBQQ__PrimaryQuote__c,
                                                SBQQ__PrimaryQuote__r.CustomerNetTotal__c
                                              from Opportunity
                                              where SBQQ__AmendedContract__c in :contractIds];

        if(opportunityList == null || opportunityList.isEmpty()){
            return;
        }

        system.debug('opportunityList ------'+opportunityList.size());

        Map<Id,List<Opportunity>> contractIdOppListMap = new Map<Id,List<Opportunity>>();
        List<Opportunity> oppList = null;
        Set<Id> quoteIdToQuery = new Set<Id>();

        for(Opportunity opp : opportunityList){

            oppList = contractIdOppListMap.get(opp.SBQQ__AmendedContract__c);
            if(oppList == null){
                oppList = new List<Opportunity>();
                oppList.add(opp);
                

            }else{
                oppList.add(opp);
                
            }
            quoteIdToQuery.add(opp.SBQQ__PrimaryQuote__c);
            contractIdOppListMap.put(opp.SBQQ__AmendedContract__c,oppList);

        }


        List<SBQQ__Quote__c> quoteToUpdate = [Select Id, TotalOfAllAmendmentsIncludingThis__c,CustomerNetTotal__c,
                                                SBQQ__Opportunity2__c,SBQQ__Opportunity2__r.SBQQ__AmendedContract__c,
                                              SBQQ__Opportunity2__r.StageName
                                              From SBQQ__Quote__c
                                              where id in :quoteIdToQuery ];

        if(quoteToUpdate == null || quoteToUpdate.isEmpty()){
            return;
        }

        system.debug('----quoteToUpdate --'+quoteToUpdate.size());

        Map<Id,Decimal> contractIdToTotalOfAllIncludingThisMap = new Map<Id,Decimal>();
        Map<Id,Decimal> contractIdToTotalOfAllNotIncludingThisMap = new Map<Id,Decimal>();

        for(SBQQ__Quote__c quote: quoteToUpdate){

            oppList = contractIdOppListMap.get(quote.SBQQ__Opportunity2__r.SBQQ__AmendedContract__c);
            if(oppList!=null && oppIdsToCheck.contains(quote.SBQQ__Opportunity2__c) ){

                Decimal totalOfPrevious = 0;
                Decimal currentQuoteAmount =0;
                
                for(Opportunity opp : oppList){
                    
                    totalOfPrevious +=opp.SBQQ__PrimaryQuote__r.CustomerNetTotal__c;

                    if(currenAmdOppAndCurrAmdOppQuoteIdMap.get(opp.id) != null){
                        currentQuoteAmount = opp.SBQQ__PrimaryQuote__r.CustomerNetTotal__c;
                    }

                }
            
                quote.TotalOfAllAmendmentsIncludingThis__c = totalOfPrevious;
                
                if(quote.SBQQ__Opportunity2__r.StageName == 'RFS'){
                    quote.SBQQ__StartDate__c = System.today();
                    quote.SBQQ__Status__c = 'Accepted';
                }

            
                contractIdToTotalOfAllIncludingThisMap.put(quote.SBQQ__Opportunity2__r.SBQQ__AmendedContract__c,
                                    quote.TotalOfAllAmendmentsIncludingThis__c);

                contractIdToTotalOfAllNotIncludingThisMap.put(quote.SBQQ__Opportunity2__r.SBQQ__AmendedContract__c,
                                    quote.TotalOfAllAmendmentsIncludingThis__c - currentQuoteAmount);
            }
        }

        system.debug('quoteToUpdate -- '+ quoteToUpdate.size());
        system.debug('quoteToUpdate -- '+ quoteToUpdate);

        update quoteToUpdate;


        List<Contract> contractToUpdate = [Select Id, ContractNumber, TotalOfAllAmendmentsIncludingThis__c,
                                                TotalOfPreviousAmendmentsIfAny__c,SBQQ__Opportunity__c
                                           From Contract
                                           Where id in :contractIds];

         system.debug('---'+contractToUpdate.size());

        for(Contract contract : contractToUpdate){

            contract.TotalOfAllAmendmentsIncludingThis__c = contractIdToTotalOfAllIncludingThisMap.get(contract.id);
            contract.TotalOfPreviousAmendmentsIfAny__c = contractIdToTotalOfAllNotIncludingThisMap.get(contract.id);
        }
        
        if(contractToUpdate != null && !contractToUpdate.isEmpty()){
            update contractToUpdate;                                        
        }
            
    }

    public static void OpportunityBeforeInsert(List<Opportunity> opptys){
        Set<Id> conSet = new Set<Id>();
        Set<String> faciltySet = new Set<String>();

        for(Opportunity opp : opptys){
            system.debug('opp.SBQQ__AmendedContract__c>>'+opp.SBQQ__AmendedContract__c);
            if(opp.SBQQ__AmendedContract__c != null){
              
                    conSet.add(opp.SBQQ__AmendedContract__c);
                }
            
        }

        system.debug('conSet ##'+conSet);
        Map<Id,Contract> conMap = new Map<Id,Contract>([select id, SBQQ__Opportunity__r.Equipment__c, 
        														SBQQ__Opportunity__r.Type,SBQQ__Opportunity__r.OwnerId,
                                                                SBQQ__Opportunity__r.RSM__c,SBQQ__Opportunity__r.BDSM__c,
                                                                SBQQ__Opportunity__r.Pricebook2Id,
                                                                SBQQ__Opportunity__r.Facility__c,SBQQ__Opportunity__r.Tier_Level__c,
                                                                SBQQ__Opportunity__r.CloseDate,SBQQ__Opportunity__r.InputDate__c,
                                                                SBQQ__Opportunity__r.OutputDate__c,SBQQ__Opportunity__r.Input_Date_Accuracy__c,
                                                                SBQQ__Opportunity__r.AccountId,SBQQ__Opportunity__r.Aircraft__c,
                                                                SBQQ__Opportunity__r.SubType__c,SBQQ__Opportunity__r.Operator__c,
                                                                SBQQ__Opportunity__r.CustomerName__c,SBQQ__Opportunity__r.Product_Line__c,
                                                                SBQQ__Opportunity__r.LeadSource,SBQQ__Opportunity__r.SPIF__c,
                                                                SBQQ__Opportunity__r.QuoterName__c,SBQQ__Opportunity__r.AFSM_Lookup__c,
                                                                SBQQ__Opportunity__r.Agent_Representative__c,SBQQ__Opportunity__r.Lead_TSM__c,
                                                                SBQQ__Opportunity__r.RSA__c,SBQQ__Opportunity__r.Contact__c,
                                                                SBQQ__Opportunity__r.Description,SBQQ__Opportunity__r.Opportunity_Name_Details__c


        												from Contract 
        												where Id IN :conSet AND SBQQ__Opportunity__c != null]);


        system.debug('conMap -- '+conMap.keySet());

        Map<String, Facility__c> facilityMap = new Map<String, Facility__c>();
        for(Facility__c facility : [Select City__c, Fax__c, State__c, 
                                   Street__c, Zip_Code__c, Name, Country__c 
                                   from Facility__c ]){
            facilityMap.put(facility.Name,facility);
        }

        for(Opportunity opp : opptys){

            if(opp.SBQQ__AmendedContract__c != null && conMap.containsKey(opp.SBQQ__AmendedContract__c)){

                system.debug('inside if');

                Contract contractObj = conMap.get(opp.SBQQ__AmendedContract__c);
                opp.RecordtypeId = amendmentRecordType;
                opp.StageName = 'RFQ Accepted';
                opp.amount = 5000;

                if(contractObj.SBQQ__Opportunity__r.Equipment__c != null){
                    opp.Equipment__c = contractObj.SBQQ__Opportunity__r.Equipment__c;
                }
                if(contractObj.SBQQ__Opportunity__r.Type != null){
                    opp.Type = contractObj.SBQQ__Opportunity__r.Type;
                }
                if(contractObj.SBQQ__Opportunity__r.OwnerId != null){
                    opp.OwnerId = contractObj.SBQQ__Opportunity__r.OwnerId;
                }
                if(contractObj.SBQQ__Opportunity__r.RSM__c != null){
                    opp.RSM__c = contractObj.SBQQ__Opportunity__r.RSM__c;
                }
                if(contractObj.SBQQ__Opportunity__r.BDSM__c != null){
                    opp.BDSM__c = contractObj.SBQQ__Opportunity__r.BDSM__c;
                }
                if(contractObj.SBQQ__Opportunity__r.Pricebook2Id != null){
                    opp.Pricebook2Id = contractObj.SBQQ__Opportunity__r.Pricebook2Id;
                }
                if(contractObj.SBQQ__Opportunity__r.Facility__c != null){
                    opp.Facility__c = contractObj.SBQQ__Opportunity__r.Facility__c;

                    Facility__c facility = facilityMap.get( opp.Facility__c );
                    if(facility != null){

                        opp.Facility_City__c = facility.City__c;
                        opp.Facility_Fax__c = facility.Fax__c;
                        opp.Facility_State__c = facility.State__c;
                        opp.Facility_Street__c = facility.Street__c;
                        opp.Facility_Zip_Code__c = facility.Zip_Code__c;
                        opp.Facility_Country__c = facility.Country__c;
                    }
                   
                }
                if(contractObj.SBQQ__Opportunity__r.Tier_Level__c != null){
                    opp.Tier_Level__c = contractObj.SBQQ__Opportunity__r.Tier_Level__c;
                }
                if(contractObj.SBQQ__Opportunity__r.CloseDate != null){
                    opp.CloseDate = contractObj.SBQQ__Opportunity__r.CloseDate;
                }
                if(contractObj.SBQQ__Opportunity__r.InputDate__c != null){
                    opp.InputDate__c = contractObj.SBQQ__Opportunity__r.InputDate__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.OutputDate__c != null){
                    opp.OutputDate__c = contractObj.SBQQ__Opportunity__r.OutputDate__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.Input_Date_Accuracy__c != null){
                    opp.Input_Date_Accuracy__c = contractObj.SBQQ__Opportunity__r.Input_Date_Accuracy__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.AccountId != null){
                    opp.AccountId = contractObj.SBQQ__Opportunity__r.AccountId;
                }
                 if(contractObj.SBQQ__Opportunity__r.Aircraft__c != null){
                    opp.Aircraft__c = contractObj.SBQQ__Opportunity__r.Aircraft__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.SubType__c != null){
                    opp.SubType__c = contractObj.SBQQ__Opportunity__r.SubType__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.Operator__c != null){
                    opp.Operator__c = contractObj.SBQQ__Opportunity__r.Operator__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.CustomerName__c != null){
                    opp.CustomerName__c = contractObj.SBQQ__Opportunity__r.CustomerName__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.Product_Line__c != null){
                    opp.Product_Line__c = contractObj.SBQQ__Opportunity__r.Product_Line__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.LeadSource != null){
                    opp.LeadSource = contractObj.SBQQ__Opportunity__r.LeadSource;
                }
                 if(contractObj.SBQQ__Opportunity__r.SPIF__c != null){
                    opp.SPIF__c = contractObj.SBQQ__Opportunity__r.SPIF__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.QuoterName__c != null){
                    opp.QuoterName__c = contractObj.SBQQ__Opportunity__r.QuoterName__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.AFSM_Lookup__c != null){
                    opp.AFSM_Lookup__c = contractObj.SBQQ__Opportunity__r.AFSM_Lookup__c;
                }
                 if(contractObj.SBQQ__Opportunity__r.Agent_Representative__c != null){
                    opp.Agent_Representative__c = contractObj.SBQQ__Opportunity__r.Agent_Representative__c;
                }
                if(contractObj.SBQQ__Opportunity__r.Lead_TSM__c != null){
                    opp.Lead_TSM__c = contractObj.SBQQ__Opportunity__r.Lead_TSM__c;
                }
                if(contractObj.SBQQ__Opportunity__r.Opportunity_Name_Details__c != null){
                    opp.Opportunity_Name_Details__c = 'Amendment of '+contractObj.SBQQ__Opportunity__r.Opportunity_Name_Details__c;
                }
                if(contractObj.SBQQ__Opportunity__r.Contact__c != null){
                    opp.Contact__c = contractObj.SBQQ__Opportunity__r.Contact__c;
                }
                if(contractObj.SBQQ__Opportunity__r.Description != null){
                    opp.Description = contractObj.SBQQ__Opportunity__r.Description;
                }
            }
        }

     }
}