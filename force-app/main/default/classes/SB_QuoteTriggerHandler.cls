public with sharing class SB_QuoteTriggerHandler {
    
    public Id rtId = Schema.SObjectType.SBQQ__Quote__c.getRecordTypeInfosByName().get('Add Work Quote').getRecordTypeId();
    
    public SB_QuoteTriggerHandler() {
        
    }
    
    public void updateFacilityAndAircraftForAmmendment(List<SBQQ__Quote__c> quoteListNew){
        
        Set<Id> oppIdSet = new Set<Id>();
        
        for(SBQQ__Quote__c quote : quoteListNew){
            if(quote.SBQQ__Type__c == 'Amendment')
                oppIdSet.add(quote.SBQQ__Opportunity2__c);
        }
        
        system.debug('oppIdSet --- ' + oppIdSet);
        
        if(oppIdSet == null || oppIdSet.isEmpty())
            return;
        
        List<Opportunity> oppList = [Select id, 
                                     SBQQ__AmendedContract__c, 
                                     SBQQ__AmendedContract__r.SBQQ__Opportunity__c, 
                                     SBQQ__AmendedContract__r.SBQQ__Opportunity__r.Aircraft__c ,
                                     SBQQ__AmendedContract__r.SBQQ__Opportunity__r.Facility__c,
                                     SBQQ__AmendedContract__r.SBQQ__Quote__r.RecordTypeId
                                     From Opportunity
                                     where id in :oppIdSet];
        
        if(oppList == null || oppList.isEmpty())
            return;
        
        system.debug('oppList -- ' + oppList.size());
        
        Map<Id,Opportunity> oppIdMap = new Map<Id,Opportunity>();
        Map<Id, Id> quoteRecordTypeMap = new Map<Id, Id>();
        for(Opportunity opp : oppList){
            oppIdMap.put(opp.id,opp);
            opp.Aircraft__c = opp.SBQQ__AmendedContract__r.SBQQ__Opportunity__r.Aircraft__c;
            opp.Facility__c = opp.SBQQ__AmendedContract__r.SBQQ__Opportunity__r.Facility__c;
            quoteRecordTypeMap.put( opp.Id, opp.SBQQ__AmendedContract__r.SBQQ__Quote__r.RecordTypeId);
            
            system.debug('opp.Aircraft__c   '+opp.Aircraft__c +'  opp.Facility__c'+opp.Facility__c);   
        }
        
        update oppList;
        
        for(SBQQ__Quote__c quote : quoteListNew){
            
            system.debug('quote.FacilityTest__c Before  '+ quote.Facility1__c + '  quote.Aircraft__c Before ' + quote.Aircraft__c);
            
            if(oppIdMap.get(quote.SBQQ__Opportunity2__c) != null){
                
                quote.Aircraft__c = oppIdMap.get(quote.SBQQ__Opportunity2__c).SBQQ__AmendedContract__r.SBQQ__Opportunity__r.Aircraft__c;    
                quote.RecordTypeId = quoteRecordTypeMap.get(quote.SBQQ__Opportunity2__c);
                quote.Facility1__c = oppIdMap.get(quote.SBQQ__Opportunity2__c).SBQQ__AmendedContract__r.SBQQ__Opportunity__r.Facility__c;
                
                system.debug('quote.FacilityTest__c   '+quote.Facility1__c +'  quote.Aircraft__c'+quote.Aircraft__c);
            }
            
            quote.SBQQ__StartDate__c = system.today();
        }
    }

    public  void checkFacility(List<SBQQ__Quote__c> quoteListNew, String Opname){
        
        //Set<Id> oppIdSet = new Set<Id>();
        Set<Id> oppIdSetOthers = new Set<Id>();
        boolean isAmmendment = false;
        
        for(SBQQ__Quote__c quote : quoteListNew){
            system.debug('-----quote.SBQQ__Opportunity2__c---' + quote.SBQQ__Opportunity2__c);
            
            if(quote.SBQQ__Opportunity2__c != null && quote.RecordTypeId != rtId)
                oppIdSetOthers.add(quote.SBQQ__Opportunity2__c);          
        }
        
        //system.debug('oppIdSet --- '+ oppIdSet);
        
        system.debug('oppIdSetOthers --- '+ oppIdSetOthers);
        if(oppIdSetOthers == null || oppIdSetOthers.isEmpty())
            return;
        
        Map<Id,Opportunity> oppIdMap = new Map<Id,Opportunity>([Select id, Aircraft__c ,Facility__c From Opportunity where id in :oppIdSetOthers]); 
        system.debug('oppIdMap --- '+ oppIdMap.size());
        
        if(oppIdMap == null || oppIdMap.isEmpty())
            return;
        
        for(SBQQ__Quote__c quote : quoteListNew){            
            system.debug('quote.FacilityTest__c Before  '+quote.Facility1__c );
            
            if(oppIdMap.get(quote.SBQQ__Opportunity2__c).Facility__c != null)
                quote.Facility1__c =oppIdMap.get(quote.SBQQ__Opportunity2__c).Facility__c;
            
            if(oppIdMap.get(quote.SBQQ__Opportunity2__c).Aircraft__c != null)
                quote.Aircraft__c =oppIdMap.get(quote.SBQQ__Opportunity2__c).Aircraft__c;
            
            system.debug('quote.FacilityTest__c   '+quote.Facility1__c +'  quote.Aircraft__c'+quote.Aircraft__c);
            
            quote.SBQQ__StartDate__c = system.today();
        }
    } 
}