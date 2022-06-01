public class myOpportinutyViewCompController {
@AuraEnabled
    public static List<Agent_Opportunity__c> getoppRecs(Id usersId){
        system.debug('userId>>'+usersId);
       /* list<Opportunity> oppList = [select Id,Name,AccountId,closeDate,Account.Name,Equipment__c,Equipment__r.Name,Aircraft__c,Aircraft__r.Name
                                     from Opportunity 
                                     where ownerId =: usersId limit 5];*/
        list<Agent_Opportunity__c> oppList = [select Id,Name,Account__c,Close_Date__c,Account__r.Name,Equipment__c,Equipment__r.Name,Aircraft__c,Aircraft__r.Name
                                     from Agent_Opportunity__c 
                                     where ownerId =: usersId ];
        system.debug('Opportunity>>>'+ oppList);
        return oppList;
    }
    @AuraEnabled
    public static List<Account> getaccRecs(Id accId){
       
        List<Account> conList = [select Id,name,OwnerId,BillingAddress,ShippingAddress,(select id,Account.name,Title,ContactType__c,phone,homephone,HangarPhone__c,email,fax,Alternate_Email__c  from contacts),(select id,name from Agent_Opportunities__r),(select Id,Account__c,ACReg__c,Aircraft_Make__c,Aircraft_Model_2011__c,AirportLookup__c,Aircraft_Status__c,AircraftDeliveryDate__c,Description__c,Maintenance_Program__c,ACHRS__c,ACHRSDate__c,NumofLandings__c,Landings_Date__c,name from Aircraft__r),(select Id,EngineorAPUSN__c,Average_Monthly_Hours__c,Account__c,Aircraft__c,Equipment_Status__c,Stale_Hours_Reason__c,name,Maintenance_Prgm_Status__c,MaintenancePrgmType__c  from Equipment__r) from Account where Id =: accId ];
        
        return conList;
    }
     @AuraEnabled
    public static void createRecord (ContentNote nt, id PrentId){
        system.debug('nt>>>>'+nt);
        try{
            if(nt != null){
                
                system.debug('PrentId>>>'+PrentId);
                insert nt;
                ContentDocument cd=[select id from ContentDocument where id=:nt.Id];
                ContentDocumentLink cdl=new ContentDocumentLink();
                cdl.ContentDocumentId=cd.id;
                
                cdl.LinkedEntityId=PrentId;
                cdl.ShareType='V';
                cdl.Visibility='AllUsers';
               
                insert cdl;
                
                 system.debug('cdl>>>'+cdl);
                                
            }
        } catch (Exception ex){

        }
    }    
}