public class LM_OpportunityListCommonController {
    
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
    public static OpportunityWrapper getRecTypeId(String recordTypeLabel,String ObjRecordId){
        OpportunityWrapper wrap = new OpportunityWrapper();
        Id recid = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
        wrap.TypeId=recid;
        try{
            if (ObjRecordId.startsWith('a02')){           
                wrap.AirRec = [select id,Product_Line__c,Account_ID__c from Aircraft__c where id=:ObjRecordId];            
            }
            else if (ObjRecordId.startsWith('a03')){
                wrap.EqptRec=[select id,Product_Line__c,Account_ID__c,Aircraft__c from Equipment__c where id=:ObjRecordId];
            }
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
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
        @AuraEnabled public Equipment__c EqptRec;
    }    
}