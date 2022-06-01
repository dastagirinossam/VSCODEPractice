trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {
    List<Profile> pList = [SELECT Id FROM Profile where Name like 'Customer Community%'];    
    Set<Id> pIds = (new Map<Id,Profile>(pList)).keySet().clone();
    
    for(ContentDocumentLink cdl : Trigger.new){
        
        //Agent Opportunities allows Agents to Share Documents
        if(cdl.LinkedEntityId != null && 
        Schema.Agent_Opportunity__c.SObjectType == cdl.LinkedEntityId.getSobjectType() &&
          !pIds.Contains(UserInfo.getProfileId())){
            // Check if contentDocumentLink is for your specific object or not.
            cdl.visibility  =   'AllUsers';
        }

        //Projects Share Files with Customers
        if(Schema.MPM4_BASE__Milestone1_Project__c.SObjectType == cdl.LinkedEntityId.getSobjectType()){
            cdl.visibility  =   'AllUsers';
        }

        //Quote
        /*if(Schema.SBQQ__Quote__c.SObjectType == cdl.LinkedEntityId.getSobjectType()  &&
          cdl.LinkedEntity.getSobjectType().getDescribe().getRecordTypeInfosByName().equals('Add Work Quote')){            
            cdl.visibility  =   'AllUsers';
        }*/
        
        //QuoteLines
        if(Schema.SBQQ__QuoteLine__c.SObjectType == cdl.LinkedEntityId.getSobjectType()) 
            cdl.visibility  =   'AllUsers';
                    
    }
}