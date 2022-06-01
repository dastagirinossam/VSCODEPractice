public class LM_OpportunityListController {
    
    public static List<String> recordtypeList {get;set;}
    
    //Method to fetch all of the opportunity record type values
    //Returns the List of Opportunity Record Type Values.
    @AuraEnabled
    public static List<String> fetchRecordTypeValues(){
        recordtypeList = new List<String>(); 
        recordtypeList.add('--None--');
        for(RecordTypeInfo info: Opportunity.SObjectType.getDescribe().getRecordTypeInfos()) {
            if(info.getName() != 'Master'){
                if(info.isAvailable() && info.isActive()) 
                    recordtypeList.add(info.getName());
            }
        }
        return recordtypeList;        
    }
    
    //Input Paramaters : Record Type Label of type String and AirCraft Id of type String
    //Method to fetch record type id for the opportunity and also the aircraft record.
    //Returns the wrapper class variable which holds the record type id and aircraft record.
    @AuraEnabled
    public static OpportunityWrapper getRecTypeId(String recordTypeLabel,String aircraftId){
        OpportunityWrapper wrap = new OpportunityWrapper();
        Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        wrap.TypeId=recid;
        if (aircraftId.startsWith('a02')){
            try{
                wrap.AirRec = [select id,Product_Line__c,Account_ID__c from Aircraft__c where id=:aircraftId];
            }
            catch(Exception e){
                throw new AuraHandledException(e.getMessage()); 
            }
        }
        return wrap;
    }
    //Cheking the profile level object Access
    @AuraEnabled
    public static boolean isCreatable(String sObjectName)
    {
        return LM_CommonUtils.isCreatable(sObjectName);
    }
    
    public class OpportunityWrapper{
        @AuraEnabled public Id TypeId;
        @AuraEnabled public Aircraft__c AirRec;
    }  
}